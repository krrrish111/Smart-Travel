package com.voyastra.dao;

import com.voyastra.model.CruiseBooking;
import com.voyastra.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CruiseBookingDAO {
    public boolean saveBooking(CruiseBooking booking) {
        // Basic save logic
        String sql = "INSERT INTO cruise_bookings (id, user_id, total_price, status) VALUES (?, ?, ?, ?)";
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
    
    public CruiseBooking getBookingById(String id) {
        return null;
    }

    public List<CruiseBooking> getBookingsByUserId(int userId) {
        List<CruiseBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM cruise_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CruiseBooking b = new CruiseBooking();
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
