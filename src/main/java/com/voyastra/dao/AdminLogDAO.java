package com.voyastra.dao;

import com.voyastra.model.AdminLog;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminLogDAO {

    /**
     * Inserts a new audit record into admin_logs.
     * Called by the AdminLogger utility from any servlet after a successful operation.
     */
    public boolean log(String adminUsername, String action, String entity,
                       int entityId, String details, String ipAddress) {
        String query = "INSERT INTO admin_logs (admin_username, action, entity, entity_id, details, ip_address) " +
                       "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, adminUsername);
            stmt.setString(2, action.toUpperCase());
            stmt.setString(3, entity);
            stmt.setInt(4, entityId);
            stmt.setString(5, details);
            stmt.setString(6, ipAddress);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: AdminLogDAO.log failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Fetches ALL audit logs, newest first.
     */
    public List<AdminLog> getAllLogs() {
        return queryLogs("SELECT * FROM admin_logs ORDER BY created_at DESC", null);
    }

    /**
     * Fetches logs filtered by a specific admin user.
     */
    public List<AdminLog> getLogsByAdmin(String adminUsername) {
        return queryLogs(
            "SELECT * FROM admin_logs WHERE admin_username = ? ORDER BY created_at DESC",
            adminUsername
        );
    }

    /**
     * Fetches logs filtered by action type (ADD / UPDATE / DELETE).
     */
    public List<AdminLog> getLogsByAction(String action) {
        return queryLogs(
            "SELECT * FROM admin_logs WHERE action = ? ORDER BY created_at DESC",
            action.toUpperCase()
        );
    }

    /**
     * Fetches the most recent N logs — for dashboard widgets.
     */
    public List<AdminLog> getRecentLogs(int limit) {
        List<AdminLog> logs = new ArrayList<>();
        String query = "SELECT * FROM admin_logs ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) logs.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * Permanently clears all audit logs — admin action itself is NOT logged
     * (to prevent infinite recursion); caller should handle that if needed.
     */
    public boolean clearAllLogs() {
        String query = "TRUNCATE TABLE admin_logs";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── Internal helpers ───────────────────────────────────────────────────

    private List<AdminLog> queryLogs(String sql, String param) {
        List<AdminLog> logs = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (param != null) stmt.setString(1, param);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) logs.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    private AdminLog extractFromResultSet(ResultSet rs) throws SQLException {
        AdminLog log = new AdminLog();
        log.setId(rs.getInt("id"));
        log.setAdminUsername(rs.getString("admin_username"));
        log.setAction(rs.getString("action"));
        log.setEntity(rs.getString("entity"));
        log.setEntityId(rs.getInt("entity_id"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }
}
