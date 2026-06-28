package com.voyastra.controller.transport;

import com.voyastra.model.booking.CabBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.booking.CabBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cab/ticket")
public class CabTicketServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CabTicketServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        CabBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new CabBookingDAO().getBookingById(idParam);
            System.out.println("Cab Ticket ID=" + idParam);
            System.out.println("Booking=" + booking);
        } catch(Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
        }
        
        if (booking == null) {
            request.setAttribute("errorMessage", "Cab Booking not found or invalid.");
            request.getRequestDispatcher("/pages/common/error.jsp").forward(request, response);
            return;
        }
        request.setAttribute("booking", booking);
        
        String print = request.getParameter("print");
        if ("true".equals(print)) {
            request.setAttribute("autoPrint", true);
        }
        
        request.getRequestDispatcher("/pages/transport/cab-ticket.jsp").forward(request, response);
    }
}
