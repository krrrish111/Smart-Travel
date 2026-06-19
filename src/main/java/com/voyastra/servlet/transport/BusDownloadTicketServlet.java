package com.voyastra.servlet.transport;

import com.voyastra.model.BusBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.BusBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/bus/download-ticket")
public class BusDownloadTicketServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(BusDownloadTicketServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        BusBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new BusBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        
        request.getRequestDispatcher("/pages/transport/bus-ticket.jsp").forward(request, response);
    }
}
