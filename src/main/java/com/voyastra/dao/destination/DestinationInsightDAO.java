package com.voyastra.dao.destination;

import com.voyastra.model.destination.DestinationInsight;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DestinationInsightDAO {

    public DestinationInsight getInsightByDestination(String destination) {
        String query = "SELECT id, destination, wiki_summary, wiki_url, top_attractions, local_foods, experiences, hotels, restaurants, travel_tips, itinerary_previews, ai_insights, country, best_time, language, currency, timezone, last_updated " +
                       "FROM destination_insights WHERE LOWER(destination) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, destination.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DestinationInsight di = new DestinationInsight();
                    di.setId(rs.getInt("id"));
                    di.setDestination(rs.getString("destination"));
                    di.setWikiSummary(rs.getString("wiki_summary"));
                    di.setWikiUrl(rs.getString("wiki_url"));
                    di.setTopAttractions(rs.getString("top_attractions"));
                    di.setLocalFoods(rs.getString("local_foods"));
                    di.setExperiences(rs.getString("experiences"));
                    di.setHotels(rs.getString("hotels"));
                    di.setRestaurants(rs.getString("restaurants"));
                    di.setTravelTips(rs.getString("travel_tips"));
                    di.setItineraryPreviews(rs.getString("itinerary_previews"));
                    di.setAiInsights(rs.getString("ai_insights"));
                    di.setCountry(rs.getString("country"));
                    di.setBestTime(rs.getString("best_time"));
                    di.setLanguage(rs.getString("language"));
                    di.setCurrency(rs.getString("currency"));
                    di.setTimezone(rs.getString("timezone"));
                    di.setLastUpdated(rs.getTimestamp("last_updated"));
                    return di;
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationInsightDAO.getInsightByDestination failed.");
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveInsight(DestinationInsight di) {
        String query = "INSERT INTO destination_insights (destination, wiki_summary, wiki_url, top_attractions, local_foods, experiences, hotels, restaurants, travel_tips, itinerary_previews, ai_insights, country, best_time, language, currency, timezone) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE wiki_summary = ?, wiki_url = ?, top_attractions = ?, local_foods = ?, experiences = ?, hotels = ?, restaurants = ?, travel_tips = ?, itinerary_previews = ?, ai_insights = ?, country = ?, best_time = ?, language = ?, currency = ?, timezone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            // INSERT params
            stmt.setString(1, di.getDestination());
            stmt.setString(2, di.getWikiSummary());
            stmt.setString(3, di.getWikiUrl());
            stmt.setString(4, di.getTopAttractions());
            stmt.setString(5, di.getLocalFoods());
            stmt.setString(6, di.getExperiences());
            stmt.setString(7, di.getHotels());
            stmt.setString(8, di.getRestaurants());
            stmt.setString(9, di.getTravelTips());
            stmt.setString(10, di.getItineraryPreviews());
            stmt.setString(11, di.getAiInsights());
            stmt.setString(12, di.getCountry());
            stmt.setString(13, di.getBestTime());
            stmt.setString(14, di.getLanguage());
            stmt.setString(15, di.getCurrency());
            stmt.setString(16, di.getTimezone());

            // UPDATE params
            stmt.setString(17, di.getWikiSummary());
            stmt.setString(18, di.getWikiUrl());
            stmt.setString(19, di.getTopAttractions());
            stmt.setString(20, di.getLocalFoods());
            stmt.setString(21, di.getExperiences());
            stmt.setString(22, di.getHotels());
            stmt.setString(23, di.getRestaurants());
            stmt.setString(24, di.getTravelTips());
            stmt.setString(25, di.getItineraryPreviews());
            stmt.setString(26, di.getAiInsights());
            stmt.setString(27, di.getCountry());
            stmt.setString(28, di.getBestTime());
            stmt.setString(29, di.getLanguage());
            stmt.setString(30, di.getCurrency());
            stmt.setString(31, di.getTimezone());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: DestinationInsightDAO.saveInsight failed.");
            e.printStackTrace();
            return false;
        }
    }
}
