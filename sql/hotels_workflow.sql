CREATE TABLE IF NOT EXISTS hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    description TEXT,
    rating DOUBLE,
    imageUrl VARCHAR(500),
    amenities VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS hotel_rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    type VARCHAR(100) NOT NULL, -- Standard, Deluxe, Suite
    capacity INT DEFAULT 2,
    price_per_night DOUBLE NOT NULL,
    amenities VARCHAR(500),
    image_url VARCHAR(500),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hotel_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_code VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    guests INT DEFAULT 1,
    total_price DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'Confirmed',
    guest_name VARCHAR(255),
    guest_email VARCHAR(255),
    guest_phone VARCHAR(50),
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES hotel_rooms(id) ON DELETE CASCADE
);

INSERT INTO hotels (name, city, address, description, rating, imageUrl, amenities) VALUES 
('Ocean View Resort', 'Bali', '123 Beachfront Ave', 'Luxurious resort with ocean views', 4.8, 'images/hotel1.jpg', 'Pool,Spa,Free WiFi,Breakfast'),
('Mountain Retreat', 'Swiss Alps', '456 Alpine Road', 'Cozy cabin in the mountains', 4.5, 'images/hotel2.jpg', 'Fireplace,Ski Access,Free WiFi'),
('City Center Inn', 'New York', '789 Broadway', 'Conveniently located in the heart of the city', 4.2, 'images/hotel3.jpg', 'Gym,Bar,Free WiFi');

INSERT INTO hotel_rooms (hotel_id, type, capacity, price_per_night, amenities, image_url) VALUES 
(1, 'Standard Ocean View', 2, 150.0, 'AC,TV,Minibar', 'images/room1.jpg'),
(1, 'Deluxe Suite', 4, 300.0, 'AC,TV,Minibar,Balcony,Jacuzzi', 'images/room2.jpg'),
(2, 'Cozy Cabin', 2, 120.0, 'Heating,Kitchenette', 'images/room3.jpg'),
(3, 'Executive Room', 2, 200.0, 'AC,TV,Work Desk', 'images/room4.jpg');
