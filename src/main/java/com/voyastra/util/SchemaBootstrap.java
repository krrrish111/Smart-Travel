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

            System.out.println("[SchemaBootstrap] Schema migration complete.");

        } catch (Exception e) {
            System.err.println("[SchemaBootstrap] Migration error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) { /* nothing */ }
}
