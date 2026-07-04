package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.model.booking.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Random;

@WebServlet("/api/process-payment")
public class ProcessPaymentServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        // Show the payment page
        request.getRequestDispatcher("/pages/booking/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Get payment callback data
        String method = request.getParameter("method"); // "wallet", "mock", or "razorpay"
        String paymentId = request.getParameter("payment_id");
        String transactionId = request.getParameter("transaction_id");
        String paymentStatus = request.getParameter("status"); // "SUCCESS" or "FAILED"

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        int userId = (int) session.getAttribute("user_id");
        String userName  = (String) session.getAttribute("name");
        String userEmail = (String) session.getAttribute("email");

        double grandTotal = session.getAttribute("grandTotal") != null
                ? (double) session.getAttribute("grandTotal") : 0;
        String selectedSeats = (String) session.getAttribute("selectedSeats");
        String draftId = (String) session.getAttribute("draftId");

        // Fetch Draft to get the phone number
        com.voyastra.dao.booking.BookingDraftDAO draftDAO = new com.voyastra.dao.booking.BookingDraftDAO();
        com.voyastra.model.booking.BookingDraft draft = draftDAO.getDraftById(draftId);
        String phone = (draft != null) ? draft.getContactPhone() : "";

        // Generate booking code
        String bookingCode = "FLT-" + new SimpleDateFormat("yyyy").format(new Date())
                + "-" + (10000 + new Random().nextInt(89999));

        // Wallet & Loyalty logic
        com.voyastra.dao.profile.UserDAO userDAO = new com.voyastra.dao.profile.UserDAO();
        com.voyastra.model.profile.User user = userDAO.getUserById(userId);
        
        if ("wallet".equals(method)) {
            if (user.getWalletBalance() < grandTotal) {
                response.sendRedirect(request.getContextPath() + "/api/process-payment?error=insufficient_funds");
                return;
            }
            user.setWalletBalance(user.getWalletBalance() - grandTotal);
            
            // Sync with wallets table and insert transaction
            com.voyastra.dao.travelcenter.WalletDAO walletDAO = new com.voyastra.dao.travelcenter.WalletDAO();
            com.voyastra.model.travelcenter.Wallet wallet = walletDAO.getWalletByUserId(userId);
            if (wallet == null) {
                wallet = walletDAO.createWallet(userId);
            }
            if (wallet != null) {
                walletDAO.updateBalance(wallet.getId(), -grandTotal);
                walletDAO.addTransaction(wallet.getId(), -grandTotal, "DEBIT", "Flight booking: " + bookingCode);
            }
        }

        // Award 1 loyalty point per 10 currency spent
        int pointsEarned = (int) (grandTotal / 10);
        user.setLoyaltyPoints(user.getLoyaltyPoints() + pointsEarned);
        
        userDAO.updateWalletAndLoyalty(userId, user.getWalletBalance(), user.getLoyaltyPoints());

        // Persist to bookings table using FlightBooking object
        com.voyastra.model.booking.FlightBooking booking = new com.voyastra.model.booking.FlightBooking();
        booking.setUserId(userId);
        booking.setType("flight");
        booking.setDetails("Flight: " + currentFlight.get("name") + " (" + currentFlight.get("id") + ")"
                + " | " + currentFlight.get("from") + " → " + currentFlight.get("to")
                + " | Class: " + currentFlight.get("class")
                + " | Passengers: " + currentFlight.get("passengers")
                + " | Seats: " + selectedSeats
                + " | Date: " + currentFlight.get("date"));
        booking.setTotalPrice(grandTotal);
        booking.setStatus("CONFIRMED");
        booking.setBookingCode(bookingCode);
        booking.setCustomerName(userName);
        booking.setCustomerEmail(userEmail);
        booking.setCustomerPhone(phone);
        booking.setPaymentId(paymentId);
        booking.setTransactionId(transactionId);
        booking.setPaymentStatus(paymentStatus);
        
        // Populate extra DB columns
        booking.setTravelDate(currentFlight.get("date"));
        booking.setNumAdults(Integer.parseInt(currentFlight.getOrDefault("passengers", "1")));
        booking.setRoomType(currentFlight.get("class")); // maps to seat_class

        int bookingId = -1;
        try {
            bookingId = bookingDAO.createBooking(booking);
            booking.setId(bookingId);
        } catch (Exception e) {
            System.err.println("[ProcessPaymentServlet] Booking save failed: " + e.getMessage());
        }

        // Save Payment record in the payments table
        if (bookingId > 0) {
            try {
                com.voyastra.dao.payment.PaymentDAO paymentDAO = new com.voyastra.dao.payment.PaymentDAO();
                com.voyastra.model.payment.Payment payment = new com.voyastra.model.payment.Payment();
                payment.setBookingId(bookingId);
                payment.setUserId(userId);
                payment.setAmount(grandTotal);
                payment.setMethod(method);
                payment.setStatus(paymentStatus);
                payment.setTransactionId(transactionId);
                payment.setServiceType("flight");
                payment.setBookingReference(bookingCode);
                payment.setRazorpayPaymentId(paymentId);
                payment.setCurrency("INR");
                paymentDAO.addPayment(payment);
            } catch (Exception e) {
                System.err.println("[ProcessPaymentServlet] Payment record save failed: " + e.getMessage());
            }
        }

        // Store confirmation data in session
        session.setAttribute("confirmedBookingCode", bookingCode);
        session.setAttribute("confirmedBookingId", bookingId);
        session.setAttribute("confirmedTotal", grandTotal);
        session.setAttribute("confirmedPaymentId", paymentId);
        session.setAttribute("confirmedDraftId", draftId);
        session.setAttribute("confirmedFlight", currentFlight);
        session.setAttribute("confirmedSeats", selectedSeats);

        // Send notifications (In-App, Email with PDFs, SMS) using NotificationManager
        try {
            com.voyastra.util.NotificationManager.sendTransportBookingSuccess(booking, userId);
        } catch (Exception e) {
            System.err.println("[ProcessPaymentServlet] Notification sending failed: " + e.getMessage());
            e.printStackTrace();
        }

        // Clean up draft session attrs
        session.removeAttribute("draftId");
        session.removeAttribute("seatCharges");
        session.removeAttribute("extras_meal");
        session.removeAttribute("extras_baggage");
        session.removeAttribute("extras_insurance");
        session.removeAttribute("extras_total");
        session.removeAttribute("selectedSeats");

        response.sendRedirect(request.getContextPath() + "/booking-confirmation");
    }
}
