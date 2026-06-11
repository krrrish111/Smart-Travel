package com.voyastra.dao;

import com.voyastra.model.CruiseBooking;
import com.voyastra.model.CruisePassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CruiseBookingDAO {
    
    public boolean saveBooking(CruiseBooking booking) {
        String insertBooking = "INSERT INTO cruise_bookings (id, user_id, ship_name, cruise_line, cabin_type, departure_port, destination, cruise_date, duration, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO cruise_passengers (booking_id, name, age, gender, passport_number) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getShipName());
                ps.setString(4, booking.getCruiseLine());
                ps.setString(5, booking.getCabinType());
                ps.setString(6, booking.getDeparturePort());
                ps.setString(7, booking.getDestination());
                ps.setString(8, booking.getCruiseDate());
                ps.setString(9, booking.getDurationDays() + " Nights");
                ps.setDouble(10, booking.getAmount());
                ps.setString(11, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                for (CruisePassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getPassportNumber());
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

    public List<CruiseBooking> getBookingsByUserId(int userId) {
        List<CruiseBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM cruise_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CruiseBooking b = new CruiseBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setShipName(rs.getString("ship_name"));
                    b.setCruiseLine(rs.getString("cruise_line"));
                    b.setCabinType(rs.getString("cabin_type"));
                    b.setDeparturePort(rs.getString("departure_port"));
                    b.setDestination(rs.getString("destination"));
                    b.setCruiseDate(rs.getString("cruise_date"));
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

