package com.voyastra.dao;

import com.voyastra.model.Story;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StoryDAO {

    public boolean addStory(Story story) {
        String query = "INSERT INTO stories (user_id, media_url) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, story.getUserId());
            stmt.setString(2, story.getMediaUrl());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Story> getRecentStories() {
        List<Story> list = new ArrayList<>();
        // Fetch stories from the last 24 hours (or general recent ones as fallback)
        String query = "SELECT s.id, s.user_id, s.media_url, s.created_at, u.name AS user_name " +
                       "FROM stories s JOIN users u ON s.user_id = u.id " +
                       "WHERE s.created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR) " +
                       "ORDER BY s.created_at DESC LIMIT 15";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Story story = new Story();
                    story.setId(rs.getInt("id"));
                    story.setUserId(rs.getInt("user_id"));
                    story.setMediaUrl(rs.getString("media_url"));
                    story.setCreatedAt(rs.getTimestamp("created_at"));
                    story.setUserName(rs.getString("user_name"));
                    list.add(story);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // If no stories exist from the last 24 hours, fetch latest general stories as a fallback so UI is not empty.
        if (list.isEmpty()) {
            String fallbackQuery = "SELECT s.id, s.user_id, s.media_url, s.created_at, u.name AS user_name " +
                                   "FROM stories s JOIN users u ON s.user_id = u.id " +
                                   "ORDER BY s.created_at DESC LIMIT 10";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(fallbackQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Story story = new Story();
                    story.setId(rs.getInt("id"));
                    story.setUserId(rs.getInt("user_id"));
                    story.setMediaUrl(rs.getString("media_url"));
                    story.setCreatedAt(rs.getTimestamp("created_at"));
                    story.setUserName(rs.getString("user_name"));
                    list.add(story);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return list;
    }
}
