CREATE TABLE IF NOT EXISTS cab_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(100),
    vehicle_type VARCHAR(50),
    booking_type VARCHAR(50),
    pickup VARCHAR(255),
    dropoff VARCHAR(255),
    journey_date VARCHAR(50),
    journey_time VARCHAR(50),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cab_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES cab_bookings(id) ON DELETE CASCADE
);
