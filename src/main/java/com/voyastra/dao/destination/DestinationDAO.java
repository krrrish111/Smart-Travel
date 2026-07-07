package com.voyastra.dao.destination;

import com.voyastra.model.destination.Destination;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DestinationDAO {

    private Destination mapRow(ResultSet rs) throws SQLException {
        Destination d = new Destination();
        d.setId(rs.getInt("id"));
        d.setTitle(rs.getString("title"));
        d.setDestination(rs.getString("destination"));
        d.setCategory(rs.getString("category"));
        d.setShortDescription(rs.getString("short_description"));
        d.setFullDescription(rs.getString("full_description"));
        d.setPriceInr(rs.getDouble("price_inr"));
        d.setDiscountPrice(rs.getDouble("discount_price"));
        d.setDurationDays(rs.getInt("duration_days"));
        d.setDurationNights(rs.getInt("duration_nights"));
        d.setBestSeason(rs.getString("best_season"));
        d.setStartingCity(rs.getString("starting_city"));
        d.setImageUrl(rs.getString("image_url"));
        d.setRating(rs.getFloat("rating"));
        d.setReviewCount(rs.getInt("review_count"));
        d.setActive(rs.getBoolean("is_active"));
        d.setFeatured(rs.getBoolean("is_featured"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        
        double lat = rs.getDouble("latitude");
        if (!rs.wasNull()) d.setLatitude(lat);
        double lng = rs.getDouble("longitude");
        if (!rs.wasNull()) d.setLongitude(lng);
        d.setHighlights(rs.getString("highlights"));
        d.setHasUnesco(rs.getBoolean("has_unesco"));
        d.setTrending(rs.getBoolean("is_trending"));
        d.setPopular(rs.getBoolean("is_popular"));
        
        // For performance, we won't load gallery here by default unless requested in a specific service.
        // Populate legacy aliases for existing JSPs
        d.setName(rs.getString("title"));
        d.setCountry(rs.getString("destination"));
        d.setDescription(rs.getString("short_description"));
        d.setImage(rs.getString("image_url"));

        return d;
    }

    public boolean addDestination(Destination d) {
        String query = "INSERT INTO destinations (title, destination, category, short_description, full_description, price_inr, discount_price, duration_days, duration_nights, best_season, starting_city, image_url, rating, review_count, is_active, is_featured, latitude, longitude, highlights, has_unesco, is_trending, is_popular) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, d.getTitle());
            stmt.setString(2, d.getDestination());
            stmt.setString(3, d.getCategory());
            stmt.setString(4, d.getShortDescription());
            stmt.setString(5, d.getFullDescription());
            stmt.setDouble(6, d.getPriceInr());
            stmt.setDouble(7, d.getDiscountPrice());
            stmt.setInt(8, d.getDurationDays());
            stmt.setInt(9, d.getDurationNights());
            stmt.setString(10, d.getBestSeason());
            stmt.setString(11, d.getStartingCity());
            stmt.setString(12, d.getImageUrl());
            stmt.setFloat(13, d.getRating());
            stmt.setInt(14, d.getReviewCount());
            stmt.setBoolean(15, d.isActive());
            stmt.setBoolean(16, d.isFeatured());
            if (d.getLatitude() != null) stmt.setDouble(17, d.getLatitude()); else stmt.setNull(17, java.sql.Types.DOUBLE);
            if (d.getLongitude() != null) stmt.setDouble(18, d.getLongitude()); else stmt.setNull(18, java.sql.Types.DOUBLE);
            stmt.setString(19, d.getHighlights());
            stmt.setBoolean(20, d.hasUnesco());
            stmt.setBoolean(21, d.isTrending());
            stmt.setBoolean(22, d.isPopular());
            
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) d.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Destination getDestinationById(int id) {
        String query = "SELECT * FROM destinations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Destination> getAllDestinations() {
        List<Destination> list = new ArrayList<>();
        String query = "SELECT * FROM destinations ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Destination> getDestinationsByCategory(String category) {
        List<Destination> list = new ArrayList<>();
        String query = "SELECT * FROM destinations WHERE category = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Destination> getFeaturedDestinations() {
        @SuppressWarnings("unchecked")
        List<Destination> cached = (List<Destination>) com.voyastra.util.CacheManager.get("featured_destinations");
        if (cached != null) {
            return cached;
        }
        List<Destination> list = new ArrayList<>();
        String query = "SELECT * FROM destinations WHERE is_featured = true ORDER BY id DESC LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Phase 4 Fallback: ORDER BY rating DESC then created_at DESC LIMIT 10
        if (list.isEmpty()) {
            System.out.println("[DestinationDAO] getFeaturedDestinations returned empty. Executing Phase 4 Fallback...");
            String fallbackQuery = "SELECT d.*, COUNT(b.id) AS booking_count " +
                                  "FROM destinations d " +
                                  "LEFT JOIN destination_bookings b ON d.id = b.destination_id " +
                                  "GROUP BY d.id " +
                                  "ORDER BY d.rating DESC, booking_count DESC, d.created_at DESC " +
                                  "LIMIT 10";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(fallbackQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            } catch (SQLException e) {
                System.out.println("[DestinationDAO] Fallback query failed, executing simple fallback...");
                String simpleFallback = "SELECT * FROM destinations ORDER BY rating DESC, created_at DESC LIMIT 10";
                try (Connection conn2 = DBConnection.getConnection();
                     PreparedStatement stmt2 = conn2.prepareStatement(simpleFallback);
                     ResultSet rs2 = stmt2.executeQuery()) {
                    while (rs2.next()) {
                        list.add(mapRow(rs2));
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        
        // Ultimate fallback: never return empty list
        if (list.isEmpty()) {
            list.add(getMockDestination(1, "Golden Triangle Tour", "Delhi, Agra & Jaipur, India", "Nature", "Discover the iconic trio — Taj Mahal, Amber Fort and Red Fort in one unforgettable circuit.", 15999, "https://images.unsplash.com/photo-1524492412937-b28074a7d70?auto=format&fit=crop&w=600&q=80", 4.8f));
            list.add(getMockDestination(2, "Kerala Backwaters Escape", "Kerala, India", "Nature", "Cruise through serene backwaters, lush paddy fields, and tranquil lagoons in God's Own Country.", 18999, "https://images.unsplash.com/photo-1593693397690-362cb9666fc2?auto=format&fit=crop&w=600&q=80", 4.9f));
            list.add(getMockDestination(3, "Goa Beach Paradise", "Goa, India", "Nature", "Sun, sand, seafood and Portuguese heritage along India's most famous coastline.", 11999, "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80", 4.6f));
        }
        
        com.voyastra.util.CacheManager.put("featured_destinations", list);
        return list;
    }

    private Destination getMockDestination(int id, String title, String destName, String category, String desc, double price, String img, float rating) {
        Destination d = new Destination();
        d.setId(id);
        d.setTitle(title);
        d.setDestination(destName);
        d.setCategory(category);
        d.setShortDescription(desc);
        d.setFullDescription(desc);
        d.setPriceInr(price);
        d.setDiscountPrice(price * 0.85);
        d.setDurationDays(4);
        d.setDurationNights(3);
        d.setBestSeason("October - March");
        d.setStartingCity("Delhi");
        d.setImageUrl(img);
        d.setRating(rating);
        d.setReviewCount(120);
        d.setActive(true);
        d.setFeatured(true);
        d.setTrending(true);
        d.setPopular(true);
        return d;
    }
    
    public List<Destination> getPopularDestinations() {
        @SuppressWarnings("unchecked")
        List<Destination> cached = (List<Destination>) com.voyastra.util.CacheManager.get("popular_destinations");
        if (cached != null) {
            return cached;
        }
        List<Destination> list = new ArrayList<>();
        String query = "SELECT * FROM destinations ORDER BY review_count DESC LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Fallback to featured destinations if popular is empty
        if (list.isEmpty()) {
            list = getFeaturedDestinations();
        }
        com.voyastra.util.CacheManager.put("popular_destinations", list);
        return list;
    }

    public List<Destination> getIconicDestinations() {
        @SuppressWarnings("unchecked")
        List<Destination> cached = (List<Destination>) com.voyastra.util.CacheManager.get("iconic_destinations");
        if (cached != null) {
            return cached;
        }
        List<Destination> list = new ArrayList<>();
        // Fetch a larger set of destinations to populate the Iconic Destinations grid
        String query = "SELECT * FROM destinations WHERE title IN ('Golden Triangle Tour', 'Kerala Backwaters Escape', 'Rajasthan Royal Odyssey', 'Goa Beach Paradise', 'Ladakh High Altitude Adventure', 'Shimla & Manali Hill Retreat', 'Varanasi Spiritual Journey', 'Andaman Island Explorer', 'Darjeeling & Sikkim Tea Trail', 'Hampi Heritage & Ruins', 'Coorg Coffee Country', 'Udaipur — City of Lakes', 'Rann of Kutch White Desert', 'Khajuraho Temples & Wildlife') LIMIT 17";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        com.voyastra.util.CacheManager.put("iconic_destinations", list);
        return list;
    }

    public boolean updateDestination(Destination d) {
        String query = "UPDATE destinations SET title=?, destination=?, category=?, short_description=?, full_description=?, price_inr=?, discount_price=?, duration_days=?, duration_nights=?, best_season=?, starting_city=?, image_url=?, rating=?, review_count=?, is_active=?, is_featured=?, latitude=?, longitude=?, highlights=?, has_unesco=?, is_trending=?, is_popular=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, d.getTitle());
            stmt.setString(2, d.getDestination());
            stmt.setString(3, d.getCategory());
            stmt.setString(4, d.getShortDescription());
            stmt.setString(5, d.getFullDescription());
            stmt.setDouble(6, d.getPriceInr());
            stmt.setDouble(7, d.getDiscountPrice());
            stmt.setInt(8, d.getDurationDays());
            stmt.setInt(9, d.getDurationNights());
            stmt.setString(10, d.getBestSeason());
            stmt.setString(11, d.getStartingCity());
            stmt.setString(12, d.getImageUrl());
            stmt.setFloat(13, d.getRating());
            stmt.setInt(14, d.getReviewCount());
            stmt.setBoolean(15, d.isActive());
            stmt.setBoolean(16, d.isFeatured());
            if (d.getLatitude() != null) stmt.setDouble(17, d.getLatitude()); else stmt.setNull(17, java.sql.Types.DOUBLE);
            if (d.getLongitude() != null) stmt.setDouble(18, d.getLongitude()); else stmt.setNull(18, java.sql.Types.DOUBLE);
            stmt.setString(19, d.getHighlights());
            stmt.setBoolean(20, d.hasUnesco());
            stmt.setBoolean(21, d.isTrending());
            stmt.setBoolean(22, d.isPopular());
            stmt.setInt(23, d.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
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
            e.printStackTrace();
            return false;
        }
    }

    public List<Destination> searchDestinations(String keyword) {
        List<Destination> list = new ArrayList<>();
        String query = "SELECT * FROM destinations WHERE LOWER(title) LIKE LOWER(?) OR LOWER(destination) LIKE LOWER(?) OR LOWER(short_description) LIKE LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            String trimmedKeyword = (keyword != null) ? keyword.trim() : "";
            String pattern = "%" + trimmedKeyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
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
            e.printStackTrace();
        }
        return 0;
    }

    public List<com.voyastra.model.destination.DestinationItinerary> getItinerariesForDestination(int destId) {
        List<com.voyastra.model.destination.DestinationItinerary> list = new ArrayList<>();
        String query = "SELECT * FROM destination_itineraries WHERE destination_id = ? ORDER BY day_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, destId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    com.voyastra.model.destination.DestinationItinerary di = new com.voyastra.model.destination.DestinationItinerary();
                    di.setId(rs.getInt("id"));
                    di.setDestinationId(rs.getInt("destination_id"));
                    di.setDayNumber(rs.getInt("day_number"));
                    di.setTitle(rs.getString("title"));
                    di.setDetails(rs.getString("details"));
                    list.add(di);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Gallery Methods
    public List<String> getGalleryForDestination(int destId) {
        List<String> list = new ArrayList<>();
        String query = "SELECT image_url FROM destination_gallery WHERE destination_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, destId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(rs.getString("image_url"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void clearGalleryImages(int destId) {
        String query = "DELETE FROM destination_gallery WHERE destination_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, destId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addGalleryImage(int destId, String imageUrl) {
        String query = "INSERT INTO destination_gallery (destination_id, image_url) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, destId);
            stmt.setString(2, imageUrl);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
