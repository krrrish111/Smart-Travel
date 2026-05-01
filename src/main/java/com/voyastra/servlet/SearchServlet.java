package com.voyastra.servlet;

import com.voyastra.model.Transport;
import com.voyastra.model.Stay;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private com.voyastra.api.ApiService apiService = new com.voyastra.api.ApiService();

    // ==================== MAIN DISPATCHER ====================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ---- Core search params ----
        String type       = request.getParameter("type");
        String from       = request.getParameter("from");
        String to         = request.getParameter("to");
        String city       = request.getParameter("city");
        String date       = request.getParameter("date");
        String pickup     = request.getParameter("pickup");
        String drop       = request.getParameter("drop");
        String query      = request.getParameter("query");
        String seatClass  = request.getParameter("seatClass");
        String passengers = request.getParameter("passengers");
        String carCat     = request.getParameter("carCategory");
        String carType    = request.getParameter("carType");
        String tourType   = request.getParameter("tourType");
        String people     = request.getParameter("people");

        // ---- Filter / sort params ----
        String filterAirline  = request.getParameter("filterAirline");
        String filterMaxPrice = request.getParameter("filterMaxPrice");
        String filterStops    = request.getParameter("filterStops");   // any | nonstop | 1stop
        String sortBy         = request.getParameter("sort");          // cheapest | fastest | best

        System.out.println("[SearchServlet] type=" + type + " from=" + from + " to=" + to
                + " seatClass=" + seatClass + " airline=" + filterAirline
                + " maxPrice=" + filterMaxPrice + " stops=" + filterStops + " sort=" + sortBy);

        // ---- Echo all params back to JSP ----
        request.setAttribute("searchSeatClass",   getSeatClassLabel(seatClass));
        request.setAttribute("searchPassengers",  passengers != null ? passengers : "1");
        request.setAttribute("searchCarCategory", carCat);
        request.setAttribute("searchCarType",     carType);
        request.setAttribute("searchTourType",    tourType);
        request.setAttribute("searchPeople",      people);
        // Filter state (for re-populating dropdowns)
        request.setAttribute("filterAirline",     filterAirline);
        request.setAttribute("filterMaxPrice",    filterMaxPrice);
        request.setAttribute("filterStops",       filterStops);
        request.setAttribute("sortBy",            sortBy != null ? sortBy : "cheapest");

        if ("flight".equalsIgnoreCase(type)) {
            handleFlightSearch(request, response, from, to, date, seatClass,
                    filterAirline, filterMaxPrice, filterStops, sortBy);
        } else if ("hotel".equalsIgnoreCase(type)) {
            handleHotelSearch(request, response, city != null ? city : to, date);
        } else if ("car".equalsIgnoreCase(type)) {
            handleCarSearch(request, response, pickup, drop, date, carCat, carType);
        } else if ("tour".equalsIgnoreCase(type)) {
            handleTourSearch(request, response, query, date, tourType, people);
        } else {
            request.setAttribute("searchError", "Please select a valid search type.");
            forward(request, response);
        }
    }

    // ==================== FLIGHT SEARCH ====================
    private void handleFlightSearch(HttpServletRequest request, HttpServletResponse response,
                                    String from, String to, String date, String seatClass,
                                    String filterAirline, String filterMaxPrice,
                                    String filterStops, String sortBy)
            throws ServletException, IOException {

        double multiplier = getPriceMultiplier(seatClass);

        // 1. Get flight list (API + fallback is handled inside ApiService)
        List<Transport> results = apiService.getFlights(
                from != null ? from : "DEL",
                to   != null ? to   : "BOM",
                date != null ? date : "2026-06-01",
                seatClass);
        
        // Ensure flights list is never null
        if (results == null) {
            results = new ArrayList<>();
        }

        // 3. Apply filters
        results = applyFlightFilters(results, filterAirline, filterMaxPrice, filterStops);

        // 4. Apply sorting
        results = applySort(results, sortBy);

        // 5. Hotels (cross-sell on flight tab)
        List<Stay> hotels = apiService.getHotelList(to != null ? to : "Mumbai");

        request.setAttribute("flights",           results);
        request.setAttribute("hotels",            hotels);
        request.setAttribute("transport",         getMockCarServices(from, to));
        request.setAttribute("transportServices", getMockCarServices(from, to));
        request.setAttribute("searchType",        "flight");
        request.setAttribute("searchOrigin",      from);
        request.setAttribute("searchDestination", to);
        request.setAttribute("date",              date);
        request.setAttribute("seatClass",         seatClass);
        forward(request, response);
    }

    // ==================== FILTER ENGINE ====================
    private List<Transport> applyFlightFilters(List<Transport> list,
                                               String airline, String maxPriceStr, String stops) {
        return list.stream()
            .filter(t -> {
                // Airline filter
                if (airline != null && !airline.isEmpty()) {
                    if (!t.getCompanyName().equalsIgnoreCase(airline)) return false;
                }
                // Max price filter
                if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                    try {
                        double max = Double.parseDouble(maxPriceStr);
                        if (t.getPrice() > max) return false;
                    } catch (NumberFormatException ignored) {}
                }
                // Stops filter
                if (stops != null && !stops.isEmpty() && !stops.equals("any")) {
                    if (stops.equals("nonstop") && t.getStops() != 0) return false;
                    if (stops.equals("1stop")   && t.getStops() != 1) return false;
                }
                return true;
            })
            .collect(Collectors.toList());
    }

    // ==================== SORT ENGINE ====================
    private List<Transport> applySort(List<Transport> list, String sortBy) {
        if (sortBy == null || sortBy.equals("cheapest")) {
            list.sort(Comparator.comparingDouble(Transport::getPrice));
        } else if (sortBy.equals("fastest")) {
            list.sort(Comparator.comparingInt(t -> parseDurationToMinutes(t.getDuration())));
        } else if (sortBy.equals("best")) {
            // "Best" = badge priority: Fastest > Best Value > Cheapest > others, then by price
            list.sort((a, b) -> {
                int scoreA = badgeScore(a.getBadge());
                int scoreB = badgeScore(b.getBadge());
                if (scoreA != scoreB) return scoreB - scoreA; // higher score first
                return Double.compare(a.getPrice(), b.getPrice());
            });
        }
        return list;
    }

    /** Parse "3h 25m" → 205 minutes for duration-based sorting */
    private int parseDurationToMinutes(String duration) {
        if (duration == null) return Integer.MAX_VALUE;
        try {
            int hours = 0, minutes = 0;
            if (duration.contains("h")) {
                hours = Integer.parseInt(duration.split("h")[0].trim());
                String rest = duration.split("h")[1].trim();
                if (rest.contains("m")) minutes = Integer.parseInt(rest.replace("m", "").trim());
            } else if (duration.contains("m")) {
                minutes = Integer.parseInt(duration.replace("m", "").trim());
            }
            return hours * 60 + minutes;
        } catch (Exception e) { return Integer.MAX_VALUE; }
    }

    /** Higher = better for "best" sort */
    private int badgeScore(String badge) {
        if (badge == null) return 0;
        switch (badge.toLowerCase()) {
            case "fastest":    return 3;
            case "best value": return 2;
            case "cheapest":   return 1;
            default:           return 0;
        }
    }

    // ==================== OTHER HANDLERS ====================
    private void handleHotelSearch(HttpServletRequest request, HttpServletResponse response,
                                   String city, String date)
            throws ServletException, IOException {

        List<Stay> hotels = apiService.getHotelList(city != null ? city : "Delhi");
        if (hotels == null) hotels = new ArrayList<>();

        request.setAttribute("flights",           new ArrayList<>());
        request.setAttribute("hotels",            hotels);
        request.setAttribute("transport",         getMockCarServices(null, null));
        request.setAttribute("transportServices", getMockCarServices(null, null));
        request.setAttribute("searchType",        "hotel");
        request.setAttribute("searchLocation",    city);
        request.setAttribute("date",              date);
        forward(request, response);
    }

    private void handleCarSearch(HttpServletRequest request, HttpServletResponse response,
                                 String pickup, String drop, String date,
                                 String carCat, String carType)
            throws ServletException, IOException {

        List<Transport> cars = getMockCarServices(pickup, drop);
        if (carCat != null && !carCat.equals("any")) {
            List<Transport> filtered = cars.stream()
                .filter(t -> t.getBadge() != null && t.getBadge().toLowerCase().contains(carCat.toLowerCase()))
                .collect(Collectors.toList());
            if (!filtered.isEmpty()) cars = filtered;
        }

        request.setAttribute("flights",           new ArrayList<>());
        request.setAttribute("hotels",            new ArrayList<>());
        request.setAttribute("transport",         cars);
        request.setAttribute("transportServices", cars);
        request.setAttribute("searchType",        "car");
        request.setAttribute("searchOrigin",      pickup);
        request.setAttribute("searchDestination", drop);
        request.setAttribute("date",              date);
        forward(request, response);
    }

    private void handleTourSearch(HttpServletRequest request, HttpServletResponse response,
                                  String query, String date, String tourType, String people)
            throws ServletException, IOException {

        List<Stay> tours = getMockTours(tourType);
        request.setAttribute("flights",           new ArrayList<>());
        request.setAttribute("hotels",            tours);
        request.setAttribute("transport",         getMockCarServices(null, null));
        request.setAttribute("transportServices", getMockCarServices(null, null));
        request.setAttribute("searchType",        "tour");
        request.setAttribute("searchQuery",       query);
        request.setAttribute("date",              date);
        forward(request, response);
    }

    // ==================== BUILDERS ====================
    private Transport buildFlight(String airline, String number, String from, String to,
                                  String dep, String arr, double price,
                                  String duration, int stops, String badge) {
        Transport t = new Transport();
        t.setCompanyName(airline);
        t.setTransportNumber(number);
        t.setOriginCode(from != null ? from.toUpperCase() : "DEL");
        t.setDestinationCode(to != null ? to.toUpperCase() : "BOM");
        t.setDepartureTime(dep);
        t.setArrivalTime(arr);
        t.setDuration(duration);
        t.setPrice(Math.round(price));
        t.setStops(stops);
        t.setBadge(badge);
        t.setType("flight");
        t.setCompanyLogo(airline.contains("India") ? "✈️" : "🛫");
        return t;
    }

    private Stay buildHotel(String name, String city, double price, String badge) {
        Stay s = new Stay();
        s.setName(name);
        s.setLocation(city);
        s.setDiscountedPrice(price);
        s.setOriginalPrice(price * 1.25);
        s.setBadge(badge);
        s.setAmenities("WiFi, Pool, Breakfast, Parking");
        s.setPriceNote("Per night, taxes included");
        s.setImageUrl("https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=400&q=80");
        return s;
    }

    // ==================== MOCK DATA ====================
    private List<Stay> getDefaultHotels(String city) {
        String loc = city != null ? city : "Destination";
        List<Stay> list = new ArrayList<>();
        list.add(buildHotel("The Grand Palace",       loc, 4500.0, "Popular"));
        list.add(buildHotel("Ocean View Resort",      loc, 3200.0, "Budget Pick"));
        list.add(buildHotel("Voyastra Luxury Suites", loc, 8500.0, "Premium"));
        list.add(buildHotel("Heritage Haveli",        loc, 2800.0, "Best Value"));
        return list;
    }

    private List<Stay> getMockTours(String tourType) {
        List<Stay> list = new ArrayList<>();
        if ("beach".equalsIgnoreCase(tourType)) {
            list.add(buildHotel("Goa Beach Escape (3N/4D)",        "Goa",     5000.0,  "Best Seller"));
            list.add(buildHotel("Andaman Island Explorer (5N/6D)", "Andaman", 14000.0, "Top Rated"));
            list.add(buildHotel("Kerala Backwater Cruise (4N/5D)", "Kerala",  9500.0,  "Scenic"));
        } else if ("wildlife".equalsIgnoreCase(tourType)) {
            list.add(buildHotel("Jim Corbett Tiger Safari (3N/4D)", "Uttarakhand", 8000.0, "Must Do"));
            list.add(buildHotel("Ranthambore Wildlife (2N/3D)",     "Rajasthan",   6500.0, "Popular"));
            list.add(buildHotel("Kaziranga Rhino Safari (4N/5D)",   "Assam",      11000.0, "Rare"));
        } else if ("cultural".equalsIgnoreCase(tourType)) {
            list.add(buildHotel("Golden Triangle Tour (6N/7D)",       "Delhi-Agra-Jaipur", 12000.0, "Classic"));
            list.add(buildHotel("Varanasi Spiritual Journey (3N/4D)", "Varanasi",          7500.0,  "Soul Trip"));
            list.add(buildHotel("Hampi Heritage Walk (2N/3D)",        "Karnataka",          5500.0,  "UNESCO"));
        } else {
            list.add(buildHotel("Manali Adventure Camp (4N/5D)",   "Manali",   8500.0,  "Best Seller"));
            list.add(buildHotel("Rishikesh River Rafting (2N/3D)", "Rishikesh",4200.0,  "Thrilling"));
            list.add(buildHotel("Ladakh Bike Expedition (7N/8D)",  "Ladakh",   22000.0, "Epic"));
            list.add(buildHotel("Spiti Valley Trek (6N/7D)",       "Himachal", 16000.0, "Off-Beat"));
        }
        return list;
    }

    private List<Transport> getMockCarServices(String pickup, String drop) {
        String from = pickup != null ? pickup : "Your Location";
        String dest = drop   != null ? drop   : "Destination";
        List<Transport> list = new ArrayList<>();

        Transport sedan = new Transport();
        sedan.setId(101); sedan.setType("taxi");
        sedan.setCompanyName("Voyastra Premium Cabs"); sedan.setTransportNumber("V-SEDAN-01");
        sedan.setOriginCode(from); sedan.setDestinationCode(dest);
        sedan.setDepartureTime("On Demand"); sedan.setDuration("As per route");
        sedan.setPrice(1200.0); sedan.setCompanyLogo("🚖"); sedan.setBadge("Sedan");
        list.add(sedan);

        Transport suv = new Transport();
        suv.setId(102); suv.setType("taxi");
        suv.setCompanyName("Voyastra SUV Transfer"); suv.setTransportNumber("V-SUV-02");
        suv.setOriginCode(from); suv.setDestinationCode(dest);
        suv.setDepartureTime("On Demand"); suv.setDuration("As per route");
        suv.setPrice(1950.0); suv.setCompanyLogo("🚙"); suv.setBadge("SUV");
        list.add(suv);

        Transport bus = new Transport();
        bus.setId(103); bus.setType("bus");
        bus.setCompanyName("Intercity Express"); bus.setTransportNumber("BUS-7721");
        bus.setOriginCode(from); bus.setDestinationCode(dest);
        bus.setDepartureTime("08:00 PM"); bus.setDuration("12h 30m");
        bus.setPrice(850.0); bus.setCompanyLogo("🚌"); bus.setBadge("Sleeper");
        list.add(bus);

        Transport train = new Transport();
        train.setId(104); train.setType("train");
        train.setCompanyName("Rajdhani Express"); train.setTransportNumber("12431");
        train.setOriginCode(from); train.setDestinationCode(dest);
        train.setDepartureTime("04:30 PM"); train.setDuration("16h 15m");
        train.setPrice(2450.0); train.setCompanyLogo("🚆"); train.setBadge("Superfast");
        list.add(train);

        return list;
    }

    // ==================== HELPERS ====================
    private double getPriceMultiplier(String seatClass) {
        if (seatClass == null) return 1.0;
        switch (seatClass.toLowerCase()) {
            case "premium":  return 1.6;
            case "business": return 2.8;
            case "first":    return 4.5;
            default:         return 1.0;
        }
    }

    private String getSeatClassLabel(String seatClass) {
        if (seatClass == null) return "Economy";
        switch (seatClass.toLowerCase()) {
            case "premium":  return "Premium Economy";
            case "business": return "Business";
            case "first":    return "First Class";
            default:         return "Economy";
        }
    }

    private void forward(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/pages/booking.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[SearchServlet] Forward failed: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Search failed.");
        }
    }
}
