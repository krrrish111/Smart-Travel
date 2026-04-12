package com.voyastra.dao;

import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LikeDAO {

    /**
     * Inserts a record identifying that a user liked a post.
     */
    public boolean addLike(int postId, int userId) {
        String query = "INSERT INTO likes (post_id, user_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            // Might throw exception if like already exists and unique constraint is enforced
            System.err.println("ERROR: LikeDAO.addLike failed or duplicate entry.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a like record.
     */
    public boolean removeLike(int postId, int userId) {
        String query = "DELETE FROM likes WHERE post_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: LikeDAO.removeLike failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Checks if a user has already liked a post.
     */
    public boolean hasUserLiked(int postId, int userId) {
        String query = "SELECT 1 FROM likes WHERE post_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Counts the total number of likes for a specific post.
     */
    public int getLikeCount(int postId) {
        String query = "SELECT COUNT(*) AS total FROM likes WHERE post_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
