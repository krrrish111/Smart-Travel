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
                    "CREATE TABLE IF NOT EXISTS hidden_gems (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(255), " +
                    "destination VARCHAR(100), " +
                    "description TEXT, " +
                    "lat DECIMAL(10,8), " +
                    "lng DECIMAL(11,8), " +
                    "image_url VARCHAR(255), " +
                    "category VARCHAR(100), " +
                    "beauty_score DECIMAL(3,1), " +
                    "peace_score DECIMAL(3,1), " +
                    "photo_score DECIMAL(3,1), " +
                    "crowd_score DECIMAL(3,1), " +
                    "authenticity_score DECIMAL(3,1), " +
                    "safety_score DECIMAL(3,1), " +
                    "overall_score DECIMAL(3,1), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS user_saved_gems (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "gem_id INT, " +
                    "saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS user_gamification (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "badge_name VARCHAR(100), " +
                    "awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS user_collections (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "name VARCHAR(100), " +
                    "description TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS collection_items (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "collection_id INT, " +
                    "item_type VARCHAR(50), " + // e.g., 'photo', 'video', 'place'
                    "item_url VARCHAR(255), " +
                    "item_name VARCHAR(255), " +
                    "added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (collection_id) REFERENCES user_collections(id) ON DELETE CASCADE)"
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

                // Phase 9 Tables
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_settlements (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT NOT NULL, " +
                    "from_user_id INT NOT NULL, " +
                    "to_user_id INT NOT NULL, " +
                    "amount DECIMAL(10,2) NOT NULL, " +
                    "status VARCHAR(20) DEFAULT 'PENDING', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_votes (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT NOT NULL, " +
                    "creator_id INT NOT NULL, " +
                    "question VARCHAR(255) NOT NULL, " +
                    "category VARCHAR(50), " +
                    "status VARCHAR(20) DEFAULT 'OPEN', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_vote_options (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "vote_id INT NOT NULL, " +
                    "option_text VARCHAR(255) NOT NULL, " +
                    "voter_ids JSON)" // Store user IDs who voted for this option
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_messages (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "message TEXT NOT NULL, " +
                    "type VARCHAR(20) DEFAULT 'TEXT', " + // TEXT, IMAGE, LOCATION
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_checklists (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT NOT NULL, " +
                    "creator_id INT NOT NULL, " +
                    "title VARCHAR(100) NOT NULL, " +
                    "items JSON, " + // Store items and completion status
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_documents (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "group_id INT NOT NULL, " +
                    "uploader_id INT NOT NULL, " +
                    "doc_name VARCHAR(100) NOT NULL, " +
                    "doc_url VARCHAR(255) NOT NULL, " +
                    "category VARCHAR(50), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );
                
                // Phase 10 Tables
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS budget_plans (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "total_budget DECIMAL(10,2) NOT NULL, " +
                    "flights DECIMAL(10,2), " +
                    "hotel DECIMAL(10,2), " +
                    "food DECIMAL(10,2), " +
                    "activities DECIMAL(10,2), " +
                    "transportation DECIMAL(10,2), " +
                    "emergency DECIMAL(10,2), " +
                    "health_score INT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_cost_predictions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "budget_plan_id INT NOT NULL, " +
                    "best_case DECIMAL(10,2), " +
                    "expected DECIMAL(10,2), " +
                    "worst_case DECIMAL(10,2), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS expense_logs (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "budget_plan_id INT NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "amount DECIMAL(10,2) NOT NULL, " +
                    "description VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS deal_alerts (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "message TEXT NOT NULL, " +
                    "is_read BOOLEAN DEFAULT FALSE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS budget_notifications (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "type VARCHAR(50), " + // e.g. OVERSPEND, DEAL, ALERT
                    "message TEXT NOT NULL, " +
                    "is_read BOOLEAN DEFAULT FALSE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                // Phase 11 Tables
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS weather_cache (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "temp DECIMAL(5,2), " +
                    "humidity INT, " +
                    "rain_prob INT, " +
                    "wind_speed DECIMAL(5,2), " +
                    "aqi VARCHAR(50), " +
                    "uv_index DECIMAL(4,1), " +
                    "weather_score INT, " +
                    "last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS crowd_predictions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "current_crowd VARCHAR(50), " +
                    "expected_crowd VARCHAR(50), " +
                    "peak_season VARCHAR(100), " +
                    "off_season VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS safety_scores (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "overall_score DECIMAL(4,1), " +
                    "night_safety VARCHAR(50), " +
                    "medical_access VARCHAR(50), " +
                    "scam_risk VARCHAR(50), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS travel_alerts (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "alert_type VARCHAR(50), " +
                    "severity VARCHAR(50), " +
                    "message TEXT, " +
                    "active BOOLEAN DEFAULT TRUE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS destination_insights (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "health_score INT, " +
                    "best_time_photos VARCHAR(50), " +
                    "sunrise VARCHAR(20), " +
                    "sunset VARCHAR(20), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS event_impacts (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "event_name VARCHAR(100), " +
                    "crowd_increase_pct INT, " +
                    "start_date DATE, " +
                    "end_date DATE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                // AI Travel Buddy Tables
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS ai_chat_sessions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "context_page VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS ai_chat_messages (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "session_id INT NOT NULL, " +
                    "sender VARCHAR(20) NOT NULL, " + // 'user' or 'ai'
                    "message TEXT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                System.out.println("[SchemaBootstrap] Created AI Planner 2.0 tables.");
            } catch (Exception e) {
                System.err.println("[SchemaBootstrap] Error creating AI Planner tables: " + e.getMessage());
            }

                // Phase 16: Travel Center Tables
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS wallets (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "balance DECIMAL(10,2) DEFAULT 0.00, " +
                    "currency VARCHAR(10) DEFAULT 'INR', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS wallet_transactions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "wallet_id INT NOT NULL, " +
                    "amount DECIMAL(10,2) NOT NULL, " +
                    "type VARCHAR(20), " + // CREDIT, DEBIT
                    "description VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS reward_profiles (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "current_points INT DEFAULT 0, " +
                    "lifetime_points INT DEFAULT 0, " +
                    "tier VARCHAR(50) DEFAULT 'Explorer', " +
                    "referral_code VARCHAR(50), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS reward_history (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "points INT NOT NULL, " +
                    "type VARCHAR(20), " + // EARNED, REDEEMED
                    "description VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS travel_readiness (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "destination VARCHAR(100), " +
                    "visa_status VARCHAR(20) DEFAULT 'Pending', " +
                    "insurance_status VARCHAR(20) DEFAULT 'Pending', " +
                    "forex_status VARCHAR(20) DEFAULT 'Pending', " +
                    "esim_status VARCHAR(20) DEFAULT 'Pending', " +
                    "score INT DEFAULT 0, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                // Phase 17: My Journey Ecosystem
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS travel_memories (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "journey_id INT, " +
                    "type VARCHAR(50) DEFAULT 'PHOTO', " +
                    "media_url VARCHAR(255) NOT NULL, " +
                    "caption VARCHAR(255), " +
                    "location VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                try {
                    stmt.execute("ALTER TABLE travel_memories ADD COLUMN type VARCHAR(50) DEFAULT 'PHOTO' AFTER journey_id");
                    System.out.println("[SchemaBootstrap] Added type column to travel_memories.");
                } catch (Exception e) {}

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS family_hub_members (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "relation VARCHAR(50) NOT NULL, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "age INT, " +
                    "passport_readiness INT DEFAULT 0, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS trip_reports (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "journey_id INT, " +
                    "destination VARCHAR(100), " +
                    "summary TEXT, " +
                    "total_cost DECIMAL(10,2), " +
                    "rating INT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                // --- Premium Social Community Migrations ---
                try {
                    stmt.execute("ALTER TABLE posts ADD COLUMN image_url VARCHAR(255) DEFAULT NULL");
                } catch (Exception e) {}
                try {
                    stmt.execute("ALTER TABLE posts ADD COLUMN category VARCHAR(50) DEFAULT 'For You'");
                } catch (Exception e) {}
                try {
                    stmt.execute("ALTER TABLE posts ADD COLUMN hashtags VARCHAR(255) DEFAULT ''");
                } catch (Exception e) {}

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS comments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "post_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "text TEXT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS likes (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "post_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                    "UNIQUE KEY (post_id, user_id))"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS follows (" +
                    "follower_id INT NOT NULL, " +
                    "followed_id INT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "PRIMARY KEY (follower_id, followed_id), " +
                    "FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (followed_id) REFERENCES users(id) ON DELETE CASCADE)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS stories (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "media_url VARCHAR(255) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS saved_posts (" +
                    "user_id INT NOT NULL, " +
                    "post_id INT NOT NULL, " +
                    "saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "PRIMARY KEY (user_id, post_id), " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE)"
                );

                System.out.println("[SchemaBootstrap] Schema migration complete.");

        } catch (Exception e) {
            System.err.println("[SchemaBootstrap] Migration error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) { /* nothing */ }
}
