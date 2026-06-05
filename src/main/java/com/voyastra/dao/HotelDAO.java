package com.voyastra.dao;

import com.voyastra.model.Hotel;
import com.voyastra.model.HotelRoom;
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
        
        // Safe defaults for newly added fields not present in old schema
        r.setRoomSize("30 m²");
        r.setBedType("1 Double Bed");
        r.setFreeCancellation(false);
        r.setBreakfastIncluded(false);
        
        return r;
    }
}