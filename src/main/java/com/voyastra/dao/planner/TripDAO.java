package com.voyastra.dao.planner;

import com.voyastra.model.planner.ItineraryDay;

import com.voyastra.model.planner.PremiumTrip;

import com.voyastra.model.*;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {
    
    public PremiumTrip getTripById(int id) {
        PremiumTrip trip = null;
        String query = "SELECT * FROM trip_plans WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
             
            pstmt.setInt(1, id);
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
        
        // Fallback mock trip plans so it is never empty!
        if (trips.isEmpty()) {
            System.out.println("[TripDAO] getAllTrips returned empty. Using fallback mock trip plans.");
            trips.add(getMockTrip(1, "Goa Beach Adventure", "Goa, India", "goa-beach-getaway", "A perfect 4-day beach vacation with water sports and sunset cruises.", "4 Days", 12500.0, 10000.0, "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80", 4.7, "Beach", "November - February", "Mumbai"));
            trips.add(getMockTrip(2, "Manali Snow Adventure", "Manali, Himachal Pradesh, India", "manali-snow-getaway", "Experience the best of the Himalayas skiing and mountain lodges.", "5 Days", 18000.0, 15000.0, "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80", 4.8, "Adventure", "December - March", "Delhi"));
            trips.add(getMockTrip(3, "Royal Rajasthan Heritage Tour", "Jaipur & Udaipur, Rajasthan, India", "royal-rajasthan", "Explore Amber Fort, Hawa Mahal, City Palace, and Johari Bazaar.", "6 Days", 22000.0, 18999.0, "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80", 4.6, "Cultural", "October - March", "Delhi"));
        }
        return trips;
    }

    private PremiumTrip getMockTrip(int id, String title, String destination, String slug, String desc, String duration, double price, double discount, String img, double rating, String category, String season, String startCity) {
        PremiumTrip t = new PremiumTrip();
        t.setId(id);
        t.setTitle(title);
        t.setDestination(destination);
        t.setSlug(slug);
        t.setShortDescription(desc);
        t.setFullDescription(desc);
        t.setDuration(duration);
        t.setPriceInr(price);
        t.setDiscountPrice(discount);
        t.setImageUrl(img);
        t.setRating(rating);
        t.setCategory(category);
        t.setBestSeason(season);
        t.setStartingCity(startCity);
        t.setFeatured(true);
        
        // Add basic mock inclusions
        List<com.voyastra.model.Inclusion> inclusions = new ArrayList<>();
        inclusions.add(new com.voyastra.model.Inclusion("Hotel Accommodation", true));
        inclusions.add(new com.voyastra.model.Inclusion("Daily Breakfast", true));
        inclusions.add(new com.voyastra.model.Inclusion("Private transfers", true));
        t.setInclusions(inclusions);
        
        // Add basic mock gallery
        List<com.voyastra.model.GalleryImage> gallery = new ArrayList<>();
        gallery.add(new com.voyastra.model.GalleryImage(img, title));
        t.setGallery(gallery);
        
        return t;
    }
}

