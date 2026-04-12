package com.voyastra.dao;

import com.voyastra.model.Stay;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StayDAO {

    /**
     * Fetches accommodation options aggressively filtered by location matching.
     */
    public List<Stay> getStaysByLocation(String location) {
        List<Stay> options = new ArrayList<>();
        // Uses wildcard searching to match anything broadly near the given locale
        String query = "SELECT * FROM stays WHERE LOWER(location) LIKE LOWER(?) ORDER BY discounted_price ASC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, "%" + location + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    options.add(extractFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }

    /**
     * Retrieves the entire stays collection.
     */
    public List<Stay> getAllStays() {
        List<Stay> options = new ArrayList<>();
        String query = "SELECT * FROM stays ORDER BY discounted_price ASC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                options.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }

    /**
     * Admin backend module logic: Insert new property into library.
     */
    public boolean addStay(Stay s) {
        String query = "INSERT INTO stays (type, name, image_url, badge, location, amenities, original_price, discounted_price, price_note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, s.getType());
            stmt.setString(2, s.getName());
            stmt.setString(3, s.getImageUrl());
            stmt.setString(4, s.getBadge());
            stmt.setString(5, s.getLocation());
            stmt.setString(6, s.getAmenities());
            stmt.setDouble(7, s.getOriginalPrice());
            stmt.setDouble(8, s.getDiscountedPrice());
            stmt.setString(9, s.getPriceNote());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Admin backend module logic: Permanently wipe property from library.
     */
    public boolean deleteStay(int id) {
        String query = "DELETE FROM stays WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Stay extractFromResultSet(ResultSet rs) throws SQLException {
        Stay s = new Stay();
        s.setId(rs.getInt("id"));
        s.setType(rs.getString("type"));
        s.setName(rs.getString("name"));
        s.setImageUrl(rs.getString("image_url"));
        s.setBadge(rs.getString("badge"));
        s.setLocation(rs.getString("location"));
        s.setAmenities(rs.getString("amenities"));
        s.setOriginalPrice(rs.getDouble("original_price"));
        s.setDiscountedPrice(rs.getDouble("discounted_price"));
        s.setPriceNote(rs.getString("price_note"));
        return s;
    }
}
