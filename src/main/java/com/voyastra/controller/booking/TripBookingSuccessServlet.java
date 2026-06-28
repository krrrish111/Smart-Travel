package com.voyastra.controller.booking;

import com.voyastra.dao.booking.TripBookingDAO;
import com.voyastra.model.booking.TripBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/trip/booking-success")
public class TripBookingSuccessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        try {
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            String tripTitle = request.getParameter("tripTitle");
            String tripDest = request.getParameter("tripDest");
            String travelDate = request.getParameter("departureDate");
            double amount = Double.parseDouble(request.getParameter("totalPrice"));

            TripBookingDAO dao = new TripBookingDAO();
            
            // Check if user has any bookings, if not, set this as active
            boolean hasBookings = dao.hasBookings(userId);

            TripBooking tb = new TripBooking();
            tb.setUserId(userId);
            tb.setTripId(tripId);
            tb.setTripName(tripTitle);
            tb.setDestination(tripDest);
            tb.setTravelDate(travelDate);
            tb.setAmount(amount);
            tb.setBookingStatus("CONFIRMED");
            tb.setActive(!hasBookings); // Set true if first booking

            dao.addTripBooking(tb);

            // Forward to trip-confirmation.jsp to render the page
            request.getRequestDispatcher("/pages/planner/trip-confirmation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp");
        }
    }
}
