package com.voyastra.servlet.booking;

import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.FlightBookingDAO;
import com.voyastra.model.Booking;
import com.voyastra.model.FlightBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private FlightBookingDAO flightBookingDAO = new FlightBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=invoice?code=" + request.getParameter("code"));
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String code = request.getParameter("code");

        if (code == null || code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=invalid_invoice");
            return;
        }

        // Step 1: Try to load from flight_bookings (new detailed table)
        FlightBooking flightBooking = flightBookingDAO.getByBookingCode(code);
        
        // Step 2: Fallback - load from old bookings table and parse details string
        if (flightBooking == null) {
            System.out.println("[InvoiceServlet] flight_bookings record not found for: " + code + " - trying bookings table fallback");
            flightBooking = flightBookingDAO.getFromBookingsTableByCode(code);
        }

        // Step 3: If still null, load generic booking and show partial ticket
        if (flightBooking == null) {
            Booking generic = bookingDAO.getBookingByCode(code);
            if (generic != null && generic.getType() != null && generic.getType().equals("flight")) {
                // Wrap in FlightBooking
                flightBooking = new FlightBooking();
                flightBooking.setId(generic.getId());
                flightBooking.setUserId(generic.getUserId());
                flightBooking.setBookingCode(generic.getBookingCode());
                flightBooking.setTotalPrice(generic.getTotalPrice());
                flightBooking.setStatus(generic.getStatus());
                flightBooking.setCreatedAt(generic.getCreatedAt());
                flightBooking.setCustomerName(generic.getCustomerName());
                flightBooking.setCustomerEmail(generic.getCustomerEmail());
                flightBooking.setDetails(generic.getDetails());
                flightBooking.parseDetails();
            }
        }

        if (flightBooking == null || flightBooking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=not_found");
            return;
        }

        // Debug logs as requested
        String bookingId = flightBooking.getBookingCode();
        String pnr = flightBooking.getPnr();
        String flightNumber = flightBooking.getFlightNumber();
        String origin = flightBooking.getDepartureCity();
        String destination = flightBooking.getArrivalCity();

        System.out.println("Booking ID = " + bookingId);
        System.out.println("PNR = " + pnr);
        System.out.println("Flight = " + flightNumber);
        System.out.println("Origin = " + origin);
        System.out.println("Destination = " + destination);

        // Verify data completeness
        if (origin == null || origin.isEmpty()) {
            System.out.println("[InvoiceServlet] WARNING: Origin is null/empty for booking: " + bookingId);
        }
        if (destination == null || destination.isEmpty()) {
            System.out.println("[InvoiceServlet] WARNING: Destination is null/empty for booking: " + bookingId);
        }
        if (flightNumber == null || flightNumber.isEmpty()) {
            System.out.println("[InvoiceServlet] WARNING: Flight number is null/empty for booking: " + bookingId);
        }

        // Calculate fare breakdown
        double total = flightBooking.getTotalPrice();
        double baseAmount = total / 1.18;
        double taxAmount = total - baseAmount;
        double convFee = 350.0;

        request.setAttribute("flightBooking", flightBooking);
        request.setAttribute("booking", flightBooking);   // kept for legacy template
        request.setAttribute("baseAmount", String.format("%.2f", baseAmount - convFee));
        request.setAttribute("gstAmount", String.format("%.2f", taxAmount));
        request.setAttribute("convFee", String.format("%.2f", convFee));
        request.setAttribute("bookingType", "FLIGHT");

        request.getRequestDispatcher("/pages/common/FlightTicket.jsp").forward(request, response);
    }
}
