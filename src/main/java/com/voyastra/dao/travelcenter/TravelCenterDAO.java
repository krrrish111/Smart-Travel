package com.voyastra.dao.travelcenter;

import com.voyastra.model.travelcenter.TravelReadiness;
import com.voyastra.util.DBConnection;

import java.sql.*;

public class TravelCenterDAO {

    public TravelReadiness getReadiness(int userId, String destination) {
        String sql = "SELECT * FROM travel_readiness WHERE user_id = ? AND destination = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, destination);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public TravelReadiness createReadiness(int userId, String destination) {
        String sql = "INSERT INTO travel_readiness (user_id, destination) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, destination);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return getReadiness(userId, destination);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private TravelReadiness mapRow(ResultSet rs) throws SQLException {
        TravelReadiness r = new TravelReadiness();
        r.setId(rs.getInt("id"));
        r.setUserId(rs.getInt("user_id"));
        r.setDestination(rs.getString("destination"));
        r.setVisaStatus(rs.getString("visa_status"));
        r.setInsuranceStatus(rs.getString("insurance_status"));
        r.setForexStatus(rs.getString("forex_status"));
        r.setEsimStatus(rs.getString("esim_status"));
        r.setScore(rs.getInt("score"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
