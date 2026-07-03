-- ============================================================
-- VOYASTRA BOOTSTRAP SQL
-- Creates all missing core tables required for the application.
-- Run this ONCE on a fresh database before running other migrations.
-- ============================================================

-- Removed USE voyastra; to prevent issues on different database schemas (like defaultdb on Aiven)

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- CORE: USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'USER',
    is_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_token VARCHAR(255),
    phone VARCHAR(20),
    profile_image VARCHAR(500),
    location VARCHAR(255),
    bio TEXT,
    wallet_balance DOUBLE DEFAULT 0.0,
    loyalty_points INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: DESTINATIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS destinations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'India',
    city VARCHAR(100),
    slug VARCHAR(255),
    category VARCHAR(100),
    image VARCHAR(500),
    description TEXT,
    rating FLOAT DEFAULT 0.0,
    review_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: PLANS (TRAVEL PACKAGES)
-- ============================================================
CREATE TABLE IF NOT EXISTS plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    destination_id INT,
    price DECIMAL(10,2) NOT NULL,
    days INT DEFAULT 1,
    nights INT DEFAULT 0,
    category VARCHAR(100),
    description TEXT,
    image VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: PLAN DAYS
-- ============================================================
CREATE TABLE IF NOT EXISTS plan_days (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    day_number INT NOT NULL,
    title VARCHAR(255),
    activities TEXT,
    FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: HOTELS
-- ============================================================
CREATE TABLE IF NOT EXISTS hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    address TEXT,
    description TEXT,
    image_url VARCHAR(500),
    price_per_night DECIMAL(10,2),
    rating FLOAT DEFAULT 0.0,
    amenities TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: ACTIVITIES
-- ============================================================
CREATE TABLE IF NOT EXISTS activities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    destination_id INT,
    category VARCHAR(100),
    description TEXT,
    image VARCHAR(500),
    price DECIMAL(10,2),
    duration VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: BOOKINGS
-- ============================================================
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT,
    destination_id INT,
    booking_reference VARCHAR(100),
    travel_date DATE,
    return_date DATE,
    num_travellers INT DEFAULT 1,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: REVIEWS
-- ============================================================
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    target_id INT NOT NULL,
    target_type VARCHAR(50) NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: POSTS (COMMUNITY)
-- ============================================================
CREATE TABLE IF NOT EXISTS posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255),
    content TEXT,
    image_url VARCHAR(500),
    destination VARCHAR(255),
    category VARCHAR(100),
    likes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: TRIPS (TRIP PLANNER)
-- ============================================================
CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    destination VARCHAR(255),
    destination_id INT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'PLANNING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: TRENDING PLACES
-- ============================================================
CREATE TABLE IF NOT EXISTS trending_places (
    id INT AUTO_INCREMENT PRIMARY KEY,
    destination_id INT,
    `rank` INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CORE: TRIP PLANS
-- ============================================================
CREATE TABLE IF NOT EXISTS trip_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    destination VARCHAR(255),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SEED DATA: DESTINATIONS
-- ============================================================
INSERT IGNORE INTO destinations (name, state, country, category, image, description, rating) VALUES
('Goa', 'Goa', 'India', 'Beach', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80', 'Golden beaches, vibrant nightlife, Portuguese heritage, and stunning sunsets.', 4.7),
('Manali', 'Himachal Pradesh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80', 'High-altitude Himalayan resort town famous for its stunning landscapes.', 4.8),
('Jaipur', 'Rajasthan', 'India', 'Heritage', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80', 'The Pink City, home to magnificent forts, palaces, and vibrant bazaars.', 4.6),
('Kerala Backwaters', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80', 'Serene network of lagoons, lakes, and canals with traditional houseboats.', 4.9),
('Varanasi', 'Uttar Pradesh', 'India', 'Spiritual', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80', 'One of the world oldest cities, a spiritual epicenter on the Ganges.', 4.5),
('Ladakh', 'Ladakh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80', 'Remote high-altitude desert with dramatic landscapes and ancient monasteries.', 4.9),
('Andaman Islands', 'Andaman & Nicobar', 'India', 'Beach', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80', 'Pristine turquoise waters, white sand beaches, and rich marine biodiversity.', 4.8),
('Munnar', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80', 'Rolling tea gardens across misty hills with breathtaking panoramic views.', 4.7),
('Agra', 'Uttar Pradesh', 'India', 'Heritage', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80', 'Home to the iconic Taj Mahal, a UNESCO World Heritage Site.', 4.6),
('Rishikesh', 'Uttarakhand', 'India', 'Adventure', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80', 'The yoga capital of the world, nestled in the Himalayan foothills.', 4.7);

-- ============================================================
-- SEED DATA: PLANS
-- ============================================================
INSERT IGNORE INTO plans (title, destination_id, price, days, nights, category, description, image) VALUES
('Goa Beach Getaway', 1, 12500, 4, 3, 'Beach', 'A perfect 4-day beach vacation with water sports and sunset cruises.', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80'),
('Manali Snow Adventure', 2, 18000, 5, 4, 'Adventure', 'Experience the best of the Himalayas skiing and mountain lodges.', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80'),
('Royal Rajasthan Circuit', 3, 22000, 6, 5, 'Heritage', 'Explore Amber Fort, Hawa Mahal, City Palace, and Johari Bazaar.', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80'),
('Kerala Houseboat Bliss', 4, 16500, 4, 3, 'Nature', 'Drift through calm backwaters on a luxury houseboat.', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80'),
('Spiritual Varanasi Trail', 5, 9500, 3, 2, 'Spiritual', 'Witness the sacred Ganga Aarti and sunrise boat rides on the Ganges.', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80'),
('Ladakh Expedition', 6, 35000, 8, 7, 'Adventure', 'Pangong Lake, Nubra Valley, Khardung La Pass, and monasteries.', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80'),
('Andaman Dive & Relax', 7, 28000, 6, 5, 'Beach', 'Snorkeling at Coral Island and scuba diving at Elephant Beach.', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80'),
('Munnar Tea Trail', 8, 14000, 4, 3, 'Nature', 'Walk through sprawling tea estates and visit Eravikulam National Park.', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80'),
('Agra Heritage Tour', 9, 11000, 3, 2, 'Heritage', 'Taj Mahal at sunrise, Agra Fort, and Fatehpur Sikri.', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80'),
('Rishikesh Yoga & Rafting', 10, 13500, 4, 3, 'Adventure', 'River rafting on Ganges rapids and yoga at an ashram.', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80');

SET FOREIGN_KEY_CHECKS = 1;
