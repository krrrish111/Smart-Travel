USE voyastra;
CREATE TABLE IF NOT EXISTS train_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10),
    berth_preference VARCHAR(20)
);
