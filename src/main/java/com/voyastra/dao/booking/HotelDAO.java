package com.voyastra.dao.booking;

import com.voyastra.model.booking.Hotel;
import com.voyastra.model.booking.HotelRoom;
import com.voyastra.model.booking.HotelReview;
import com.voyastra.model.booking.HotelPhoto;
import com.voyastra.model.destination.NearbyPlace;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HotelDAO {

    public List<Hotel> searchHotels(String city) {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT * FROM hotels WHERE city LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + city + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    hotels.add(extractHotel(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }

    public Hotel getHotelById(int id) {
        String query = "SELECT * FROM hotels WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return extractHotel(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<HotelRoom> getHotelRooms(int hotelId) {
        List<HotelRoom> rooms = new ArrayList<>();
        String query = "SELECT * FROM hotel_rooms WHERE hotel_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(extractRoom(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public HotelRoom getRoomById(int roomId) {
        String query = "SELECT * FROM hotel_rooms WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return extractRoom(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<HotelPhoto> getPhotos(int hotelId) {
        List<HotelPhoto> photos = new ArrayList<>();
        String query = "SELECT * FROM hotel_photos WHERE hotel_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HotelPhoto p = new HotelPhoto();
                    p.setId(rs.getInt("id"));
                    p.setHotelId(rs.getInt("hotel_id"));
                    p.setUrl(rs.getString("url"));
                    p.setCaption(rs.getString("caption"));
                    photos.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return photos;
    }

    public List<NearbyPlace> getNearbyPlaces(int hotelId) {
        List<NearbyPlace> places = new ArrayList<>();
        String query = "SELECT * FROM nearby_places WHERE hotel_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    NearbyPlace p = new NearbyPlace();
                    p.setId(rs.getInt("id"));
                    p.setHotelId(rs.getInt("hotel_id"));
                    p.setName(rs.getString("name"));
                    p.setPlaceType(rs.getString("place_type"));
                    p.setDistanceKm(rs.getDouble("distance_km"));
                    places.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    public List<HotelReview> getReviews(int hotelId) {
        List<HotelReview> reviews = new ArrayList<>();
        String query = "SELECT r.*, u.full_name FROM hotel_reviews r JOIN users u ON r.user_id = u.id WHERE r.hotel_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HotelReview r = new HotelReview();
                    r.setId(rs.getInt("id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setHotelId(rs.getInt("hotel_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setReviewText(rs.getString("review_text"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setUserName(rs.getString("full_name"));
                    reviews.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public void addReview(HotelReview review) {
        String query = "INSERT INTO hotel_reviews (user_id, hotel_id, rating, review_text) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getHotelId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getReviewText());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addRecentlyViewed(int userId, int hotelId) {
        String query = "INSERT INTO recently_viewed_hotels (user_id, hotel_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE viewed_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Hotel> getRecentlyViewed(int userId) {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT h.* FROM hotels h JOIN recently_viewed_hotels r ON h.id = r.hotel_id WHERE r.user_id = ? ORDER BY r.viewed_at DESC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    hotels.add(extractHotel(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }

    public List<Hotel> getRecommendedHotels() {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT * FROM hotels WHERE id IN (SELECT min_id FROM (SELECT MIN(id) as min_id FROM hotels GROUP BY name) as temp) ORDER BY rating DESC, id DESC LIMIT 4";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    hotels.add(extractHotel(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }
    
    public List<Hotel> getWishlist(int userId) {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT h.* FROM hotels h JOIN hotel_wishlists w ON h.id = w.hotel_id WHERE w.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    hotels.add(extractHotel(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }

    public boolean isWishlisted(int userId, int hotelId) {
        String query = "SELECT 1 FROM hotel_wishlists WHERE user_id = ? AND hotel_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void toggleWishlist(int userId, int hotelId) {
        if (isWishlisted(userId, hotelId)) {
            String query = "DELETE FROM hotel_wishlists WHERE user_id = ? AND hotel_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, hotelId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String query = "INSERT INTO hotel_wishlists (user_id, hotel_id) VALUES (?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, hotelId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private Hotel extractHotel(ResultSet rs) throws SQLException {
        Hotel h = new Hotel();
        h.setId(rs.getInt("id"));
        h.setName(rs.getString("name"));
        h.setCity(rs.getString("city"));
        h.setAddress(rs.getString("address"));
        h.setDescription(rs.getString("description"));
        h.setRating(rs.getDouble("rating"));
        h.setImageUrl(rs.getString("imageUrl"));
        h.setAmenities(rs.getString("amenities"));
        
        try {
            h.setLatitude(rs.getDouble("latitude"));
            h.setLongitude(rs.getDouble("longitude"));
            h.setBestSeller(rs.getBoolean("best_seller"));
            h.setRecommended(rs.getBoolean("recommended"));
        } catch(SQLException e) {
            // columns might not exist if extractHotel used in old joins without select *
        }

        return h;
    }

    private HotelRoom extractRoom(ResultSet rs) throws SQLException {
        HotelRoom r = new HotelRoom();
        r.setId(rs.getInt("id"));
        r.setHotelId(rs.getInt("hotel_id"));
        r.setType(rs.getString("type"));
        r.setCapacity(rs.getInt("capacity"));
        r.setPricePerNight(rs.getDouble("price_per_night"));
        r.setAmenities(rs.getString("amenities"));
        r.setImageUrl(rs.getString("image_url"));
        
        r.setRoomSize("30 m²");
        r.setBedType("1 Double Bed");
        r.setFreeCancellation(false);
        r.setBreakfastIncluded(false);
        
        return r;
    }
}