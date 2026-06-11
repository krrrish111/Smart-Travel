CREATE TABLE IF NOT EXISTS car_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    car_model VARCHAR(100),
    vehicle_type VARCHAR(50),
    pickup_city VARCHAR(255),
    pickup_date VARCHAR(50),
    return_date VARCHAR(50),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS car_customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    dl_path VARCHAR(255),
    FOREIGN KEY (booking_id) REFERENCES car_bookings(id) ON DELETE CASCADE
);
