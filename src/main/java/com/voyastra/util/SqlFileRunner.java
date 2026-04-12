package com.voyastra.util;
import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.stream.Collectors;

public class SqlFileRunner {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "Home@123";

    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java SqlFileRunner <sql-file-path>");
            return;
        }
        String filePath = args[0];
        try (BufferedReader br = new BufferedReader(new FileReader(filePath));
             Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {
            
            String content = br.lines().collect(Collectors.joining("\n"));
            // Simple split by semicolon. Warning: will break on semicolons inside strings/quotes.
            // But for simple seed files it's usually fine.
            String[] queries = content.split(";");
            for (String query : queries) {
                if (!query.trim().isEmpty()) {
                    stmt.execute(query);
                }
            }
            System.out.println("SUCCESS: SQL script executed from " + filePath);
        } catch (Exception e) {
            System.err.println("FAILURE: SQL script execution failed.");
            e.printStackTrace();
        }
    }
}
