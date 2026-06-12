package com.voyastra.servlet.transport;

import com.voyastra.model.TrainBooking;
import com.voyastra.dao.TrainBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/train/details")
public class TrainBookingDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        System.out.println("Booking ID = " + bookingId);
        System.out.println("Booking Type = train");
        if (bookingId == null || bookingId.isEmpty()) {
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }
        TrainBooking booking = null;
        try {
            booking = new com.voyastra.dao.TrainBookingDAO().getBookingById(bookingId);
        } catch(Exception e) {
            e.printStackTrace();
        }
        System.out.println("Booking Loaded = " + booking);
        if (booking == null) {
            System.out.println("Error: Booking is null for id " + bookingId);
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/pages/transport/train-confirmation.jsp").forward(request, response);
    }
}
