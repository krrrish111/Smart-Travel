package com.voyastra.servlet;

import com.voyastra.api.TravelpayoutsService;
import com.voyastra.model.FlightResult;
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

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private com.voyastra.api.ApiService apiService = new com.voyastra.api.ApiService();
    private com.voyastra.api.TravelpayoutsService travelpayoutsService = new com.voyastra.api.TravelpayoutsService();

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
        String adultCount = request.getParameter("adultCount");
        String childCount = request.getParameter("childCount");
        String infantCount= request.getParameter("infantCount");
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

        int adults = adultCount != null ? Integer.parseInt(adultCount) : 1;
        int children = childCount != null ? Integer.parseInt(childCount) : 0;
        int infants = infantCount != null ? Integer.parseInt(infantCount) : 0;
        int totalPassengers = adults + children + infants;

        // ---- Echo all params back to JSP ----
        request.setAttribute("searchSeatClass",   getSeatClassLabel(seatClass));
        request.setAttribute("searchPassengers",  String.valueOf(totalPassengers));
        request.setAttribute("searchAdultCount",  String.valueOf(adults));
        request.setAttribute("searchChildCount",  String.valueOf(children));
        request.setAttribute("searchInfantCount", String.valueOf(infants));
        request.setAttribute("searchSeatClassRaw", seatClass != null ? seatClass : "economy");
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
                    filterAirline, filterMaxPrice, filterStops, sortBy, adults, children, infants);
        } else if ("hotel".equalsIgnoreCase(type)) {
            handleHotelSearch(request, response, city != null ? city : to, date);
        } else if ("car".equalsIgnoreCase(type) || "selfdrive".equalsIgnoreCase(type)) {
            handleCarSearch(request, response, pickup != null ? pickup : city, drop, date, carCat, carType);
        } else if ("tour".equalsIgnoreCase(type)) {
            handleTourSearch(request, response, query != null ? query : city, date, tourType, people);
        } else if ("train".equalsIgnoreCase(type)) {
            handleTrainSearch(request, response, from, to, date, seatClass);
        } else if ("bus".equalsIgnoreCase(type)) {
            handleBusSearch(request, response, from, to, date, seatClass);
        } else if ("cab".equalsIgnoreCase(type)) {
            handleCabSearch(request, response, pickup, drop, date, carType);
        } else if ("cruise".equalsIgnoreCase(type)) {
            handleCruiseSearch(request, response, from, to, date, seatClass);
        } else if ("helicopter".equalsIgnoreCase(type)) {
            handleHelicopterSearch(request, response, from, to, date, seatClass);
        } else if ("package".equalsIgnoreCase(type)) {
            handlePackageSearch(request, response, city != null ? city : to, date, tourType);
        } else {
            request.setAttribute("searchError", "Please select a valid search type.");
            forward(request, response);
        }
    }

    // ==================== FLIGHT SEARCH ====================
    private void handleFlightSearch(HttpServletRequest request, HttpServletResponse response,
                                    String from, String to, String date, String seatClass,
                                    String filterAirline, String filterMaxPrice,
                                    String filterStops, String sortBy, int adults, int children, int infants)
            throws ServletException, IOException {

        // 1. Call Travelpayouts API → parse JSON → List<FlightResult>
        List<FlightResult> apiFlights = travelpayoutsService.searchAndParseFlights(
                from != null ? from : "DEL",
                to   != null ? to   : "BOM",
                date != null ? date : "2026-07-01",
                adults, children, infants, seatClass);

        // 2. Convert FlightResult → Transport (for booking.jsp compatibility)
        List<Transport> results = convertToTransports(apiFlights, seatClass);

        // 3. Apply filters
        results = applyFlightFilters(results, filterAirline, filterMaxPrice, filterStops);

        // 4. Apply sorting
        results = applySort(results, sortBy);

        // 5. Hotels cross-sell on flight tab (hotel logic unchanged)
        List<Stay> hotels = apiService.getHotelList(to != null ? to : "Mumbai");

        // 6. Set attributes and forward to booking.jsp
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

    /**
     * Converts parsed FlightResult objects from TravelpayoutsService into
     * Transport objects that booking.jsp already knows how to render.
     * Price multiplier is applied here based on selected seat class.
     */
    private List<Transport> convertToTransports(List<FlightResult> flights, String seatClass) {
        if (flights == null || flights.isEmpty()) return new ArrayList<>();
        double multiplier = getPriceMultiplier(seatClass);
        List<Transport> list = new ArrayList<>();
        int id = 1;
        for (FlightResult f : flights) {
            Transport t = new Transport();
            t.setId(id++);
            t.setType("flight");
            t.setCompanyLogo(f.getAirline());                       // IATA code (e.g. "6E")
            t.setCompanyName(resolveAirlineName(f.getAirline()));   // Full name (e.g. "IndiGo")
            t.setTransportNumber(f.getFlightNumber());              // e.g. "6E-101"
            t.setOriginCode(f.getOrigin());
            t.setDestinationCode(f.getDestination());
            t.setDepartureTime(f.getDepartureTime());
            t.setArrivalTime(f.getArrivalTime());
            t.setDuration(f.getDuration());
            t.setPrice(Math.round(f.getPrice() * multiplier));
            t.setStops(f.getStops());
            t.setBadge(f.getBadge());
            list.add(t);
        }
        return list;
    }

    /** Resolve IATA carrier code to full airline name for display. */
    private String resolveAirlineName(String iata) {
        if (iata == null) return "Unknown Airline";
        switch (iata.toUpperCase()) {
            case "AI":  return "Air India";
            case "6E":  return "IndiGo";
            case "SG":  return "SpiceJet";
            case "UK":  return "Vistara";
            case "G8":  return "Go First";
            case "IX":  return "Air India Express";
            case "QP":  return "Akasa Air";
            case "EK":  return "Emirates";
            case "LH":  return "Lufthansa";
            case "BA":  return "British Airways";
            case "QR":  return "Qatar Airways";
            case "SQ":  return "Singapore Airlines";
            case "EY":  return "Etihad Airways";
            case "TK":  return "Turkish Airlines";
            default:    return iata + " Airlines";
        }
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
        request.setAttribute("transport",         new ArrayList<>());
        request.setAttribute("transportServices", new ArrayList<>());
        request.setAttribute("searchType",        "tour");
        request.setAttribute("searchQuery",       query);
        request.setAttribute("date",              date);
        forward(request, response);
    }

    private void handleTrainSearch(HttpServletRequest request, HttpServletResponse response, String from, String to, String date, String seatClass) throws ServletException, IOException {
        List<Transport> trains = getMockTrains(from, to, seatClass);
        request.setAttribute("transport", trains);
        request.setAttribute("transportServices", trains);
        request.setAttribute("searchType", "train");
        request.setAttribute("searchOrigin", from);
        request.setAttribute("searchDestination", to);
        request.setAttribute("date", date);
        forward(request, response);
    }

    private void handleBusSearch(HttpServletRequest request, HttpServletResponse response, String from, String to, String date, String type) throws ServletException, IOException {
        List<Transport> buses = getMockBuses(from, to, type);
        request.setAttribute("transport", buses);
        request.setAttribute("transportServices", buses);
        request.setAttribute("searchType", "bus");
        request.setAttribute("searchOrigin", from);
        request.setAttribute("searchDestination", to);
        request.setAttribute("date", date);
        forward(request, response);
    }

    private void handleCabSearch(HttpServletRequest request, HttpServletResponse response, String pickup, String drop, String date, String type) throws ServletException, IOException {
        List<Transport> cabs = getMockCabs(pickup, drop, type);
        request.setAttribute("transport", cabs);
        request.setAttribute("transportServices", cabs);
        request.setAttribute("searchType", "cab");
        request.setAttribute("searchOrigin", pickup);
        request.setAttribute("searchDestination", drop);
        request.setAttribute("date", date);
        forward(request, response);
    }

    private void handleCruiseSearch(HttpServletRequest request, HttpServletResponse response, String from, String to, String date, String type) throws ServletException, IOException {
        List<Transport> cruises = getMockCruises(from, to, type);
        request.setAttribute("transport", cruises);
        request.setAttribute("transportServices", cruises);
        request.setAttribute("searchType", "cruise");
        request.setAttribute("searchOrigin", from);
        request.setAttribute("searchDestination", to);
        request.setAttribute("date", date);
        forward(request, response);
    }

    private void handleHelicopterSearch(HttpServletRequest request, HttpServletResponse response, String from, String to, String date, String type) throws ServletException, IOException {
        List<Transport> helis = getMockHelicopters(from, to, type);
        request.setAttribute("transport", helis);
        request.setAttribute("transportServices", helis);
        request.setAttribute("searchType", "helicopter");
        request.setAttribute("searchOrigin", from);
        request.setAttribute("searchDestination", to);
        request.setAttribute("date", date);
        forward(request, response);
    }

    private void handlePackageSearch(HttpServletRequest request, HttpServletResponse response, String city, String date, String type) throws ServletException, IOException {
        List<Stay> packages = getMockPackages(city, type);
        request.setAttribute("hotels", packages); // Reusing hotels display format for packages
        request.setAttribute("searchType", "package");
        request.setAttribute("searchLocation", city);
        request.setAttribute("date", date);
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

    private List<Transport> getMockTrains(String from, String to, String seatClass) {
        List<Transport> list = new ArrayList<>();
        list.add(buildFlight("Vande Bharat", "22436", from, to, "06:00 AM", "02:00 PM", 1500.0, "8h 00m", 0, "Fastest"));
        list.add(buildFlight("Rajdhani Express", "12951", from, to, "04:30 PM", "08:30 AM", 2500.0, "16h 00m", 2, "Premium"));
        list.add(buildFlight("Shatabdi Exp", "12001", from, to, "06:00 AM", "11:45 AM", 1200.0, "5h 45m", 1, "Best Value"));
        for(Transport t : list) { t.setType("train"); t.setCompanyLogo("🚆"); }
        return list;
    }

    private List<Transport> getMockBuses(String from, String to, String type) {
        List<Transport> list = new ArrayList<>();
        list.add(buildFlight("Volvo AC Sleeper", "BUS-01", from, to, "09:00 PM", "07:00 AM", 1200.0, "10h 00m", 0, "Luxury"));
        list.add(buildFlight("Scania Semi-Sleeper", "BUS-02", from, to, "10:30 PM", "06:30 AM", 950.0, "8h 00m", 1, "Comfort"));
        list.add(buildFlight("Non-AC Seater", "BUS-03", from, to, "08:00 AM", "06:00 PM", 500.0, "10h 00m", 3, "Cheapest"));
        for(Transport t : list) { t.setType("bus"); t.setCompanyLogo("🚌"); }
        return list;
    }

    private List<Transport> getMockCabs(String pickup, String drop, String type) {
        List<Transport> list = new ArrayList<>();
        list.add(buildFlight("Uber Sedan", "Sedan", pickup, drop, "On Demand", "N/A", 1200.0, "Route Dependent", 0, "Popular"));
        list.add(buildFlight("Ola SUV", "SUV", pickup, drop, "On Demand", "N/A", 1800.0, "Route Dependent", 0, "Spacious"));
        for(Transport t : list) { t.setType("cab"); t.setCompanyLogo("🚕"); }
        return list;
    }

    private List<Transport> getMockCruises(String from, String to, String type) {
        List<Transport> list = new ArrayList<>();
        list.add(buildFlight("Cordelia Cruises", "Empress", from, to, "05:00 PM", "08:00 AM", 15000.0, "3 Days", 0, "Luxury"));
        list.add(buildFlight("Costa Cruises", "Serena", from, to, "04:00 PM", "10:00 AM", 18000.0, "4 Days", 1, "Premium"));
        for(Transport t : list) { t.setType("cruise"); t.setCompanyLogo("🚢"); }
        return list;
    }

    private List<Transport> getMockHelicopters(String from, String to, String type) {
        List<Transport> list = new ArrayList<>();
        list.add(buildFlight("Pawan Hans", "H-1", from, to, "08:00 AM", "08:45 AM", 8500.0, "45m", 0, "Scenic"));
        list.add(buildFlight("Blade India", "H-2", from, to, "10:00 AM", "10:30 AM", 12000.0, "30m", 0, "Fastest"));
        for(Transport t : list) { t.setType("helicopter"); t.setCompanyLogo("🚁"); }
        return list;
    }

    private List<Stay> getMockPackages(String city, String type) {
        List<Stay> list = new ArrayList<>();
        list.add(buildHotel("Complete " + (city != null ? city : "Destination") + " Package", city, 25000.0, "All Inclusive"));
        list.add(buildHotel("Luxury " + (city != null ? city : "Destination") + " Getaway", city, 45000.0, "Premium"));
        list.add(buildHotel("Budget " + (city != null ? city : "Destination") + " Tour", city, 12000.0, "Budget"));
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
