package com.voyastra.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;

/**
 * Runs automatic DB schema migrations on application startup.
 * All migrations are idempotent (safe to run multiple times).
 */
@WebListener
public class SchemaBootstrap implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // ── 1. Add booking_type to refunds (differentiates FLIGHT vs HOTEL) ──
            try {
                stmt.execute(
                    "ALTER TABLE refunds ADD COLUMN booking_type VARCHAR(20) DEFAULT 'FLIGHT' AFTER booking_id"
                );
                System.out.println("[SchemaBootstrap] Added column booking_type to refunds.");
            } catch (Exception e) {
                // Column already exists — safe to ignore
            }

            // ── 2. Add PROCESSING status support is just a data value — no schema change needed ──

            // ── 3. Drop foreign keys on hotel_bookings to allow dynamic API hotels ──
            try {
                stmt.execute("ALTER TABLE hotel_bookings DROP FOREIGN KEY hotel_bookings_ibfk_2");
                System.out.println("[SchemaBootstrap] Dropped FK hotel_bookings_ibfk_2.");
            } catch (Exception e) {}
            try {
                stmt.execute("ALTER TABLE hotel_bookings DROP FOREIGN KEY hotel_bookings_ibfk_3");
                System.out.println("[SchemaBootstrap] Dropped FK hotel_bookings_ibfk_3.");
            } catch (Exception e) {}

            // ── 4. Create payments table if it doesn't exist ──
            try {
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS payments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "booking_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "amount DECIMAL(10,2) NOT NULL, " +
                    "method VARCHAR(50) NOT NULL, " +
                    "status VARCHAR(50) NOT NULL, " +
                    "transaction_id VARCHAR(100) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );
                System.out.println("[SchemaBootstrap] Created table payments if it did not exist.");
            } catch (Exception e) {
                System.err.println("[SchemaBootstrap] Error creating payments table: " + e.getMessage());
            }

            System.out.println("[SchemaBootstrap] Schema migration complete.");

        } catch (Exception e) {
            System.err.println("[SchemaBootstrap] Migration error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) { /* nothing */ }
}
