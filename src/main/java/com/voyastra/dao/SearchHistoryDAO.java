package com.voyastra.dao;

import com.voyastra.model.booking.HotelSearchHistory;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SearchHistoryDAO {
    
    public void saveSearchHistory(HotelSearchHistory history) {
        String sql = "INSERT INTO hotel_search_history (user_id, destination, check_in, check_out, rooms, adults, children, hotel_type, amenities) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, history.getUserId() == 0 ? null : history.getUserId());
            stmt.setString(2, history.getDestination());
            stmt.setString(3, history.getCheckIn());
            stmt.setString(4, history.getCheckOut());
            stmt.setInt(5, history.getRooms());
            stmt.setInt(6, history.getAdults());
            stmt.setInt(7, history.getChildren());
            stmt.setString(8, history.getHotelType());
            stmt.setString(9, history.getAmenities());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}