package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class RunSQL {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            String sqlFile = "c:\\Users\\Dell\\Desktop\\antigravity\\src\\main\\resources\\seed_home_data.sql";
            String content = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(sqlFile)), java.nio.charset.StandardCharsets.UTF_8);
            
            // Split queries by semicolon followed by a newline (with optional whitespace) to avoid splitting on semicolons inside string literals.
            String[] queries = content.split(";\\s*\\r?\\n");
            
            for (String query : queries) {
                if (!query.trim().isEmpty()) {
                    try {
                        boolean isResultSet = stmt.execute(query.trim());
                        int affected = stmt.getUpdateCount();
                        System.out.println("Executed: " + query.trim().substring(0, Math.min(50, query.trim().length())) + "... | Affected: " + affected);
                    } catch (SQLException sqle) {
                        System.err.println("FAILED query: " + query.trim().substring(0, Math.min(100, query.trim().length())) + "...");
                        System.err.println("Reason: " + sqle.getMessage());
                    }
                }
            }
            
            System.out.println("home page seed data populated successfully.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
