package com.voyastra.dao.booking;

import com.voyastra.model.booking.HotelBooking;
import com.voyastra.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HotelBookingDAO {
    
    public int createBooking(HotelBooking booking) {
        String query = "INSERT INTO hotel_bookings (booking_code, user_id, hotel_id, room_id, check_in, check_out, " +
                       "guests, total_price, status, guest_name, guest_email, guest_phone, special_requests) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, booking.getBookingCode());
            stmt.setInt(2, booking.getUserId());
            stmt.setInt(3, booking.getHotelId());
            stmt.setInt(4, booking.getRoomId());
            stmt.setDate(5, booking.getCheckIn());
            stmt.setDate(6, booking.getCheckOut());
            stmt.setInt(7, booking.getGuests());
            stmt.setDouble(8, booking.getTotalPrice());
            stmt.setString(9, booking.getStatus() != null ? booking.getStatus() : "Confirmed");
            stmt.setString(10, booking.getGuestName());
            stmt.setString(11, booking.getGuestEmail());
            stmt.setString(12, booking.getGuestPhone());
            stmt.setString(13, booking.getSpecialRequests());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public HotelBooking getBookingById(int id) {
        String query = "SELECT * FROM hotel_bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return extractBooking(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<HotelBooking> getBookingsByUserId(int userId) {
        List<HotelBooking> list = new ArrayList<>();
        String query = "SELECT * FROM hotel_bookings WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String query = "UPDATE hotel_bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private HotelBooking extractBooking(ResultSet rs) throws SQLException {
        HotelBooking b = new HotelBooking();
        b.setId(rs.getInt("id"));
        b.setBookingCode(rs.getString("booking_code"));
        b.setUserId(rs.getInt("user_id"));
        b.setHotelId(rs.getInt("hotel_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setCheckIn(rs.getDate("check_in"));
        b.setCheckOut(rs.getDate("check_out"));
        b.setGuests(rs.getInt("guests"));
        b.setTotalPrice(rs.getDouble("total_price"));
        b.setStatus(rs.getString("status"));
        b.setGuestName(rs.getString("guest_name"));
        b.setGuestEmail(rs.getString("guest_email"));
        b.setGuestPhone(rs.getString("guest_phone"));
        b.setSpecialRequests(rs.getString("special_requests"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        
        HotelDAO hDAO = new HotelDAO();
        int hotelId = b.getHotelId();
        int roomId  = b.getRoomId();

        if (hotelId >= 100) {
            // Reconstruct mock hotel
            com.voyastra.model.booking.Hotel mockHotel = new com.voyastra.model.booking.Hotel();
            mockHotel.setId(hotelId);
            mockHotel.setName("Premium API Hotel " + hotelId);
            mockHotel.setCity("Dynamic City");
            mockHotel.setImageUrl("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80");
            mockHotel.setRating(4.8);
            b.setHotel(mockHotel);

            // Reconstruct mock room
            String[] roomTypes = {"Standard", "Deluxe", "Suite", "Executive", "Luxury Suite"};
            double[] prices    = {120.0, 180.0, 250.0, 350.0, 500.0};
            int index = (roomId - hotelId * 10);
            if (index < 0 || index >= roomTypes.length) index = 0;
            com.voyastra.model.booking.HotelRoom mockRoom = new com.voyastra.model.booking.HotelRoom();
            mockRoom.setId(roomId);
            mockRoom.setHotelId(hotelId);
            mockRoom.setType(roomTypes[index]);
            mockRoom.setPricePerNight(prices[index]);
            b.setRoom(mockRoom);
        } else {
            b.setHotel(hDAO.getHotelById(hotelId));
            b.setRoom(hDAO.getRoomById(roomId));
        }
        return b;
    }
}