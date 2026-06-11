package com.voyastra.dao;

import com.voyastra.model.TrainBooking;
import com.voyastra.model.TrainPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TrainBookingDAO {
    
    public boolean saveDraft(TrainBooking booking) {
        String insertBookingSql = "INSERT INTO train_bookings (id, user_id, from_station, to_station, journey_date, train_class, total_price, status, train_name, train_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassengerSql = "INSERT INTO train_passengers (booking_id, name, age, gender, berth_preference) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if(conn == null) return false;
            
            // Insert Booking
            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getFromStation());
                ps.setString(4, booking.getToStation());
                ps.setString(5, booking.getJourneyDate());
                ps.setString(6, booking.getTrainClass());
                ps.setDouble(7, booking.getFare() * booking.getPassengers().size()); // Total amount
                ps.setString(8, booking.getStatus());
                ps.setString(9, booking.getTrainName());
                ps.setString(10, booking.getTrainNumber());
                ps.executeUpdate();
            }

            // Insert Passengers
            try (PreparedStatement ps = conn.prepareStatement(insertPassengerSql)) {
                for (TrainPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getBerthPreference());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            System.out.println("TRAIN BOOKING SAVED");
            System.out.println("BOOKING ID = " + booking.getId());
            System.out.println("USER ID = " + booking.getUserId());
            return true;
        } catch (Exception e) {
            System.err.println("[TrainBookingDAO] saveDraft FAILED: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    public java.util.List<TrainBooking> getBookingsByUserId(int userId) {
        java.util.List<TrainBooking> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM train_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainBooking b = new TrainBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setTrainNumber(rs.getString("train_number"));
                    b.setTrainName(rs.getString("train_name"));
                    b.setFromStation(rs.getString("from_station"));
                    b.setToStation(rs.getString("to_station"));
                    b.setJourneyDate(rs.getString("journey_date"));
                    b.setTrainClass(rs.getString("train_class"));
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

    public TrainBooking getBookingById(String id) {
        TrainBooking booking = null;
        String sql = "SELECT * FROM train_bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new TrainBooking();
                    booking.setId(rs.getString("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setTrainNumber(rs.getString("train_number"));
                    booking.setTrainName(rs.getString("train_name"));
                    booking.setFromStation(rs.getString("from_station"));
                    booking.setToStation(rs.getString("to_station"));
                    booking.setJourneyDate(rs.getString("journey_date"));
                    booking.setTrainClass(rs.getString("train_class"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPassengers(new java.util.ArrayList<>());
                }
            }
            if (booking != null) {
                String passSql = "SELECT * FROM train_passengers WHERE booking_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(passSql)) {
                    ps2.setString(1, id);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            TrainPassenger p = new TrainPassenger();
                            p.setName(rs2.getString("name"));
                            p.setAge(rs2.getInt("age"));
                            p.setGender(rs2.getString("gender"));
                            p.setBerthPreference(rs2.getString("berth_preference"));
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
