package com.voyastra.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class CheckDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            String[] tables = {"destinations", "trip_plans", "trip_itinerary", "trip_inclusions", "trip_gallery", "hotels", "activities"};
            
            System.out.println("=== FINAL SEED AND SCHEMA VERIFICATION ===");
            for (String table : tables) {
                try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM `" + table + "`")) {
                    if (rs.next()) {
                        System.out.println("Table: " + table + " | Row Count: " + rs.getInt(1));
                    }
                } catch (Exception e) {
                    System.out.println("Table: " + table + " | Error: " + e.getMessage());
                }
            }
            
            System.out.println("\n=== SAMPLE DATA FROM destinations ===");
            try (ResultSet rs = stmt.executeQuery("SELECT id, title, category, price_inr, duration_days FROM destinations LIMIT 3")) {
                while (rs.next()) {
                    System.out.println("Destination: ID=" + rs.getInt("id") + ", Title=" + rs.getString("title") + 
                                       ", Category=" + rs.getString("category") + ", Price=" + rs.getDouble("price_inr") +
                                       ", Days=" + rs.getInt("duration_days"));
                }
            }
            
            System.out.println("\n=== SAMPLE DATA FROM trip_plans ===");
            try (ResultSet rs = stmt.executeQuery("SELECT id, title, destination, category, price_inr FROM trip_plans LIMIT 3")) {
                while (rs.next()) {
                    System.out.println("TripPlan: ID=" + rs.getInt("id") + ", Title=" + rs.getString("title") + 
                                       ", Destination=" + rs.getString("destination") + ", Category=" + rs.getString("category") + 
                                       ", Price=" + rs.getDouble("price_inr"));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
