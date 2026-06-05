CREATE TABLE IF NOT EXISTS hotel_search_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    destination VARCHAR(255),
    check_in DATE,
    check_out DATE,
    rooms INT DEFAULT 1,
    adults INT DEFAULT 1,
    children INT DEFAULT 0,
    hotel_type VARCHAR(255),
    amenities VARCHAR(500),
    search_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);