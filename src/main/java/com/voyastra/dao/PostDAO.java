package com.voyastra.dao;

import com.voyastra.model.Post;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {

    /**
     * Inserts a new community post into the database.
     */
    public boolean addPost(Post post) {
        String query = "INSERT INTO posts (user_id, text, image_url, location) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, post.getUserId());
            stmt.setString(2, post.getText());
            stmt.setString(3, post.getImageUrl());
            stmt.setString(4, post.getLocation());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.addPost failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Fetches all trending posts, including like counts and whether the given user liked each post.
     * Pass userId = 0 for guests (hasLiked will always be false).
     */
    public List<Post> getAllPosts(int userId) {
        List<Post> posts = new ArrayList<>();
        String query =
            "SELECT p.id, p.user_id, p.text, p.image_url, p.location, p.created_at, " +
            "       u.name AS user_name, u.role AS user_role, " +
            "       COUNT(DISTINCT l.id) AS like_count, " +
            "       MAX(CASE WHEN l.user_id = ? THEN 1 ELSE 0 END) AS user_liked " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id " +
            "LEFT JOIN likes l ON l.post_id = p.id " +
            "GROUP BY p.id, p.user_id, p.text, p.image_url, p.location, p.created_at, u.name, u.role " +
            "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setText(rs.getString("text"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setLocation(rs.getString("location"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUserName(rs.getString("user_name"));
                    post.setUserRole(rs.getString("user_role"));
                    post.setLikeCount(rs.getInt("like_count"));
                    post.setHasLiked(rs.getInt("user_liked") == 1);
                    posts.add(post);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.getAllPosts failed.");
            e.printStackTrace();
        }
        return posts;
    }

    /**
     * Convenience overload for guests / admin-list (no hasLiked resolution).
     */
    public List<Post> getAllPosts() {
        return getAllPosts(0);
    }

    /**
     * Allows an admin to completely delete a post from the database.
     */
    public boolean deletePost(int id) {
        String query = "DELETE FROM posts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.deletePost failed.");
            e.printStackTrace();
        }
        return false;
    }

    public Post getPostById(int id) {
        Post post = null;
        String query = "SELECT p.id, p.user_id, p.text, p.image_url, p.location, p.created_at, u.name AS user_name, u.role AS user_role " +
                       "FROM posts p JOIN users u ON p.user_id = u.id WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setText(rs.getString("text"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setLocation(rs.getString("location"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUserName(rs.getString("user_name"));
                    post.setUserRole(rs.getString("user_role"));
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.getPostById failed.");
            e.printStackTrace();
        }
        return post;
    }

    public boolean updatePost(Post post) {
        String query = "UPDATE posts SET user_id = ?, text = ?, image_url = ?, location = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, post.getUserId());
            stmt.setString(2, post.getText());
            stmt.setString(3, post.getImageUrl());
            stmt.setString(4, post.getLocation());
            stmt.setInt(5, post.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.updatePost failed.");
            e.printStackTrace();
            return false;
        }
    }
}
