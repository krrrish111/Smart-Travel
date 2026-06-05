package com.voyastra.dao;

import com.voyastra.model.Traveller;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TravellerDAO {

    public List<Traveller> getTravellersByDraftId(String draftId) {
        List<Traveller> list = new ArrayList<>();
        String sql = "SELECT * FROM travellers WHERE draft_id = ? ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, draftId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Traveller t = new Traveller();
                t.setId(rs.getInt("id"));
                t.setDraftId(rs.getString("draft_id"));
                t.setTitle(rs.getString("title"));
                t.setFirstName(rs.getString("first_name"));
                t.setLastName(rs.getString("last_name"));
                t.setGender(rs.getString("gender"));
                t.setDob(rs.getString("dob"));
                t.setNationality(rs.getString("nationality"));
                t.setPassport(rs.getString("passport"));
                t.setSeatNumber(rs.getString("seat_number"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateSeats(String draftId, List<String> seats) {
        List<Traveller> travellers = getTravellersByDraftId(draftId);
        if (travellers.isEmpty() || seats.size() != travellers.size()) {
            return false;
        }

        String sql = "UPDATE travellers SET seat_number = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            
            for (int i = 0; i < travellers.size(); i++) {
                ps.setString(1, seats.get(i));
                ps.setInt(2, travellers.get(i).getId());
                ps.addBatch();
            }
            
            ps.executeBatch();
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
