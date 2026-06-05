package com.voyastra.servlet.booking;

import com.voyastra.dao.BookingDAO;
import com.voyastra.model.Booking;
import com.voyastra.model.Traveller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/ticket")
public class ViewTicketServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=ticket?code=" + request.getParameter("code"));
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String code = request.getParameter("code");

        if (code == null || code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=invalid_ticket");
            return;
        }

        Booking booking = bookingDAO.getBookingByCode(code);
        
        if (booking == null || booking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=not_found");
            return;
        }

        // We don't store draft_id in bookings to fetch the exact passenger details natively for past flights.
        // Instead, we reconstruct the Traveller objects directly from the `details` string which has the seats!
        List<Traveller> travellers = new ArrayList<>();
        
        String details = booking.getDetails();
        String seatsStr = "";
        
        // Extract Seats from details (e.g., "... | Seats: 12A, 14B | Date: ...")
        Matcher m = Pattern.compile("Seats:\\s*([^|]+)").matcher(details);
        if (m.find()) {
            seatsStr = m.group(1).trim();
        }

        String[] seatsArray = seatsStr.split(",");
        for (int i = 0; i < seatsArray.length; i++) {
            String seat = seatsArray[i].trim();
            if (seat.isEmpty()) continue;

            Traveller t = new Traveller();
            t.setSeatNumber(seat);
            if (i == 0) {
                // Main passenger is the customer
                t.setFirstName(booking.getCustomerName() != null ? booking.getCustomerName() : "Passenger");
                t.setLastName("");
            } else {
                t.setFirstName("Companion " + i);
                t.setLastName("");
            }
            travellers.add(t);
        }

        // Fallback if no seats found
        if (travellers.isEmpty()) {
            Traveller t = new Traveller();
            t.setFirstName(booking.getCustomerName() != null ? booking.getCustomerName() : "Passenger");
            t.setLastName("");
            t.setSeatNumber("TBA");
            travellers.add(t);
        }

        request.setAttribute("booking", booking);
        request.setAttribute("travellers", travellers);

        request.getRequestDispatcher("/pages/booking/booking-success.jsp").forward(request, response);
    }
}
