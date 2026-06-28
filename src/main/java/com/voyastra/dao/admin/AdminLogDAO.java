package com.voyastra.dao.admin;

import com.voyastra.model.admin.AdminLog;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminLogDAO {

    /**
     * Inserts a new audit record into admin_logs.
     * Called by the AdminLogger utility from any servlet after a successful operation.
     */
    public boolean log(int adminId, String action, String module,
                       String details, String ipAddress) {
        String query = "INSERT INTO admin_logs (admin_id, action, module, details, ip_address) " +
                       "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, adminId);
            stmt.setString(2, action.toUpperCase());
            stmt.setString(3, module);
            stmt.setString(4, details);
            stmt.setString(5, ipAddress);

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
    public List<AdminLog> getLogsByAdmin(int adminId) {
        return queryLogs(
            "SELECT * FROM admin_logs WHERE admin_id = ? ORDER BY created_at DESC",
            String.valueOf(adminId)
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
        log.setAdminId(rs.getInt("admin_id"));
        log.setAction(rs.getString("action"));
        log.setModule(rs.getString("module"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }
}
