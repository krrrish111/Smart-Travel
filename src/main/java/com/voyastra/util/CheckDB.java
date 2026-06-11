package com.voyastra.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class CheckDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery("SELECT * FROM bookings LIMIT 1");
            ResultSetMetaData metaData = rs.getMetaData();
            for(int i = 1; i <= metaData.getColumnCount(); i++) {
                System.out.println(metaData.getColumnName(i));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
