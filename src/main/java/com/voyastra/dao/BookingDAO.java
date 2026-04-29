package com.voyastra.dao;

import com.voyastra.model.Booking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /**
     * Inserts a new booking request into the database.
     */
    public boolean addBooking(Booking booking) {
        String query = "INSERT INTO bookings (user_id, plan_id, total_price, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getPlanId());
            stmt.setDouble(3, booking.getTotalPrice());
            stmt.setString(4, booking.getStatus() != null ? booking.getStatus() : "PENDING");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.addBooking failed.");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Inserts a trip booking with expanded traveler details. Returns the generated booking ID or -1.
     */
    public int addTripBooking(Booking b) {
        String query = "INSERT INTO bookings (user_id, plan_id, total_price, status, travel_date, num_adults, num_children, room_type, pickup_city, customer_name, customer_email, customer_phone, special_requests, booking_code) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, b.getUserId());
            stmt.setInt(2, b.getPlanId());
            stmt.setDouble(3, b.getTotalPrice());
            stmt.setString(4, b.getStatus() != null ? b.getStatus() : "PENDING");
            stmt.setString(5, b.getTravelDate());
            stmt.setInt(6, b.getNumAdults());
            stmt.setInt(7, b.getNumChildren());
            stmt.setString(8, b.getRoomType());
            stmt.setString(9, b.getPickupCity());
            stmt.setString(10, b.getCustomerName());
            stmt.setString(11, b.getCustomerEmail());
            stmt.setString(12, b.getCustomerPhone());
            stmt.setString(13, b.getSpecialRequests());
            stmt.setString(14, b.getBookingCode());
            stmt.executeUpdate();
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.addTripBooking failed.");
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Fetches a booking by its unique booking code (e.g., VYS-2026-XXXXX).
     */
    public Booking getBookingByCode(String code) {
        Booking booking = null;
        String query = "SELECT * FROM bookings WHERE booking_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setPlanId(rs.getInt("plan_id"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setBookingCode(rs.getString("booking_code"));
                    booking.setTravelDate(rs.getString("travel_date"));
                    booking.setNumAdults(rs.getInt("num_adults"));
                    booking.setNumChildren(rs.getInt("num_children"));
                    booking.setRoomType(rs.getString("room_type"));
                    booking.setPickupCity(rs.getString("pickup_city"));
                    booking.setCustomerName(rs.getString("customer_name"));
                    booking.setCustomerEmail(rs.getString("customer_email"));
                    booking.setCustomerPhone(rs.getString("customer_phone"));
                    booking.setSpecialRequests(rs.getString("special_requests"));
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.getBookingByCode failed.");
            e.printStackTrace();
        }
        return booking;
    }

    /**
     * Fetches all bookings belonging to a specific user, joining with the plans table to get the plan title.
     */
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, p.title AS plan_title, p.image AS plan_image " +
                       "FROM bookings b " +
                       "JOIN plans p ON b.plan_id = p.id " +
                       "WHERE b.user_id = ? " +
                       "ORDER BY b.created_at DESC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setPlanId(rs.getInt("plan_id"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setPlanTitle(rs.getString("plan_title"));
                    booking.setPlanImage(rs.getString("plan_image"));
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.getBookingsByUser failed.");
            e.printStackTrace();
        }
        return bookings;
    }

    public Booking getBookingById(int id) {
        Booking booking = null;
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, p.title AS plan_title, p.image AS plan_image " +
                       "FROM bookings b JOIN plans p ON b.plan_id = p.id WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setPlanId(rs.getInt("plan_id"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setPlanTitle(rs.getString("plan_title"));
                    booking.setPlanImage(rs.getString("plan_image"));
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.getBookingById failed.");
            e.printStackTrace();
        }
        return booking;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String query = "SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, p.title AS plan_title, p.image AS plan_image, u.name AS user_name " +
                       "FROM bookings b JOIN plans p ON b.plan_id = p.id JOIN users u ON b.user_id = u.id ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setPlanId(rs.getInt("plan_id"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setPlanTitle(rs.getString("plan_title"));
                booking.setPlanImage(rs.getString("plan_image"));
                booking.setUserName(rs.getString("user_name"));
                list.add(booking);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.getAllBookings failed.");
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateBooking(Booking booking) {
        String query = "UPDATE bookings SET user_id = ?, plan_id = ?, total_price = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getPlanId());
            stmt.setDouble(3, booking.getTotalPrice());
            stmt.setString(4, booking.getStatus());
            stmt.setInt(5, booking.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.updateBooking failed.");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBooking(int id) {
        String query = "DELETE FROM bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.deleteBooking failed.");
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalBookingCount() {
        String query = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.getTotalBookingCount failed.");
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue() {
        String query = "SELECT SUM(total_price) FROM bookings WHERE status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: BookingDAO.getTotalRevenue failed.");
            e.printStackTrace();
        }
        return 0.0;
    }
}
