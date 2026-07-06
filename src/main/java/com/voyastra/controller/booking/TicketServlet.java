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
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorId", "MISSING_BOOKING_ID");
            request.setAttribute("javax.servlet.error.status_code", 400);
            request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
            return;
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
