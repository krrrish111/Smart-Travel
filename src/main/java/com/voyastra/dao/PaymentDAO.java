package com.voyastra.dao;

import com.voyastra.model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.voyastra.util.DBConnection;

public class PaymentDAO {

    public int addPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, user_id, amount, method, status, transaction_id, service_type, booking_reference, razorpay_order_id, razorpay_payment_id, currency) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            if (payment.getBookingId() > 0) {
                stmt.setInt(1, payment.getBookingId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setInt(2, payment.getUserId());
            stmt.setDouble(3, payment.getAmount());
            if (payment.getMethod() != null) {
                stmt.setString(4, payment.getMethod());
            } else {
                stmt.setNull(4, Types.VARCHAR);
            }
            stmt.setString(5, payment.getStatus());
            if (payment.getTransactionId() != null) {
                stmt.setString(6, payment.getTransactionId());
            } else {
                stmt.setNull(6, Types.VARCHAR);
            }
            stmt.setString(7, payment.getServiceType());
            stmt.setString(8, payment.getBookingReference());
            stmt.setString(9, payment.getRazorpayOrderId());
            stmt.setString(10, payment.getRazorpayPaymentId());
            stmt.setString(11, payment.getCurrency() != null ? payment.getCurrency() : "INR");
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        payment.setId(generatedId);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding payment: " + e.getMessage());
        }
        return generatedId;
    }

    public boolean updatePaymentStatus(int id, String status) {
        String sql = "UPDATE payments SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating payment status: " + e.getMessage());
            return false;
        }
    }

    public Payment getPaymentByTransactionId(String txId) {
        String sql = "SELECT * FROM payments WHERE transaction_id = ? OR razorpay_payment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, txId);
            stmt.setString(2, txId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractPayment(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting payment by txId: " + e.getMessage());
        }
        return null;
    }

    public List<Payment> getPaymentsByUser(int userId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(extractPayment(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting payments by user: " + e.getMessage());
        }
        return payments;
    }

    private Payment extractPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setAmount(rs.getDouble("amount"));
        p.setMethod(rs.getString("method"));
        p.setStatus(rs.getString("status"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setServiceType(rs.getString("service_type"));
        p.setBookingReference(rs.getString("booking_reference"));
        p.setRazorpayOrderId(rs.getString("razorpay_order_id"));
        p.setRazorpayPaymentId(rs.getString("razorpay_payment_id"));
        p.setCurrency(rs.getString("currency"));
        return p;
    }
}
