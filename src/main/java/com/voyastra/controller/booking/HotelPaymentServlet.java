package com.voyastra.controller.booking;

import com.voyastra.dao.booking.HotelBookingDAO;
import com.voyastra.dao.booking.BookingDAO;
import com.voyastra.dao.payment.PaymentDAO;
import com.voyastra.dao.travelcenter.WalletDAO;
import com.voyastra.dao.profile.UserDAO;
import com.voyastra.model.booking.HotelBooking;
import com.voyastra.model.booking.Booking;
import com.voyastra.model.payment.Payment;
import com.voyastra.model.profile.User;
import com.voyastra.model.travelcenter.Wallet;
import com.voyastra.util.DBConnection;
import com.voyastra.util.RazorpayConfig;
import com.voyastra.util.NotificationManager;
import com.voyastra.util.ObservabilityLogger;

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

@WebServlet("/process-hotel-payment")
public class HotelPaymentServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(HotelPaymentServlet.class);

    private final HotelBookingDAO hotelBookingDAO = new HotelBookingDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

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
            ObservabilityLogger.logError("HotelPaymentServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            ObservabilityLogger.logError("HotelPaymentServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            ObservabilityLogger.logStep("HotelPaymentServlet", "doPost", status, duration, "Process Hotel Payment POST transaction method: " + method);
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[HotelPaymentServlet] doPost called to process hotel payment.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            logger.warn("[HotelPaymentServlet] Session expired or user missing. Redirecting to login.");
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            logger.warn("[HotelPaymentServlet] No pending hotel booking found. Redirecting to stays.");
            response.sendRedirect("stays");
            return;
        }

        String method = request.getParameter("method"); // "WALLET", "MOCK", or Razorpay payment method
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        String transactionId = razorpayPaymentId != null ? razorpayPaymentId : "TXN-" + System.currentTimeMillis();
        String paymentId = razorpayOrderId != null ? razorpayOrderId : "PAY-" + System.currentTimeMillis();

        // Razorpay signature verification (Server-Side)
        if (method != null && !"WALLET".equalsIgnoreCase(method) && !"MOCK".equalsIgnoreCase(method)) {
            String keyId = RazorpayConfig.getKeyId();
            if (keyId != null && keyId.startsWith("rzp_test_")) {
                logger.info("[HotelPaymentServlet] Verifying Razorpay payment signature.");
                if (!RazorpayConfig.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
                    logger.error("[HotelPaymentServlet] Razorpay payment signature verification failed!");
                    response.sendRedirect(request.getContextPath() + "/payment?error=SignatureFailed");
                    return;
                }
            }
        }

        int userId = pending.getUserId();
        double grandTotal = pending.getTotalPrice();
        String bookingCode = pending.getBookingCode();

        logger.info("[HotelPaymentServlet] Starting database transaction. User: {}, Method: {}, Total: ₹{}", userId, method, grandTotal);

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
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
            if ("WALLET".equalsIgnoreCase(method)) {
                if (walletBalance < grandTotal) {
                    logger.warn("[HotelPaymentServlet] Insufficient wallet funds. Required: ₹{}, Available: ₹{}", grandTotal, walletBalance);
                    conn.rollback();
                    response.sendRedirect(request.getContextPath() + "/payment?error=insufficient_funds");
                    return;
                }
                walletBalance -= grandTotal;

                // Sync with wallets table and insert transaction
                long tWalletStart = System.currentTimeMillis();
                WalletDAO walletDAO = new WalletDAO();
                Wallet wallet = walletDAO.getWalletByUserId(conn, userId);
                if (wallet == null) {
                    wallet = walletDAO.createWallet(conn, userId);
                }
                if (wallet != null) {
                    walletDAO.updateBalance(conn, wallet.getId(), -grandTotal);
                    walletDAO.addTransaction(conn, wallet.getId(), -grandTotal, "DEBIT", "Hotel booking: " + bookingCode);
                }
                long tWalletDuration = System.currentTimeMillis() - tWalletStart;
                ObservabilityLogger.logStep("WalletDAO", "walletDeductions", "SUCCESS", tWalletDuration, "Deduct wallet balance and record transactions", userId, bookingCode);
            }

            // Award 1 loyalty point per 10 currency spent
            int pointsEarned = (int) (grandTotal / 10);
            loyaltyPoints += pointsEarned;

            // 2. Update user wallet and loyalty in DB
            long tUserStart = System.currentTimeMillis();
            UserDAO userDAO = new UserDAO();
            userDAO.updateWalletAndLoyalty(conn, userId, walletBalance, loyaltyPoints);
            long tUserDuration = System.currentTimeMillis() - tUserStart;
            ObservabilityLogger.logStep("UserDAO", "updateWalletAndLoyalty", "SUCCESS", tUserDuration, "Update user wallet & loyalty points", userId, bookingCode);

            // 3. Update HotelBooking in hotel_bookings table
            long tHotelBookingStart = System.currentTimeMillis();
            String updateHotelSql = "UPDATE hotel_bookings SET status = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateHotelSql)) {
                ps.setString(1, "Confirmed");
                ps.setInt(2, pending.getId());
                int rows = ps.executeUpdate();
                if (rows <= 0) {
                    throw new SQLException("Failed to update hotel booking status to Confirmed.");
                }
            }
            long tHotelBookingDuration = System.currentTimeMillis() - tHotelBookingStart;
            ObservabilityLogger.logStep("HotelBookingDAO", "confirmHotelBooking", "SUCCESS", tHotelBookingDuration, "Update hotel booking status to Confirmed", userId, bookingCode);

            // 4. Create and Save Booking record in the main bookings table
            Booking genericBooking = new Booking();
            genericBooking.setUserId(userId);
            genericBooking.setType("hotel");
            genericBooking.setDetails("Hotel: " + (pending.getHotel() != null ? pending.getHotel().getName() : "Premium Hotel")
                    + " | Room: " + (pending.getRoom() != null ? pending.getRoom().getType() : "Standard Room")
                    + " | Check-in: " + pending.getCheckIn()
                    + " | Check-out: " + pending.getCheckOut()
                    + " | Guests: " + pending.getGuests());
            genericBooking.setTotalPrice(grandTotal);
            genericBooking.setStatus("CONFIRMED");
            genericBooking.setBookingCode(bookingCode);
            genericBooking.setCustomerName(pending.getGuestName());
            genericBooking.setCustomerEmail(pending.getGuestEmail());
            genericBooking.setCustomerPhone(pending.getGuestPhone());
            genericBooking.setPaymentId(paymentId);
            genericBooking.setTransactionId(transactionId);
            genericBooking.setPaymentStatus("PAID");
            genericBooking.setTravelDate(pending.getCheckIn() != null ? pending.getCheckIn().toString() : "");
            genericBooking.setNumAdults(pending.getGuests());
            genericBooking.setRoomType(pending.getRoom() != null ? pending.getRoom().getType() : "Standard");

            long tBookingStart = System.currentTimeMillis();
            int mainBookingId = bookingDAO.createBooking(conn, genericBooking);
            long tBookingDuration = System.currentTimeMillis() - tBookingStart;
            if (mainBookingId <= 0) {
                throw new SQLException("Failed to create unified booking record.");
            }
            ObservabilityLogger.logStep("BookingDAO", "createBooking", "SUCCESS", tBookingDuration, "Insert confirmed unified booking record", userId, bookingCode);

            // 5. Save Payment record in the payments table
            Payment payment = new Payment();
            payment.setBookingId(pending.getId()); // maps to hotel booking ID
            payment.setUserId(userId);
            payment.setAmount(grandTotal);
            payment.setMethod(method != null ? method : "Razorpay");
            payment.setStatus("Success");
            payment.setTransactionId(transactionId);
            payment.setServiceType("hotel");
            payment.setBookingReference(bookingCode);
            payment.setRazorpayPaymentId(razorpayPaymentId);
            payment.setCurrency("INR");

            long tPaymentStart = System.currentTimeMillis();
            int payId = paymentDAO.addPayment(conn, payment);
            long tPaymentDuration = System.currentTimeMillis() - tPaymentStart;
            if (payId <= 0) {
                throw new SQLException("Failed to save payment record.");
            }
            ObservabilityLogger.logStep("PaymentDAO", "addPayment", "SUCCESS", tPaymentDuration, "Insert payment confirmation record", userId, bookingCode);

            conn.commit(); // Commit transaction
            logger.info("[HotelPaymentServlet] Transaction committed successfully for bookingCode: {}", bookingCode);

        } catch (Exception e) {
            ObservabilityLogger.logError("HotelPaymentServlet", "doPost", e, userId, bookingCode);
            logger.error("[HotelPaymentServlet] Transaction failed, rolling back. Error: {}", e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    logger.error("[HotelPaymentServlet] Rollback failed: {}", rollbackEx.getMessage(), rollbackEx);
                }
            }
            response.sendRedirect(request.getContextPath() + "/payment?error=SystemError");
            return;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    logger.error("[HotelPaymentServlet] Connection close failed: {}", closeEx.getMessage(), closeEx);
                }
            }
        }

        // Clean up all hotel booking session attributes
        session.removeAttribute("pendingHotelBooking");
        session.removeAttribute("pendingAddons");
        session.removeAttribute("currentBooking");
        session.removeAttribute("paymentAction");

        // Send notifications (In-App, Email with PDFs, SMS) using NotificationManager
        long tNotifyStart = System.currentTimeMillis();
        try {
            logger.info("[HotelPaymentServlet] Sending booking confirmation notifications.");
            NotificationManager.sendTransportBookingSuccess(pending, userId);
            long tNotifyDuration = System.currentTimeMillis() - tNotifyStart;
            ObservabilityLogger.logStep("NotificationManager", "sendTransportBookingSuccess", "SUCCESS", tNotifyDuration, "Send hotel booking confirmation notifications", userId, bookingCode);
        } catch (Exception e) {
            long tNotifyDuration = System.currentTimeMillis() - tNotifyStart;
            ObservabilityLogger.logStep("NotificationManager", "sendTransportBookingSuccess", "ERROR", tNotifyDuration, "Notifications dispatch failed: " + e.getMessage(), userId, bookingCode);
            logger.error("[HotelPaymentServlet] Notification sending failed: {}", e.getMessage(), e);
        }

        response.sendRedirect(request.getContextPath() + "/hotel-confirmation?id=" + pending.getId());
    }
}
