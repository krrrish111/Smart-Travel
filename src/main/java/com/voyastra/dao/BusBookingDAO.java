package com.voyastra.dao;

import com.voyastra.model.BusBooking;
import com.voyastra.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BusBookingDAO {
    public boolean saveBooking(BusBooking booking) {
        // Basic save logic
        String sql = "INSERT INTO bus_bookings (id, user_id, total_price, status) VALUES (?, ?, ?, ?)";
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
    
    public BusBooking getBookingById(String id) {
        return null;
    }

    public List<BusBooking> getBookingsByUserId(int userId) {
        List<BusBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM bus_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusBooking b = new BusBooking();
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
