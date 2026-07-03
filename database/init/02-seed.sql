USE voyastra;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Seed Users (passwords are 'Admin@123' hashed with bcrypt)
INSERT IGNORE INTO users (name, email, password, role, is_verified, wallet_balance, loyalty_points) VALUES
('Voyastra Admin', 'admin@voyastra.com', '$2a$12$OhufE14IFnHVGNvDtOlTKOuEYohGZD/HUV6CUEBioKhevSiRdcbIu', 'ADMIN', TRUE, 5000.0, 1000),
('Test User', 'user@voyastra.com', '$2a$12$OhufE14IFnHVGNvDtOlTKOuEYohGZD/HUV6CUEBioKhevSiRdcbIu', 'USER', TRUE, 1500.0, 200);

-- 2. Seed Destinations
INSERT IGNORE INTO destinations (id, name, state, country, category, image, description, rating) VALUES
(1, 'Goa', 'Goa', 'India', 'Beach', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80', 'Golden beaches, vibrant nightlife, Portuguese heritage, and stunning sunsets.', 4.7),
(2, 'Manali', 'Himachal Pradesh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80', 'High-altitude Himalayan resort town famous for its stunning landscapes.', 4.8),
(3, 'Jaipur', 'Rajasthan', 'India', 'Heritage', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80', 'The Pink City, home to magnificent forts, palaces, and vibrant bazaars.', 4.6),
(4, 'Kerala Backwaters', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80', 'Serene network of lagoons, lakes, and canals with traditional houseboats.', 4.9),
(5, 'Varanasi', 'Uttar Pradesh', 'India', 'Spiritual', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80', 'One of the world oldest cities, a spiritual epicenter on the Ganges.', 4.5),
(6, 'Ladakh', 'Ladakh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80', 'Remote high-altitude desert with dramatic landscapes and ancient monasteries.', 4.9),
(7, 'Andaman Islands', 'Andaman & Nicobar', 'India', 'Beach', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80', 'Pristine turquoise waters, white sand beaches, and rich marine biodiversity.', 4.8),
(8, 'Munnar', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80', 'Rolling tea gardens across misty hills with breathtaking panoramic views.', 4.7),
(9, 'Agra', 'Uttar Pradesh', 'India', 'Heritage', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80', 'Home to the iconic Taj Mahal, a UNESCO World Heritage Site.', 4.6),
(10, 'Rishikesh', 'Uttarakhand', 'India', 'Adventure', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80', 'The yoga capital of the world, nestled in the Himalayan foothills.', 4.7);

-- 3. Seed Plans
INSERT IGNORE INTO plans (id, title, destination_id, price, days, nights, category, description, image) VALUES
(1, 'Goa Beach Getaway', 1, 12500, 4, 3, 'Beach', 'A perfect 4-day beach vacation with water sports and sunset cruises.', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80'),
(2, 'Manali Snow Adventure', 2, 18000, 5, 4, 'Adventure', 'Experience the best of the Himalayas skiing and mountain lodges.', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80'),
(3, 'Royal Rajasthan Circuit', 3, 22000, 6, 5, 'Heritage', 'Explore Amber Fort, Hawa Mahal, City Palace, and Johari Bazaar.', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80'),
(4, 'Kerala Houseboat Bliss', 4, 16500, 4, 3, 'Nature', 'Drift through calm backwaters on a luxury houseboat.', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80'),
(5, 'Spiritual Varanasi Trail', 5, 9500, 3, 2, 'Spiritual', 'Witness the sacred Ganga Aarti and sunrise boat rides on the Ganges.', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80'),
(6, 'Ladakh Expedition', 6, 35000, 8, 7, 'Adventure', 'Pangong Lake, Nubra Valley, Khardung La Pass, and monasteries.', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80'),
(7, 'Andaman Dive & Relax', 7, 28000, 6, 5, 'Beach', 'Snorkeling at Coral Island and scuba diving at Elephant Beach.', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80'),
(8, 'Munnar Tea Trail', 8, 14000, 4, 3, 'Nature', 'Walk through sprawling tea estates and visit Eravikulam National Park.', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80'),
(9, 'Agra Heritage Tour', 9, 11000, 3, 2, 'Heritage', 'Taj Mahal at sunrise, Agra Fort, and Fatehpur Sikri.', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80'),
(10, 'Rishikesh Yoga & Rafting', 10, 13500, 4, 3, 'Adventure', 'River rafting on Ganges rapids and yoga at an ashram.', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80');

-- 4. Seed Plan Days
INSERT IGNORE INTO plan_days (plan_id, day_number, title, activities) VALUES
(1, 1, 'Arrival in Goa', 'Check-in to beach resort, leisure time at Baga Beach, evening sunset walk.'),
(1, 2, 'North Goa Sightseeing', 'Visit Fort Aguada, Chapora Fort, and enjoy water sports at Calangute Beach.'),
(1, 3, 'South Goa Cultural Tour', 'Explore Basilica of Bom Jesus, Se Cathedral, and Miramar beach cruise.'),
(1, 4, 'Departure', 'Souvenir shopping at Panaji local market and departure transfer.'),
(2, 1, 'Arrival & Acclimatization', 'Arrival in Manali, check-in to lodge, stroll along Mall Road.'),
(2, 2, 'Solang Valley Adventure', 'Paragliding, zorbing, and beautiful snow sights in Solang.'),
(2, 3, 'Rohtang Pass Tour', 'Spectacular high altitude views, snow scooter rides, and photography.'),
(2, 4, 'Hadimba Temple & Local Sightseeing', 'Visit ancient Hadimba Temple, Vashisht Hot Springs, and Club House.'),
(2, 5, 'Departure', 'Check out and depart towards Chandigarh/Delhi.');

-- 5. Seed Hotels
INSERT IGNORE INTO hotels (id, name, city, country, address, description, imageUrl, price_per_night, rating, amenities, latitude, longitude, best_seller, recommended, starting_price) VALUES
(1, 'Oceanview Retreat', 'Bali', 'Indonesia', '123 Beachfront Ave', 'Beautiful ocean views beachfront resort.', 'https://images.unsplash.com/photo-1522798514-97ceb8c4f1c8?auto=format&fit=crop&w=800', 250.00, 4.8, 'WiFi,Pool,Spa', -8.409518, 115.188919, TRUE, TRUE, 250.0),
(2, 'Alpine Lodge', 'Zurich', 'Switzerland', '45 Mountain Rd', 'Cozy lodge nestled in the Swiss Alps.', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800', 300.00, 4.7, 'WiFi,Heater,Ski', 47.3769, 8.5417, FALSE, TRUE, 300.0),
(3, 'Urban Boutique', 'Tokyo', 'Japan', '789 Downtown St', 'Modern and sleek stay in the heart of Tokyo.', 'https://images.unsplash.com/photo-1512453979436-5a50ce8c5d18?auto=format&fit=crop&w=800', 200.00, 4.9, 'WiFi,Gym,Bar', 35.6762, 139.6503, TRUE, TRUE, 200.0),
(4, 'Desert Oasis', 'Dubai', 'UAE', '101 Sand Dunes Blvd', 'Luxury and tranquility in the desert dunes.', 'https://images.unsplash.com/photo-1542314831-c6a4d27ece50?auto=format&fit=crop&w=800', 500.00, 4.9, 'WiFi,Pool,Air Conditioning', 25.2048, 55.2708, TRUE, TRUE, 500.0),
(5, 'Historic Palace', 'Rome', 'Italy', '222 Colosseum Way', 'Grand, classical palace experience near historical landmarks.', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800', 180.00, 4.6, 'WiFi,Restaurant,Tour', 41.9028, 12.4964, FALSE, TRUE, 180.0);

-- 6. Seed Hotel Rooms
INSERT IGNORE INTO hotel_rooms (id, hotel_id, type, capacity, price_per_night, amenities, image_url) VALUES
(1, 1, 'Deluxe Ocean Room', 2, 250.00, 'Ocean view, WiFi, AC, King Bed', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=500'),
(2, 1, 'Executive Beach Suite', 3, 400.00, 'Plunge pool, WiFi, Butler service', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500'),
(3, 2, 'Cozy Chalet Room', 2, 300.00, 'Mountain view, Heater, Balcony', 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=500'),
(4, 3, 'Standard Cozy Room', 2, 200.00, 'City view, WiFi, AC', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500');

-- 7. Seed Activities
INSERT IGNORE INTO activities (id, title, hero_image, description, location, price, duration_minutes, rating, review_count, highlights) VALUES
(1, 'River Rafting', 'https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format,compress&fit=crop&w=800', 'Navigate the thrilling rapids of the Ganges with expert guides.', 'Rishikesh, Uttarakhand', 1500.00, 180, 4.8, 342, 'Grade 3 Rapids|Safety Gear Included|Professional Guide'),
(2, 'Ganga Aarti', 'https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format,compress&fit=crop&w=800', 'Experience the spiritual and mesmerizing Ganga Aarti at Dashashwamedh Ghat.', 'Varanasi, UP', 0.00, 60, 4.9, 1024, 'Spiritual Chants|Evening Views|Cultural Heritage'),
(3, 'Nightlife & Beaches', 'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format,compress&fit=crop&w=800', 'Enjoy the vibrant nightlife and pristine sandy beaches of Goa.', 'Goa', 2000.00, 240, 4.7, 512, 'Live Music|Beach Shacks|Fire Shows'),
(4, 'Taj Mahal Tour', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format,compress&fit=crop&w=800', 'A guided tour of the iconic Taj Mahal, a symbol of eternal love.', 'Agra, UP', 1100.00, 120, 4.9, 2048, 'Skip-the-line Entry|Historical Insights|Photography Spots');

-- 8. Seed Site Content
INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) VALUES
('hero', 'Experience Voyastra', 'Say goodbye to endless research. Our intelligent platform crafts hyper-personalized itineraries.', TRUE, 1),
('promotion', 'Summer Special: 20% Off', 'Use code SUMMER20 for all European trips.', TRUE, 2),
('announcement', 'New Destinations Added!', 'Explore our latest travel packages now.', TRUE, 3);

-- 9. Seed Flights
INSERT IGNORE INTO flights (flight_number, airline, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
('VY-101', 'Voyastra Air', 'Delhi', 'Goa', '2026-08-15 06:00:00', '2026-08-15 08:30:00', 4500.00, 60),
('VY-102', 'Voyastra Air', 'Mumbai', 'Delhi', '2026-08-16 14:00:00', '2026-08-16 16:15:00', 3200.00, 60),
('VY-103', 'Voyastra Air', 'Delhi', 'Zurich', '2026-09-01 02:00:00', '2026-09-01 08:30:00', 48000.00, 60),
('VY-104', 'Voyastra Air', 'Delhi', 'Tokyo', '2026-09-10 22:30:00', '2026-09-11 07:30:00', 35000.00, 60);

-- 10. Seed Community Posts
INSERT IGNORE INTO posts (id, user_id, content, location, category) VALUES
(1, 2, 'Misty mornings in Manali - Waking up to snowy mountain peaks and warm chai is something else. Highly recommend visiting Old Manali!', 'Manali', 'Adventure'),
(2, 2, 'Sunset cruise in Goa - Breathtaking golden hour views from the Mandovi river cruise. Totally worth it!', 'Goa', 'For You');

SET FOREIGN_KEY_CHECKS = 1;
