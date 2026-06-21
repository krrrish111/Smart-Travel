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
        String query = "INSERT INTO stories (user_id, media_url, media_type, caption, location, expires_at) VALUES (?, ?, ?, ?, ?, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 24 HOUR))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, story.getUserId());
            stmt.setString(2, story.getMediaUrl());
            stmt.setString(3, story.getMediaType());
            stmt.setString(4, story.getCaption());
            stmt.setString(5, story.getLocation());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Story> getRecentStories() {
        List<Story> list = new ArrayList<>();
        // Fetch active stories (expires_at > NOW())
        String query = "SELECT s.id, s.user_id, s.media_url, s.media_type, s.caption, s.location, s.created_at, s.expires_at, u.name AS user_name " +
                       "FROM stories s JOIN users u ON s.user_id = u.id " +
                       "WHERE s.expires_at > NOW() " +
                       "ORDER BY s.created_at DESC LIMIT 15";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Story story = new Story();
                    story.setId(rs.getInt("id"));
                    story.setUserId(rs.getInt("user_id"));
                    story.setMediaUrl(rs.getString("media_url"));
                    story.setMediaType(rs.getString("media_type"));
                    story.setCaption(rs.getString("caption"));
                    story.setLocation(rs.getString("location"));
                    story.setCreatedAt(rs.getTimestamp("created_at"));
                    story.setExpiresAt(rs.getTimestamp("expires_at"));
                    story.setUserName(rs.getString("user_name"));
                    list.add(story);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteStory(int storyId, int userId) {
        String query = "DELETE FROM stories WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, storyId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Story> getUserStories(int userId) {
        List<Story> list = new ArrayList<>();
        String query = "SELECT id, user_id, media_url, media_type, caption, location, created_at, expires_at " +
                       "FROM stories WHERE user_id = ? ORDER BY created_at DESC";
        
        StoryViewDAO viewDAO = new StoryViewDAO();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Story story = new Story();
                    story.setId(rs.getInt("id"));
                    story.setUserId(rs.getInt("user_id"));
                    story.setMediaUrl(rs.getString("media_url"));
                    story.setMediaType(rs.getString("media_type"));
                    story.setCaption(rs.getString("caption"));
                    story.setLocation(rs.getString("location"));
                    story.setCreatedAt(rs.getTimestamp("created_at"));
                    story.setExpiresAt(rs.getTimestamp("expires_at"));
                    
                    int viewCount = viewDAO.getViewCount(story.getId());
                    List<String> viewers = viewDAO.getViewers(story.getId());
                    story.setViewCount(viewCount);
                    story.setViewers(viewers);
                    
                    list.add(story);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Story getStoryById(int storyId) {
        String query = "SELECT * FROM stories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, storyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Story story = new Story();
                    story.setId(rs.getInt("id"));
                    story.setUserId(rs.getInt("user_id"));
                    story.setMediaUrl(rs.getString("media_url"));
                    story.setMediaType(rs.getString("media_type"));
                    story.setCaption(rs.getString("caption"));
                    story.setLocation(rs.getString("location"));
                    story.setCreatedAt(rs.getTimestamp("created_at"));
                    story.setExpiresAt(rs.getTimestamp("expires_at"));
                    return story;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int deleteExpiredStories() {
        String query = "DELETE FROM stories WHERE expires_at <= NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static class StoryGroup {
        private int userId;
        private String username;
        private List<Story> stories;

        public StoryGroup(int userId, String username) {
            this.userId = userId;
            this.username = username;
            this.stories = new java.util.ArrayList<>();
        }

        public int getUserId() { return userId; }
        public String getUsername() { return username; }
        public List<Story> getStories() { return stories; }
        public void addStory(Story s) { this.stories.add(s); }
    }

    public List<StoryGroup> getGroupedStories() {
        List<StoryGroup> groupedList = new java.util.ArrayList<>();
        java.util.Map<Integer, StoryGroup> map = new java.util.LinkedHashMap<>(); // Preserve ordering
        
        List<Story> allStories = getRecentStories();
        for (Story s : allStories) {
            if (!map.containsKey(s.getUserId())) {
                map.put(s.getUserId(), new StoryGroup(s.getUserId(), s.getUserName()));
            }
            map.get(s.getUserId()).addStory(s);
        }
        
        groupedList.addAll(map.values());
        return groupedList;
    }
}
