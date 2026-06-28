package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;

public class DBInitSettings {
    public static void main(String[] args) {
        System.out.println("Initializing system_settings table...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            String createTable = "CREATE TABLE IF NOT EXISTS system_settings (" +
                    "setting_key VARCHAR(100) PRIMARY KEY," +
                    "setting_value VARCHAR(255) NOT NULL," +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                    ")";
            stmt.executeUpdate(createTable);
            System.out.println("system_settings table created or already exists.");

            String insertInitial = "INSERT IGNORE INTO system_settings (setting_key, setting_value) VALUES " +
                    "('theme', 'light')," +
                    "('currency', 'USD')," +
                    "('language', 'en')";
            stmt.executeUpdate(insertInitial);
            System.out.println("Initial settings populated.");

            System.out.println("Success.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
