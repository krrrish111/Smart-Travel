package com.voyastra.dao;

import com.voyastra.model.Refund;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RefundDAO {
    public boolean createRefund(Refund refund) {
        String sql = "INSERT INTO refunds (booking_id, amount, status, refund_method) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, refund.getBookingId());
            stmt.setDouble(2, refund.getAmount());
            stmt.setString(3, refund.getStatus());
            stmt.setString(4, refund.getRefundMethod());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Refund getRefundByBookingId(int bookingId) {
        String sql = "SELECT * FROM refunds WHERE booking_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            try (java.sql.ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Refund r = new Refund();
                    r.setId(rs.getInt("id"));
                    r.setBookingId(rs.getInt("booking_id"));
                    r.setAmount(rs.getDouble("amount"));
                    r.setStatus(rs.getString("status"));
                    r.setRefundMethod(rs.getString("refund_method"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
