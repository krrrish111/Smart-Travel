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
        String insertBooking = "INSERT INTO cab_bookings (id, user_id, provider, vehicle_type, booking_type, pickup, dropoff, journey_date, journey_time, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO cab_passengers (booking_id, name, phone, email) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getProvider());
                ps.setString(4, booking.getVehicleType());
                ps.setString(5, booking.getBookingType());
                ps.setString(6, booking.getPickup());
                ps.setString(7, booking.getDropoff());
                ps.setString(8, booking.getDate());
                ps.setString(9, booking.getTime());
                ps.setDouble(10, booking.getAmount());
                ps.setString(11, booking.getStatus());
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
}

