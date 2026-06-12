package com.voyastra.dao;

import com.voyastra.model.CabBooking;
import com.voyastra.model.CabPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CabBookingDAO {
    
    public boolean saveBooking(CabBooking booking) {
        String insertBooking = "INSERT INTO cab_bookings (id, user_id, pickup_location, drop_location, pickup_date, pickup_time, cab_type, vehicle_type, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO cab_passengers (booking_id, name, phone, email) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getPickup());
                ps.setString(4, booking.getDropoff());
                ps.setString(5, booking.getDate());
                ps.setString(6, booking.getTime());
                ps.setString(7, booking.getBookingType()); // e.g. Airport, Outstation
                ps.setString(8, booking.getVehicleType()); // e.g. SUV, Sedan
                ps.setDouble(9, booking.getAmount());
                ps.setString(10, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                ps.setString(1, booking.getId());
                ps.setString(2, booking.getPassenger().getName());
                ps.setString(3, booking.getPassenger().getPhone());
                ps.setString(4, booking.getPassenger().getEmail());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CabBooking> getBookingsByUserId(int userId) {
        List<CabBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM cab_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CabBooking b = new CabBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setVehicleType(rs.getString("vehicle_type"));
                    b.setPickup(rs.getString("pickup_location"));
                    b.setDropoff(rs.getString("drop_location"));
                    b.setDate(rs.getString("pickup_date"));
                    b.setTime(rs.getString("pickup_time"));
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

    public CabBooking getBookingById(String id) {
        CabBooking booking = null;
        String sql = "SELECT * FROM cab_bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new CabBooking();
                    booking.setId(rs.getString("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setPickup(rs.getString("pickup_location"));
                    booking.setDropoff(rs.getString("drop_location"));
                    booking.setDate(rs.getString("pickup_date"));
                    booking.setTime(rs.getString("pickup_time"));
                    booking.setBookingType(rs.getString("cab_type"));
                    booking.setVehicleType(rs.getString("vehicle_type"));
                    booking.setAmount(rs.getDouble("total_price"));
                    booking.setStatus(rs.getString("status"));
                      booking.setAmount(rs.getDouble("amount"));
                    
                }
            }
            if (booking != null) {
                String passSql = "SELECT * FROM cab_passengers WHERE booking_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(passSql)) {
                    ps2.setString(1, id);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            CabPassenger p = new CabPassenger();
                            p.setName(rs2.getString("name"));
                            p.setPhone(rs2.getString("phone"));
                            p.setEmail(rs2.getString("email"));
                            // booking.getPassengers().add(p);
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
