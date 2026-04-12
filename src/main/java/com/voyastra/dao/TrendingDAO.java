package com.voyastra.dao;

import com.voyastra.model.TrendingPlace;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TrendingDAO {

    /**
     * Fetches all trending places sorted ascending by rank column.
     */
    public List<TrendingPlace> getAllTrending() {
        List<TrendingPlace> places = new ArrayList<>();
        String query = "SELECT * FROM trending_places ORDER BY rank ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                places.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    /**
     * Fetches only the top N trending places — useful for homepage previews.
     */
    public List<TrendingPlace> getTopTrending(int limit) {
        List<TrendingPlace> places = new ArrayList<>();
        String query = "SELECT * FROM trending_places ORDER BY rank ASC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    places.add(extractFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    /**
     * Admin: Insert a new trending destination record.
     */
    public boolean addTrendingPlace(TrendingPlace place) {
        String query = "INSERT INTO trending_places (rank, name, image_url, category, category_color, sub_title, price, duration, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, place.getRank());
            stmt.setString(2, place.getName());
            stmt.setString(3, place.getImageUrl());
            stmt.setString(4, place.getCategory());
            stmt.setString(5, place.getCategoryColor());
            stmt.setString(6, place.getSubTitle());
            stmt.setString(7, place.getPrice());
            stmt.setString(8, place.getDuration());
            stmt.setDouble(9, place.getRating());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Admin: Update an existing trending place's rank or details.
     */
    public boolean updateTrendingPlace(TrendingPlace place) {
        String query = "UPDATE trending_places SET rank = ?, name = ?, image_url = ?, category = ?, category_color = ?, sub_title = ?, price = ?, duration = ?, rating = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, place.getRank());
            stmt.setString(2, place.getName());
            stmt.setString(3, place.getImageUrl());
            stmt.setString(4, place.getCategory());
            stmt.setString(5, place.getCategoryColor());
            stmt.setString(6, place.getSubTitle());
            stmt.setString(7, place.getPrice());
            stmt.setString(8, place.getDuration());
            stmt.setDouble(9, place.getRating());
            stmt.setInt(10, place.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Admin: Permanently remove a trending place.
     */
    public boolean deleteTrendingPlace(int id) {
        String query = "DELETE FROM trending_places WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private TrendingPlace extractFromResultSet(ResultSet rs) throws SQLException {
        TrendingPlace p = new TrendingPlace();
        p.setId(rs.getInt("id"));
        p.setRank(rs.getInt("rank"));
        p.setName(rs.getString("name"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCategory(rs.getString("category"));
        p.setCategoryColor(rs.getString("category_color"));
        p.setSubTitle(rs.getString("sub_title"));
        p.setPrice(rs.getString("price"));
        p.setDuration(rs.getString("duration"));
        p.setRating(rs.getDouble("rating"));
        return p;
    }
}
