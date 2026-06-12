package com.voyastra.servlet.transport;

import com.voyastra.model.CruiseBooking;
import com.voyastra.dao.CruiseBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cruise/download-ticket")
public class CruiseDownloadTicketServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        CruiseBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new CruiseBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        
        request.getRequestDispatcher("/pages/transport/cruise-ticket.jsp").forward(request, response);
    }
}
