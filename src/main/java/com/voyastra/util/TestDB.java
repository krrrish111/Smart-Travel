package com.voyastra.util;
import java.sql.*;
public class TestDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("ALTER TABLE bookings MODIFY plan_id INT NULL");
            System.out.println("Modified plan_id successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
