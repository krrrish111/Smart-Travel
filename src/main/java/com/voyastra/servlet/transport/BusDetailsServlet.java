package com.voyastra.servlet.transport;

import com.voyastra.model.BusBooking;
import com.voyastra.dao.BusBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/bus/details")
public class BusDetailsServlet extends HttpServlet {
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
            e.printStackTrace();
        }
        
        System.out.println("Booking Loaded: " + booking);
        if (booking != null) {
            System.out.println("Amount: " + booking);
            System.out.println("Status: " + booking);
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/pages/transport/bus-confirmation.jsp").forward(request, response);
    }
}
