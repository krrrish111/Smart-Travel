package com.voyastra.servlet;

import com.voyastra.dao.HotelBookingDAO;
import com.voyastra.model.HotelBooking;
import com.voyastra.model.User;
import com.voyastra.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.temporal.ChronoUnit;

@WebServlet("/hotel-review")
public class HotelReviewServlet extends HttpServlet {
    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            // Nothing to review — go back to search
            response.sendRedirect("hotels");
            return;
        }

        // Calculate nights
        long nights = 0;
        if (pending.getCheckIn() != null && pending.getCheckOut() != null) {
            nights = ChronoUnit.DAYS.between(
                pending.getCheckIn().toLocalDate(),
                pending.getCheckOut().toLocalDate()
            );
        }

        // Parse addons for display
        String[] addons = (String[]) session.getAttribute("pendingAddons");

        // Tax calculation (10%)
        double subtotal = pending.getTotalPrice();
        double tax      = Math.round(subtotal * 0.10 * 100.0) / 100.0;
        double grandTotal = Math.round((subtotal + tax) * 100.0) / 100.0;

        request.setAttribute("pending", pending);
        request.setAttribute("nights", nights);
        request.setAttribute("addons", addons);
        request.setAttribute("tax", tax);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/pages/hotel-review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            response.sendRedirect("hotels");
            return;
        }

        // Verify terms accepted
        String terms = request.getParameter("termsAccepted");
        if (!"on".equals(terms)) {
            request.setAttribute("error", "You must accept the Terms & Conditions to proceed.");
            doGet(request, response);
            return;
        }

        try {
            // Update total price with tax
            double tax       = Math.round(pending.getTotalPrice() * 0.10 * 100.0) / 100.0;
            double grandTotal = Math.round((pending.getTotalPrice() + tax) * 100.0) / 100.0;
            pending.setTotalPrice(grandTotal);

            int bookingId = bookingDAO.createBooking(pending);
            if (bookingId > 0) {
                // Send confirmation email
                String hotelName = pending.getHotel() != null ? pending.getHotel().getName() : "Your Hotel";
                EmailUtil.sendBookingConfirmation(
                    pending.getGuestEmail(),
                    pending.getGuestName(),
                    hotelName,
                    pending.getBookingCode()
                );

                // Clean up session
                session.removeAttribute("pendingHotelBooking");
                session.removeAttribute("pendingAddons");

                response.sendRedirect(request.getContextPath() + "/hotel-confirmation?id=" + bookingId);
            } else {
                request.setAttribute("error", "Failed to confirm booking. Please try again.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            doGet(request, response);
        }
    }
}
