package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class MigrateUpgrade {
    public static void main(String[] args) {
        System.out.println("Starting Database Migration for Production Upgrade...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // 1. Alter Users Table (Ignore if exists)
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN wallet_balance DECIMAL(10,2) DEFAULT 0.00");
                System.out.println("Added wallet_balance to users.");
            } catch (SQLException e) { System.out.println("wallet_balance may already exist."); }

            try {
                stmt.execute("ALTER TABLE users ADD COLUMN loyalty_points INT DEFAULT 0");
                System.out.println("Added loyalty_points to users.");
            } catch (SQLException e) { System.out.println("loyalty_points may already exist."); }

            // 2. Create Coupons Table
            String createCoupons = "CREATE TABLE IF NOT EXISTS coupons (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "code VARCHAR(50) UNIQUE, " +
                    "discount_percent DECIMAL(5,2), " +
                    "max_discount DECIMAL(10,2), " +
                    "valid_until DATETIME" +
                    ")";
            stmt.execute(createCoupons);
            System.out.println("Created coupons table.");

            // Insert a dummy coupon for testing
            try {
                stmt.execute("INSERT IGNORE INTO coupons (code, discount_percent, max_discount, valid_until) VALUES ('WELCOME20', 20.00, 1500.00, '2027-12-31 23:59:59')");
                System.out.println("Inserted WELCOME20 coupon.");
            } catch (SQLException e) {}

            // 3. Create Refunds Table
            String createRefunds = "CREATE TABLE IF NOT EXISTS refunds (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "booking_id INT, " +
                    "amount DECIMAL(10,2), " +
                    "status VARCHAR(50), " +
                    "refund_method VARCHAR(50), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (booking_id) REFERENCES bookings(id)" +
                    ")";
            stmt.execute(createRefunds);
            System.out.println("Created refunds table.");

            // 4. Create Boarding Passes (Uploads) Table
            String createPasses = "CREATE TABLE IF NOT EXISTS boarding_passes (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "booking_id INT, " +
                    "file_path VARCHAR(255), " +
                    "uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (booking_id) REFERENCES bookings(id)" +
                    ")";
            stmt.execute(createPasses);
            System.out.println("Created boarding_passes table.");

            System.out.println("Migration Completed Successfully!");
        } catch (Exception e) {
            System.err.println("Migration Failed:");
            e.printStackTrace();
        }
    }
}
