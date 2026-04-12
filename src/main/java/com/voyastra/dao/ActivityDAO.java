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

    public boolean addActivity(Activity activity) {
        String query = "INSERT INTO activities (destination_id, name, image_url, price, rating, reviews_count) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, activity.getDestinationId());
            stmt.setString(2, activity.getName());
            stmt.setString(3, activity.getImageUrl());
            stmt.setDouble(4, activity.getPrice());
            stmt.setDouble(5, activity.getRating());
            stmt.setInt(6, activity.getReviewsCount());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateActivity(Activity activity) {
        String query = "UPDATE activities SET destination_id = ?, name = ?, image_url = ?, price = ?, rating = ?, reviews_count = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, activity.getDestinationId());
            stmt.setString(2, activity.getName());
            stmt.setString(3, activity.getImageUrl());
            stmt.setDouble(4, activity.getPrice());
            stmt.setDouble(5, activity.getRating());
            stmt.setInt(6, activity.getReviewsCount());
            stmt.setInt(7, activity.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteActivity(int id) {
        String query = "DELETE FROM activities WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Activity> getActivitiesByDestination(int destinationId) {
        List<Activity> activities = new ArrayList<>();
        String query = "SELECT id, destination_id, name, image_url, price, rating, reviews_count " +
                       "FROM activities WHERE destination_id = ?";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, destinationId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activities.add(extractFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    public List<Activity> getAllActivities() {
        List<Activity> activities = new ArrayList<>();
        // Optional Left Join for Admin Interface
        String query = "SELECT a.id, a.destination_id, a.name, a.image_url, a.price, a.rating, a.reviews_count, d.name AS destination_name " +
                       "FROM activities a " +
                       "LEFT JOIN destinations d ON a.destination_id = d.id";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                Activity activity = extractFromResultSet(rs);
                activity.setDestinationName(rs.getString("destination_name"));
                activities.add(activity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    private Activity extractFromResultSet(ResultSet rs) throws SQLException {
        Activity activity = new Activity();
        activity.setId(rs.getInt("id"));
        activity.setDestinationId(rs.getInt("destination_id"));
        activity.setName(rs.getString("name"));
        activity.setImageUrl(rs.getString("image_url"));
        activity.setPrice(rs.getDouble("price"));
        activity.setRating(rs.getDouble("rating"));
        activity.setReviewsCount(rs.getInt("reviews_count"));
        return activity;
    }
}
