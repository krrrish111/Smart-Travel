CREATE VIEW flight_bookings AS SELECT * FROM bookings WHERE type = 'flight';
CREATE VIEW car_bookings AS SELECT * FROM bookings WHERE type = 'car';
CREATE VIEW tour_bookings AS SELECT * FROM bookings WHERE type = 'tour';
