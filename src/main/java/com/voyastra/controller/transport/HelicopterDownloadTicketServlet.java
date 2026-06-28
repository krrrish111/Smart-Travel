package com.voyastra.controller.transport;

import com.voyastra.model.booking.HelicopterBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.booking.HelicopterBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/helicopter/download-ticket")
public class HelicopterDownloadTicketServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(HelicopterDownloadTicketServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        HelicopterBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new HelicopterBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        
        request.getRequestDispatcher("/pages/transport/helicopter-ticket.jsp").forward(request, response);
    }
}
