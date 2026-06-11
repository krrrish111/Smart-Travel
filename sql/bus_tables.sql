CREATE TABLE IF NOT EXISTS bus_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    bus_name VARCHAR(100),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bus_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    seat_preference VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES bus_bookings(id) ON DELETE CASCADE
);
