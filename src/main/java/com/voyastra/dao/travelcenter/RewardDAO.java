package com.voyastra.dao.travelcenter;

import com.voyastra.model.travelcenter.RewardProfile;
import com.voyastra.model.travelcenter.RewardHistory;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class RewardDAO {

    public RewardProfile getProfileByUserId(int userId) {
        String sql = "SELECT * FROM reward_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToProfile(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public RewardProfile createProfile(int userId) {
        String refCode = "VOY" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        String sql = "INSERT INTO reward_profiles (user_id, current_points, lifetime_points, tier, referral_code) VALUES (?, 0, 0, 'Explorer', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, refCode);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    RewardProfile p = new RewardProfile();
                    p.setId(rs.getInt(1));
                    p.setUserId(userId);
                    p.setCurrentPoints(0);
                    p.setLifetimePoints(0);
                    p.setTier("Explorer");
                    p.setReferralCode(refCode);
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addPoints(int userId, int points, String description) {
        String sqlUpdate = "UPDATE reward_profiles SET current_points = current_points + ?, lifetime_points = lifetime_points + ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
            ps.setInt(1, points);
            ps.setInt(2, points);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sqlHist = "INSERT INTO reward_history (user_id, points, type, description) VALUES (?, ?, 'EARNED', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlHist)) {
            ps.setInt(1, userId);
            ps.setInt(2, points);
            ps.setString(3, description);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        checkTierUpgrade(userId);
    }

    private void checkTierUpgrade(int userId) {
        RewardProfile p = getProfileByUserId(userId);
        if (p == null) return;
        String newTier = "Explorer";
        if (p.getLifetimePoints() >= 10000) newTier = "Elite";
        else if (p.getLifetimePoints() >= 5000) newTier = "Platinum";
        else if (p.getLifetimePoints() >= 2000) newTier = "Gold";

        if (!p.getTier().equals(newTier)) {
            String sql = "UPDATE reward_profiles SET tier = ? WHERE user_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newTier);
                ps.setInt(2, userId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private RewardProfile mapRowToProfile(ResultSet rs) throws SQLException {
        RewardProfile p = new RewardProfile();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setCurrentPoints(rs.getInt("current_points"));
        p.setLifetimePoints(rs.getInt("lifetime_points"));
        p.setTier(rs.getString("tier"));
        p.setReferralCode(rs.getString("referral_code"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
