package com.voyastra.dao.journey;

import com.voyastra.model.journey.ActiveJourneyRecord;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO for the user_active_journey table.
 *
 * Table DDL (run once on production DB):
 *
 * CREATE TABLE IF NOT EXISTS user_active_journey (
 *   id          INT NOT NULL AUTO_INCREMENT,
 *   user_id     INT NOT NULL,
 *   booking_id  VARCHAR(100) NOT NULL,
 *   booking_type VARCHAR(50) NOT NULL,
 *   created_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 *   PRIMARY KEY (id),
 *   UNIQUE KEY uq_user (user_id),
 *   CONSTRAINT fk_uaj_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
 * );
 */
public class ActiveJourneyDAO {

    /**
     * Upserts the active journey for a user.
     * Only one active journey is allowed per user.
     */
    public boolean setActiveJourney(int userId, String bookingId, String bookingType) {
        // INSERT ... ON DUPLICATE KEY UPDATE handles the unique constraint on user_id
        String sql = "INSERT INTO user_active_journey (user_id, booking_id, booking_type) " +
                     "VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE booking_id = VALUES(booking_id), " +
                     "booking_type = VALUES(booking_type), " +
                     "created_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, bookingId);
            ps.setString(3, bookingType);
            ps.executeUpdate();
            System.out.println("[ActiveJourneyDAO] Set active journey for userId=" + userId
                    + " bookingId=" + bookingId + " type=" + bookingType);
            return true;
        } catch (SQLException e) {
            System.err.println("[ActiveJourneyDAO] setActiveJourney failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Returns the user's active journey record, or null if none is set.
     */
    public ActiveJourneyRecord getActiveJourney(int userId) {
        String sql = "SELECT user_id, booking_id, booking_type FROM user_active_journey WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ActiveJourneyRecord(
                            rs.getInt("user_id"),
                            rs.getString("booking_id"),
                            rs.getString("booking_type")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("[ActiveJourneyDAO] getActiveJourney failed: " + e.getMessage());
        }
        return null;
    }

    /**
     * Clears the active journey selection for a user.
     */
    public boolean clearActiveJourney(int userId) {
        String sql = "DELETE FROM user_active_journey WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("[ActiveJourneyDAO] clearActiveJourney failed: " + e.getMessage());
            return false;
        }
    }
}
