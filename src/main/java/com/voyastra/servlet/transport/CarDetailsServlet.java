package com.voyastra.servlet.transport;

import com.voyastra.model.CarBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.CarBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/car/details")
public class CarDetailsServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CarDetailsServlet.class.getName());

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
        request.getRequestDispatcher("/pages/transport/car-confirmation.jsp").forward(request, response);
    }
}
