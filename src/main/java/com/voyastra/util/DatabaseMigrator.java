package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class DatabaseMigrator {
    public static void main(String[] args) {
        System.out.println("Starting Profile Dashboard Migrations...");
        
        String[] migrations = {
            "ALTER TABLE users ADD COLUMN phone VARCHAR(20) DEFAULT NULL",
            "ALTER TABLE users ADD COLUMN profile_image VARCHAR(255) DEFAULT NULL",
            "ALTER TABLE users ADD COLUMN location VARCHAR(100) DEFAULT NULL",
            "ALTER TABLE users ADD COLUMN bio TEXT DEFAULT NULL"
        };
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            for (String sql : migrations) {
                try {
                    stmt.executeUpdate(sql);
                    System.out.println("Executed: " + sql);
                } catch (SQLException e) {
                    if (e.getMessage().contains("Duplicate column")) {
                        System.out.println("Column already exists, skipping...");
                    } else {
                        System.err.println("Error executing " + sql + ": " + e.getMessage());
                    }
                }
            }
            
            System.out.println("Migration complete!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
