package com.voyastra.dao.booking;

import com.voyastra.model.booking.ActivityBooking;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityBookingDAO {

    public int createBooking(ActivityBooking booking) {
        String query = "INSERT INTO activity_bookings (booking_id, user_id, activity_id, travel_date, travel_time, guests, status, amount, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
             
            stmt.setString(1, booking.getBookingId());
            stmt.setInt(2, booking.getUserId());
            stmt.setInt(3, booking.getActivityId());
            stmt.setString(4, booking.getTravelDate());
            stmt.setString(5, booking.getTravelTime());
            stmt.setInt(6, booking.getGuests());
            stmt.setString(7, booking.getStatus());
            stmt.setDouble(8, booking.getAmount());
            stmt.setBoolean(9, booking.isActive());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateBookingStatus(int id, String status) {
        String query = "UPDATE activity_bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setActiveBooking(int userId, int bookingId) {
        // Reset all active bookings for this user
        String resetQuery = "UPDATE activity_bookings SET is_active = false WHERE user_id = ?";
        String setActiveQuery = "UPDATE activity_bookings SET is_active = true WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt1 = conn.prepareStatement(resetQuery);
                 PreparedStatement stmt2 = conn.prepareStatement(setActiveQuery)) {
                 
                stmt1.setInt(1, userId);
                stmt1.executeUpdate();
                
                stmt2.setInt(1, bookingId);
                stmt2.setInt(2, userId);
                stmt2.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public ActivityBooking getBookingByOrderId(String orderId) {
        // Here we map the Razorpay receipt ID to our booking_id
        String query = "SELECT ab.*, a.title, a.hero_image, a.location FROM activity_bookings ab " +
                       "JOIN activities a ON ab.activity_id = a.id " +
                       "WHERE ab.booking_id = ?";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public ActivityBooking getBookingById(int id) {
        String query = "SELECT ab.*, a.title, a.hero_image, a.location FROM activity_bookings ab " +
                       "JOIN activities a ON ab.activity_id = a.id " +
                       "WHERE ab.id = ?";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ActivityBooking> getBookingsByUserId(int userId) {
        List<ActivityBooking> bookings = new ArrayList<>();
        String query = "SELECT ab.*, a.title, a.hero_image, a.location FROM activity_bookings ab " +
                       "JOIN activities a ON ab.activity_id = a.id " +
                       "WHERE ab.user_id = ? ORDER BY ab.created_at DESC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(extractFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    private ActivityBooking extractFromResultSet(ResultSet rs) throws SQLException {
        ActivityBooking booking = new ActivityBooking();
        booking.setId(rs.getInt("id"));
        booking.setBookingId(rs.getString("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setActivityId(rs.getInt("activity_id"));
        booking.setTravelDate(rs.getString("travel_date"));
        booking.setTravelTime(rs.getString("travel_time"));
        booking.setGuests(rs.getInt("guests"));
        booking.setStatus(rs.getString("status"));
        booking.setAmount(rs.getDouble("amount"));
        booking.setActive(rs.getBoolean("is_active"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        
        try { booking.setActivityName(rs.getString("title")); } catch (Exception e) {}
        try { booking.setActivityImage(rs.getString("hero_image")); } catch (Exception e) {}
        try { booking.setActivityLocation(rs.getString("location")); } catch (Exception e) {}
        
        return booking;
    }
}
