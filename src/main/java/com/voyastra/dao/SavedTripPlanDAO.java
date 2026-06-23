package com.voyastra.dao;

import com.voyastra.model.SavedTripPlan;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SavedTripPlanDAO {

    public boolean savePlan(int userId, int tripId) {
        String query = "INSERT IGNORE INTO saved_trip_plans (user_id, trip_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, tripId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeSavedPlan(int userId, int tripId) {
        String query = "DELETE FROM saved_trip_plans WHERE user_id = ? AND trip_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, tripId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<SavedTripPlan> getUserSavedPlans(int userId) {
        List<SavedTripPlan> list = new ArrayList<>();
        String query = "SELECT s.*, p.title AS trip_name, p.destination, p.image AS trip_image, p.price " +
                       "FROM saved_trip_plans s " +
                       "JOIN plans p ON s.trip_id = p.id " +
                       "WHERE s.user_id = ? " +
                       "ORDER BY s.saved_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SavedTripPlan sp = new SavedTripPlan();
                    sp.setId(rs.getInt("id"));
                    sp.setUserId(rs.getInt("user_id"));
                    sp.setTripId(rs.getInt("trip_id"));
                    sp.setSavedAt(rs.getTimestamp("saved_at"));
                    sp.setTripName(rs.getString("trip_name"));
                    sp.setDestination(rs.getString("destination"));
                    sp.setTripImage(rs.getString("trip_image"));
                    sp.setPrice(rs.getDouble("price"));
                    list.add(sp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
