package com.voyastra.dao;

import com.voyastra.model.TripBooking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TripBookingDAO {

    public boolean addTripBooking(TripBooking booking) {
        String query = "INSERT INTO trip_bookings (user_id, trip_id, trip_name, destination, travel_date, amount, booking_status, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getTripId());
            stmt.setString(3, booking.getTripName());
            stmt.setString(4, booking.getDestination());
            stmt.setString(5, booking.getTravelDate());
            stmt.setDouble(6, booking.getAmount());
            stmt.setString(7, booking.getBookingStatus() != null ? booking.getBookingStatus() : "CONFIRMED");
            stmt.setBoolean(8, booking.isActive());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<TripBooking> getUserTripBookings(int userId) {
        List<TripBooking> list = new ArrayList<>();
        // Join with plans to get tripImage if necessary. The schema has trip_name and destination. 
        // We will fetch image from the plans table using trip_id.
        String query = "SELECT tb.*, p.image AS trip_image " +
                       "FROM trip_bookings tb " +
                       "LEFT JOIN plans p ON tb.trip_id = p.id " +
                       "WHERE tb.user_id = ? " +
                       "ORDER BY tb.created_at DESC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    TripBooking b = new TripBooking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setTripId(rs.getInt("trip_id"));
                    b.setTripName(rs.getString("trip_name"));
                    b.setDestination(rs.getString("destination"));
                    b.setTravelDate(rs.getString("travel_date"));
                    b.setAmount(rs.getDouble("amount"));
                    b.setBookingStatus(rs.getString("booking_status"));
                    b.setActive(rs.getBoolean("is_active"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    b.setTripImage(rs.getString("trip_image"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean hasBookings(int userId) {
        String query = "SELECT 1 FROM trip_bookings WHERE user_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setActiveTrip(int userId, int bookingId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Deactivate all
            String deactivateSql = "UPDATE trip_bookings SET is_active = FALSE WHERE user_id = ?";
            try (PreparedStatement stmt1 = conn.prepareStatement(deactivateSql)) {
                stmt1.setInt(1, userId);
                stmt1.executeUpdate();
            }

            // Activate target
            String activateSql = "UPDATE trip_bookings SET is_active = TRUE WHERE user_id = ? AND booking_id = ?";
            try (PreparedStatement stmt2 = conn.prepareStatement(activateSql)) {
                stmt2.setInt(1, userId);
                stmt2.setInt(2, bookingId);
                stmt2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }
}
