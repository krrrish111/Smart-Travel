package com.voyastra.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;

public class RunUpdate {
    public static void main(String[] args) {
        System.out.println("Starting Database Initialization and Update...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
             
            runScript(stmt, "database/schema/hotels_workflow.sql");
            runScript(stmt, "database/schema/database_update_hotels.sql");
            
            System.out.println("Database Update Complete!");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.shutdown();
        }
    }
    
    private static void runScript(Statement stmt, String fileName) throws Exception {
        System.out.println("Running script: " + fileName);
        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                    continue;
                }
                sb.append(line);
                if (line.trim().endsWith(";")) {
                    String sql = sb.toString();
                    try {
                        stmt.executeUpdate(sql);
                    } catch (Exception ex) {
                        System.out.println("Error executing statement: " + ex.getMessage());
                    }
                    sb.setLength(0);
                }
            }
        }
    }
}
