package com.voyastra.dao;

import com.voyastra.model.Destination;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DestinationDAO {

    // Helper to map a ResultSet row to a Destination object
    private Destination mapRow(ResultSet rs) throws SQLException {
        Destination d = new Destination();
        d.setId(rs.getInt("id"));
        d.setName(rs.getString("name"));
        d.setState(rs.getString("state"));
        d.setCountry(rs.getString("country"));
        d.setCategory(rs.getString("category"));
        d.setImage(rs.getString("image"));
        d.setDescription(rs.getString("description"));
        d.setRating(rs.getFloat("rating"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        return d;
    }

    public boolean addDestination(Destination destination) {
        String query = "INSERT INTO destinations (name, state, country, category, image, description, rating) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, destination.getName());
            stmt.setString(2, destination.getState());
            stmt.setString(3, destination.getCountry());
            stmt.setString(4, destination.getCategory());
            stmt.setString(5, destination.getImage());
            stmt.setString(6, destination.getDescription());
            stmt.setFloat(7, destination.getRating());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.addDestination failed.");
            e.printStackTrace();
            return false;
        }
    }

    public Destination getDestinationById(int id) {
        String query = "SELECT id, name, state, country, category, image, description, rating, created_at FROM destinations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.getDestinationById failed.");
            e.printStackTrace();
        }
        return null;
    }

    public List<Destination> getAllDestinations() {
        List<Destination> list = new ArrayList<>();
        String query = "SELECT id, name, state, country, category, image, description, rating, created_at FROM destinations ORDER BY rating DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) return list;
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.getAllDestinations failed.");
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public List<Destination> getDestinationsByCategory(String category) {
        List<Destination> list = new ArrayList<>();
        String query = "SELECT id, name, state, country, category, image, description, rating, created_at FROM destinations WHERE category = ? ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.getDestinationsByCategory failed.");
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateDestination(Destination destination) {
        String query = "UPDATE destinations SET name = ?, state = ?, country = ?, category = ?, image = ?, description = ?, rating = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, destination.getName());
            stmt.setString(2, destination.getState());
            stmt.setString(3, destination.getCountry());
            stmt.setString(4, destination.getCategory());
            stmt.setString(5, destination.getImage());
            stmt.setString(6, destination.getDescription());
            stmt.setFloat(7, destination.getRating());
            stmt.setInt(8, destination.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.updateDestination failed.");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteDestination(int id) {
        String query = "DELETE FROM destinations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.deleteDestination failed.");
            e.printStackTrace();
            return false;
        }
    }

    public List<Destination> searchDestinations(String keyword) {
        List<Destination> list = new ArrayList<>();
        String query = "SELECT id, name, state, country, category, image, description, rating, created_at FROM destinations " +
                       "WHERE LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?) OR LOWER(state) LIKE LOWER(?) " +
                       "ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.searchDestinations failed.");
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalDestinationCount() {
        String query = "SELECT COUNT(*) FROM destinations";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationDAO.getTotalDestinationCount failed.");
            e.printStackTrace();
        }
        return 0;
    }
}
