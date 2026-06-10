CREATE TABLE IF NOT EXISTS flight_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    airline_logo VARCHAR(255),
    airline_name VARCHAR(100),
    flight_number VARCHAR(50),
    pnr_number VARCHAR(50),
    departure_city VARCHAR(100),
    arrival_city VARCHAR(100),
    departure_date VARCHAR(50),
    traveller_count INT,
    total_price DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'CONFIRMED',
    payment_id VARCHAR(100),
    transaction_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS car_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    car_name VARCHAR(100),
    car_image VARCHAR(255),
    pickup_location VARCHAR(100),
    dropoff_location VARCHAR(100),
    pickup_date VARCHAR(50),
    dropoff_date VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'CONFIRMED',
    booking_code VARCHAR(50),
    payment_id VARCHAR(100),
    transaction_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tour_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tour_name VARCHAR(100),
    tour_image VARCHAR(255),
    tour_date VARCHAR(50),
    guests INT,
    total_price DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'CONFIRMED',
    booking_code VARCHAR(50),
    payment_id VARCHAR(100),
    transaction_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
