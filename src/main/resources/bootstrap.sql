-- ============================================================
-- VOYASTRA BOOTSTRAP SQL (AUTO-GENERATED)
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `activities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `hero_image` VARCHAR(255) DEFAULT NULL,
  `description` TEXT,
  `highlights` TEXT,
  `duration_minutes` INT DEFAULT NULL,
  `opening_hours` VARCHAR(255) DEFAULT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `price` DECIMAL(10,2) DEFAULT NULL,
  `best_time` VARCHAR(255) DEFAULT NULL,
  `difficulty` VARCHAR(50) DEFAULT NULL,
  `age_limit` VARCHAR(50) DEFAULT NULL,
  `inclusions` TEXT,
  `exclusions` TEXT,
  `lat` VARCHAR(50) DEFAULT NULL,
  `lng` VARCHAR(50) DEFAULT NULL,
  `rating` DECIMAL(3,2) DEFAULT NULL,
  `review_count` INT DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `activity_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `activity_id` int NOT NULL,
  `travel_date` varchar(50) DEFAULT NULL,
  `travel_time` varchar(50) DEFAULT NULL,
  `guests` int DEFAULT '1',
  `status` varchar(50) DEFAULT 'PENDING',
  `amount` decimal(10,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  KEY `user_id` (`user_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `activity_bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `activity_bookings_ibfk_2` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `module` varchar(100) DEFAULT NULL,
  `details` text,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `ai_chat_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `sender` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `ai_chat_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `context_page` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `analytics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(100) DEFAULT NULL,
  `value` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `boarding_passes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `boarding_passes_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `booking_draft` (
  `draft_id` varchar(100) NOT NULL,
  `user_id` int NOT NULL,
  `flight_id` varchar(100) DEFAULT NULL,
  `flight_name` varchar(100) DEFAULT NULL,
  `flight_price` decimal(10,2) DEFAULT NULL,
  `flight_class` varchar(50) DEFAULT NULL,
  `passengers` int DEFAULT NULL,
  `travel_date` varchar(50) DEFAULT NULL,
  `origin` varchar(50) DEFAULT NULL,
  `destination` varchar(50) DEFAULT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(50) DEFAULT NULL,
  `gst_number` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`draft_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `booking_extras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `draft_id` varchar(100) NOT NULL,
  `meal_type` varchar(30) DEFAULT 'none',
  `extra_baggage` varchar(20) DEFAULT 'none',
  `priority_boarding` tinyint(1) DEFAULT '0',
  `travel_insurance` tinyint(1) DEFAULT '0',
  `total_cost` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `draft_id` (`draft_id`),
  CONSTRAINT `booking_extras_ibfk_1` FOREIGN KEY (`draft_id`) REFERENCES `booking_draft` (`draft_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `plan_id` int DEFAULT NULL,
  `total_price` decimal(12,2) DEFAULT '0.00',
  `status` enum('PENDING','CONFIRMED','CANCELLED','COMPLETED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `travel_date` date DEFAULT NULL,
  `num_adults` int DEFAULT '1',
  `num_children` int DEFAULT '0',
  `room_type` varchar(50) DEFAULT 'Standard',
  `pickup_city` varchar(100) DEFAULT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `customer_email` varchar(200) DEFAULT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `special_requests` text,
  `booking_code` varchar(20) DEFAULT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'unknown',
  `details` text,
  `seat_class` varchar(50) DEFAULT 'economy',
  `passengers` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `budget_notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `budget_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `destination` varchar(100) NOT NULL,
  `total_budget` decimal(10,2) NOT NULL,
  `flights` decimal(10,2) DEFAULT NULL,
  `hotel` decimal(10,2) DEFAULT NULL,
  `food` decimal(10,2) DEFAULT NULL,
  `activities` decimal(10,2) DEFAULT NULL,
  `transportation` decimal(10,2) DEFAULT NULL,
  `emergency` decimal(10,2) DEFAULT NULL,
  `health_score` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `bus_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `from_city` varchar(100) DEFAULT NULL,
  `to_city` varchar(100) DEFAULT NULL,
  `journey_date` date DEFAULT NULL,
  `bus_type` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `operator_name` varchar(100) DEFAULT NULL,
  `seat_numbers` varchar(100) DEFAULT NULL,
  `departure_time` varchar(20) DEFAULT NULL,
  `arrival_time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `bus_passengers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `seat_preference` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `bus_passengers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bus_bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cab_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `pickup_location` varchar(200) DEFAULT NULL,
  `drop_location` varchar(200) DEFAULT NULL,
  `pickup_date` date DEFAULT NULL,
  `pickup_time` varchar(20) DEFAULT NULL,
  `cab_type` varchar(50) DEFAULT NULL,
  `vehicle_type` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `driver_name` varchar(100) DEFAULT NULL,
  `driver_contact` varchar(20) DEFAULT NULL,
  `vehicle_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cab_passengers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `cab_passengers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `cab_bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `car_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `car_model` varchar(100) DEFAULT NULL,
  `vehicle_type` varchar(50) DEFAULT NULL,
  `pickup_city` varchar(255) DEFAULT NULL,
  `pickup_date` varchar(50) DEFAULT NULL,
  `return_date` varchar(50) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `car_customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `dl_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `car_customers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `car_bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `collection_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `collection_id` int DEFAULT NULL,
  `item_type` varchar(50) DEFAULT NULL,
  `item_url` varchar(255) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `collection_id` (`collection_id`),
  CONSTRAINT `collection_items_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `user_collections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `text` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `content_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(100) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `coupons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `discount_percent` decimal(5,2) DEFAULT NULL,
  `max_discount` decimal(10,2) DEFAULT NULL,
  `valid_until` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `crowd_predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `current_crowd` varchar(50) DEFAULT NULL,
  `expected_crowd` varchar(50) DEFAULT NULL,
  `peak_season` varchar(100) DEFAULT NULL,
  `off_season` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cruise_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `departure_port` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `cruise_date` date DEFAULT NULL,
  `passengers` int DEFAULT NULL,
  `cabin_type` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `cruise_line` varchar(100) DEFAULT NULL,
  `ship_name` varchar(100) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cruise_passengers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `passport_number` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `cruise_passengers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `cruise_bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `deal_alerts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `destination` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `activity_name` varchar(255) NOT NULL,
  `is_included` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `destination_activities_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `destination_id` int NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'PENDING',
  `is_active` tinyint(1) DEFAULT '0',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `travel_date` date DEFAULT NULL,
  `guests` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `destination_bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `destination_bookings_ibfk_2` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_experiences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT NULL,
  `image_url` varchar(512) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_gallery` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `destination_gallery_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_hotels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `hotel_id` int DEFAULT NULL,
  `hotel_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `destination_hotels_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_insights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `health_score` int DEFAULT NULL,
  `best_time_photos` varchar(50) DEFAULT NULL,
  `sunrise` varchar(20) DEFAULT NULL,
  `sunset` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `wiki_summary` text,
  `wiki_url` varchar(255) DEFAULT NULL,
  `top_attractions` json DEFAULT NULL,
  `local_foods` json DEFAULT NULL,
  `ai_insights` text,
  `country` varchar(100) DEFAULT NULL,
  `best_time` varchar(100) DEFAULT NULL,
  `language` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `timezone` varchar(100) DEFAULT NULL,
  `experiences` json DEFAULT NULL,
  `hotels` json DEFAULT NULL,
  `restaurants` json DEFAULT NULL,
  `travel_tips` json DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `itinerary_previews` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_itineraries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `day_number` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `details` text,
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `destination_itineraries_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destination_media_cache` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `media_type` varchar(20) NOT NULL,
  `url` varchar(512) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `extra_data` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=511 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `destination` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `short_description` varchar(500) DEFAULT NULL,
  `full_description` text,
  `price_inr` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `duration_days` int DEFAULT NULL,
  `duration_nights` int DEFAULT NULL,
  `best_season` varchar(100) DEFAULT NULL,
  `starting_city` varchar(100) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `rating` float DEFAULT '0',
  `review_count` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `is_featured` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `highlights` text,
  `has_unesco` tinyint(1) DEFAULT '0',
  `is_trending` tinyint(1) DEFAULT '0',
  `is_popular` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `event_impacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `event_name` varchar(100) DEFAULT NULL,
  `crowd_increase_pct` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `expense_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `budget_plan_id` int NOT NULL,
  `category` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `family_hub_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `relation` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `passport_readiness` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `flight_tickets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `booking_code` varchar(50) DEFAULT NULL,
  `pnr` varchar(30) DEFAULT NULL,
  `flight_number` varchar(30) DEFAULT NULL,
  `airline` varchar(100) DEFAULT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `departure_date` varchar(30) DEFAULT NULL,
  `departure_time` varchar(20) DEFAULT NULL,
  `arrival_time` varchar(20) DEFAULT NULL,
  `duration` varchar(30) DEFAULT NULL,
  `stops` varchar(10) DEFAULT '0',
  `seat_class` varchar(50) DEFAULT NULL,
  `seat_numbers` varchar(200) DEFAULT NULL,
  `total_price` double DEFAULT '0',
  `customer_name` varchar(200) DEFAULT NULL,
  `customer_email` varchar(200) DEFAULT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  `payment_status` varchar(30) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'CONFIRMED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_code` (`booking_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `follows` (
  `follower_id` int NOT NULL,
  `followed_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followed_id`),
  KEY `followed_id` (`followed_id`),
  CONSTRAINT `follows_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `follows_ibfk_2` FOREIGN KEY (`followed_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `helicopter_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `journey_date` date DEFAULT NULL,
  `passengers` int DEFAULT NULL,
  `heli_class` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `operator` varchar(100) DEFAULT NULL,
  `departure_time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `helicopter_passengers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `weight_kg` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `helicopter_passengers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `helicopter_bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hidden_gems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `description` text,
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `beauty_score` decimal(3,1) DEFAULT NULL,
  `peace_score` decimal(3,1) DEFAULT NULL,
  `photo_score` decimal(3,1) DEFAULT NULL,
  `crowd_score` decimal(3,1) DEFAULT NULL,
  `authenticity_score` decimal(3,1) DEFAULT NULL,
  `safety_score` decimal(3,1) DEFAULT NULL,
  `overall_score` decimal(3,1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hotel_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_code` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `hotel_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `guests` int DEFAULT '1',
  `total_price` double NOT NULL,
  `status` varchar(50) DEFAULT 'Confirmed',
  `guest_name` varchar(255) DEFAULT NULL,
  `guest_email` varchar(255) DEFAULT NULL,
  `guest_phone` varchar(50) DEFAULT NULL,
  `special_requests` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_code` (`booking_code`),
  KEY `user_id` (`user_id`),
  KEY `hotel_id` (`hotel_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `hotel_bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hotel_photos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hotel_id` int NOT NULL,
  `url` varchar(500) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `hotel_photos_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hotel_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `hotel_id` int NOT NULL,
  `rating` int NOT NULL,
  `review_text` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Approved',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `hotel_reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_reviews_ibfk_2` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_reviews_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hotel_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hotel_id` int NOT NULL,
  `type` varchar(100) NOT NULL,
  `capacity` int DEFAULT '2',
  `price_per_night` double NOT NULL,
  `amenities` varchar(500) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `hotel_rooms_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hotel_wishlists` (
  `user_id` int NOT NULL,
  `hotel_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`hotel_id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `hotel_wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_wishlists_ibfk_2` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `hotels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `description` text,
  `imageUrl` varchar(500) DEFAULT NULL,
  `price_per_night` decimal(10,2) DEFAULT NULL,
  `rating` double DEFAULT NULL,
  `amenities` varchar(500) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `best_seller` tinyint(1) DEFAULT '0',
  `recommended` tinyint(1) DEFAULT '0',
  `starting_price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `itineraries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `itinerary_data` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `itineraries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `uploaded_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uploaded_by` (`uploaded_by`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `nearby_places` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hotel_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `place_type` varchar(50) NOT NULL,
  `distance_km` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `nearby_places_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `message` text,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `package_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `travel_date` date DEFAULT NULL,
  `travellers` int DEFAULT NULL,
  `package_type` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `package_name` varchar(200) DEFAULT NULL,
  `inclusions` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `method` varchar(50) DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `service_type` varchar(50) DEFAULT NULL,
  `booking_reference` varchar(100) DEFAULT NULL,
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  `razorpay_payment_id` varchar(100) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'INR',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `plan_days` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int DEFAULT NULL,
  `day_number` int DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `plan_days_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `planner_locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `planner_map_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) DEFAULT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `active_layers` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `planner_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `origin` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `departure_date` date NOT NULL,
  `return_date` date NOT NULL,
  `budget` decimal(10,2) NOT NULL,
  `travel_style` varchar(50) DEFAULT NULL,
  `adults` int DEFAULT '1',
  `children` int DEFAULT '0',
  `seniors` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `planner_selected_places` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) DEFAULT NULL,
  `place_name` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `planner_sessions` (
  `session_id` varchar(100) NOT NULL,
  `user_id` int DEFAULT NULL,
  `last_active` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `destination_id` int DEFAULT NULL,
  `price` int DEFAULT NULL,
  `days` int DEFAULT NULL,
  `nights` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `plans_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text,
  `image` varchar(255) DEFAULT NULL,
  `video` varchar(255) DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `image_url` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT 'For You',
  `hashtags` varchar(255) DEFAULT '',
  `hidden` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `recently_viewed_hotels` (
  `user_id` int NOT NULL,
  `hotel_id` int NOT NULL,
  `viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`hotel_id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `recently_viewed_hotels_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recently_viewed_hotels_ibfk_2` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `refunds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `booking_type` varchar(20) DEFAULT 'FLIGHT',
  `amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `refund_method` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `refunds_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `destination_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` text,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Approved',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `reward_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `points` int NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `reward_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `current_points` int DEFAULT '0',
  `lifetime_points` int DEFAULT '0',
  `tier` varchar(50) DEFAULT 'Explorer',
  `referral_code` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `safety_scores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `overall_score` decimal(4,1) DEFAULT NULL,
  `night_safety` varchar(50) DEFAULT NULL,
  `medical_access` varchar(50) DEFAULT NULL,
  `scam_risk` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `saved_destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `destination_id` int NOT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `saved_destinations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `saved_destinations_ibfk_2` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `saved_posts` (
  `user_id` int NOT NULL,
  `post_id` int NOT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`post_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `saved_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `saved_posts_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `saved_trip_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `trip_id` int NOT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_trip` (`user_id`,`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key_name` varchar(100) DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `site_content` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_type` varchar(50) NOT NULL,
  `title` text,
  `subtitle` text,
  `is_active` tinyint(1) DEFAULT '1',
  `display_order` int DEFAULT '0',
  `body_text` text,
  `image_url` varchar(512) DEFAULT NULL,
  `button_text` varchar(255) DEFAULT NULL,
  `button_link` varchar(512) DEFAULT NULL,
  `promo_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `section_type` (`section_type`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stays` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `type` enum('hotel','homestay','villa','hostel') DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `price_per_night` int DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `media_url` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `media_type` varchar(20) DEFAULT 'image',
  `caption` varchar(255) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `stories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `story_views` (
  `id` int NOT NULL AUTO_INCREMENT,
  `story_id` int NOT NULL,
  `viewer_id` int NOT NULL,
  `viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `story_id` (`story_id`,`viewer_id`),
  KEY `viewer_id` (`viewer_id`),
  CONSTRAINT `story_views_ibfk_1` FOREIGN KEY (`story_id`) REFERENCES `stories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `story_views_ibfk_2` FOREIGN KEY (`viewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `system_settings` (
  `setting_key` varchar(100) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `train_bookings` (
  `id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `from_station` varchar(100) DEFAULT NULL,
  `to_station` varchar(100) DEFAULT NULL,
  `journey_date` date DEFAULT NULL,
  `train_class` varchar(50) DEFAULT NULL,
  `quota` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `pnr` varchar(50) DEFAULT NULL,
  `train_name` varchar(100) DEFAULT NULL,
  `train_number` varchar(20) DEFAULT NULL,
  `departure_time` varchar(20) DEFAULT NULL,
  `arrival_time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `train_passengers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `berth_preference` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `transport` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` enum('flight','train','bus','cab','auto') DEFAULT NULL,
  `from_location` varchar(100) DEFAULT NULL,
  `to_location` varchar(100) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `provider` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `travel_alerts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `alert_type` varchar(50) DEFAULT NULL,
  `severity` varchar(50) DEFAULT NULL,
  `message` text,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `travel_memories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `journey_id` int DEFAULT NULL,
  `type` varchar(50) DEFAULT 'PHOTO',
  `media_url` varchar(255) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `travel_readiness` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `visa_status` varchar(20) DEFAULT 'Pending',
  `insurance_status` varchar(20) DEFAULT 'Pending',
  `forex_status` varchar(20) DEFAULT 'Pending',
  `esim_status` varchar(20) DEFAULT 'Pending',
  `score` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `travellers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `draft_id` varchar(100) NOT NULL,
  `title` varchar(10) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `dob` varchar(20) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `passport` varchar(100) DEFAULT NULL,
  `seat_number` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `draft_id` (`draft_id`),
  CONSTRAINT `travellers_ibfk_1` FOREIGN KEY (`draft_id`) REFERENCES `booking_draft` (`draft_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trending_places` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int DEFAULT NULL,
  `rank_no` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `trending_places_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `trip_id` int NOT NULL,
  `trip_name` varchar(255) NOT NULL,
  `destination` varchar(255) NOT NULL,
  `travel_date` varchar(50) NOT NULL,
  `amount` double NOT NULL,
  `booking_status` varchar(50) DEFAULT 'CONFIRMED',
  `is_active` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_checklists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `creator_id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `items` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_cost_predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `budget_plan_id` int NOT NULL,
  `best_case` decimal(10,2) DEFAULT NULL,
  `expected` decimal(10,2) DEFAULT NULL,
  `worst_case` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `uploader_id` int NOT NULL,
  `doc_name` varchar(100) NOT NULL,
  `doc_url` varchar(255) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_expense_splits` (
  `expense_id` int NOT NULL,
  `user_id` int NOT NULL,
  `owed_amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`expense_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_expenses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `payer_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `split_type` varchar(20) DEFAULT 'EQUAL',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_gallery` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trip_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trip_id` (`trip_id`),
  CONSTRAINT `trip_gallery_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_group_members` (
  `group_id` int NOT NULL,
  `user_id` int NOT NULL,
  `role` varchar(20) DEFAULT 'MEMBER',
  PRIMARY KEY (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `creator_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `budget` int DEFAULT NULL,
  `days` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `trip_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_inclusions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trip_id` int NOT NULL,
  `inclusion_name` varchar(255) NOT NULL,
  `included` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `trip_id` (`trip_id`),
  CONSTRAINT `trip_inclusions_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_itineraries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `json_data` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_itinerary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trip_id` int NOT NULL,
  `day_number` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `details` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `trip_id` (`trip_id`),
  CONSTRAINT `trip_itinerary_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `type` varchar(20) DEFAULT 'TEXT',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `short_description` varchar(500) NOT NULL,
  `full_description` text NOT NULL,
  `duration` varchar(50) NOT NULL,
  `price_inr` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `rating` decimal(3,1) DEFAULT '5.0',
  `category` enum('Luxury','Honeymoon','Family','Adventure','Cultural') DEFAULT 'Luxury',
  `best_season` varchar(100) DEFAULT NULL,
  `starting_city` varchar(100) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `journey_id` int DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `summary` text,
  `total_cost` decimal(10,2) DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_settlements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `from_user_id` int NOT NULL,
  `to_user_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_vote_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vote_id` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `voter_ids` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trip_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `creator_id` int NOT NULL,
  `question` varchar(255) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'OPEN',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `user_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `user_gamification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `badge_name` varchar(100) DEFAULT NULL,
  `awarded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `user_saved_gems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `gem_id` int DEFAULT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','blocked') DEFAULT 'active',
  `google_id` varchar(100) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `verification_token` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `bio` text,
  `wallet_balance` decimal(10,2) DEFAULT '0.00',
  `loyalty_points` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `wallet_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `wallet_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `wallets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `balance` decimal(10,2) DEFAULT '0.00',
  `currency` varchar(10) DEFAULT 'INR',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `weather_cache` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(100) NOT NULL,
  `temp` decimal(5,2) DEFAULT NULL,
  `humidity` int DEFAULT NULL,
  `rain_prob` int DEFAULT NULL,
  `wind_speed` decimal(5,2) DEFAULT NULL,
  `aqi` varchar(50) DEFAULT NULL,
  `uv_index` decimal(4,1) DEFAULT NULL,
  `weather_score` int DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `flights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `flight_number` varchar(50) NOT NULL,
  `airline` varchar(100) NOT NULL,
  `origin` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `available_seats` int DEFAULT '60',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `flight_number` (`flight_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ============================================================
-- VIEW: flight_bookings
-- ============================================================
CREATE OR REPLACE VIEW flight_bookings AS
SELECT id, user_id, plan_id, total_price, status, created_at, type, details, booking_code, travel_date, customer_name, customer_email, customer_phone
FROM bookings
WHERE type = 'flight';

-- ============================================================
-- SEED DATA
-- ============================================================


SET FOREIGN_KEY_CHECKS = 0;

-- 1. Seed Users (passwords are 'Admin@123' hashed with bcrypt)
INSERT IGNORE INTO users (name, email, password, role, is_verified, wallet_balance, loyalty_points) VALUES
('Voyastra Admin', 'admin@voyastra.com', '$2a$12$OhufE14IFnHVGNvDtOlTKOuEYohGZD/HUV6CUEBioKhevSiRdcbIu', 'ADMIN', TRUE, 5000.0, 1000),
('Test User', 'user@voyastra.com', '$2a$12$OhufE14IFnHVGNvDtOlTKOuEYohGZD/HUV6CUEBioKhevSiRdcbIu', 'USER', TRUE, 1500.0, 200);

-- 2. Seed Destinations
INSERT IGNORE INTO destinations (id, name, state, country, category, image, description, rating) VALUES
(1, 'Goa', 'Goa', 'India', 'Beach', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80', 'Golden beaches, vibrant nightlife, Portuguese heritage, and stunning sunsets.', 4.7),
(2, 'Manali', 'Himachal Pradesh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80', 'High-altitude Himalayan resort town famous for its stunning landscapes.', 4.8),
(3, 'Jaipur', 'Rajasthan', 'India', 'Heritage', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80', 'The Pink City, home to magnificent forts, palaces, and vibrant bazaars.', 4.6),
(4, 'Kerala Backwaters', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80', 'Serene network of lagoons, lakes, and canals with traditional houseboats.', 4.9),
(5, 'Varanasi', 'Uttar Pradesh', 'India', 'Spiritual', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80', 'One of the world oldest cities, a spiritual epicenter on the Ganges.', 4.5),
(6, 'Ladakh', 'Ladakh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80', 'Remote high-altitude desert with dramatic landscapes and ancient monasteries.', 4.9),
(7, 'Andaman Islands', 'Andaman & Nicobar', 'India', 'Beach', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80', 'Pristine turquoise waters, white sand beaches, and rich marine biodiversity.', 4.8),
(8, 'Munnar', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80', 'Rolling tea gardens across misty hills with breathtaking panoramic views.', 4.7),
(9, 'Agra', 'Uttar Pradesh', 'India', 'Heritage', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80', 'Home to the iconic Taj Mahal, a UNESCO World Heritage Site.', 4.6),
(10, 'Rishikesh', 'Uttarakhand', 'India', 'Adventure', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80', 'The yoga capital of the world, nestled in the Himalayan foothills.', 4.7);

-- 3. Seed Plans
INSERT IGNORE INTO plans (id, title, destination_id, price, days, nights, category, description, image) VALUES
(1, 'Goa Beach Getaway', 1, 12500, 4, 3, 'Beach', 'A perfect 4-day beach vacation with water sports and sunset cruises.', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80'),
(2, 'Manali Snow Adventure', 2, 18000, 5, 4, 'Adventure', 'Experience the best of the Himalayas skiing and mountain lodges.', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80'),
(3, 'Royal Rajasthan Circuit', 3, 22000, 6, 5, 'Heritage', 'Explore Amber Fort, Hawa Mahal, City Palace, and Johari Bazaar.', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80'),
(4, 'Kerala Houseboat Bliss', 4, 16500, 4, 3, 'Nature', 'Drift through calm backwaters on a luxury houseboat.', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80'),
(5, 'Spiritual Varanasi Trail', 5, 9500, 3, 2, 'Spiritual', 'Witness the sacred Ganga Aarti and sunrise boat rides on the Ganges.', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80'),
(6, 'Ladakh Expedition', 6, 35000, 8, 7, 'Adventure', 'Pangong Lake, Nubra Valley, Khardung La Pass, and monasteries.', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80'),
(7, 'Andaman Dive & Relax', 7, 28000, 6, 5, 'Beach', 'Snorkeling at Coral Island and scuba diving at Elephant Beach.', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80'),
(8, 'Munnar Tea Trail', 8, 14000, 4, 3, 'Nature', 'Walk through sprawling tea estates and visit Eravikulam National Park.', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80'),
(9, 'Agra Heritage Tour', 9, 11000, 3, 2, 'Heritage', 'Taj Mahal at sunrise, Agra Fort, and Fatehpur Sikri.', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80'),
(10, 'Rishikesh Yoga & Rafting', 10, 13500, 4, 3, 'Adventure', 'River rafting on Ganges rapids and yoga at an ashram.', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80');

-- 4. Seed Plan Days
INSERT IGNORE INTO plan_days (plan_id, day_number, title, activities) VALUES
(1, 1, 'Arrival in Goa', 'Check-in to beach resort, leisure time at Baga Beach, evening sunset walk.'),
(1, 2, 'North Goa Sightseeing', 'Visit Fort Aguada, Chapora Fort, and enjoy water sports at Calangute Beach.'),
(1, 3, 'South Goa Cultural Tour', 'Explore Basilica of Bom Jesus, Se Cathedral, and Miramar beach cruise.'),
(1, 4, 'Departure', 'Souvenir shopping at Panaji local market and departure transfer.'),
(2, 1, 'Arrival & Acclimatization', 'Arrival in Manali, check-in to lodge, stroll along Mall Road.'),
(2, 2, 'Solang Valley Adventure', 'Paragliding, zorbing, and beautiful snow sights in Solang.'),
(2, 3, 'Rohtang Pass Tour', 'Spectacular high altitude views, snow scooter rides, and photography.'),
(2, 4, 'Hadimba Temple & Local Sightseeing', 'Visit ancient Hadimba Temple, Vashisht Hot Springs, and Club House.'),
(2, 5, 'Departure', 'Check out and depart towards Chandigarh/Delhi.');

-- 5. Seed Hotels
INSERT IGNORE INTO hotels (id, name, city, country, address, description, imageUrl, price_per_night, rating, amenities, latitude, longitude, best_seller, recommended, starting_price) VALUES
(1, 'Oceanview Retreat', 'Bali', 'Indonesia', '123 Beachfront Ave', 'Beautiful ocean views beachfront resort.', 'https://images.unsplash.com/photo-1522798514-97ceb8c4f1c8?auto=format&fit=crop&w=800', 250.00, 4.8, 'WiFi,Pool,Spa', -8.409518, 115.188919, TRUE, TRUE, 250.0),
(2, 'Alpine Lodge', 'Zurich', 'Switzerland', '45 Mountain Rd', 'Cozy lodge nestled in the Swiss Alps.', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800', 300.00, 4.7, 'WiFi,Heater,Ski', 47.3769, 8.5417, FALSE, TRUE, 300.0),
(3, 'Urban Boutique', 'Tokyo', 'Japan', '789 Downtown St', 'Modern and sleek stay in the heart of Tokyo.', 'https://images.unsplash.com/photo-1512453979436-5a50ce8c5d18?auto=format&fit=crop&w=800', 200.00, 4.9, 'WiFi,Gym,Bar', 35.6762, 139.6503, TRUE, TRUE, 200.0),
(4, 'Desert Oasis', 'Dubai', 'UAE', '101 Sand Dunes Blvd', 'Luxury and tranquility in the desert dunes.', 'https://images.unsplash.com/photo-1542314831-c6a4d27ece50?auto=format&fit=crop&w=800', 500.00, 4.9, 'WiFi,Pool,Air Conditioning', 25.2048, 55.2708, TRUE, TRUE, 500.0),
(5, 'Historic Palace', 'Rome', 'Italy', '222 Colosseum Way', 'Grand, classical palace experience near historical landmarks.', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800', 180.00, 4.6, 'WiFi,Restaurant,Tour', 41.9028, 12.4964, FALSE, TRUE, 180.0);

-- 6. Seed Hotel Rooms
INSERT IGNORE INTO hotel_rooms (id, hotel_id, type, capacity, price_per_night, amenities, image_url) VALUES
(1, 1, 'Deluxe Ocean Room', 2, 250.00, 'Ocean view, WiFi, AC, King Bed', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=500'),
(2, 1, 'Executive Beach Suite', 3, 400.00, 'Plunge pool, WiFi, Butler service', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500'),
(3, 2, 'Cozy Chalet Room', 2, 300.00, 'Mountain view, Heater, Balcony', 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=500'),
(4, 3, 'Standard Cozy Room', 2, 200.00, 'City view, WiFi, AC', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500');

-- 7. Seed Activities
INSERT IGNORE INTO activities (id, title, hero_image, description, location, price, duration_minutes, rating, review_count, highlights) VALUES
(1, 'River Rafting', 'https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format,compress&fit=crop&w=800', 'Navigate the thrilling rapids of the Ganges with expert guides.', 'Rishikesh, Uttarakhand', 1500.00, 180, 4.8, 342, 'Grade 3 Rapids|Safety Gear Included|Professional Guide'),
(2, 'Ganga Aarti', 'https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format,compress&fit=crop&w=800', 'Experience the spiritual and mesmerizing Ganga Aarti at Dashashwamedh Ghat.', 'Varanasi, UP', 0.00, 60, 4.9, 1024, 'Spiritual Chants|Evening Views|Cultural Heritage'),
(3, 'Nightlife & Beaches', 'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format,compress&fit=crop&w=800', 'Enjoy the vibrant nightlife and pristine sandy beaches of Goa.', 'Goa', 2000.00, 240, 4.7, 512, 'Live Music|Beach Shacks|Fire Shows'),
(4, 'Taj Mahal Tour', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format,compress&fit=crop&w=800', 'A guided tour of the iconic Taj Mahal, a symbol of eternal love.', 'Agra, UP', 1100.00, 120, 4.9, 2048, 'Skip-the-line Entry|Historical Insights|Photography Spots');

-- 8. Seed Site Content
INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) VALUES
('hero', 'Experience Voyastra', 'Say goodbye to endless research. Our intelligent platform crafts hyper-personalized itineraries.', TRUE, 1),
('promotion', 'Summer Special: 20% Off', 'Use code SUMMER20 for all European trips.', TRUE, 2),
('announcement', 'New Destinations Added!', 'Explore our latest travel packages now.', TRUE, 3);

-- 9. Seed Flights
INSERT IGNORE INTO flights (flight_number, airline, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
('VY-101', 'Voyastra Air', 'Delhi', 'Goa', '2026-08-15 06:00:00', '2026-08-15 08:30:00', 4500.00, 60),
('VY-102', 'Voyastra Air', 'Mumbai', 'Delhi', '2026-08-16 14:00:00', '2026-08-16 16:15:00', 3200.00, 60),
('VY-103', 'Voyastra Air', 'Delhi', 'Zurich', '2026-09-01 02:00:00', '2026-09-01 08:30:00', 48000.00, 60),
('VY-104', 'Voyastra Air', 'Delhi', 'Tokyo', '2026-09-10 22:30:00', '2026-09-11 07:30:00', 35000.00, 60);

-- 10. Seed Community Posts
INSERT IGNORE INTO posts (id, user_id, content, location, category) VALUES
(1, 2, 'Misty mornings in Manali - Waking up to snowy mountain peaks and warm chai is something else. Highly recommend visiting Old Manali!', 'Manali', 'Adventure'),
(2, 2, 'Sunset cruise in Goa - Breathtaking golden hour views from the Mandovi river cruise. Totally worth it!', 'Goa', 'For You');

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 1;
