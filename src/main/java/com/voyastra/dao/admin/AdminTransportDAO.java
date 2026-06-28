package com.voyastra.dao.admin;

import com.voyastra.model.booking.Booking;
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
            case "train": tableName = "train_bookings"; titleCol = "train_number"; amountCol = "total_price"; break;
            case "bus": tableName = "bus_bookings"; titleCol = "operator_name"; amountCol = "total_price"; break;
            case "cab": tableName = "cab_bookings"; titleCol = "vehicle_type"; amountCol = "total_price"; break;
            case "car": tableName = "car_bookings"; titleCol = "car_model"; amountCol = "amount"; break;
            case "cruise": tableName = "cruise_bookings"; titleCol = "ship_name"; amountCol = "total_price"; break;
            case "helicopter": tableName = "helicopter_bookings"; titleCol = "heli_class"; amountCol = "total_price"; break;
            case "hotel": tableName = "hotel_bookings"; titleCol = "guest_name"; amountCol = "total_price"; break;
            case "packages": tableName = "package_bookings"; titleCol = "package_name"; amountCol = "total_price"; break;
            case "flight": tableName = "flight_bookings"; titleCol = "details"; amountCol = "total_price"; break;
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
        String[] tables = {"train_bookings", "bus_bookings", "cab_bookings", "car_bookings", "cruise_bookings", "helicopter_bookings", "hotel_bookings", "package_bookings", "flight_bookings"};
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
            {"train_bookings", "total_price"}, 
            {"bus_bookings", "total_price"}, 
            {"cab_bookings", "total_price"}, 
            {"car_bookings", "amount"}, 
            {"cruise_bookings", "total_price"}, 
            {"helicopter_bookings", "total_price"},
            {"hotel_bookings", "total_price"},
            {"package_bookings", "total_price"},
            {"flight_bookings", "total_price"}
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
            case "hotel": return "hotel_bookings";
            case "packages": return "package_bookings";
            case "flight": return "flight_bookings";
            default: return null;
        }
    }
}
