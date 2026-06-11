package com.voyastra.dao;

import com.voyastra.model.Booking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminTransportDAO {

    public List<Booking> getAllTransportBookings(String type) {
        List<Booking> list = new ArrayList<>();
        String tableName;
        String titleCol;
        String amountCol;
        
        switch (type.toLowerCase()) {
            case "train": tableName = "train_bookings"; titleCol = "train_number"; amountCol = "amount"; break;
            case "bus": tableName = "bus_bookings"; titleCol = "bus_name"; amountCol = "fare"; break;
            case "cab": tableName = "cab_bookings"; titleCol = "vehicle_type"; amountCol = "amount"; break;
            case "car": tableName = "car_bookings"; titleCol = "car_model"; amountCol = "price"; break;
            case "cruise": tableName = "cruise_bookings"; titleCol = "ship_name"; amountCol = "price"; break;
            case "helicopter": tableName = "helicopter_bookings"; titleCol = "flight_type"; amountCol = "price"; break;
            default: return list;
        }

        String query = "SELECT b.id, b.user_id, b." + titleCol + " AS title, b." + amountCol + " AS price, b.status, u.name AS user_name " +
                       "FROM " + tableName + " b JOIN users u ON b.user_id = u.id ORDER BY b.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Booking booking = new Booking();
                // Map the string ID into BookingCode to use it easily in the UI
                booking.setBookingCode(rs.getString("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setPlanTitle(rs.getString("title"));
                booking.setTotalPrice(rs.getDouble("price"));
                booking.setStatus(rs.getString("status"));
                booking.setUserName(rs.getString("user_name"));
                booking.setType(type);
                list.add(booking);
            }
        } catch (SQLException e) {
            System.err.println("ERROR: AdminTransportDAO.getAllTransportBookings failed for " + type);
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateTransportStatus(String type, String id, String status) {
        String tableName = getTableName(type);
        if (tableName == null) return false;

        String query = "UPDATE " + tableName + " SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setString(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTransportBooking(String type, String id) {
        String tableName = getTableName(type);
        if (tableName == null) return false;

        String query = "DELETE FROM " + tableName + " WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTransportBookingCount() {
        int total = 0;
        String[] tables = {"train_bookings", "bus_bookings", "cab_bookings", "car_bookings", "cruise_bookings", "helicopter_bookings"};
        try (Connection conn = DBConnection.getConnection()) {
            for (String table : tables) {
                try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM " + table);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) total += rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public double getTransportRevenue() {
        double total = 0.0;
        String[][] tableCols = {
            {"train_bookings", "amount"}, 
            {"bus_bookings", "fare"}, 
            {"cab_bookings", "amount"}, 
            {"car_bookings", "price"}, 
            {"cruise_bookings", "price"}, 
            {"helicopter_bookings", "price"}
        };
        try (Connection conn = DBConnection.getConnection()) {
            for (String[] tc : tableCols) {
                try (PreparedStatement stmt = conn.prepareStatement("SELECT SUM(" + tc[1] + ") FROM " + tc[0] + " WHERE status = 'CONFIRMED'");
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) total += rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    private String getTableName(String type) {
        switch (type.toLowerCase()) {
            case "train": return "train_bookings";
            case "bus": return "bus_bookings";
            case "cab": return "cab_bookings";
            case "car": return "car_bookings";
            case "cruise": return "cruise_bookings";
            case "helicopter": return "helicopter_bookings";
            default: return null;
        }
    }
}
