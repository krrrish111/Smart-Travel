package com.voyastra.util;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class MigratePaymentUnified {
    public static void main(String[] args) {
        System.out.println("Starting Database Migration for Unified Payment Flow...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // 1. Modify existing columns to support NULL (for backward compatibility)
            try {
                stmt.execute("ALTER TABLE payments MODIFY COLUMN booking_id INT NULL");
                System.out.println("Modified booking_id to be nullable.");
            } catch (SQLException e) {
                System.out.println("Error modifying booking_id: " + e.getMessage());
            }

            try {
                stmt.execute("ALTER TABLE payments MODIFY COLUMN method VARCHAR(50) NULL");
                System.out.println("Modified method to be nullable.");
            } catch (SQLException e) {
                System.out.println("Error modifying method: " + e.getMessage());
            }

            // 2. Add new columns
            try {
                stmt.execute("ALTER TABLE payments ADD COLUMN service_type VARCHAR(50) NULL");
                System.out.println("Added service_type to payments.");
            } catch (SQLException e) {
                System.out.println("service_type may already exist: " + e.getMessage());
            }

            try {
                stmt.execute("ALTER TABLE payments ADD COLUMN booking_reference VARCHAR(100) NULL");
                System.out.println("Added booking_reference to payments.");
            } catch (SQLException e) {
                System.out.println("booking_reference may already exist: " + e.getMessage());
            }

            try {
                stmt.execute("ALTER TABLE payments ADD COLUMN razorpay_order_id VARCHAR(100) NULL");
                System.out.println("Added razorpay_order_id to payments.");
            } catch (SQLException e) {
                System.out.println("razorpay_order_id may already exist: " + e.getMessage());
            }

            try {
                stmt.execute("ALTER TABLE payments ADD COLUMN razorpay_payment_id VARCHAR(100) NULL");
                System.out.println("Added razorpay_payment_id to payments.");
            } catch (SQLException e) {
                System.out.println("razorpay_payment_id may already exist: " + e.getMessage());
            }

            try {
                stmt.execute("ALTER TABLE payments ADD COLUMN currency VARCHAR(10) DEFAULT 'INR'");
                System.out.println("Added currency to payments.");
            } catch (SQLException e) {
                System.out.println("currency may already exist: " + e.getMessage());
            }

            System.out.println("Migration Completed Successfully!");
        } catch (Exception e) {
            System.err.println("Migration Failed:");
            e.printStackTrace();
        }
    }
}
