package com.voyastra.dao;

import com.voyastra.util.DBConnection;
import java.sql.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class DashboardDAO {

    public int getTotalCount(String table) {
        String query = "SELECT COUNT(*) FROM " + table;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getPremiumUsers() {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'premium'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getBookingsByStatus(String status) {
        String query = "SELECT COUNT(*) FROM bookings WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTodaysBookings() {
        String query = "SELECT COUNT(*) FROM bookings WHERE DATE(created_at) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double getThisMonthRevenue() {
        String query = "SELECT SUM(total_price) FROM bookings WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE()) AND status = 'confirmed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    public JsonArray getBookingsPerMonth() {
        JsonArray array = new JsonArray();
        String query = "SELECT MONTH(created_at) as m, COUNT(*) as c FROM bookings WHERE YEAR(created_at) = YEAR(CURDATE()) GROUP BY MONTH(created_at) ORDER BY MONTH(created_at)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             int[] counts = new int[12];
            while (rs.next()) {
                counts[rs.getInt("m") - 1] = rs.getInt("c");
            }
            for(int i=0; i<12; i++) array.add(counts[i]);
        } catch (Exception e) { e.printStackTrace(); }
        return array;
    }

    public JsonArray getRevenuePerMonth() {
        JsonArray array = new JsonArray();
        String query = "SELECT MONTH(created_at) as m, SUM(total_price) as s FROM bookings WHERE YEAR(created_at) = YEAR(CURDATE()) AND status = 'confirmed' GROUP BY MONTH(created_at) ORDER BY MONTH(created_at)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             double[] sums = new double[12];
            while (rs.next()) {
                sums[rs.getInt("m") - 1] = rs.getDouble("s");
            }
            for(int i=0; i<12; i++) array.add(sums[i]);
        } catch (Exception e) { e.printStackTrace(); }
        return array;
    }

    public JsonArray getTopPlans(int limit) {
        JsonArray array = new JsonArray();
        String query = "SELECT p.title, COUNT(b.id) as b_count, SUM(b.total_price) as rev FROM plans p JOIN bookings b ON p.id = b.plan_id WHERE b.status = 'confirmed' GROUP BY p.title ORDER BY b_count DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    JsonObject obj = new JsonObject();
                    obj.addProperty("name", rs.getString("title"));
                    obj.addProperty("bookings", rs.getInt("b_count"));
                    obj.addProperty("revenue", rs.getDouble("rev"));
                    obj.addProperty("growth", "+5%"); // mock growth for UI consistency
                    array.add(obj);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return array;
    }

    public JsonArray getDestinationPieChart() {
        JsonArray labels = new JsonArray();
        JsonArray data = new JsonArray();
        String query = "SELECT d.location, COUNT(b.id) as c FROM destinations d JOIN plans p ON d.id = p.destination_id JOIN bookings b ON p.id = b.plan_id GROUP BY d.location ORDER BY c DESC LIMIT 5";
        JsonObject result = new JsonObject();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                labels.add(rs.getString("location"));
                data.add(rs.getInt("c"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        result.add("labels", labels);
        result.add("data", data);
        JsonArray resArray = new JsonArray();
        resArray.add(result);
        return resArray;
    }
}
