package com.voyastra.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckPlansSchema {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Checking 'plans' table...");
            try (ResultSet rs = stmt.executeQuery("DESCRIBE plans;")) {
                while (rs.next()) {
                    System.out.println(rs.getString("Field") + " | " + rs.getString("Type"));
                }
            } catch (Exception e) {
                System.out.println("Table 'plans' does not exist.");
            }
            
            System.out.println("\nChecking 'trip_plans' table...");
            try (ResultSet rs = stmt.executeQuery("DESCRIBE trip_plans;")) {
                while (rs.next()) {
                    System.out.println(rs.getString("Field") + " | " + rs.getString("Type"));
                }
            } catch (Exception e) {
                System.out.println("Table 'trip_plans' does not exist.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
