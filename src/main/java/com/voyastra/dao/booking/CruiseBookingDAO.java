package com.voyastra.dao.booking;

import com.voyastra.model.booking.CruiseBooking;
import com.voyastra.model.transport.CruisePassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CruiseBookingDAO {
    
    public boolean saveBooking(CruiseBooking booking) {
        String insertBooking = "INSERT INTO cruise_bookings (id, user_id, departure_port, destination, cruise_date, passengers, cabin_type, total_price, status, cruise_line, ship_name, duration) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO cruise_passengers (booking_id, name, age, gender, passport_number) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getDeparturePort());
                ps.setString(4, booking.getDestination());
                ps.setString(5, booking.getCruiseDate());
                ps.setInt(6, booking.getPassengers().size());
                ps.setString(7, booking.getCabinType());
                ps.setDouble(8, booking.getAmount());
                ps.setString(9, booking.getStatus());
                ps.setString(10, booking.getCruiseLine());
                ps.setString(11, booking.getShipName());
                ps.setString(12, booking.getDurationDays() + " Nights");
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

    public CruiseBooking getBookingById(String id) {
        CruiseBooking booking = null;
        String sql = "SELECT * FROM cruise_bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new CruiseBooking();
                    booking.setId(rs.getString("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setDeparturePort(rs.getString("departure_port"));
                    booking.setDestination(rs.getString("destination"));
                    booking.setCruiseDate(rs.getString("cruise_date"));
                    booking.setCabinType(rs.getString("cabin_type"));
                    booking.setAmount(rs.getDouble("total_price"));
                    booking.setStatus(rs.getString("status"));
                      booking.setAmount(rs.getDouble("amount"));
                    booking.setCruiseLine(rs.getString("cruise_line"));
                    booking.setShipName(rs.getString("ship_name"));
                    try { booking.setDurationDays(Integer.parseInt(rs.getString("duration").split(" ")[0])); } catch(Exception e) { booking.setDurationDays(0); }
                    booking.setPassengers(new java.util.ArrayList<>());
                }
            }
            if (booking != null) {
                String passSql = "SELECT * FROM cruise_passengers WHERE booking_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(passSql)) {
                    ps2.setString(1, id);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            CruisePassenger p = new CruisePassenger();
                            p.setName(rs2.getString("name"));
                            p.setAge(rs2.getInt("age"));
                            p.setGender(rs2.getString("gender"));
                            p.setPassportNumber(rs2.getString("passport_number"));
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


    public boolean updateBookingStatus(String id, String status) {
        String sql = "UPDATE cruise_bookings SET status = ? WHERE id = ?";
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
