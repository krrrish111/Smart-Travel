package com.voyastra.dao;

import com.voyastra.model.TrainBooking;
import com.voyastra.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainBookingDAO {
    public boolean saveBooking(TrainBooking booking) {
        // Basic save logic
        String sql = "INSERT INTO train_bookings (id, user_id, total_price, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, booking.getId());
            ps.setInt(2, booking.getUserId());
            ps.setDouble(3, booking.getTotalPrice());
            ps.setString(4, booking.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public TrainBooking getBookingById(String id) {
        return null;
    }

    public List<TrainBooking> getBookingsByUserId(int userId) {
        List<TrainBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM train_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainBooking b = new TrainBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
