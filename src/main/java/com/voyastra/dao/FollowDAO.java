package com.voyastra.dao;

import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FollowDAO {

    public static class Explorer {
        private int id;
        private String name;
        private String profileImage;
        private int tripCount;
        private int followerCount;
        private boolean followedByCurrentUser;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getProfileImage() { return profileImage; }
        public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
        public int getTripCount() { return tripCount; }
        public void setTripCount(int tripCount) { this.tripCount = tripCount; }
        public int getFollowerCount() { return followerCount; }
        public void setFollowerCount(int followerCount) { this.followerCount = followerCount; }
        public boolean isFollowedByCurrentUser() { return followedByCurrentUser; }
        public void setFollowedByCurrentUser(boolean followedByCurrentUser) { this.followedByCurrentUser = followedByCurrentUser; }
    }

    public boolean toggleFollow(int followerId, int followedId) {
        if (isFollowing(followerId, followedId)) {
            return unfollow(followerId, followedId);
        } else {
            return follow(followerId, followedId);
        }
    }

    public boolean follow(int followerId, int followedId) {
        String query = "INSERT IGNORE INTO follows (follower_id, followed_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followedId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean unfollow(int followerId, int followedId) {
        String query = "DELETE FROM follows WHERE follower_id = ? AND followed_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followedId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isFollowing(int followerId, int followedId) {
        String query = "SELECT 1 FROM follows WHERE follower_id = ? AND followed_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followedId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Explorer> getTopExplorers(int currentUserId, int limit) {
        List<Explorer> list = new ArrayList<>();
        // Fetch users with the highest count of posts, excluding the current user if logged in
        String query = 
            "SELECT u.id, u.name, u.profile_image, " +
            "       (SELECT COUNT(*) FROM posts WHERE user_id = u.id) AS trip_count, " +
            "       (SELECT COUNT(*) FROM follows WHERE followed_id = u.id) AS follower_count, " +
            "       (SELECT COUNT(*) FROM follows WHERE follower_id = ? AND followed_id = u.id) AS is_following " +
            "FROM users u " +
            "WHERE u.id != ? " +
            "ORDER BY trip_count DESC, follower_count DESC " +
            "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, currentUserId);
            stmt.setInt(2, currentUserId);
            stmt.setInt(3, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Explorer explorer = new Explorer();
                    explorer.setId(rs.getInt("id"));
                    explorer.setName(rs.getString("name"));
                    explorer.setProfileImage(rs.getString("profile_image"));
                    explorer.setTripCount(rs.getInt("trip_count"));
                    explorer.setFollowerCount(rs.getInt("follower_count"));
                    explorer.setFollowedByCurrentUser(rs.getInt("is_following") > 0);
                    list.add(explorer);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
