package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.model.booking.Booking;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Random;

@WebServlet("/api/process-payment")
public class ProcessPaymentServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ProcessPaymentServlet.class);
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("ProcessPaymentServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("ProcessPaymentServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("ProcessPaymentServlet", "doGet", status, duration, "Process Payment GET page load");
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[ProcessPaymentServlet] doGet called, forwarding to payment screen.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            logger.warn("[ProcessPaymentServlet] Missing session or draftId. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        request.getRequestDispatcher("/pages/booking/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        String method = request.getParameter("method");
        try {
            doPostInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("ProcessPaymentServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("ProcessPaymentServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("ProcessPaymentServlet", "doPost", status, duration, "Process Payment POST transaction method: " + method);
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[ProcessPaymentServlet] doPost called to process payment.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("draftId") == null) {
            logger.warn("[ProcessPaymentServlet] Session expired or draftId missing in doPost. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Get payment callback data
        String method = request.getParameter("method"); // "wallet", "mock", or "razorpay"
        String paymentId = request.getParameter("payment_id");
        String transactionId = request.getParameter("transaction_id");
        String paymentStatus = request.getParameter("status"); // "SUCCESS" or "FAILED"

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            logger.warn("[ProcessPaymentServlet] Flight details missing from session. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Validation: only process if status is SUCCESS
        if (!"SUCCESS".equalsIgnoreCase(paymentStatus)) {
            logger.warn("[ProcessPaymentServlet] Payment status is not SUCCESS (status: {}). Redirecting back.", paymentStatus);
            response.sendRedirect(request.getContextPath() + "/api/process-payment?error=payment_failed");
            return;
        }

        // Razorpay signature verification (Server-Side)
        if ("razorpay".equals(method)) {
            String signature = request.getParameter("signature");
            String keyId = com.voyastra.util.RazorpayConfig.getKeyId();
            if (keyId != null && keyId.startsWith("rzp_test_")) {
                logger.info("[ProcessPaymentServlet] Verifying Razorpay payment signature.");
                if (!com.voyastra.util.RazorpayConfig.verifySignature(transactionId, paymentId, signature)) {
                    logger.error("[ProcessPaymentServlet] Razorpay payment signature verification failed!");
                    response.sendRedirect(request.getContextPath() + "/api/process-payment?error=payment_signature_verification_failed");
                    return;
                }
            }
        }
        int userId = (int) session.getAttribute("user_id");
        String userName  = (String) session.getAttribute("name");
        String userEmail = (String) session.getAttribute("email");

        double grandTotal = session.getAttribute("grandTotal") != null
                ? (double) session.getAttribute("grandTotal") : 0;
        String selectedSeats = (String) session.getAttribute("selectedSeats");
        String draftId = (String) session.getAttribute("draftId");

        com.voyastra.dao.booking.BookingDraftDAO draftDAO = new com.voyastra.dao.booking.BookingDraftDAO();
        long tDraftStart = System.currentTimeMillis();
        com.voyastra.model.booking.BookingDraft draft = draftDAO.getDraftById(draftId);
        long tDraftDuration = System.currentTimeMillis() - tDraftStart;
        com.voyastra.util.ObservabilityLogger.logStep("BookingDraftDAO", "getDraftById", "SUCCESS", tDraftDuration, "Fetch draft details", userId, null);
        String phone = (draft != null) ? draft.getContactPhone() : "";

        // Generate booking code
        String bookingCode = "FLT-" + new SimpleDateFormat("yyyy").format(new Date())
                + "-" + (10000 + new Random().nextInt(89999));

        logger.info("[ProcessPaymentServlet] Starting database transaction. User: {}, Method: {}, Total: ₹{}", userId, method, grandTotal);

        Connection conn = null;
        int bookingId = -1;
        com.voyastra.model.booking.FlightBooking booking = new com.voyastra.model.booking.FlightBooking();

        try {
            conn = com.voyastra.util.DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // Fetch user for balance check and loyalty points (with locks)
            double walletBalance = 0;
            int loyaltyPoints = 0;
            String checkUserSql = "SELECT wallet_balance, loyalty_points FROM users WHERE id = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(checkUserSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        walletBalance = rs.getDouble("wallet_balance");
                        loyaltyPoints = rs.getInt("loyalty_points");
                    } else {
                        throw new SQLException("User not found inside database transaction: " + userId);
                    }
                }
            }

            // Wallet check
            if ("wallet".equals(method)) {
                if (walletBalance < grandTotal) {
                    logger.warn("[ProcessPaymentServlet] Insufficient wallet funds. Required: ₹{}, Available: ₹{}", grandTotal, walletBalance);
                    conn.rollback();
                    response.sendRedirect(request.getContextPath() + "/api/process-payment?error=insufficient_funds");
                    return;
                }
                walletBalance -= grandTotal;

                // Sync with wallets table and insert transaction
                long tWalletStart = System.currentTimeMillis();
                com.voyastra.dao.travelcenter.WalletDAO walletDAO = new com.voyastra.dao.travelcenter.WalletDAO();
                com.voyastra.model.travelcenter.Wallet wallet = walletDAO.getWalletByUserId(conn, userId);
                if (wallet == null) {
                    wallet = walletDAO.createWallet(conn, userId);
                }
                if (wallet != null) {
                    walletDAO.updateBalance(conn, wallet.getId(), -grandTotal);
                    walletDAO.addTransaction(conn, wallet.getId(), -grandTotal, "DEBIT", "Flight booking: " + bookingCode);
                }
                long tWalletDuration = System.currentTimeMillis() - tWalletStart;
                com.voyastra.util.ObservabilityLogger.logStep("WalletDAO", "walletDeductions", "SUCCESS", tWalletDuration, "Deduct wallet balance and record transactions", userId, bookingCode);
            }

            // Award 1 loyalty point per 10 currency spent
            int pointsEarned = (int) (grandTotal / 10);
            loyaltyPoints += pointsEarned;

            // 2. Update user wallet and loyalty in DB
            long tUserStart = System.currentTimeMillis();
            com.voyastra.dao.profile.UserDAO userDAO = new com.voyastra.dao.profile.UserDAO();
            userDAO.updateWalletAndLoyalty(conn, userId, walletBalance, loyaltyPoints);
            long tUserDuration = System.currentTimeMillis() - tUserStart;
            com.voyastra.util.ObservabilityLogger.logStep("UserDAO", "updateWalletAndLoyalty", "SUCCESS", tUserDuration, "Update user wallet & loyalty points", userId, bookingCode);

            // 3. Create FlightBooking record
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
            booking.setTravelDate(currentFlight.get("date"));
            booking.setNumAdults(Integer.parseInt(currentFlight.getOrDefault("passengers", "1")));
            booking.setRoomType(currentFlight.get("class")); // maps to seat_class

            long tBookingStart = System.currentTimeMillis();
            bookingId = bookingDAO.createBooking(conn, booking);
            long tBookingDuration = System.currentTimeMillis() - tBookingStart;
            if (bookingId <= 0) {
                throw new SQLException("Failed to create booking in DB.");
            }
            booking.setId(bookingId);
            com.voyastra.util.ObservabilityLogger.logStep("BookingDAO", "createBooking", "SUCCESS", tBookingDuration, "Insert confirmed booking record", userId, bookingCode);

            // 4. Save Payment record in the payments table
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
            
            long tPaymentStart = System.currentTimeMillis();
            int payId = paymentDAO.addPayment(conn, payment);
            long tPaymentDuration = System.currentTimeMillis() - tPaymentStart;
            if (payId <= 0) {
                throw new SQLException("Failed to save payment record.");
            }
            com.voyastra.util.ObservabilityLogger.logStep("PaymentDAO", "addPayment", "SUCCESS", tPaymentDuration, "Insert payment confirmation record", userId, bookingCode);

            conn.commit(); // Commit transaction
            logger.info("[ProcessPaymentServlet] Transaction committed successfully for bookingCode: {}", bookingCode);

        } catch (Exception e) {
            com.voyastra.util.ObservabilityLogger.logError("ProcessPaymentServlet", "doPost", e, userId, bookingCode);
            logger.error("[ProcessPaymentServlet] Transaction failed, rolling back. Error: {}", e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    logger.error("[ProcessPaymentServlet] Rollback failed: {}", rollbackEx.getMessage(), rollbackEx);
                }
            }
            response.sendRedirect(request.getContextPath() + "/api/process-payment?error=transaction_failed");
            return;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    logger.error("[ProcessPaymentServlet] Connection close failed: {}", closeEx.getMessage(), closeEx);
                }
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
        long tNotifyStart = System.currentTimeMillis();
        try {
            logger.info("[ProcessPaymentServlet] Sending booking confirmation notifications.");
            com.voyastra.util.NotificationManager.sendTransportBookingSuccess(booking, userId);
            long tNotifyDuration = System.currentTimeMillis() - tNotifyStart;
            com.voyastra.util.ObservabilityLogger.logStep("NotificationManager", "sendTransportBookingSuccess", "SUCCESS", tNotifyDuration, "Send booking confirmation notifications", userId, bookingCode);
        } catch (Exception e) {
            long tNotifyDuration = System.currentTimeMillis() - tNotifyStart;
            com.voyastra.util.ObservabilityLogger.logStep("NotificationManager", "sendTransportBookingSuccess", "ERROR", tNotifyDuration, "Notifications dispatch failed: " + e.getMessage(), userId, bookingCode);
            logger.error("[ProcessPaymentServlet] Notification sending failed: {}", e.getMessage(), e);
        }

        // Clean up draft session attrs
        session.removeAttribute("draftId");
        session.removeAttribute("seatCharges");
        session.removeAttribute("extras_meal");
        session.removeAttribute("extras_baggage");
        session.removeAttribute("extras_insurance");
        session.removeAttribute("extras_total");
        session.removeAttribute("selectedSeats");

        logger.info("[ProcessPaymentServlet] Booking flow complete. Redirecting to success screen.");
        response.sendRedirect(request.getContextPath() + "/booking-confirmation");
    }
}
