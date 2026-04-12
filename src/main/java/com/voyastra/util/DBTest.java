package com.voyastra.util;
import java.sql.Connection;
import java.sql.SQLException;

public class DBTest {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                System.out.println("SUCCESS: HikariCP connection established!");
            }
        } catch (SQLException e) {
            System.err.println("FAILURE: DB Connection test failed: " + e.getMessage());
        } finally {
            DBConnection.shutdown();
        }
    }
}
