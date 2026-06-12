package com.voyastra.servlet.transport;

import com.voyastra.model.CabBooking;
import com.voyastra.dao.CabBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cab/ticket")
public class CabTicketServlet extends HttpServlet {
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
            e.printStackTrace();
        }
        
        if (booking == null) {
            request.setAttribute("errorMessage", "Cab Booking not found or invalid.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
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
