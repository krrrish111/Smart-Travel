package com.voyastra.dao;

import com.voyastra.model.BusBooking;
import com.voyastra.model.BusPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BusBookingDAO {
    
    public boolean saveBooking(BusBooking booking) {
        String insertBookingSql = "INSERT INTO bus_bookings (id, user_id, operator_name, bus_type, from_city, to_city, journey_date, seat_numbers, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassengerSql = "INSERT INTO bus_passengers (booking_id, name, age, gender, seat_preference) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if(conn == null) return false;
            
            // Insert Booking
            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getOperator() != null ? booking.getOperator() : booking.getBusName());
                ps.setString(4, booking.getBusType());
                ps.setString(5, booking.getFromCity());
                ps.setString(6, booking.getToCity());
                ps.setString(7, booking.getJourneyDate());
                ps.setString(8, booking.getSeatNumbers());
                ps.setDouble(9, booking.getFare() * booking.getPassengers().size());
                ps.setString(10, booking.getStatus());
                ps.executeUpdate();
            }

            // Insert Passengers
            try (PreparedStatement ps = conn.prepareStatement(insertPassengerSql)) {
                for (BusPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getSeatPreference());
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

    public List<BusBooking> getBookingsByUserId(int userId) {
        List<BusBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM bus_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusBooking b = new BusBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setOperatorName(rs.getString("operator_name"));
                    b.setBusType(rs.getString("bus_type"));
                    b.setFromCity(rs.getString("from_city"));
                    b.setToCity(rs.getString("to_city"));
                    b.setJourneyDate(rs.getString("journey_date"));
                    b.setSeatNumbers(rs.getString("seat_numbers"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public BusBooking getBookingById(String id) {
        BusBooking booking = null;
        String sql = "SELECT b.*, u.email as user_email, u.phone as user_phone FROM bus_bookings b LEFT JOIN users u ON b.user_id = u.id WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new BusBooking();
                    booking.setId(rs.getString("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setBusName(rs.getString("operator_name"));
                    
                    booking.setBusType(rs.getString("bus_type"));
                    booking.setFromCity(rs.getString("from_city"));
                    booking.setToCity(rs.getString("to_city"));
                    booking.setJourneyDate(rs.getString("journey_date"));
                    booking.setSeatNumbers(rs.getString("seat_numbers"));
                    booking.setStatus(rs.getString("status"));
                    booking.setEmail(rs.getString("user_email"));
                    booking.setPhone(rs.getString("user_phone"));
                      
                      booking.setFare(rs.getDouble("total_fare"));
                    booking.setPassengers(new java.util.ArrayList<>());
                }
            }
            if (booking != null) {
                String passSql = "SELECT * FROM bus_passengers WHERE booking_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(passSql)) {
                    ps2.setString(1, id);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            BusPassenger p = new BusPassenger();
                            p.setName(rs2.getString("name"));
                            p.setAge(rs2.getInt("age"));
                            p.setGender(rs2.getString("gender"));
                            p.setSeatPreference(rs2.getString("seat_preference"));
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
