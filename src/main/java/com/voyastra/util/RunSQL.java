package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;

public class RunSQL {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            String sqlFile = "c:\\Users\\Dell\\Desktop\\antigravity\\sql\\super_app_tables.sql";
            String content = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(sqlFile)));
            String[] queries = content.split(";");
            
            for (String query : queries) {
                if (!query.trim().isEmpty()) {
                    stmt.execute(query.trim());
                    System.out.println("Executed: " + query.trim().substring(0, Math.min(30, query.trim().length())) + "...");
                }
            }
            
            System.out.println("Super-App tables created successfully.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
