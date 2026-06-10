ALTER TABLE hotels ADD COLUMN latitude DOUBLE;
ALTER TABLE hotels ADD COLUMN longitude DOUBLE;
ALTER TABLE hotels ADD COLUMN best_seller BOOLEAN DEFAULT FALSE;
ALTER TABLE hotels ADD COLUMN recommended BOOLEAN DEFAULT FALSE;

UPDATE hotels SET latitude = -8.409518, longitude = 115.188919, best_seller = TRUE, recommended = TRUE WHERE id = 1;
UPDATE hotels SET latitude = 46.8182, longitude = 8.2275, best_seller = FALSE, recommended = TRUE WHERE id = 2;
UPDATE hotels SET latitude = 40.7128, longitude = -74.0060, best_seller = TRUE, recommended = FALSE WHERE id = 3;

CREATE TABLE IF NOT EXISTS hotel_wishlists (
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, hotel_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recently_viewed_hotels (
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, hotel_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hotel_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hotel_photos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    caption VARCHAR(255),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nearby_places (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    place_type VARCHAR(50) NOT NULL,
    distance_km DOUBLE NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

INSERT INTO hotel_reviews (user_id, hotel_id, rating, review_text) VALUES 
(1, 1, 5, 'Amazing experience, right by the beach!'),
(1, 2, 4, 'Very cozy, but a bit cold.'),
(2, 1, 4, 'Great views.');

INSERT INTO hotel_photos (hotel_id, url, caption) VALUES
(1, 'https://picsum.photos/800/600?random=1', 'Pool view'),
(1, 'https://picsum.photos/800/600?random=2', 'Lobby'),
(2, 'https://picsum.photos/800/600?random=3', 'Cabin exterior'),
(3, 'https://picsum.photos/800/600?random=4', 'City view');

INSERT INTO nearby_places (hotel_id, name, place_type, distance_km) VALUES
(1, 'Kuta Beach', 'Attraction', 2.5),
(1, 'Seafood Bay', 'Restaurant', 0.5),
(2, 'Ski Lift 1', 'Attraction', 1.2),
(3, 'Times Square', 'Attraction', 0.8),
(3, 'Joe''s Pizza', 'Restaurant', 0.3);
