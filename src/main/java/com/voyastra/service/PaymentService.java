package com.voyastra.service;

import com.voyastra.api.RazorpayService;
import com.voyastra.dao.PaymentDAO;
import com.voyastra.model.Payment;
import com.voyastra.util.DBConnection;
import com.voyastra.util.RazorpayConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;

public class PaymentService {

    private static final PaymentDAO paymentDAO = new PaymentDAO();

    /**
     * Creates an order in Razorpay using the provided amount and receipt ID.
     */
    public static String createOrder(double amount, String receiptId) throws Exception {
        // Razorpay amount is in paise (multiply by 100)
        int amountInPaise = (int) (amount * 100);
        return RazorpayService.createOrder(amountInPaise, receiptId);
    }

    /**
     * Verifies if the signature passed by Razorpay is valid.
     */
    public static boolean verifyPayment(String orderId, String paymentId, String signature) {
        return RazorpayConfig.verifySignature(orderId, paymentId, signature);
    }

    /**
     * Saves the payment transaction details to the database.
     */
    public static int savePayment(int userId, String serviceType, String bookingReference,
                                  String razorpayOrderId, String razorpayPaymentId,
                                  double amount, String currency, String status) {
        Payment p = new Payment();
        p.setUserId(userId);
        p.setServiceType(serviceType);
        p.setBookingReference(bookingReference);
        p.setRazorpayOrderId(razorpayOrderId);
        p.setRazorpayPaymentId(razorpayPaymentId);
        p.setAmount(amount);
        p.setCurrency(currency != null ? currency : "INR");
        p.setStatus(status);
        p.setMethod("Razorpay");
        p.setTransactionId(razorpayPaymentId); // Set for backward compatibility
        return paymentDAO.addPayment(p);
    }

    /**
     * Generates a sequential booking reference number based on the current year.
     * e.g., TRN-2026-0001
     */
    public static synchronized String generateBookingReference(String serviceType) {
        String prefix = "";
        String tableName = "";
        switch (serviceType.toLowerCase()) {
            case "train":
                prefix = "TRN";
                tableName = "train_bookings";
                break;
            case "bus":
                prefix = "BUS";
                tableName = "bus_bookings";
                break;
            case "cab":
                prefix = "CAB";
                tableName = "cab_bookings";
                break;
            case "car":
                prefix = "CAR";
                tableName = "car_bookings";
                break;
            case "cruise":
                prefix = "CRU";
                tableName = "cruise_bookings";
                break;
            case "helicopter":
                prefix = "HEL";
                tableName = "helicopter_bookings";
                break;
            default:
                throw new IllegalArgumentException("Unknown service type: " + serviceType);
        }

        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        String yearStr = String.valueOf(currentYear);
        String pattern = prefix + "-" + yearStr + "-%";
        int count = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM " + tableName + " WHERE id LIKE ?")) {
            stmt.setString(1, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("[PaymentService] Error generating reference: " + e.getMessage());
        }

        return prefix + "-" + yearStr + "-" + String.format("%04d", count + 1);
    }
}
