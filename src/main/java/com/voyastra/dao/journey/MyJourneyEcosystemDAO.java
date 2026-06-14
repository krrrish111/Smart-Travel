package com.voyastra.dao.journey;

import com.voyastra.model.journey.TravelMemory;
import com.voyastra.model.journey.FamilyMember;
import com.voyastra.model.journey.TripReport;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MyJourneyEcosystemDAO {

    public List<TravelMemory> getMemoriesForUser(int userId) {
        List<TravelMemory> list = new ArrayList<>();
        String sql = "SELECT * FROM travel_memories WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TravelMemory tm = new TravelMemory();
                    tm.setId(rs.getInt("id"));
                    tm.setUserId(rs.getInt("user_id"));
                    tm.setJourneyId(rs.getInt("journey_id"));
                    tm.setMediaUrl(rs.getString("media_url"));
                    tm.setCaption(rs.getString("caption"));
                    tm.setLocation(rs.getString("location"));
                    tm.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(tm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FamilyMember> getFamilyMembersForUser(int userId) {
        List<FamilyMember> list = new ArrayList<>();
        String sql = "SELECT * FROM family_hub_members WHERE user_id = ? ORDER BY created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FamilyMember fm = new FamilyMember();
                    fm.setId(rs.getInt("id"));
                    fm.setUserId(rs.getInt("user_id"));
                    fm.setRelation(rs.getString("relation"));
                    fm.setName(rs.getString("name"));
                    fm.setAge(rs.getInt("age"));
                    fm.setPassportReadiness(rs.getInt("passport_readiness"));
                    fm.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(fm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TripReport> getTripReportsForUser(int userId) {
        List<TripReport> list = new ArrayList<>();
        String sql = "SELECT * FROM trip_reports WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TripReport tr = new TripReport();
                    tr.setId(rs.getInt("id"));
                    tr.setUserId(rs.getInt("user_id"));
                    tr.setJourneyId(rs.getInt("journey_id"));
                    tr.setDestination(rs.getString("destination"));
                    tr.setSummary(rs.getString("summary"));
                    tr.setTotalCost(rs.getBigDecimal("total_cost"));
                    tr.setRating(rs.getInt("rating"));
                    tr.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(tr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
