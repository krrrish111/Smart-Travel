package com.voyastra.dao;

import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StoryViewDAO {

    public boolean recordView(int storyId, int viewerId) {
        String query = "INSERT IGNORE INTO story_views (story_id, viewer_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, storyId);
            stmt.setInt(2, viewerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getViewers(int storyId) {
        List<String> viewers = new ArrayList<>();
        String query = "SELECT u.name FROM story_views sv JOIN users u ON sv.viewer_id = u.id WHERE sv.story_id = ? ORDER BY sv.viewed_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, storyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    viewers.add(rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return viewers;
    }
    
    public int getViewCount(int storyId) {
        String query = "SELECT COUNT(*) FROM story_views WHERE story_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, storyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
