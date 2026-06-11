CREATE TABLE IF NOT EXISTS cruise_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    ship_name VARCHAR(100),
    cruise_line VARCHAR(100),
    cabin_type VARCHAR(50),
    departure_port VARCHAR(255),
    destination VARCHAR(255),
    cruise_date VARCHAR(50),
    duration_days INT,
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cruise_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    passport_number VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES cruise_bookings(id) ON DELETE CASCADE
);
