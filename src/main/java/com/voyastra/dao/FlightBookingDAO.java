package com.voyastra.dao;

import com.voyastra.model.FlightBooking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FlightBookingDAO {

    private static final String TABLE = "flight_tickets";

    /**
     * Creates flight_tickets table if needed and inserts a new row with full flight data.
     */
    public void saveFlightBooking(
            int userId, String bookingCode, String pnr,
            String flightNumber, String airline,
            String origin, String destination,
            String departureDate, String departureTime,
            String arrivalTime, String duration, String stops,
            String seatClass, String seatNumbers,
            double totalPrice, String customerName, String customerEmail,
            String paymentId, String paymentStatus) {

        ensureTableExists();

        String sql = "INSERT INTO " + TABLE + " " +
            "(user_id, booking_code, pnr, flight_number, airline, origin, destination, " +
            "departure_date, departure_time, arrival_time, duration, stops, seat_class, " +
            "seat_numbers, total_price, customer_name, customer_email, payment_id, payment_status, status) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'CONFIRMED')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, bookingCode);
            stmt.setString(3, pnr);
            stmt.setString(4, flightNumber);
            stmt.setString(5, airline);
            stmt.setString(6, origin);
            stmt.setString(7, destination);
            stmt.setString(8, departureDate);
            stmt.setString(9, departureTime);
            stmt.setString(10, arrivalTime);
            stmt.setString(11, duration);
            stmt.setString(12, stops);
            stmt.setString(13, seatClass);
            stmt.setString(14, seatNumbers);
            stmt.setDouble(15, totalPrice);
            stmt.setString(16, customerName);
            stmt.setString(17, customerEmail);
            stmt.setString(18, paymentId);
            stmt.setString(19, paymentStatus);
            stmt.executeUpdate();
            System.out.println("[FlightBookingDAO] Saved to flight_tickets: " + bookingCode);
        } catch (SQLException e) {
            System.err.println("[FlightBookingDAO] saveFlightBooking FAILED: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Retrieve a FlightBooking by booking_code from the new flight_tickets table.
     */
    public FlightBooking getByBookingCode(String bookingCode) {
        String sql = "SELECT * FROM " + TABLE + " WHERE booking_code = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bookingCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FlightBookingDAO] getByBookingCode failed (flight_tickets): " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieve all tickets for a user from the new flight_tickets table.
     */
    public List<FlightBooking> getTicketsByUserId(int userId) {
        List<FlightBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM " + TABLE + " WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[FlightBookingDAO] getTicketsByUserId failed: " + e.getMessage());
        }
        return list;
    }

    /**
     * Legacy method: fetch bookings from the old flight_bookings table (for Profile page).
     * Parses flight info from the details string.
     */
    public List<FlightBooking> getBookingsByUserId(int userId) {
        List<FlightBooking> list = new ArrayList<>();
        // First try the new flight_tickets table
        list.addAll(getTicketsByUserId(userId));
        if (!list.isEmpty()) return list;

        // Fallback: old flight_bookings table
        String query = "SELECT id, user_id, total_price, status, created_at, details, booking_code, travel_date " +
                       "FROM flight_bookings WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FlightBooking fb = new FlightBooking();
                    fb.setId(rs.getInt("id"));
                    fb.setUserId(rs.getInt("user_id"));
                    fb.setTotalPrice(rs.getDouble("total_price"));
                    fb.setStatus(rs.getString("status"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    fb.setDetails(rs.getString("details"));
                    fb.setBookingCode(rs.getString("booking_code"));
                    fb.setTravelDate(rs.getString("travel_date"));
                    fb.parseDetails();
                    list.add(fb);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FlightBookingDAO] getBookingsByUserId (legacy) failed: " + e.getMessage());
        }
        return list;
    }

    /**
     * Fallback: load from old bookings table, parse details string.
     */
    public FlightBooking getFromBookingsTableByCode(String bookingCode) {
        String sql = "SELECT * FROM bookings WHERE booking_code = ? AND type = 'flight' LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bookingCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FlightBooking fb = new FlightBooking();
                    fb.setId(rs.getInt("id"));
                    fb.setUserId(rs.getInt("user_id"));
                    fb.setTotalPrice(rs.getDouble("total_price"));
                    fb.setStatus(rs.getString("status"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    fb.setDetails(rs.getString("details"));
                    fb.setBookingCode(rs.getString("booking_code"));
                    try { fb.setCustomerName(rs.getString("customer_name")); } catch (Exception e) {}
                    try { fb.setCustomerEmail(rs.getString("customer_email")); } catch (Exception e) {}
                    try { fb.setCustomerPhone(rs.getString("customer_phone")); } catch (Exception e) {}
                    try { fb.setPaymentId(rs.getString("payment_id")); } catch (Exception e) {}
                    try { fb.setPaymentStatus(rs.getString("payment_status")); } catch (Exception e) {}
                    fb.parseDetails();
                    return fb;
                }
            }
        } catch (SQLException e) {
            System.err.println("[FlightBookingDAO] getFromBookingsTableByCode failed: " + e.getMessage());
        }
        return null;
    }

    private FlightBooking mapRow(ResultSet rs) throws SQLException {
        FlightBooking fb = new FlightBooking();
        try { fb.setId(rs.getInt("id")); } catch (Exception e) {}
        try { fb.setUserId(rs.getInt("user_id")); } catch (Exception e) {}
        try { fb.setBookingCode(rs.getString("booking_code")); } catch (Exception e) {}
        try { fb.setPnr(rs.getString("pnr")); } catch (Exception e) {}
        try { fb.setFlightNumber(rs.getString("flight_number")); } catch (Exception e) {}
        try { fb.setAirlineName(rs.getString("airline")); } catch (Exception e) {}
        try { fb.setDepartureCity(rs.getString("origin")); } catch (Exception e) {}
        try { fb.setArrivalCity(rs.getString("destination")); } catch (Exception e) {}
        try { fb.setTravelDate(rs.getString("departure_date")); } catch (Exception e) {}
        try { fb.setDepartureTime(rs.getString("departure_time")); } catch (Exception e) {}
        try { fb.setArrivalTime(rs.getString("arrival_time")); } catch (Exception e) {}
        try { fb.setDuration(rs.getString("duration")); } catch (Exception e) {}
        try { fb.setStops(rs.getString("stops")); } catch (Exception e) {}
        try { fb.setSeatClass(rs.getString("seat_class")); } catch (Exception e) {}
        try { fb.setSeatNumbers(rs.getString("seat_numbers")); } catch (Exception e) {}
        try { fb.setTotalPrice(rs.getDouble("total_price")); } catch (Exception e) {}
        try { fb.setCustomerName(rs.getString("customer_name")); } catch (Exception e) {}
        try { fb.setCustomerEmail(rs.getString("customer_email")); } catch (Exception e) {}
        try { fb.setPaymentId(rs.getString("payment_id")); } catch (Exception e) {}
        try { fb.setPaymentStatus(rs.getString("payment_status")); } catch (Exception e) {}
        try { fb.setStatus(rs.getString("status")); } catch (Exception e) {}
        try { fb.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception e) {}
        return fb;
    }

    private void ensureTableExists() {
        String ddl = "CREATE TABLE IF NOT EXISTS " + TABLE + " (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "user_id INT NOT NULL, " +
            "booking_code VARCHAR(50) UNIQUE, " +
            "pnr VARCHAR(30), " +
            "flight_number VARCHAR(30), " +
            "airline VARCHAR(100), " +
            "origin VARCHAR(100), " +
            "destination VARCHAR(100), " +
            "departure_date VARCHAR(30), " +
            "departure_time VARCHAR(20), " +
            "arrival_time VARCHAR(20), " +
            "duration VARCHAR(30), " +
            "stops VARCHAR(10) DEFAULT '0', " +
            "seat_class VARCHAR(50), " +
            "seat_numbers VARCHAR(200), " +
            "total_price DOUBLE DEFAULT 0, " +
            "customer_name VARCHAR(200), " +
            "customer_email VARCHAR(200), " +
            "payment_id VARCHAR(100), " +
            "payment_status VARCHAR(30), " +
            "status VARCHAR(30) DEFAULT 'CONFIRMED', " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(ddl)) {
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[FlightBookingDAO] ensureTableExists failed: " + e.getMessage());
        }
    }
}
