package com.voyastra.dao;

import com.voyastra.model.TourBooking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TourBookingDAO {

    public List<TourBooking> getBookingsByUserId(int userId) {
        List<TourBooking> list = new ArrayList<>();
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, b.type, b.details, b.booking_code, b.travel_date " +
                       "FROM tour_bookings b " +
                       "WHERE b.user_id = ? " +
                       "ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    TourBooking tb = new TourBooking();
                    tb.setId(rs.getInt("id"));
                    tb.setUserId(rs.getInt("user_id"));
                    tb.setPlanId(rs.getInt("plan_id"));
                    tb.setTotalPrice(rs.getDouble("total_price"));
                    tb.setStatus(rs.getString("status"));
                    tb.setCreatedAt(rs.getTimestamp("created_at"));
                    tb.setType(rs.getString("type"));
                    tb.setDetails(rs.getString("details"));
                    tb.setBookingCode(rs.getString("booking_code"));
                    tb.setTravelDate(rs.getString("travel_date"));
                    list.add(tb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
