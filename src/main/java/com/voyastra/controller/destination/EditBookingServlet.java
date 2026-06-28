package com.voyastra.controller.destination;

import com.voyastra.dao.booking.DestinationBookingDAO;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/destination/booking/edit")
public class EditBookingServlet extends HttpServlet {
    private DestinationBookingDAO destinationBookingDAO;

    @Override
    public void init() throws ServletException {
        destinationBookingDAO = new DestinationBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Unauthorized\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String bookingIdStr = request.getParameter("booking_id");
        String travelDateStr = request.getParameter("travel_date");
        String guestsStr = request.getParameter("guests");

        if (bookingIdStr == null || travelDateStr == null || guestsStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Missing parameters\"}");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            java.sql.Date travelDate = java.sql.Date.valueOf(travelDateStr);
            int guests = Integer.parseInt(guestsStr);

            boolean success = destinationBookingDAO.updateBooking(bookingId, user.getId(), travelDate, guests);

            response.setContentType("application/json");
            if (success) {
                response.getWriter().write("{\"status\":\"success\", \"message\":\"Booking updated successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update booking\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"An error occurred\"}");
        }
    }
}
