package com.voyastra.dao.destination;

import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO for the user_saved_trips table.
 *
 * Table DDL (run on production DB once):
 *
 * CREATE TABLE IF NOT EXISTS user_saved_trips (
 *   id             INT NOT NULL AUTO_INCREMENT,
 *   user_id        INT NOT NULL,
 *   destination_id INT NOT NULL,
 *   created_at     TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
 *   PRIMARY KEY (id),
 *   UNIQUE KEY uq_user_dest (user_id, destination_id),
 *   CONSTRAINT fk_ust_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
 * );
 */
public class SavedTripDAO {

    /**
     * Creates the user_saved_trips table if it does not already exist.
     * Called once from SaveTripServlet.init().
     */
    public void ensureTableExists() {
        String ddl = "CREATE TABLE IF NOT EXISTS user_saved_trips (" +
                "  id             INT NOT NULL AUTO_INCREMENT," +
                "  user_id        INT NOT NULL," +
                "  destination_id INT NOT NULL," +
                "  created_at     TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP," +
                "  PRIMARY KEY (id)," +
                "  UNIQUE KEY uq_user_dest (user_id, destination_id)," +
                "  CONSTRAINT fk_ust_user FOREIGN KEY (user_id)" +
                "    REFERENCES users (id) ON DELETE CASCADE" +
                ")";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(ddl)) {
            ps.execute();
            System.out.println("[SavedTripDAO] Table user_saved_trips ensured.");
        } catch (SQLException e) {
            System.err.println("[SavedTripDAO] ensureTableExists failed: " + e.getMessage());
        }
    }

    /**
     * Saves a destination for a user. Silently ignores duplicates.
     *
     * @return true if inserted (new save), false if already saved or error.
     */
    public boolean saveTrip(int userId, int destinationId) {
        String sql = "INSERT IGNORE INTO user_saved_trips (user_id, destination_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, destinationId);
            int rows = ps.executeUpdate();
            System.out.println("[SavedTripDAO] saveTrip userId=" + userId
                    + " destId=" + destinationId + " rows=" + rows);
            return rows > 0; // 0 = already saved (duplicate), 1 = new save
        } catch (SQLException e) {
            System.err.println("[SavedTripDAO] saveTrip failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Checks whether a user has already saved a destination.
     */
    public boolean isSaved(int userId, int destinationId) {
        String sql = "SELECT 1 FROM user_saved_trips WHERE user_id = ? AND destination_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, destinationId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("[SavedTripDAO] isSaved failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Removes a saved trip for a user (toggle off).
     */
    public boolean unsaveTrip(int userId, int destinationId) {
        String sql = "DELETE FROM user_saved_trips WHERE user_id = ? AND destination_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, destinationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[SavedTripDAO] unsaveTrip failed: " + e.getMessage());
            return false;
        }
    }
}
