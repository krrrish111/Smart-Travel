package com.voyastra.servlet;

import com.voyastra.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/submit-booking")
public class SubmitGenericBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String type = request.getParameter("type");
        String idStr = request.getParameter("id");
        String priceStr = request.getParameter("price");
        String name = request.getParameter("name");
        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String travelDate = request.getParameter("travelDate");
        String travelTime = request.getParameter("travelTime");
        String guestsStr = request.getParameter("guests");

        double price = 0;
        int id = 0;
        int guests = 1;
        try { price = Double.parseDouble(priceStr); } catch (Exception ignored) {}
        try { id = Integer.parseInt(idStr); } catch (Exception ignored) {}
        try { guests = Integer.parseInt(guestsStr); } catch (Exception ignored) {}

        Booking booking = new Booking();
        booking.setType(type);
        booking.setId(id);
        booking.setTotalPrice(price + 250); // Adding tax for UI consistency with generic booking
        booking.setPlanTitle(name);
        booking.setDetails(name + " (" + guests + " Guests)");
        booking.setCustomerName(customerName);
        booking.setCustomerEmail(customerEmail);
        booking.setTravelDate(travelDate);
        booking.setNumAdults(guests);
        
        // Temporarily store additional info in empty fields for the next step
        booking.setRoomType(travelTime); // using roomType to store travelTime

        session.setAttribute("currentBooking", booking);
        request.getRequestDispatcher("/pages/booking-confirm.jsp").forward(request, response);
    }
}
