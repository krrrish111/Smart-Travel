package com.voyastra.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBTableCheck {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                // Check count
                String countQuery = "SELECT COUNT(*) FROM plans";
                try (PreparedStatement stmt = conn.prepareStatement(countQuery);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        System.out.println("PLAN_COUNT: " + count);
                        
                        if (count == 0) {
                            System.out.println("No plans found. Inserting sample data...");
                            String insertQuery = "INSERT INTO plans (title, price, days, nights, category, description, image) VALUES " +
                                "('Spiti Valley Adventure', 18000, 7, 6, 'Adventure', 'Experience the rugged beauty of the cold desert mountain valley.', 'https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=600&q=80'), " +
                                "('Mawlynnong Village', 12000, 4, 3, 'Cultural', 'Asias cleanest village, offering a pristine natural environment.', 'https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=600&q=80')";
                            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                                insertStmt.executeUpdate();
                                System.out.println("Sample data inserted successfully.");
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
