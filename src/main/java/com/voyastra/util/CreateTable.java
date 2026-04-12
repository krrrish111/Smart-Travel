package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;

public class CreateTable {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            String sql = "CREATE TABLE IF NOT EXISTS uploaded_images (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "file_path VARCHAR(255) NOT NULL, " +
                         "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                         ")";
            stmt.executeUpdate(sql);
            System.out.println("Script executed successfully: uploaded_images table created.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
