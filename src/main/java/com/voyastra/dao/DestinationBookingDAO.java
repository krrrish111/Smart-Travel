package com.voyastra.dao;

import com.voyastra.model.DestinationBooking;
import com.voyastra.model.Destination;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DestinationBookingDAO {

    public boolean addBooking(DestinationBooking b) {
        String query = "INSERT INTO destination_bookings (user_id, destination_id, order_id, payment_id, amount, status, is_active, travel_date, guests) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, b.getUserId());
            stmt.setInt(2, b.getDestinationId());
            stmt.setString(3, b.getOrderId());
            stmt.setString(4, b.getPaymentId());
            stmt.setDouble(5, b.getAmount());
            stmt.setString(6, b.getStatus());
            stmt.setBoolean(7, b.isActive());
            stmt.setDate(8, b.getTravelDate());
            stmt.setInt(9, b.getGuests());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<DestinationBooking> getBookingsByUserId(int userId) {
        List<DestinationBooking> list = new ArrayList<>();
        String query = "SELECT b.*, d.title, d.destination, d.image_url " +
                       "FROM destination_bookings b " +
                       "JOIN destinations d ON b.destination_id = d.id " +
                       "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DestinationBooking b = new DestinationBooking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setDestinationId(rs.getInt("destination_id"));
                    b.setOrderId(rs.getString("order_id"));
                    b.setPaymentId(rs.getString("payment_id"));
                    b.setAmount(rs.getDouble("amount"));
                    b.setStatus(rs.getString("status"));
                    b.setActive(rs.getBoolean("is_active"));
                    b.setTravelDate(rs.getDate("travel_date"));
                    b.setGuests(rs.getInt("guests"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    
                    Destination d = new Destination();
                    d.setId(b.getDestinationId());
                    d.setTitle(rs.getString("title"));
                    d.setDestination(rs.getString("destination"));
                    d.setImageUrl(rs.getString("image_url"));
                    b.setDestination(d);
                    
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean updatePaymentStatus(String orderId, String paymentId, String status) {
        String query = "UPDATE destination_bookings SET payment_id = ?, status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, paymentId);
            stmt.setString(2, status);
            stmt.setString(3, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setActiveBooking(int userId, int bookingId) {
        String resetQuery = "UPDATE destination_bookings SET is_active = false WHERE user_id = ?";
        String setActiveQuery = "UPDATE destination_bookings SET is_active = true WHERE id = ? AND user_id = ?";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmt1 = conn.prepareStatement(resetQuery)) {
                stmt1.setInt(1, userId);
                stmt1.executeUpdate();
            }
            
            try (PreparedStatement stmt2 = conn.prepareStatement(setActiveQuery)) {
                stmt2.setInt(1, bookingId);
                stmt2.setInt(2, userId);
                stmt2.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean updateBooking(int id, int userId, java.sql.Date travelDate, int guests) {
        String query = "UPDATE destination_bookings SET travel_date = ?, guests = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setDate(1, travelDate);
            stmt.setInt(2, guests);
            stmt.setInt(3, id);
            stmt.setInt(4, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelBooking(int id, int userId) {
        String query = "UPDATE destination_bookings SET status = 'CANCELLED' WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBookingStatus(int id, String status) {
        String query = "UPDATE destination_bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public DestinationBooking getBookingByOrderId(String orderId) {
        String query = "SELECT b.*, d.title, d.destination, d.image_url " +
                       "FROM destination_bookings b " +
                       "JOIN destinations d ON b.destination_id = d.id " +
                       "WHERE b.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DestinationBooking b = new DestinationBooking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setDestinationId(rs.getInt("destination_id"));
                    b.setOrderId(rs.getString("order_id"));
                    b.setPaymentId(rs.getString("payment_id"));
                    b.setAmount(rs.getDouble("amount"));
                    b.setStatus(rs.getString("status"));
                    b.setActive(rs.getBoolean("is_active"));
                    b.setTravelDate(rs.getDate("travel_date"));
                    b.setGuests(rs.getInt("guests"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    
                    Destination d = new Destination();
                    d.setId(b.getDestinationId());
                    d.setTitle(rs.getString("title"));
                    d.setDestination(rs.getString("destination"));
                    d.setImageUrl(rs.getString("image_url"));
                    b.setDestination(d);
                    
                    return b;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
