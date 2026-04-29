package com.voyastra.servlet;

import com.voyastra.dao.*;
import com.voyastra.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Random;

@WebServlet(urlPatterns = {"/booking", "/booking-history"})
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private TransportDAO transportDAO;
    private StayDAO stayDAO;
    private ActivityDAO activityDAO;
    private TripDAO tripDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        transportDAO = new TransportDAO();
        stayDAO = new StayDAO();
        activityDAO = new ActivityDAO();
        tripDAO = new TripDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "tripBooking": {
                // Dedicated trip booking form
                String tripIdStr = request.getParameter("tripId");
                if (tripIdStr != null) {
                    try {
                        PremiumTrip trip = tripDAO.getTripById(Integer.parseInt(tripIdStr));
                        if (trip != null) {
                            request.setAttribute("trip", trip);
                            request.getRequestDispatcher("/pages/trip-booking.jsp").forward(request, response);
                            return;
                        }
                    } catch (Exception e) {
                        System.err.println("Error loading trip for booking: " + e.getMessage());
                    }
                }
                response.sendRedirect("home");
                break;
            }
            case "confirm": {
                // Show confirmation page - data passed via session
                HttpSession session = request.getSession();
                if (session.getAttribute("pendingBooking") != null) {
                    request.getRequestDispatcher("/pages/booking-confirm.jsp").forward(request, response);
                } else {
                    response.sendRedirect("home");
                }
                break;
            }
            case "success": {
                String code = request.getParameter("code");
                if (code != null) {
                    Booking booking = bookingDAO.getBookingByCode(code);
                    if (booking != null) {
                        PremiumTrip trip = tripDAO.getTripById(booking.getPlanId());
                        request.setAttribute("booking", booking);
                        request.setAttribute("trip", trip);
                        request.getRequestDispatcher("/pages/booking-success.jsp").forward(request, response);
                        return;
                    }
                }
                response.sendRedirect("home");
                break;
            }
            case "new": {
                // Legacy: redirect to tripBooking
                String tripId = request.getParameter("tripId");
                if (tripId != null) {
                    response.sendRedirect("booking?action=tripBooking&tripId=" + tripId);
                } else {
                    response.sendRedirect("booking");
                }
                break;
            }
            default: {
                // Default booking page with transport/stays/activities
                String tripIdStr = request.getParameter("tripId");
                if (tripIdStr != null && !tripIdStr.isEmpty()) {
                    // Redirect to dedicated trip booking
                    response.sendRedirect("booking?action=tripBooking&tripId=" + tripIdStr);
                    return;
                }
                try {
                    List<Transport> allTransports = transportDAO.getAllTransportOptions();
                    List<Stay> allStays = stayDAO.getAllStays();
                    List<Activity> allActivities = activityDAO.getAllActivities();
                    request.setAttribute("transports", allTransports != null ? allTransports : new java.util.ArrayList<>());
                    request.setAttribute("stays", allStays != null ? allStays : new java.util.ArrayList<>());
                    request.setAttribute("activities", allActivities != null ? allActivities : new java.util.ArrayList<>());
                    request.getRequestDispatcher("/pages/booking.jsp").forward(request, response);
                } catch (Exception e) {
                    System.err.println("WARNING: Error fetching booking data.");
                    e.printStackTrace();
                    request.setAttribute("transports", new java.util.ArrayList<>());
                    request.setAttribute("stays", new java.util.ArrayList<>());
                    request.setAttribute("activities", new java.util.ArrayList<>());
                    request.getRequestDispatcher("/pages/booking.jsp").forward(request, response);
                }
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        if ("submitBooking".equals(action)) {
            // Process the trip booking form submission
            HttpSession session = request.getSession();
            String tripIdStr = request.getParameter("tripId");
            if (tripIdStr == null) { response.sendRedirect("home"); return; }

            int tripId = Integer.parseInt(tripIdStr);
            PremiumTrip trip = tripDAO.getTripById(tripId);
            if (trip == null) { response.sendRedirect("home"); return; }

            // Build booking object
            Booking booking = new Booking();
            Object userObj = session.getAttribute("user");
            int userId = 0;
            if (userObj instanceof User) userId = ((User) userObj).getId();
            booking.setUserId(userId);
            booking.setPlanId(tripId);
            booking.setCustomerName(request.getParameter("customerName"));
            booking.setCustomerEmail(request.getParameter("customerEmail"));
            booking.setCustomerPhone(request.getParameter("customerPhone"));
            booking.setTravelDate(request.getParameter("travelDate"));
            booking.setNumAdults(parseInt(request.getParameter("numAdults"), 1));
            booking.setNumChildren(parseInt(request.getParameter("numChildren"), 0));
            booking.setRoomType(request.getParameter("roomType"));
            booking.setPickupCity(request.getParameter("pickupCity"));
            booking.setSpecialRequests(request.getParameter("specialRequests"));

            // Calculate price
            double basePrice = trip.getDiscountPrice() > 0 ? trip.getDiscountPrice() : trip.getPriceInr();
            int totalTravelers = booking.getNumAdults() + booking.getNumChildren();
            double roomMultiplier = 1.0;
            if ("Deluxe".equals(booking.getRoomType())) roomMultiplier = 1.3;
            else if ("Suite".equals(booking.getRoomType())) roomMultiplier = 1.8;
            else if ("Premium Suite".equals(booking.getRoomType())) roomMultiplier = 2.5;
            double subtotal = basePrice * totalTravelers * roomMultiplier;
            double tax = subtotal * 0.05; // 5% GST
            double total = subtotal + tax;
            booking.setTotalPrice(total);

            // Generate booking code
            String code = "VYS-" + java.time.Year.now().getValue() + "-" + String.format("%05d", new Random().nextInt(99999));
            booking.setBookingCode(code);
            booking.setStatus("PENDING");

            // Store in session for confirmation page
            session.setAttribute("pendingBooking", booking);
            session.setAttribute("pendingTrip", trip);
            session.setAttribute("pendingSubtotal", subtotal);
            session.setAttribute("pendingTax", tax);

            response.sendRedirect("booking?action=confirm");

        } else if ("confirmBooking".equals(action)) {
            // Final confirmation - save to database
            HttpSession session = request.getSession();
            Booking booking = (Booking) session.getAttribute("pendingBooking");
            if (booking == null) { response.sendRedirect("home"); return; }

            booking.setStatus("CONFIRMED");
            int id = bookingDAO.addTripBooking(booking);
            if (id > 0) {
                String code = booking.getBookingCode();
                session.removeAttribute("pendingBooking");
                session.removeAttribute("pendingTrip");
                session.removeAttribute("pendingSubtotal");
                session.removeAttribute("pendingTax");
                response.sendRedirect("booking?action=success&code=" + code);
            } else {
                request.setAttribute("error", "Booking failed. Please try again.");
                request.getRequestDispatcher("/pages/booking-confirm.jsp").forward(request, response);
            }
        }
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
