package com.voyastra.dao;

import com.voyastra.model.TrainBooking;
import com.voyastra.model.TrainPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TrainBookingDAO {
    
    public boolean saveDraft(TrainBooking booking) {
        String insertBookingSql = "INSERT INTO train_bookings (id, user_id, train_number, amount, status) VALUES (?, ?, ?, ?, ?)";
        String insertPassengerSql = "INSERT INTO train_passengers (booking_id, name, age, gender, berth_preference) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if(conn == null) return false;
            
            // Insert Booking
            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getTrainNumber());
                ps.setDouble(4, booking.getFare() * booking.getPassengers().size()); // Total amount
                ps.setString(5, booking.getStatus());
                ps.executeUpdate();
            }

            // Insert Passengers
            try (PreparedStatement ps = conn.prepareStatement(insertPassengerSql)) {
                for (TrainPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getBerthPreference());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public java.util.List<TrainBooking> getBookingsByUserId(int userId) {
        java.util.List<TrainBooking> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM train_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainBooking b = new TrainBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setTotalPrice(rs.getDouble("amount")); // Using amount column since we did amount
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
