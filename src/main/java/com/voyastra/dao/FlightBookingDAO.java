package com.voyastra.dao;

import com.voyastra.model.FlightBooking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FlightBookingDAO {

    public FlightBooking getBookingById(int id) {
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, b.type, b.details, b.booking_code, b.travel_date, b.customer_name, b.customer_email, b.customer_phone " +
                       "FROM flight_bookings b " +
                       "WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FlightBooking fb = new FlightBooking();
                    fb.setId(rs.getInt("id"));
                    fb.setUserId(rs.getInt("user_id"));
                    fb.setPlanId(rs.getInt("plan_id"));
                    fb.setTotalPrice(rs.getDouble("total_price"));
                    fb.setStatus(rs.getString("status"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    fb.setType(rs.getString("type"));
                    fb.setDetails(rs.getString("details"));
                    fb.setBookingCode(rs.getString("booking_code"));
                    fb.setTravelDate(rs.getString("travel_date"));
                    fb.setCustomerName(rs.getString("customer_name"));
                    fb.setCustomerEmail(rs.getString("customer_email"));
                    fb.setCustomerPhone(rs.getString("customer_phone"));
                    fb.parseDetails();
                    System.out.println("FLIGHT BOOKING FOUND: id=" + fb.getId() + " code=" + fb.getBookingCode());
                    return fb;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<FlightBooking> getBookingsByUserId(int userId) {

        List<FlightBooking> list = new ArrayList<>();
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, b.type, b.details, b.booking_code, b.travel_date, b.customer_name, b.customer_email, b.customer_phone " +
                       "FROM flight_bookings b " +
                       "WHERE b.user_id = ? " +
                       "ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FlightBooking fb = new FlightBooking();
                    fb.setId(rs.getInt("id"));
                    fb.setUserId(rs.getInt("user_id"));
                    fb.setPlanId(rs.getInt("plan_id"));
                    fb.setTotalPrice(rs.getDouble("total_price"));
                    fb.setStatus(rs.getString("status"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    fb.setType(rs.getString("type"));
                    fb.setDetails(rs.getString("details"));
                    fb.setBookingCode(rs.getString("booking_code"));
                    fb.setTravelDate(rs.getString("travel_date"));
                    fb.setCustomerName(rs.getString("customer_name"));
                    fb.setCustomerEmail(rs.getString("customer_email"));
                    fb.setCustomerPhone(rs.getString("customer_phone"));
                    fb.parseDetails();
                    list.add(fb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
