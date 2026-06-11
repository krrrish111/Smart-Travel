package com.voyastra.dao;

import com.voyastra.model.CarBooking;
import com.voyastra.model.CarCustomer;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CarBookingDAO {
    
    public boolean saveBooking(CarBooking booking) {
        String insertBooking = "INSERT INTO car_bookings (id, user_id, car_model, vehicle_type, pickup_city, pickup_date, return_date, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertCustomer = "INSERT INTO car_customers (booking_id, name, phone, email, dl_path) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getCarModel());
                ps.setString(4, booking.getVehicleType());
                ps.setString(5, booking.getPickupCity());
                ps.setString(6, booking.getPickupDate());
                ps.setString(7, booking.getReturnDate());
                ps.setDouble(8, booking.getAmount());
                ps.setString(9, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertCustomer)) {
                ps.setString(1, booking.getId());
                ps.setString(2, booking.getCustomer().getName());
                ps.setString(3, booking.getCustomer().getPhone());
                ps.setString(4, booking.getCustomer().getEmail());
                ps.setString(5, booking.getCustomer().getDlPath());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CarBooking> getBookingsByUserId(int userId) {
        List<CarBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM car_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CarBooking b = new CarBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setCarModel(rs.getString("car_model"));
                    b.setVehicleType(rs.getString("vehicle_type"));
                    b.setAmount(rs.getDouble("amount"));
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
