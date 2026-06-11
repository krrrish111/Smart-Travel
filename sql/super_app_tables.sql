CREATE TABLE IF NOT EXISTS train_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    from_station VARCHAR(100),
    to_station VARCHAR(100),
    journey_date DATE,
    train_class VARCHAR(50),
    quota VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'CONFIRMED',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pnr VARCHAR(50),
    train_name VARCHAR(100),
    train_number VARCHAR(20),
    departure_time VARCHAR(20),
    arrival_time VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS bus_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    from_city VARCHAR(100),
    to_city VARCHAR(100),
    journey_date DATE,
    bus_type VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'CONFIRMED',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operator_name VARCHAR(100),
    seat_numbers VARCHAR(100),
    departure_time VARCHAR(20),
    arrival_time VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS cab_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    pickup_location VARCHAR(200),
    drop_location VARCHAR(200),
    pickup_date DATE,
    pickup_time VARCHAR(20),
    cab_type VARCHAR(50),
    vehicle_type VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'CONFIRMED',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    driver_name VARCHAR(100),
    driver_contact VARCHAR(20),
    vehicle_number VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS cruise_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    departure_port VARCHAR(100),
    destination VARCHAR(100),
    cruise_date DATE,
    passengers INT,
    cabin_type VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'CONFIRMED',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cruise_line VARCHAR(100),
    ship_name VARCHAR(100),
    duration VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS helicopter_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    origin VARCHAR(100),
    destination VARCHAR(100),
    journey_date DATE,
    passengers INT,
    heli_class VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'CONFIRMED',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operator VARCHAR(100),
    departure_time VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS package_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    destination VARCHAR(100),
    duration VARCHAR(50),
    travel_date DATE,
    travellers INT,
    package_type VARCHAR(50),
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'CONFIRMED',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    package_name VARCHAR(200),
    inclusions TEXT
);
