package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.model.booking.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/trip-ticket")
public class TicketServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String typeParam = request.getParameter("type");

        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorId", "MISSING_BOOKING_ID");
            request.setAttribute("javax.servlet.error.status_code", 400);
            request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
            return;
        }

        // Check if destination ticket is requested
        if ("destination".equalsIgnoreCase(typeParam)) {
            try {
                com.voyastra.dao.booking.DestinationBookingDAO destDAO = new com.voyastra.dao.booking.DestinationBookingDAO();
                com.voyastra.model.booking.DestinationBooking db = destDAO.getBookingByIdOrCode(idParam);
                if (db != null) {
                    com.voyastra.dao.profile.UserDAO userDAO = new com.voyastra.dao.profile.UserDAO();
                    com.voyastra.model.profile.User user = userDAO.getUserById(db.getUserId());
                    
                    request.setAttribute("bookingId", db.getOrderId() != null ? db.getOrderId() : db.getPaymentId());
                    request.setAttribute("destinationTitle", db.getDestination() != null ? db.getDestination().getTitle() : "Top Trending Destination");
                    request.setAttribute("travelDate", db.getTravelDate() != null ? db.getTravelDate().toString() : "");
                    request.setAttribute("primaryName", user != null ? user.getName() : "Traveler");
                    request.setAttribute("primaryEmail", user != null ? user.getEmail() : "");
                    request.setAttribute("primaryPhone", user != null ? user.getPhone() : "");
                    request.setAttribute("guests", db.getGuests());

                    request.getRequestDispatcher("/pages/destination/destination-ticket.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorId", "BOOKING_NOT_FOUND");
                    request.setAttribute("javax.servlet.error.status_code", 404);
                    request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorId", "SYSTEM_FAILURE");
                request.setAttribute("javax.servlet.error.status_code", 500);
                request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
                return;
            }
        }

        try {
            int id = Integer.parseInt(idParam);
            Booking booking = bookingDAO.getBookingById(id);
            if (booking != null) {
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/pages/ticket/trip-ticket.jsp").forward(request, response);
            } else {
                request.setAttribute("errorId", "BOOKING_NOT_FOUND");
                request.setAttribute("javax.servlet.error.status_code", 404);
                request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorId", "INVALID_BOOKING_ID");
            request.setAttribute("javax.servlet.error.status_code", 400);
            request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
        }
    }
}
