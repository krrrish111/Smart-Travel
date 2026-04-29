-- ============================================================
-- VOYASTRA SEED DATA SCRIPT
-- Populates all key tables with realistic demo data
-- ============================================================

USE voyastra;

-- ============================================================
-- 1. DESTINATIONS
-- ============================================================
TRUNCATE TABLE trending_places;
TRUNCATE TABLE reviews;
DELETE FROM plans WHERE id > 1;
DELETE FROM destinations WHERE id > 0;
ALTER TABLE destinations AUTO_INCREMENT = 1;

INSERT INTO destinations (name, state, country, category, image, description, rating) VALUES
('Goa', 'Goa', 'India', 'Beach', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80', 'Golden beaches, vibrant nightlife, Portuguese heritage, and stunning sunsets make Goa the ultimate coastal escape.', 4.7),
('Manali', 'Himachal Pradesh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80', 'A high-altitude Himalayan resort town famous for its stunning landscapes, snow-capped peaks, and thrilling adventure sports.', 4.8),
('Jaipur', 'Rajasthan', 'India', 'Heritage', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80', 'The Pink City, home to magnificent forts, palaces, and vibrant bazaars that tell tales of the royal Rajputana era.', 4.6),
('Kerala Backwaters', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80', 'Serene network of lagoons, lakes, and canals with traditional houseboats, lush greenery, and tranquil village life.', 4.9),
('Varanasi', 'Uttar Pradesh', 'India', 'Spiritual', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80', 'One of the world\'s oldest cities, Varanasi is a spiritual epicenter on the banks of the sacred Ganges River.', 4.5),
('Ladakh', 'Ladakh', 'India', 'Adventure', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80', 'A remote high-altitude desert with dramatic landscapes, ancient monasteries, and some of the world\'s highest mountain passes.', 4.9),
('Andaman Islands', 'Andaman & Nicobar', 'India', 'Beach', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80', 'Pristine turquoise waters, white sand beaches, and rich marine biodiversity that make it a diver\'s paradise.', 4.8),
('Munnar', 'Kerala', 'India', 'Nature', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80', 'Rolling tea gardens stretching across misty hills, with refreshing cool air and breathtaking panoramic views.', 4.7),
('Agra', 'Uttar Pradesh', 'India', 'Heritage', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80', 'Home to the iconic Taj Mahal, a UNESCO World Heritage Site and one of the most recognized monuments on earth.', 4.6),
('Rishikesh', 'Uttarakhand', 'India', 'Adventure', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80', 'The yoga capital of the world, nestled in the Himalayan foothills where the Ganges flows swiftly through canyons.', 4.7);

-- ============================================================
-- 2. TRAVEL PLANS
-- ============================================================
DELETE FROM plan_days;
DELETE FROM plans;
ALTER TABLE plans AUTO_INCREMENT = 1;

INSERT INTO plans (title, destination_id, price, days, nights, category, description, image) VALUES
('Goa Beach Getaway', 1, 12500, 4, 3, 'Beach', 'A perfect 4-day beach vacation with water sports, shack dinners, and sunset cruises along the stunning Goan coastline.', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80'),
('Manali Snow Adventure', 2, 18000, 5, 4, 'Adventure', 'Experience the best of the Himalayas — skiing at Solang Valley, crossing Rohtang Pass, and staying in cozy mountain lodges.', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800&q=80'),
('Royal Rajasthan Circuit', 3, 22000, 6, 5, 'Heritage', 'Explore the grandeur of Rajasthan — Amber Fort, Hawa Mahal, City Palace, and vibrant Johari Bazaar shopping.', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80'),
('Kerala Houseboat Bliss', 4, 16500, 4, 3, 'Nature', 'Drift through the calm backwaters on a luxury houseboat, enjoy Ayurvedic massages, and savor authentic Kerala cuisine.', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80'),
('Spiritual Varanasi Trail', 5, 9500, 3, 2, 'Spiritual', 'Witness the sacred Ganga Aarti, sunrise boat rides, ancient ghats, and the mystical energy of one of India\'s holiest cities.', 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80'),
('Ladakh Expedition', 6, 35000, 8, 7, 'Adventure', 'The ultimate Ladakh experience — Pangong Lake, Nubra Valley, Khardung La Pass, and ancient Buddhist monasteries.', 'https://images.unsplash.com/photo-1600971522762-07be77aadf67?auto=format&fit=crop&w=800&q=80'),
('Andaman Dive & Relax', 7, 28000, 6, 5, 'Beach', 'Snorkeling at Coral Island, scuba diving at Elephant Beach, and relaxing on the pristine Radhanagar Beach.', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?auto=format&fit=crop&w=800&q=80'),
('Munnar Tea Trail', 8, 14000, 4, 3, 'Nature', 'Walk through sprawling tea estates, visit Eravikulam National Park, and enjoy breathtaking views at Mattupetty Dam.', 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=800&q=80'),
('Agra Heritage Tour', 9, 11000, 3, 2, 'Heritage', 'Visit the Taj Mahal at sunrise, explore Agra Fort, and discover the abandoned city of Fatehpur Sikri.', 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=800&q=80'),
('Rishikesh Yoga & Rafting', 10, 13500, 4, 3, 'Adventure', 'A soul-refreshing retreat with river rafting on Ganges rapids, yoga at an ashram, and cliff jumping at Neer Garh waterfall.', 'https://images.unsplash.com/photo-1591970413685-f0f6f0607f83?auto=format&fit=crop&w=800&q=80');

-- ============================================================
-- 3. PLAN DAY ITINERARIES
-- ============================================================
INSERT INTO plan_days (plan_id, day_number, title, description) VALUES
-- Goa (Plan 1)
(1, 1, 'Arrival & North Goa Beaches', 'Check in to beach resort, explore Baga and Calangute beaches, sunset at Sinquerim Fort, dinner at a beach shack.'),
(1, 2, 'Water Sports & Old Goa', 'Morning water sports at Baga Beach, visit Basilica of Bom Jesus, explore Old Goa churches, evening at Candolim.'),
(1, 3, 'South Goa & Sunset Cruise', 'Drive to serene Palolem and Agonda beaches, sunset cruise on the Mandovi River, farewell dinner.'),
(1, 4, 'Flea Market & Departure', 'Visit Anjuna Flea Market, buy souvenirs, check out and head to airport.'),

-- Manali (Plan 2)
(2, 1, 'Arrival in Manali', 'Arrive in Manali, check in to mountain lodge, explore Mall Road and Hadimba Temple.'),
(2, 2, 'Solang Valley Snow Fun', 'Full-day excursion to Solang Valley for skiing, snowboarding, and zorbing, bonfire at night.'),
(2, 3, 'Rohtang Pass Adventure', 'Early morning drive to Rohtang Pass, enjoy snow-capped views, photography, return by evening.'),
(2, 4, 'Old Manali & River Rafting', 'Explore Old Manali village, river rafting on Beas River, local cafe hopping.'),
(2, 5, 'Departure via Kullu', 'Visit Kullu Shawl factories, Raghunath Temple, depart.'),

-- Ladakh (Plan 6)
(6, 1, 'Arrival & Acclimatization', 'Arrive in Leh, rest for acclimatization, light walk around Leh Market and Namgyal Tsemo Monastery.'),
(6, 2, 'Leh City Tour', 'Visit Shanti Stupa, Leh Palace, Hall of Fame Museum. Short local sightseeing.'),
(6, 3, 'Nubra Valley Trip', 'Drive over Khardung La (world\'s highest motorable pass), arrive at Nubra Valley, Diskit Monastery.'),
(6, 4, 'Camel Safari & Sand Dunes', 'Double-humped Bactrian camel safari at Hunder Sand Dunes, overnight stay at Nubra camp.'),
(6, 5, 'Pangong Lake Day 1', 'Drive to Pangong Tso Lake, set up camp by the stunning blue lake.'),
(6, 6, 'Pangong Sunrise & Return', 'Witness magical sunrise over Pangong Lake, drive back to Leh.'),
(6, 7, 'Hemis & Thiksey Monasteries', 'Visit Hemis Monastery and Thiksey Gompa, sunset at Shey Palace.'),
(6, 8, 'Departure', 'Morning market shopping for Pashmina and local crafts, fly out from Leh Airport.');

-- ============================================================
-- 4. DEMO USERS (password = 'password123' bcrypt-hashed)
-- ============================================================
INSERT IGNORE INTO users (name, email, password, role, status) VALUES
('Arjun Mehta', 'arjun@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Priya Sharma', 'priya@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Rahul Singh', 'rahul@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Ananya Gupta', 'ananya@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Karan Joshi', 'karan@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active');

-- ============================================================
-- 5. REVIEWS
-- ============================================================
INSERT INTO reviews (user_id, destination_id, rating, comment) VALUES
(2, 1, 5, 'Goa is absolutely magical! The beaches, the food, the vibe — it was a perfect vacation. Voyastra made planning so easy!'),
(3, 2, 5, 'Manali in winter is breathtaking. The snow-covered peaks and the serenity of the valley is something else. Highly recommended!'),
(4, 6, 5, 'Ladakh changed my life. Pangong Lake at sunrise — words cannot describe it. The itinerary was spot on!'),
(5, 4, 4, 'The Kerala Backwaters houseboat experience was luxurious and peaceful. The food on board was exceptional!'),
(2, 3, 5, 'Jaipur\'s forts and palaces are awe-inspiring. The lighting at Amber Fort in the evening is a sight to behold!'),
(3, 5, 4, 'Varanasi is an overwhelming, humbling spiritual experience. The Ganga Aarti at sunrise is simply unforgettable.'),
(4, 7, 5, 'Andaman Islands are India\'s best-kept secret! Water visibility for snorkeling was crystal clear. Loved every moment.'),
(5, 8, 4, 'Munnar\'s tea gardens are picture-perfect. The cool misty mornings and views from Top Station are surreal!'),
(2, 9, 5, 'Seeing the Taj Mahal at sunrise was a dream come true. It''s even more beautiful in person. Truly iconic!'),
(3, 10, 5, 'Rishikesh fulfilled my need for adventure AND peace. Rafting in the rapids and then yoga by the Ganges — perfect balance!'),
(4, 1, 4, 'Great beaches, amazing seafood, and fun water sports. Goa is always a great idea. Will visit again!'),
(5, 2, 5, 'The views from Rohtang Pass are jaw-dropping. Manali is a must-visit for every adventure lover in India.');

-- ============================================================
-- 6. TRENDING PLACES
-- ============================================================
INSERT INTO trending_places (destination_id, rank_no, year) VALUES
(6, 1, 2026),
(4, 2, 2026),
(2, 3, 2026),
(7, 4, 2026),
(1, 5, 2026),
(3, 6, 2026),
(8, 7, 2026),
(10, 8, 2026);

-- ============================================================
-- 7. BOOKINGS (sample)
-- ============================================================
INSERT INTO bookings (user_id, plan_id, total_price, status) VALUES
(2, 1, 12500, 'confirmed'),
(3, 2, 18000, 'confirmed'),
(4, 6, 35000, 'pending'),
(5, 4, 16500, 'confirmed'),
(2, 7, 28000, 'confirmed');

-- ============================================================
-- 8. COMMUNITY POSTS
-- ============================================================
INSERT INTO posts (user_id, content, location) VALUES
(2, 'Just got back from Goa and I''m already missing those sunsets! 🌅 The beach shacks, the water sports, the people — Goa has a magic that is hard to explain. Voyastra planned everything perfectly!', 'Goa, India'),
(3, 'Pangong Lake at 4am is the most beautiful thing I have ever seen. The stars, the silence, the blue water — I cried happy tears 😭✨ #Ladakh #MustVisit', 'Pangong Lake, Ladakh'),
(4, 'Kerala backwaters on a houseboat is absolute serenity. No wifi, no noise — just coconut trees, birds, and the gentle sound of water. Pure bliss! 🌿', 'Alleppey, Kerala'),
(5, 'Rishikesh for solo travel is iconic. Did white water rafting in the morning and meditation at an ashram in the evening. My soul feels reset! 🙏', 'Rishikesh, Uttarakhand'),
(2, 'Manali in January: snow everywhere, piping hot Maggi, a bonfire at night, and mountains all around. This is what heaven looks like 🏔️❄️', 'Manali, Himachal Pradesh');

-- ============================================================
-- FINAL CHECKS
-- ============================================================
SELECT '=== SEED DATA SUMMARY ===' AS '';
SELECT 'destinations' AS table_name, COUNT(*) AS rows_inserted FROM destinations
UNION ALL SELECT 'plans', COUNT(*) FROM plans
UNION ALL SELECT 'plan_days', COUNT(*) FROM plan_days
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'trending_places', COUNT(*) FROM trending_places
UNION ALL SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL SELECT 'posts', COUNT(*) FROM posts;

SELECT '✅ Database seeded successfully! Voyastra is ready.' AS message;
