package com.voyastra.util;

import java.sql.*;

public class SchemaMigrator {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Migrating 'users' table...");
            
            // Add is_verified if missing
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN is_verified TINYINT(1) DEFAULT 0");
                System.out.println("- Added is_verified");
            } catch (SQLException e) { System.out.println("- is_verified already exists or error: " + e.getMessage()); }
            
            // Add verification_token if missing
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN verification_token VARCHAR(255)");
                System.out.println("- Added verification_token");
            } catch (SQLException e) { System.out.println("- verification_token already exists or error: " + e.getMessage()); }
            
            // Add reset_token if missing
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN reset_token VARCHAR(255)");
                System.out.println("- Added reset_token");
            } catch (SQLException e) { System.out.println("- reset_token already exists or error: " + e.getMessage()); }

            // Add google_id if missing (it seemed to be there, but just in case)
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN google_id VARCHAR(255)");
                System.out.println("- Added google_id");
            } catch (SQLException e) { System.out.println("- google_id already exists or error: " + e.getMessage()); }
            
            System.out.println("Migration complete.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
