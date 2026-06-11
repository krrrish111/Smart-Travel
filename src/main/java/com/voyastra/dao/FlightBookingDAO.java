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

    public List<FlightBooking> getBookingsByUserId(int userId) {
        List<FlightBooking> list = new ArrayList<>();
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, b.type, b.details, b.booking_code, b.travel_date " +
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
