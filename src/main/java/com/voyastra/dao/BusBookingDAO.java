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
}

