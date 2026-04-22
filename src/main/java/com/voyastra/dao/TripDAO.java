package com.voyastra.dao;

import com.voyastra.model.*;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {
    
    public PremiumTrip getTripBySlug(String slug) {
        PremiumTrip trip = null;
        String query = "SELECT * FROM trip_plans WHERE slug = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
             
            pstmt.setString(1, slug);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                trip = new PremiumTrip();
                trip.setId(rs.getInt("id"));
                trip.setTitle(rs.getString("title"));
                trip.setSlug(rs.getString("slug"));
                trip.setDestination(rs.getString("destination"));
                trip.setShortDescription(rs.getString("short_description"));
                trip.setFullDescription(rs.getString("full_description"));
                trip.setDuration(rs.getString("duration"));
                trip.setPriceInr(rs.getDouble("price_inr"));
                trip.setDiscountPrice(rs.getDouble("discount_price"));
                trip.setImageUrl(rs.getString("image_url"));
                trip.setRating(rs.getDouble("rating"));
                trip.setCategory(rs.getString("category"));
                trip.setBestSeason(rs.getString("best_season"));
                trip.setStartingCity(rs.getString("starting_city"));
                trip.setFeatured(rs.getBoolean("featured"));
                
                // Fetch nested collections
                trip.setItinerary(getItineraryForTrip(trip.getId(), conn));
                trip.setInclusions(getInclusionsForTrip(trip.getId(), conn));
                trip.setGallery(getGalleryForTrip(trip.getId(), conn));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trip;
    }
    
    private List<ItineraryDay> getItineraryForTrip(int tripId, Connection conn) throws SQLException {
        List<ItineraryDay> list = new ArrayList<>();
        String sql = "SELECT * FROM trip_itinerary WHERE trip_id = ? ORDER BY day_number ASC";
        try(PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                list.add(new ItineraryDay(rs.getInt("day_number"), rs.getString("title"), rs.getString("details")));
            }
        }
        return list;
    }

    private List<Inclusion> getInclusionsForTrip(int tripId, Connection conn) throws SQLException {
        List<Inclusion> list = new ArrayList<>();
        String sql = "SELECT * FROM trip_inclusions WHERE trip_id = ?";
        try(PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                list.add(new Inclusion(rs.getString("inclusion_name"), rs.getBoolean("included")));
            }
        }
        return list;
    }

    private List<GalleryImage> getGalleryForTrip(int tripId, Connection conn) throws SQLException {
        List<GalleryImage> list = new ArrayList<>();
        String sql = "SELECT * FROM trip_gallery WHERE trip_id = ?";
        try(PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                list.add(new GalleryImage(rs.getString("image_url"), rs.getString("caption")));
            }
        }
        return list;
    }

    public List<PremiumTrip> getAllTrips() {
        List<PremiumTrip> trips = new ArrayList<>();
        String query = "SELECT * FROM trip_plans ORDER BY featured DESC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                PremiumTrip trip = new PremiumTrip();
                trip.setId(rs.getInt("id"));
                trip.setTitle(rs.getString("title"));
                trip.setSlug(rs.getString("slug"));
                trip.setDestination(rs.getString("destination"));
                trip.setShortDescription(rs.getString("short_description"));
                trip.setDuration(rs.getString("duration"));
                trip.setPriceInr(rs.getDouble("price_inr"));
                trip.setDiscountPrice(rs.getDouble("discount_price"));
                trip.setImageUrl(rs.getString("image_url"));
                trip.setRating(rs.getDouble("rating"));
                trip.setCategory(rs.getString("category"));
                trip.setBestSeason(rs.getString("best_season"));
                trip.setStartingCity(rs.getString("starting_city"));
                trip.setFeatured(rs.getBoolean("featured"));
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }
}

