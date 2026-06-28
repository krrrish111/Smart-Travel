package com.voyastra.controller.transport;

import com.voyastra.model.booking.CarBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.booking.CarBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/car/ticket")
public class CarTicketServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CarTicketServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        CarBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new CarBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }
        request.setAttribute("booking", booking);
        
        String print = request.getParameter("print");
        if ("true".equals(print)) {
            request.setAttribute("autoPrint", true);
        }
        
        request.getRequestDispatcher("/pages/transport/car-ticket.jsp").forward(request, response);
    }
}
