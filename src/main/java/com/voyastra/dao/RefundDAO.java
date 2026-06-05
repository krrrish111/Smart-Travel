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
}
