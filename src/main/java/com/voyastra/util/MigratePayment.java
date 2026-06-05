package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;

public class MigratePayment {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Applying schema update for payments...");
            try { stmt.execute("ALTER TABLE bookings ADD COLUMN payment_id VARCHAR(100)"); } catch (Exception e) {}
            try { stmt.execute("ALTER TABLE bookings ADD COLUMN transaction_id VARCHAR(100)"); } catch (Exception e) {}
            try { stmt.execute("ALTER TABLE bookings ADD COLUMN payment_status VARCHAR(50)"); } catch (Exception e) {}
            
            System.out.println("Migration successful!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
