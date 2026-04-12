package com.voyastra.dao;

import com.voyastra.model.Itinerary;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for managing operations on the itineraries table.
 */
public class ItineraryDAO {

    public boolean save(Itinerary itinerary) {
        String query = "INSERT INTO itineraries (user_id, title, destination, itinerary_data) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, itinerary.getUserId());
            stmt.setString(2, itinerary.getTitle());
            stmt.setString(3, itinerary.getDestination());
            stmt.setString(4, itinerary.getItineraryData());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR: ItineraryDAO.save failed.");
            e.printStackTrace();
        }
        return false;
    }

    public List<Itinerary> getByUser(int userId) {
        List<Itinerary> list = new ArrayList<>();
        String query = "SELECT id, user_id, title, destination, itinerary_data, created_at FROM itineraries WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Itinerary it = new Itinerary();
                    it.setId(rs.getInt("id"));
                    it.setUserId(rs.getInt("user_id"));
                    it.setTitle(rs.getString("title"));
                    it.setDestination(rs.getString("destination"));
                    it.setItineraryData(rs.getString("itinerary_data"));
                    it.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(it);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR: ItineraryDAO.getByUser failed.");
            e.printStackTrace();
        }
        return list;
    }

    public Itinerary getById(int id) {
        String query = "SELECT id, user_id, title, destination, itinerary_data, created_at FROM itineraries WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Itinerary it = new Itinerary();
                    it.setId(rs.getInt("id"));
                    it.setUserId(rs.getInt("user_id"));
                    it.setTitle(rs.getString("title"));
                    it.setDestination(rs.getString("destination"));
                    it.setItineraryData(rs.getString("itinerary_data"));
                    it.setCreatedAt(rs.getTimestamp("created_at"));
                    return it;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR: ItineraryDAO.getById failed.");
            e.printStackTrace();
        }
        return null;
    }

    public boolean delete(int id) {
        String query = "DELETE FROM itineraries WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR: ItineraryDAO.delete failed.");
            e.printStackTrace();
        }
        return false;
    }
}
