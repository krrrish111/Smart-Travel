package com.voyastra.servlet;

import com.voyastra.dao.ActivityDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.ItineraryDAO;
import com.voyastra.dao.StayDAO;
import com.voyastra.dao.TransportDAO;
import com.voyastra.model.Activity;
import com.voyastra.model.Booking;
import com.voyastra.model.Itinerary;
import com.voyastra.model.Stay;
import com.voyastra.model.Transport;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private ItineraryDAO itineraryDAO;
    private TransportDAO transportDAO;
    private StayDAO stayDAO;
    private ActivityDAO activityDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        itineraryDAO = new ItineraryDAO();
        transportDAO = new TransportDAO();
        stayDAO = new StayDAO();
        activityDAO = new ActivityDAO();
    }

    /**
     * Handles creating a new booking request.
     * Ensures session-based user access before processing.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        // Ensure user is authenticated to make a booking
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=authRequired");
            return;
        }

        try {
            String planIdStr = request.getParameter("plan_id");
            String priceStr = request.getParameter("total_price");

            if (planIdStr == null || planIdStr.isEmpty() || priceStr == null || priceStr.isEmpty()) {
                session.setAttribute("errorMsg", "Invalid booking request. Missing plan details.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            int planId = Integer.parseInt(planIdStr);
            double price = Double.parseDouble(priceStr);

            if (planId <= 0 || price < 0) {
                session.setAttribute("errorMsg", "Invalid booking data detected.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            // Extract userId safely from session
            int userId = (Integer) session.getAttribute("user_id");

            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setPlanId(planId);
            booking.setTotalPrice(price);
            booking.setStatus("CONFIRMED");

            boolean success = bookingDAO.addBooking(booking);

            if (success) {
                session.setAttribute("successMsg", "🎉 Booking confirmed! Your adventure awaits.");
                response.sendRedirect(request.getContextPath() + "/booking?action=history");
            } else {
                session.setAttribute("errorMsg", "Booking failed. Please try again.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An internal error occurred during booking.");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    /**
     * Handles fetching the user's personal booking history.
     * Ensures session-based user access before processing.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if ("history".equals(action)) {
            // Check session and userId to avoid NPE
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=sessionExpired");
                return;
            }
            
            try {
                int userId = (Integer) session.getAttribute("user_id");
                    
                List<Booking> userBookings = bookingDAO.getBookingsByUser(userId);
                List<Itinerary> userItineraries = itineraryDAO.getByUser(userId);
                
                // Safety: ensure they are never null
                if (userBookings == null) userBookings = new java.util.ArrayList<>();
                if (userItineraries == null) userItineraries = new java.util.ArrayList<>();
                
                request.setAttribute("userBookings", userBookings);
                request.setAttribute("userItineraries", userItineraries);
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("CRITICAL: Error fetching user history in BookingServlet");
                e.printStackTrace();
                request.setAttribute("userBookings", new java.util.ArrayList<>());
                request.setAttribute("userItineraries", new java.util.ArrayList<>());
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            }

        } else {
            // Default: Show the main Booking page with initial data
            try {
                List<Transport> allTransports = transportDAO.getAllTransportOptions();
                List<Stay> allStays = stayDAO.getAllStays();
                List<Activity> allActivities = activityDAO.getAllActivities();

                request.setAttribute("transports", allTransports != null ? allTransports : new java.util.ArrayList<>());
                request.setAttribute("stays", allStays != null ? allStays : new java.util.ArrayList<>());
                request.setAttribute("activities", allActivities != null ? allActivities : new java.util.ArrayList<>());

                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("WARNING: Error fetching global booking data. Falling back to empty lists.");
                e.printStackTrace();
                request.setAttribute("transports", new java.util.ArrayList<>());
                request.setAttribute("stays", new java.util.ArrayList<>());
                request.setAttribute("activities", new java.util.ArrayList<>());
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            }
        }
    }
}
