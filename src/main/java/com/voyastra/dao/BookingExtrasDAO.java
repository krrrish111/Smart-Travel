package com.voyastra.dao;

import com.voyastra.model.BookingExtras;
import com.voyastra.util.DBConnection;

import java.sql.*;

public class BookingExtrasDAO {

    /* ── Create table if absent (called once on app startup or first use) ── */
    public static void ensureTable() {
        String sql = "CREATE TABLE IF NOT EXISTS booking_extras (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "draft_id VARCHAR(100) NOT NULL, " +
                "meal_type VARCHAR(30) DEFAULT 'none', " +
                "extra_baggage VARCHAR(20) DEFAULT 'none', " +
                "priority_boarding TINYINT(1) DEFAULT 0, " +
                "travel_insurance  TINYINT(1) DEFAULT 0, " +
                "total_cost DECIMAL(10,2) DEFAULT 0.00, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (draft_id) REFERENCES booking_draft(draft_id) ON DELETE CASCADE)";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* ── INSERT or REPLACE extras for a draft ─────────────────────────── */
    public boolean saveExtras(BookingExtras extras) {
        // Delete old record first (idempotent upsert)
        String del = "DELETE FROM booking_extras WHERE draft_id = ?";
        String ins = "INSERT INTO booking_extras (draft_id, meal_type, extra_baggage, " +
                "priority_boarding, travel_insurance, total_cost) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(del)) {
                ps1.setString(1, extras.getDraftId());
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(ins)) {
                ps2.setString(1, extras.getDraftId());
                ps2.setString(2, extras.getMealType());
                ps2.setString(3, extras.getExtraBaggage());
                ps2.setBoolean(4, extras.isPriorityBoarding());
                ps2.setBoolean(5, extras.isTravelInsurance());
                ps2.setDouble(6, extras.getTotalCost());
                ps2.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ── Fetch extras for a draft ─────────────────────────────────────── */
    public BookingExtras getByDraftId(String draftId) {
        String sql = "SELECT * FROM booking_extras WHERE draft_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, draftId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BookingExtras e = new BookingExtras();
                e.setId(rs.getInt("id"));
                e.setDraftId(rs.getString("draft_id"));
                e.setMealType(rs.getString("meal_type"));
                e.setExtraBaggage(rs.getString("extra_baggage"));
                e.setPriorityBoarding(rs.getBoolean("priority_boarding"));
                e.setTravelInsurance(rs.getBoolean("travel_insurance"));
                e.setTotalCost(rs.getDouble("total_cost"));
                return e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
