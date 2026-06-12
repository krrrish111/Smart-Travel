package com.voyastra.servlet.transport;

import com.voyastra.model.CarBooking;
import com.voyastra.dao.CarBookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/car/ticket")
public class CarTicketServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("id");
        System.out.println("Booking ID = " + bookingId);
        System.out.println("Booking Type = car");
        if (bookingId == null || bookingId.isEmpty()) {
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }
        CarBooking booking = null;
        try {
            booking = new com.voyastra.dao.CarBookingDAO().getBookingById(bookingId);
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
        String print = request.getParameter("print");
        if (print != null && print.equals("true")) {
            request.setAttribute("autoPrint", true);
        }
        request.getRequestDispatcher("/pages/transport/car-ticket.jsp").forward(request, response);
    }
}
