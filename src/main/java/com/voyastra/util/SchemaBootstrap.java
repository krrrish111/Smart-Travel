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

            // ── 5. AI Planner 2.0 Tables ──
            try {
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_groups (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "creator_id INT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );
                
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS planner_requests (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "origin VARCHAR(100) NOT NULL, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "departure_date DATE NOT NULL, " +
                    "return_date DATE NOT NULL, " +
                    "budget DECIMAL(10,2) NOT NULL, " +
                    "travel_style VARCHAR(50), " +
                    "adults INT DEFAULT 1, " +
                    "children INT DEFAULT 0, " +
                    "seniors INT DEFAULT 0, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS planner_sessions (" +
                    "session_id VARCHAR(100) PRIMARY KEY, " +
                    "user_id INT, " +
                    "last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS planner_map_sessions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "session_id VARCHAR(100), " +
                    "origin VARCHAR(100), " +
                    "destination VARCHAR(100), " +
                    "active_layers VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS planner_locations (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) UNIQUE, " +
                    "lat DECIMAL(10,8), " +
                    "lng DECIMAL(11,8), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS planner_selected_places (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "session_id VARCHAR(100), " +
                    "place_name VARCHAR(255), " +
                    "category VARCHAR(50), " +
                    "lat DECIMAL(10,8), " +
                    "lng DECIMAL(11,8), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );
                
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_group_members (" +
                    "group_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "role VARCHAR(20) DEFAULT 'MEMBER', " +
                    "PRIMARY KEY(group_id, user_id))"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_itineraries (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT, " +
                    "user_id INT NOT NULL, " +
                    "title VARCHAR(100), " +
                    "destination VARCHAR(100), " +
                    "start_date DATE, " +
                    "end_date DATE, " +
                    "json_data JSON, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_expenses (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT NOT NULL, " +
                    "payer_id INT NOT NULL, " +
                    "amount DECIMAL(10,2) NOT NULL, " +
                    "description VARCHAR(255), " +
                    "split_type VARCHAR(20) DEFAULT 'EQUAL', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_expense_splits (" +
                    "expense_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "owed_amount DECIMAL(10,2) NOT NULL, " +
                    "PRIMARY KEY(expense_id, user_id))"
                );
                System.out.println("[SchemaBootstrap] Created AI Planner 2.0 tables.");
            } catch (Exception e) {
                System.err.println("[SchemaBootstrap] Error creating AI Planner tables: " + e.getMessage());
            }

            System.out.println("[SchemaBootstrap] Schema migration complete.");

        } catch (Exception e) {
            System.err.println("[SchemaBootstrap] Migration error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) { /* nothing */ }
}
