package com.voyastra.dao;

import com.voyastra.model.HelicopterBooking;
import com.voyastra.model.HelicopterPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HelicopterBookingDAO {
    
    public boolean saveBooking(HelicopterBooking booking) {
        String insertBooking = "INSERT INTO helicopter_bookings (id, user_id, operator, flight_type, origin, destination, travel_date, travel_time, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO helicopter_passengers (booking_id, name, weight_kg) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getOperator());
                ps.setString(4, booking.getFlightType());
                ps.setString(5, booking.getOrigin());
                ps.setString(6, booking.getDestination());
                ps.setString(7, booking.getTravelDate());
                ps.setString(8, booking.getTravelTime());
                ps.setDouble(9, booking.getAmount());
                ps.setString(10, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                for (HelicopterPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setDouble(3, p.getWeightKg());
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

    public List<HelicopterBooking> getBookingsByUserId(int userId) {
        List<HelicopterBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM helicopter_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HelicopterBooking b = new HelicopterBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setOperator(rs.getString("operator"));
                    b.setFlightType(rs.getString("heli_class"));
                    b.setOrigin(rs.getString("origin"));
                    b.setDestination(rs.getString("destination"));
                    b.setTravelDate(rs.getString("journey_date"));
                    b.setAmount(rs.getDouble("total_price"));
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

