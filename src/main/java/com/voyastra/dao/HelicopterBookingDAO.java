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
        String insertBooking = "INSERT INTO helicopter_bookings (id, user_id, origin, destination, journey_date, passengers, heli_class, total_price, status, operator, departure_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO helicopter_passengers (booking_id, name, weight_kg) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getOrigin());
                ps.setString(4, booking.getDestination());
                ps.setString(5, booking.getTravelDate());
                ps.setInt(6, booking.getPassengers().size());
                ps.setString(7, booking.getFlightType());
                ps.setDouble(8, booking.getAmount());
                ps.setString(9, booking.getStatus());
                ps.setString(10, booking.getOperator());
                ps.setString(11, booking.getTravelTime());
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

    public HelicopterBooking getBookingById(String id) {
        HelicopterBooking booking = null;
        String sql = "SELECT * FROM helicopter_bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new HelicopterBooking();
                    booking.setId(rs.getString("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setOrigin(rs.getString("origin"));
                    booking.setDestination(rs.getString("destination"));
                    booking.setTravelDate(rs.getString("journey_date"));
                    booking.setFlightType(rs.getString("heli_class"));
                    booking.setAmount(rs.getDouble("total_price"));
                    booking.setStatus(rs.getString("status"));
                    booking.setOperator(rs.getString("operator"));
                    booking.setTravelTime(rs.getString("departure_time"));
                    booking.setPassengers(new java.util.ArrayList<>());
                }
            }
            if (booking != null) {
                String passSql = "SELECT * FROM helicopter_passengers WHERE booking_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(passSql)) {
                    ps2.setString(1, id);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            HelicopterPassenger p = new HelicopterPassenger();
                            p.setName(rs2.getString("name"));
                            p.setWeightKg(rs2.getDouble("weight_kg"));
                            booking.getPassengers().add(p);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return booking;
    }

}
