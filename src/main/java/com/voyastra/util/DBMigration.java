package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;

public class DBMigration {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Applying schema...");

            String sql1 = "CREATE TABLE IF NOT EXISTS booking_draft (" +
                "draft_id VARCHAR(100) PRIMARY KEY, " +
                "user_id INT NOT NULL, " +
                "flight_id VARCHAR(100), " +
                "flight_name VARCHAR(100), " +
                "flight_price DECIMAL(10, 2), " +
                "flight_class VARCHAR(50), " +
                "passengers INT, " +
                "travel_date VARCHAR(50), " +
                "origin VARCHAR(50), " +
                "destination VARCHAR(50), " +
                "contact_email VARCHAR(255), " +
                "contact_phone VARCHAR(50), " +
                "gst_number VARCHAR(50), " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";

            String sql2 = "CREATE TABLE IF NOT EXISTS travellers (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "draft_id VARCHAR(100) NOT NULL, " +
                "title VARCHAR(10), " +
                "first_name VARCHAR(100), " +
                "last_name VARCHAR(100), " +
                "gender VARCHAR(20), " +
                "dob VARCHAR(20), " +
                "nationality VARCHAR(50), " +
                "passport VARCHAR(100), " +
                "seat_number VARCHAR(10), " +
                "FOREIGN KEY (draft_id) REFERENCES booking_draft(draft_id) ON DELETE CASCADE" +
                ")";

            stmt.execute(sql1);
            stmt.execute(sql2);
            
            System.out.println("Migration successful!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
