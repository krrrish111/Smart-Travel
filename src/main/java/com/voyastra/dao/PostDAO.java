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
        String query = "INSERT INTO posts (user_id, content, location, image_url, category, hashtags) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, post.getUserId());
            stmt.setString(2, post.getText());
            stmt.setString(3, post.getLocation());
            stmt.setString(4, post.getImageUrl());
            stmt.setString(5, post.getCategory() != null ? post.getCategory() : "For You");
            stmt.setString(6, post.getHashtags() != null ? post.getHashtags() : "");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.addPost failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Fetches posts based on category, offset, and limit, resolving social relationships.
     */
    public List<Post> getFeedPosts(int userId, String category, int offset, int limit) {
        List<Post> posts = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT p.id, p.user_id, p.content, p.location, p.image_url, p.category, p.hashtags, p.created_at, " +
            "       u.name AS user_name, u.role AS user_role, " +
            "       (SELECT COUNT(*) FROM likes WHERE post_id = p.id) AS like_count, " +
            "       (SELECT COUNT(*) FROM comments WHERE post_id = p.id) AS comment_count, " +
            "       (SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = ?) AS user_liked, " +
            "       (SELECT COUNT(*) FROM saved_posts WHERE post_id = p.id AND user_id = ?) AS user_saved, " +
            "       (SELECT COUNT(*) FROM follows WHERE follower_id = ? AND followed_id = p.user_id) AS is_following " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id "
        );

        List<Object> params = new ArrayList<>();
        params.add(userId);
        params.add(userId);
        params.add(userId);

        if ("Following".equalsIgnoreCase(category)) {
            query.append("WHERE p.user_id IN (SELECT followed_id FROM follows WHERE follower_id = ?) ");
            params.add(userId);
        } else if (category != null && !category.isEmpty() && !"For You".equalsIgnoreCase(category) && !"Trending".equalsIgnoreCase(category)) {
            query.append("WHERE p.category = ? ");
            params.add(category);
        }

        if ("Trending".equalsIgnoreCase(category)) {
            query.append("ORDER BY like_count DESC, p.created_at DESC ");
        } else {
            query.append("ORDER BY p.created_at DESC ");
        }

        query.append("LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setText(rs.getString("content"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setLocation(rs.getString("location"));
                    post.setCategory(rs.getString("category"));
                    post.setHashtags(rs.getString("hashtags"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUserName(rs.getString("user_name"));
                    post.setUserRole(rs.getString("user_role"));
                    post.setLikeCount(rs.getInt("like_count"));
                    post.setCommentCount(rs.getInt("comment_count"));
                    post.setHasLiked(rs.getInt("user_liked") > 0);
                    post.setHasSaved(rs.getInt("user_saved") > 0);
                    post.setFollowingCreator(rs.getInt("is_following") > 0);
                    posts.add(post);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.getFeedPosts failed.");
            e.printStackTrace();
        }
        return posts;
    }

    /**
     * Backward compatibility or default retrieval.
     */
    public List<Post> getAllPosts(int userId) {
        return getFeedPosts(userId, "For You", 0, 50);
    }

    public List<Post> getAllPosts() {
        return getAllPosts(0);
    }

    /**
     * Allows deleting a post.
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
        String query = "SELECT p.id, p.user_id, p.content, p.image_url, p.location, p.category, p.hashtags, p.created_at, " +
                       "u.name AS user_name, u.role AS user_role FROM posts p JOIN users u ON p.user_id = u.id WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setText(rs.getString("content"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setLocation(rs.getString("location"));
                    post.setCategory(rs.getString("category"));
                    post.setHashtags(rs.getString("hashtags"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUserName(rs.getString("user_name"));
                    post.setUserRole(rs.getString("user_role"));
                    return post;
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.getPostById failed.");
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePost(Post post) {
        String query = "UPDATE posts SET user_id = ?, content = ?, image_url = ?, location = ?, category = ?, hashtags = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, post.getUserId());
            stmt.setString(2, post.getText());
            stmt.setString(3, post.getImageUrl());
            stmt.setString(4, post.getLocation());
            stmt.setString(5, post.getCategory());
            stmt.setString(6, post.getHashtags());
            stmt.setInt(7, post.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: PostDAO.updatePost failed.");
            e.printStackTrace();
            return false;
        }
    }
}
