package com.voyastra.dao;

import com.voyastra.model.TripGroup;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TripGroupDAO {
    
    public int createGroup(TripGroup group) {
        String sql = "INSERT INTO trip_groups (name, creator_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, group.getName());
            ps.setInt(2, group.getCreatorId());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    public TripGroup getGroupById(int id) {
        String sql = "SELECT * FROM trip_groups WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TripGroup tg = new TripGroup();
                    tg.setId(rs.getInt("id"));
                    tg.setName(rs.getString("name"));
                    tg.setCreatorId(rs.getInt("creator_id"));
                    tg.setCreatedAt(rs.getTimestamp("created_at"));
                    return tg;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
