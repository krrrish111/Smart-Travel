package com.voyastra.controller.booking;

import com.voyastra.model.booking.HotelBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.booking.HotelBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/hotel/download-ticket")
public class HotelDownloadTicketServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(HotelDownloadTicketServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        HotelBooking booking = null;
        try {
            int idParam = Integer.parseInt(bookingId);
            booking = new HotelBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        
        request.getRequestDispatcher("/pages/booking/hotel-ticket.jsp").forward(request, response);
    }
}
