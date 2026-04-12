package com.voyastra.dao;

import com.voyastra.model.Review;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    /**
     * Stores a user rating and comment in the "reviews" table.
     */
    public boolean addReview(Review review) {
        String query = "INSERT INTO reviews (user_id, destination_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getDestinationId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: ReviewDAO.addReview failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Fetches all reviews for a specific destination, joining the users table to get the user's name.
     */
    public List<Review> getReviewsByDestination(int destinationId) {
        List<Review> reviews = new ArrayList<>();
        String query = "SELECT r.id, r.user_id, r.destination_id, r.rating, r.comment, r.created_at, u.name AS user_name " +
                       "FROM reviews r " +
                       "JOIN users u ON r.user_id = u.id " +
                       "WHERE r.destination_id = ? " +
                       "ORDER BY r.created_at DESC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, destinationId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setDestinationId(rs.getInt("destination_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUserName(rs.getString("user_name"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: ReviewDAO.getReviewsByDestination failed.");
            e.printStackTrace();
        }
        return reviews;
    }

    /**
     * Deletes a review from the database.
     */
    public boolean deleteReview(int id) {
        String query = "DELETE FROM reviews WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: ReviewDAO.deleteReview failed.");
            e.printStackTrace();
        }
        return false;
    }

    public Review getReviewById(int id) {
        Review review = null;
        String query = "SELECT r.id, r.user_id, r.destination_id, r.rating, r.comment, r.created_at, u.name AS user_name " +
                       "FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setDestinationId(rs.getInt("destination_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUserName(rs.getString("user_name"));
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: ReviewDAO.getReviewById failed.");
            e.printStackTrace();
        }
        return review;
    }

    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String query = "SELECT r.id, r.user_id, r.destination_id, r.rating, r.comment, r.created_at, u.name AS user_name, d.name AS destination_name " +
                       "FROM reviews r " +
                       "JOIN users u ON r.user_id = u.id " +
                       "JOIN destinations d ON r.destination_id = d.id " +
                       "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setDestinationId(rs.getInt("destination_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setUserName(rs.getString("user_name"));
                review.setDestinationName(rs.getString("destination_name"));
                list.add(review);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: ReviewDAO.getAllReviews failed.");
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateReview(Review review) {
        String query = "UPDATE reviews SET user_id = ?, destination_id = ?, rating = ?, comment = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getDestinationId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.setInt(5, review.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: ReviewDAO.updateReview failed.");
            e.printStackTrace();
            return false;
        }
    }
}
