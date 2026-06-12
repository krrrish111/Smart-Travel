package com.voyastra.servlet.booking;

import com.voyastra.model.FlightBooking;
import com.voyastra.dao.FlightBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/flight/download-ticket")
public class FlightDownloadTicketServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        FlightBooking booking = null;
        try {
            int idParam = Integer.parseInt(bookingId);
            booking = new FlightBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        
        request.getRequestDispatcher("/pages/flight-ticket.jsp").forward(request, response);
    }
}
