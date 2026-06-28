package com.voyastra.dao.destination;

import com.voyastra.model.destination.SavedDestination;
import com.voyastra.model.destination.Destination;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SavedDestinationDAO {

    public boolean addSavedDestination(int userId, int destinationId) {
        // Prevent duplicates
        if (isSaved(userId, destinationId)) return true;

        String query = "INSERT INTO saved_destinations (user_id, destination_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, destinationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeSavedDestination(int userId, int destinationId) {
        String query = "DELETE FROM saved_destinations WHERE user_id = ? AND destination_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, destinationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isSaved(int userId, int destinationId) {
        String query = "SELECT 1 FROM saved_destinations WHERE user_id = ? AND destination_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, destinationId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<SavedDestination> getSavedDestinationsByUser(int userId) {
        List<SavedDestination> list = new ArrayList<>();
        String query = "SELECT s.id as saved_id, s.user_id, s.destination_id, s.saved_at, " +
                       "d.title, d.destination, d.image_url, d.price_inr " +
                       "FROM saved_destinations s " +
                       "JOIN destinations d ON s.destination_id = d.id " +
                       "WHERE s.user_id = ? ORDER BY s.saved_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SavedDestination s = new SavedDestination();
                    s.setId(rs.getInt("saved_id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setDestinationId(rs.getInt("destination_id"));
                    s.setSavedAt(rs.getTimestamp("saved_at"));
                    
                    Destination d = new Destination();
                    d.setId(s.getDestinationId());
                    d.setTitle(rs.getString("title"));
                    d.setDestination(rs.getString("destination"));
                    d.setImageUrl(rs.getString("image_url"));
                    d.setPriceInr(rs.getDouble("price_inr"));
                    s.setDestination(d);
                    
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
