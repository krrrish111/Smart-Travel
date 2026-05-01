package com.voyastra.servlet;

import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.ItineraryDAO;
import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Booking;
import com.voyastra.model.Itinerary;
import com.voyastra.model.Destination;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class DashboardServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final ItineraryDAO itineraryDAO = new ItineraryDAO();
    private final DestinationDAO destinationDAO = new DestinationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=dashboard");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            // 1. Fetch All User Data
            List<Booking> allBookings = bookingDAO.getBookingsByUser(userId);
            List<Itinerary> allPlans = itineraryDAO.getSavedPlans(userId);

            // 2. Calculate Stats
            int totalBookings = allBookings.size();
            int upcomingTrips = (int) allBookings.stream()
                    .filter(b -> "CONFIRMED".equalsIgnoreCase(b.getStatus()))
                    .count();
            int savedPlansCount = allPlans.size();

            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("upcomingTrips", upcomingTrips);
            request.setAttribute("savedPlansCount", savedPlansCount);

            // 3. Previews (Limit results)
            List<Booking> recentBookings = allBookings.stream()
                    .limit(3)
                    .collect(Collectors.toList());
            
            List<Itinerary> recentPlans = allPlans.stream()
                    .limit(3)
                    .collect(Collectors.toList());

            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("recentPlans", recentPlans);

            // 4. Recommended Destinations (Random 3)
            List<Destination> allDestinations = destinationDAO.getAllDestinations();
            List<Destination> recommendations = new ArrayList<>(allDestinations);
            Collections.shuffle(recommendations);
            recommendations = recommendations.stream().limit(3).collect(Collectors.toList());
            
            request.setAttribute("recommendations", recommendations);

        } catch (Exception e) {
            System.err.println("[DashboardServlet] Error fetching dashboard data: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/pages/user-home.jsp").forward(request, response);
    }
}
