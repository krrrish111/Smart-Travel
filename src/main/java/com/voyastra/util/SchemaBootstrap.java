package com.voyastra.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;
import com.voyastra.config.ConfigManager;

/**
 * Runs automatic DB schema migrations on application startup.
 * All migrations are idempotent (safe to run multiple times).
 */
@WebListener
public class SchemaBootstrap implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        
        System.out.println("=================================");
        System.out.println("VOYASTRA STARTUP CHECK");
        
        // 1. Database Connection
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("Database Connection: SUCCESS");
                DiagnosticManager.dbConnected = true;
            } else {
                System.out.println("Database Connection: FAILED");
                DiagnosticManager.dbConnected = false;
            }
        } catch (Exception e) {
            System.out.println("Database Connection: FAILED");
            DiagnosticManager.dbConnected = false;
        }

        // 2. Servlet Registration
        // If we are here, listeners are working, assume Servlets are registered
        System.out.println("Servlet Registration: SUCCESS");
        DiagnosticManager.servletsRegistered = true;

        // 3. YouTube Config
        String ytKey = ConfigManager.get("YOUTUBE_API_KEY");
        if (ytKey != null && !ytKey.trim().isEmpty() && !ytKey.contains("YOUR_YOUTUBE")) {
            System.out.println("YouTube Config: SUCCESS");
            DiagnosticManager.youtubeConfigured = true;
        } else {
            System.out.println("YouTube Config: FAILED");
            DiagnosticManager.youtubeConfigured = false;
        }

        // 4. Unsplash Config
        String unsplashKey = ConfigManager.get("UNSPLASH_ACCESS_KEY");
        if (unsplashKey != null && !unsplashKey.trim().isEmpty() && !unsplashKey.contains("YOUR_UNSPLASH")) {
            System.out.println("Unsplash Config: SUCCESS");
            DiagnosticManager.unsplashConfigured = true;
        } else {
            System.out.println("Unsplash Config: FAILED");
            DiagnosticManager.unsplashConfigured = false;
        }
        
        System.out.println("=================================");

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

                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN wiki_summary TEXT"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN wiki_url VARCHAR(255)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN top_attractions JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN local_foods JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN ai_insights TEXT"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN country VARCHAR(100)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN best_time VARCHAR(100)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN language VARCHAR(100)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN currency VARCHAR(100)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN timezone VARCHAR(100)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN experiences JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN hotels JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN restaurants JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN travel_tips JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN itinerary_previews JSON"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE destination_insights ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"); } catch (Exception e) {}

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS destination_media_cache (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "media_type VARCHAR(20) NOT NULL, " + 
                    "url VARCHAR(512) NOT NULL, " +
                    "title VARCHAR(255), " +
                    "extra_data JSON, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS destination_experiences (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "destination VARCHAR(100) NOT NULL, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "description TEXT, " +
                    "price DECIMAL(10, 2), " +
                    "rating DECIMAL(3, 2), " +
                    "image_url VARCHAR(512), " +
                    "category VARCHAR(100))"
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
                try {
                    stmt.execute("ALTER TABLE posts ADD COLUMN hidden BOOLEAN DEFAULT FALSE");
                } catch (Exception e) {}

                // site_content extended fields for Admin Content Management
                try { stmt.execute("ALTER TABLE site_content ADD COLUMN body_text TEXT"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE site_content ADD COLUMN image_url VARCHAR(512)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE site_content ADD COLUMN button_text VARCHAR(255)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE site_content ADD COLUMN button_link VARCHAR(512)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE site_content ADD COLUMN promo_code VARCHAR(100)"); } catch (Exception e) {}
                // Ensure site_content table exists with all columns
                try {
                    stmt.execute("CREATE TABLE IF NOT EXISTS site_content (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "section_type VARCHAR(50) NOT NULL UNIQUE, " +
                        "title TEXT, " +
                        "subtitle TEXT, " +
                        "body_text TEXT, " +
                        "image_url VARCHAR(512), " +
                        "button_text VARCHAR(255), " +
                        "button_link VARCHAR(512), " +
                        "promo_code VARCHAR(100), " +
                        "is_active BOOLEAN DEFAULT TRUE, " +
                        "display_order INT DEFAULT 0)");
                } catch (Exception e) {}
                // Seed default content if table is empty
                try {
                    stmt.execute("INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) " +
                        "VALUES ('hero', 'Experience Voyastra', 'Say goodbye to endless research. Our intelligent platform crafts hyper-personalized itineraries.', TRUE, 1)");
                    stmt.execute("INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) " +
                        "VALUES ('promotion', 'Summer Special: 20% Off', 'Use code SUMMER20 for all European trips.', TRUE, 2)");
                    stmt.execute("INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) " +
                        "VALUES ('announcement', 'New Destinations Added!', 'Explore our latest travel packages now.', TRUE, 3)");
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

                try { stmt.execute("ALTER TABLE stories ADD COLUMN media_type VARCHAR(20) DEFAULT 'image'"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE stories ADD COLUMN caption VARCHAR(255)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE stories ADD COLUMN location VARCHAR(100)"); } catch (Exception e) {}
                try { stmt.execute("ALTER TABLE stories ADD COLUMN expires_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"); } catch (Exception e) {}

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS story_views (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "story_id INT NOT NULL, " +
                    "viewer_id INT NOT NULL, " +
                    "viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (story_id) REFERENCES stories(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (viewer_id) REFERENCES users(id) ON DELETE CASCADE, " +
                    "UNIQUE KEY (story_id, viewer_id))"
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

                try {
                    stmt.execute("ALTER TABLE destination_bookings ADD COLUMN travel_date DATE");
                    System.out.println("[SchemaBootstrap] Added travel_date to destination_bookings.");
                } catch (Exception e) {}
                try {
                    stmt.execute("ALTER TABLE destination_bookings ADD COLUMN guests INT DEFAULT 1");
                    System.out.println("[SchemaBootstrap] Added guests to destination_bookings.");
                } catch (Exception e) {}

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS activities (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "hero_image VARCHAR(255), " +
                    "description TEXT, " +
                    "highlights TEXT, " +
                    "duration_minutes INT, " +
                    "opening_hours VARCHAR(255), " +
                    "location VARCHAR(255), " +
                    "price DECIMAL(10,2), " +
                    "best_time VARCHAR(255), " +
                    "difficulty VARCHAR(50), " +
                    "age_limit VARCHAR(50), " +
                    "inclusions TEXT, " +
                    "exclusions TEXT, " +
                    "lat VARCHAR(50), " +
                    "lng VARCHAR(50), " +
                    "rating DECIMAL(3,1), " +
                    "review_count INT DEFAULT 0)"
                );

                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS activity_bookings (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "booking_id VARCHAR(50) NOT NULL UNIQUE, " +
                    "user_id INT NOT NULL, " +
                    "activity_id INT NOT NULL, " +
                    "travel_date VARCHAR(50), " +
                    "travel_time VARCHAR(50), " +
                    "guests INT DEFAULT 1, " +
                    "status VARCHAR(50) DEFAULT 'PENDING', " +
                    "amount DECIMAL(10,2), " +
                    "is_active BOOLEAN DEFAULT false, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE)"
                );

                // Seed data for the 4 Must-Do activities if activities table is empty
                try {
                    var rs = stmt.executeQuery("SELECT COUNT(*) AS c FROM activities");
                    if (rs.next() && rs.getInt("c") == 0) {
                        stmt.execute("INSERT INTO activities (title, hero_image, description, location, price, duration_minutes, rating, review_count, highlights) VALUES " +
                            "('River Rafting', 'https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format,compress&fit=crop&w=800', 'Navigate the thrilling rapids of the Ganges with expert guides.', 'Rishikesh, Uttarakhand', 1500.00, 180, 4.8, 342, 'Grade 3 Rapids|Safety Gear Included|Professional Guide'), " +
                            "('Ganga Aarti', 'https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format,compress&fit=crop&w=800', 'Experience the spiritual and mesmerizing Ganga Aarti at Dashashwamedh Ghat.', 'Varanasi, UP', 0.00, 60, 4.9, 1024, 'Spiritual Chants|Evening Views|Cultural Heritage'), " +
                            "('Nightlife & Beaches', 'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format,compress&fit=crop&w=800', 'Enjoy the vibrant nightlife and pristine sandy beaches of Goa.', 'Goa', 2000.00, 240, 4.7, 512, 'Live Music|Beach Shacks|Fire Shows'), " +
                            "('Taj Mahal Tour', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format,compress&fit=crop&w=800', 'A guided tour of the iconic Taj Mahal, a symbol of eternal love.', 'Agra, UP', 1100.00, 120, 4.9, 2048, 'Skip-the-line Entry|Historical Insights|Photography Spots')"
                        );
                        System.out.println("[SchemaBootstrap] Seeded activities table with 4 Must-Do experiences.");
                    }
                } catch (Exception e) {}

                try {
                    stmt.execute("DROP TABLE IF EXISTS admin_logs");
                    stmt.execute(
                        "CREATE TABLE admin_logs (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "admin_id INT, " +
                        "action VARCHAR(255), " +
                        "module VARCHAR(100), " +
                        "details TEXT, " +
                        "ip_address VARCHAR(50), " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                        ")"
                    );
                    System.out.println("[SchemaBootstrap] Recreated admin_logs table.");
                } catch (Exception e) {
                    System.err.println("[SchemaBootstrap] Failed to create admin_logs: " + e.getMessage());
                }

                System.out.println("[SchemaBootstrap] Schema migration complete.");

        } catch (Exception e) {
            System.err.println("[SchemaBootstrap] Migration error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) { /* nothing */ }
}
