package com.voyastra.servlet;

import com.voyastra.model.HotelBooking;
import com.voyastra.dao.HotelBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/hotel/details")
public class HotelBookingDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        System.out.println("Booking ID = " + bookingId);
        System.out.println("Booking Type = hotel");
        if (bookingId == null || bookingId.isEmpty()) {
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }
        HotelBooking booking = null;
        try {
            booking = new com.voyastra.dao.HotelBookingDAO().getBookingById(Integer.parseInt(bookingId));
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
        request.getRequestDispatcher("/pages/hotel-confirmation.jsp").forward(request, response);
    }
}
