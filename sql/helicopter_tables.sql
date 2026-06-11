CREATE TABLE IF NOT EXISTS helicopter_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    operator VARCHAR(100),
    flight_type VARCHAR(50),
    origin VARCHAR(255),
    destination VARCHAR(255),
    travel_date VARCHAR(50),
    travel_time VARCHAR(50),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS helicopter_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    weight_kg DOUBLE,
    FOREIGN KEY (booking_id) REFERENCES helicopter_bookings(id) ON DELETE CASCADE
);
