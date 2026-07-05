package com.voyastra.controller.booking;

import com.voyastra.dao.booking.HotelDAO;
import com.voyastra.dao.SearchHistoryDAO;
import com.voyastra.model.booking.Hotel;
import com.voyastra.model.booking.HotelSearchHistory;
import com.voyastra.model.profile.User;
import com.voyastra.util.HotelAPIClient;
import com.voyastra.service.GoogleMapService;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/hotels")
public class HotelSearchServlet extends HttpServlet {
    private HotelDAO hotelDAO = new HotelDAO();
    private SearchHistoryDAO historyDAO = new SearchHistoryDAO();
    private GoogleMapService googleMapService = new GoogleMapService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelSearchServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelSearchServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("HotelSearchServlet", "doGet", status, duration, "Hotel Search query: " + request.getParameter("q"));
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String city = request.getParameter("q");
        if (city == null) city = "";
        
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String roomsStr = request.getParameter("rooms");
        String adultsStr = request.getParameter("adults");
        String childrenStr = request.getParameter("children");
        String hotelType = request.getParameter("hotelType");
        
        // Amenities array
        String[] amenitiesArr = request.getParameterValues("amenities");
        String amenitiesList = amenitiesArr != null ? String.join(",", amenitiesArr) : "";

        // Parse ints
        int rooms = roomsStr != null && !roomsStr.isEmpty() ? Integer.parseInt(roomsStr) : 1;
        int adults = adultsStr != null && !adultsStr.isEmpty() ? Integer.parseInt(adultsStr) : 2;
        int children = childrenStr != null && !childrenStr.isEmpty() ? Integer.parseInt(childrenStr) : 0;

        // Store Search History if parameters exist
        if (!city.isEmpty() || checkIn != null) {
            HotelSearchHistory history = new HotelSearchHistory();
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                history.setUserId(user.getId());
            }
            history.setDestination(city);
            history.setCheckIn(checkIn);
            history.setCheckOut(checkOut);
            history.setRooms(rooms);
            history.setAdults(adults);
            history.setChildren(children);
            history.setHotelType(hotelType);
            history.setAmenities(amenitiesList);
            
            historyDAO.saveSearchHistory(history);
        }

        // Fetch Local Hotels
        List<Hotel> localHotels = hotelDAO.searchHotels(city);
        
        // Fetch API Dynamic Hotels using Google Places
        List<Hotel> apiHotels = new ArrayList<>();
        if (!city.isEmpty()) {
            JsonObject googleRes = googleMapService.getHotelsForDestination(city);
            if ("OK".equals(googleRes.get("status").getAsString())) {
                JsonArray places = googleRes.getAsJsonArray("hotels");
                int apiIndex = 0;
                for (JsonElement el : places) {
                    JsonObject p = el.getAsJsonObject();
                    Hotel h = new Hotel();
                    h.setName(p.get("name").getAsString());
                    h.setAddress(p.get("address").getAsString());
                    h.setCity(city);
                    h.setStartingPrice(150.0 + (apiIndex * 30.0)); // Staggered price
                    h.setRating(p.get("rating").getAsDouble());
                    h.setImageUrl(p.get("photo").getAsString());
                    // Assign a stable synthetic ID >= 100 so HotelCheckoutServlet
                    // routes this as a dynamic API hotel instead of a DB lookup.
                    // Formula: 100 + abs(nameHash) % 9900  → always in [100, 9999]
                    int syntheticId = 100 + Math.abs(h.getName().hashCode()) % 9900;
                    h.setId(syntheticId);
                    apiHotels.add(h);
                    apiIndex++;
                }
            }
        }

        
        // Merge results
        List<Hotel> allHotels = new ArrayList<>();
        allHotels.addAll(localHotels);
        allHotels.addAll(apiHotels);
        
        List<Integer> wishlistedIds = new ArrayList<>();
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            List<Hotel> wishlistHotels = hotelDAO.getWishlist(user.getId());
            for (Hotel h : wishlistHotels) {
                wishlistedIds.add(h.getId());
            }
        }
        request.setAttribute("wishlistedIds", wishlistedIds);

        request.setAttribute("hotels", allHotels);
        request.setAttribute("searchQuery", city);
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("rooms", rooms);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("hotelType", hotelType);
        if (amenitiesArr != null) {
            request.setAttribute("selectedAmenities", Arrays.asList(amenitiesArr));
        }

        if (city.isEmpty() && checkIn == null) {
            request.getRequestDispatcher("/pages/booking/hotels.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/pages/booking/hotel-results.jsp").forward(request, response);
        }
    }
}