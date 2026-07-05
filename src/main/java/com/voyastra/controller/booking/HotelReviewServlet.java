package com.voyastra.controller.booking;

import com.voyastra.dao.booking.HotelBookingDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.model.booking.HotelBooking;
import com.voyastra.model.profile.User;
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
    private static final Logger logger = Logger.getLogger(HotelReviewServlet.class.getName());

    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelReviewServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelReviewServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("HotelReviewServlet", "doGet", status, duration, "Hotel booking review screen render");
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            // Nothing to review â€” go back to home
            response.sendRedirect(request.getContextPath() + "/");
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

        request.getRequestDispatcher("/pages/booking/hotel-review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doPostInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelReviewServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("HotelReviewServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("HotelReviewServlet", "doPost", status, duration, "Hotel booking review accepted, forwarding to payment");
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            response.sendRedirect(request.getContextPath() + "/");
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

            // Create a generic Booking object for the payment.jsp generic UI
            com.voyastra.model.booking.Booking genericBooking = new com.voyastra.model.booking.Booking();
            genericBooking.setId(0); // not saved yet
            genericBooking.setType("hotel");
            genericBooking.setBookingCode(pending.getBookingCode());
            genericBooking.setTotalPrice(grandTotal);
            genericBooking.setCustomerName(pending.getGuestName());
            genericBooking.setTravelDate(pending.getCheckIn() + " to " + pending.getCheckOut());
            genericBooking.setDetails(pending.getHotel() != null ? pending.getHotel().getName() : "Premium Hotel");
            genericBooking.setPlanTitle(pending.getRoom() != null ? pending.getRoom().getType() : "Standard Room");
            genericBooking.setPlanImage(pending.getHotel() != null ? pending.getHotel().getImageUrl() : "");

            // Store in session for payment.jsp to render
            session.setAttribute("currentBooking", genericBooking);
            session.setAttribute("paymentAction", "process-hotel-payment"); // Instruct payment.jsp where to POST
            
            // Note: pendingHotelBooking remains in session to be accessed by HotelPaymentServlet

            response.sendRedirect(request.getContextPath() + "/payment");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            doGet(request, response);
        }
    }
}
