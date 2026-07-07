package com.voyastra.dao;

import com.voyastra.util.DBConnection;
import java.sql.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class DashboardDAO {

    public JsonObject getDashboardMetrics() {
        JsonObject metrics = new JsonObject();
        String query = "SELECT " +
            "(SELECT COUNT(*) FROM users) as users_count, " +
            "(SELECT COUNT(*) FROM bookings) as bookings_count, " +
            "(SELECT COUNT(*) FROM plans) as plans_count, " +
            "(SELECT COUNT(*) FROM destinations) as destinations_count, " +
            "(SELECT COUNT(*) FROM reviews) as reviews_count, " +
            "(SELECT COUNT(*) FROM activities) as activities_count, " +
            "(SELECT COUNT(*) FROM bookings WHERE status = 'pending') as pending_bookings, " +
            "(SELECT COUNT(*) FROM bookings WHERE status = 'confirmed') as confirmed_bookings, " +
            "(SELECT COUNT(*) FROM bookings WHERE status = 'cancelled') as cancelled_bookings, " +
            "(SELECT COUNT(*) FROM bookings WHERE DATE(created_at) = CURDATE()) as todays_bookings, " +
            "(SELECT COUNT(*) FROM users WHERE role = 'premium') as premium_users, " +
            "(SELECT COALESCE(SUM(total_price), 0.0) FROM bookings WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE()) AND status = 'confirmed') as this_month_rev";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                metrics.addProperty("users", rs.getInt("users_count"));
                metrics.addProperty("bookings", rs.getInt("bookings_count"));
                metrics.addProperty("plans", rs.getInt("plans_count"));
                metrics.addProperty("destinations", rs.getInt("destinations_count"));
                metrics.addProperty("reviews", rs.getInt("reviews_count"));
                metrics.addProperty("activities", rs.getInt("activities_count"));
                metrics.addProperty("pendingBookings", rs.getInt("pending_bookings"));
                metrics.addProperty("completedBookings", rs.getInt("confirmed_bookings"));
                metrics.addProperty("cancelledBookings", rs.getInt("cancelled_bookings"));
                metrics.addProperty("todaysBookings", rs.getInt("todays_bookings"));
                metrics.addProperty("premiumUsers", rs.getInt("premium_users"));
                double rev = rs.getDouble("this_month_rev");
                metrics.addProperty("revenue", rev);
                metrics.addProperty("totalRevenue", rev);
                metrics.addProperty("thisMonthRevenue", rev);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return metrics;
    }

    public void getMonthlyStats(JsonObject target) {
        JsonArray bookingsArray = new JsonArray();
        JsonArray revenueArray = new JsonArray();
        String query = "SELECT " +
            "MONTH(created_at) as m, " +
            "COUNT(*) as c, " +
            "SUM(CASE WHEN status = 'confirmed' THEN total_price ELSE 0.0 END) as s " +
            "FROM bookings " +
            "WHERE YEAR(created_at) = YEAR(CURDATE()) " +
            "GROUP BY MONTH(created_at) " +
            "ORDER BY MONTH(created_at)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            int[] counts = new int[12];
            double[] sums = new double[12];
            while (rs.next()) {
                int monthIdx = rs.getInt("m") - 1;
                if (monthIdx >= 0 && monthIdx < 12) {
                    counts[monthIdx] = rs.getInt("c");
                    sums[monthIdx] = rs.getDouble("s");
                }
            }
            for (int i = 0; i < 12; i++) {
                bookingsArray.add(counts[i]);
                revenueArray.add(sums[i]);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        target.add("bookingsPerMonth", bookingsArray);
        target.add("revenuePerMonth", revenueArray);
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
