package com.voyastra.util;

import java.sql.*;

public class SchemaCheck {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet rs = meta.getColumns(null, null, "users", null);
            System.out.println("Columns in 'users' table:");
            while (rs.next()) {
                System.out.println("- " + rs.getString("COLUMN_NAME"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
