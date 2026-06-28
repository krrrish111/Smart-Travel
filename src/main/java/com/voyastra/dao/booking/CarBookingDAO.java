package com.voyastra.dao.booking;

import com.voyastra.model.booking.CarBooking;
import com.voyastra.model.transport.CarCustomer;
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
        String sql = "SELECT * FROM car_bookings WHERE user_id = ? ORDER BY created_at DESC";
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
                    b.setPickupCity(rs.getString("pickup_city"));
                    b.setPickupDate(rs.getString("pickup_date"));
                    b.setReturnDate(rs.getString("return_date"));
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

    public CarBooking getBookingById(String id) {
        CarBooking booking = null;
        String sql = "SELECT * FROM car_bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new CarBooking();
                    booking.setId(rs.getString("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setCarModel(rs.getString("car_model"));
                    booking.setVehicleType(rs.getString("vehicle_type"));
                    booking.setPickupCity(rs.getString("pickup_city"));
                    booking.setPickupDate(rs.getString("pickup_date"));
                    booking.setReturnDate(rs.getString("return_date"));
                    booking.setAmount(rs.getDouble("amount"));
                    booking.setStatus(rs.getString("status"));
                }
            }
        if (booking != null) {
                String custSql = "SELECT * FROM car_customers WHERE booking_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(custSql)) {
                    ps2.setString(1, id);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        if (rs2.next()) {
                            CarCustomer c = new CarCustomer();
                            c.setName(rs2.getString("name"));
                            c.setPhone(rs2.getString("phone"));
                            c.setEmail(rs2.getString("email"));
                            c.setDlPath(rs2.getString("dl_path"));
                            booking.setCustomer(c);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return booking;
    }


    public boolean updateBookingStatus(String id, String status) {
        String sql = "UPDATE car_bookings SET status = ? WHERE id = ?";
        try (java.sql.Connection conn = com.voyastra.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
