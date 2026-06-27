package com.voyastra.dao;

import com.voyastra.model.Activity;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActivityDAO {

    public List<Activity> getAllActivities() {
        List<Activity> activities = new ArrayList<>();
        String query = "SELECT * FROM activities";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                activities.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }
    
    public Activity getActivityById(int id) {
        String query = "SELECT * FROM activities WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Activity extractFromResultSet(ResultSet rs) throws SQLException {
        Activity activity = new Activity();
        activity.setId(rs.getInt("id"));
        activity.setTitle(rs.getString("title"));
        
        // Handle gracefully if using an older schema version
        try { activity.setHeroImage(rs.getString("hero_image")); } catch (Exception e) {}
        try { activity.setDescription(rs.getString("description")); } catch (Exception e) {}
        try { activity.setHighlights(rs.getString("highlights")); } catch (Exception e) {}
        try { activity.setDurationMinutes(rs.getInt("duration_minutes")); } catch (Exception e) {}
        try { activity.setOpeningHours(rs.getString("opening_hours")); } catch (Exception e) {}
        try { activity.setLocation(rs.getString("location")); } catch (Exception e) {}
        try { activity.setPrice(rs.getDouble("price")); } catch (Exception e) {}
        try { activity.setBestTime(rs.getString("best_time")); } catch (Exception e) {}
        try { activity.setDifficulty(rs.getString("difficulty")); } catch (Exception e) {}
        try { activity.setAgeLimit(rs.getString("age_limit")); } catch (Exception e) {}
        try { activity.setInclusions(rs.getString("inclusions")); } catch (Exception e) {}
        try { activity.setExclusions(rs.getString("exclusions")); } catch (Exception e) {}
        try { activity.setLat(rs.getString("lat")); } catch (Exception e) {}
        try { activity.setLng(rs.getString("lng")); } catch (Exception e) {}
        try { activity.setRating(rs.getDouble("rating")); } catch (Exception e) {}
        try { activity.setReviewCount(rs.getInt("review_count")); } catch (Exception e) {}
        
        return activity;
    }

    // Compatibility methods for old ActivityServlet
    public void deleteActivity(int id) {
        String query = "DELETE FROM activities WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Activity> getActivitiesByDestination(int destinationId) {
        // Return an empty list to satisfy old servlet requirements since destinations is decoupled in new schema
        return new ArrayList<>();
    }

    public void addActivity(Activity a) {}
    public void updateActivity(Activity a) {}
}
