-- =============================================================================
-- Voyastra — Database Migration: Recreate `destinations` table
-- 
-- PURPOSE:  The remote Aiven MySQL `destinations` table has the wrong schema
--           (columns: name, state, country, image, description) vs what
--           DestinationDAO.java expects (title, destination, short_description,
--           price_inr, duration_days, duration_nights, image_url, etc.)
--
-- WARNING:  This script DROPS and RECREATES the destinations table.
--           All existing destination rows will be erased.
--           Run this ONCE against the production database.
--
-- USAGE:    mysql -h <host> -u <user> -p <db_name> < migrate_destinations.sql
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Drop dependent tables first to avoid FK constraint errors
DROP TABLE IF EXISTS destination_gallery;
DROP TABLE IF EXISTS destination_itineraries;
DROP TABLE IF EXISTS destination_bookings;
DROP TABLE IF EXISTS destinations;

-- Recreate destinations with the schema expected by DestinationDAO.java
CREATE TABLE destinations (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(255)    NOT NULL,
    destination      VARCHAR(255)    NOT NULL,
    category         VARCHAR(100)    DEFAULT 'Tour',
    short_description TEXT,
    full_description  TEXT,
    price_inr        DECIMAL(10,2)   DEFAULT 0.00,
    discount_price   DECIMAL(10,2)   DEFAULT 0.00,
    duration_days    INT             DEFAULT 3,
    duration_nights  INT             DEFAULT 2,
    best_season      VARCHAR(100)    DEFAULT 'October - March',
    starting_city    VARCHAR(100)    DEFAULT 'Delhi',
    image_url        VARCHAR(500),
    rating           FLOAT           DEFAULT 4.5,
    review_count     INT             DEFAULT 0,
    is_active        TINYINT(1)      DEFAULT 1,
    is_featured      TINYINT(1)      DEFAULT 0,
    latitude         DOUBLE,
    longitude        DOUBLE,
    highlights       TEXT,
    has_unesco       TINYINT(1)      DEFAULT 0,
    is_trending      TINYINT(1)      DEFAULT 0,
    is_popular       TINYINT(1)      DEFAULT 0,
    created_at       TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Recreate destination_itineraries
CREATE TABLE destination_itineraries (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    day_number      INT NOT NULL,
    title           VARCHAR(255),
    details         TEXT,
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Recreate destination_gallery
CREATE TABLE destination_gallery (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    image_url       VARCHAR(500),
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Recreate destination_bookings (referenced by DestinationBookingServlet)
CREATE TABLE destination_bookings (
    id                   VARCHAR(64)   PRIMARY KEY,
    user_id              INT           NOT NULL,
    destination_id       INT           NOT NULL,
    travel_date          DATE,
    adults               INT           DEFAULT 1,
    children             INT           DEFAULT 0,
    special_requests     TEXT,
    total_price          DECIMAL(10,2) DEFAULT 0.00,
    status               VARCHAR(50)   DEFAULT 'CONFIRMED',
    razorpay_order_id    VARCHAR(100),
    razorpay_payment_id  VARCHAR(100),
    created_at           TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (destination_id) REFERENCES destinations(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- SEED DATA — 25 Indian Tour Destinations
-- =============================================================================

INSERT INTO destinations
    (title, destination, category, short_description, full_description, price_inr, discount_price,
     duration_days, duration_nights, best_season, starting_city,
     image_url, rating, review_count, is_active, is_featured, is_trending, is_popular,
     has_unesco, highlights, latitude, longitude)
VALUES
('Golden Triangle Tour', 'Delhi, Agra & Jaipur, India', 'Heritage',
 'Discover the iconic trio — Taj Mahal, Amber Fort and Red Fort in one unforgettable circuit.',
 'Explore three of India''s most iconic cities: Delhi, the capital with its Mughal heritage; Agra, home to the world-famous Taj Mahal; and Jaipur, the Pink City with its majestic Amber Fort. This is India''s most popular cultural circuit.',
 18999, 15999, 5, 4, 'October - March', 'Delhi',
 'https://images.unsplash.com/photo-1524492412937-b28074a47d70?auto=format&fit=crop&w=600&q=80',
 4.8, 2850, 1, 1, 1, 1, 1, 'Taj Mahal, Amber Fort, India Gate, Qutub Minar', 27.1767, 78.0081),

('Kerala Backwaters Escape', 'Kerala, India', 'Nature',
 'Cruise through serene backwaters, lush paddy fields, and tranquil lagoons in God''s Own Country.',
 'Kerala is renowned for its network of backwater canals, beaches, and Ayurveda retreats. Stay on a traditional houseboat (kettuvallam), enjoy kathakali dance performances, and explore spice plantations in Munnar.',
 22999, 18999, 6, 5, 'September - March', 'Kochi',
 'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?auto=format&fit=crop&w=600&q=80',
 4.9, 3120, 1, 1, 1, 1, 0, 'Alleppey Backwaters, Munnar Tea Gardens, Kovalam Beach, Ayurveda Spa', 9.4981, 76.9462),

('Rajasthan Royal Odyssey', 'Rajasthan, India', 'Heritage',
 'Majestic forts, desert safaris, camel rides and royal heritage await in the Land of Kings.',
 'Rajasthan is India''s largest state and one of its most colourful. This package covers Jaipur, Jodhpur, Udaipur, and Jaisalmer — from palace hotels to desert camps, this is the ultimate royal India experience.',
 29999, 24999, 8, 7, 'October - February', 'Jaipur',
 'https://images.unsplash.com/photo-1477587458883-47145ed31328?auto=format&fit=crop&w=600&q=80',
 4.7, 1980, 1, 1, 1, 1, 0, 'City Palace, Mehrangarh Fort, Lake Pichola, Jaisalmer Desert Camp', 26.9124, 70.9121),

('Goa Beach Paradise', 'Goa, India', 'Beach',
 'Sun, sand, seafood and Portuguese heritage along India''s most famous coastline.',
 'Goa offers a perfect mix of golden beaches, vibrant nightlife, historic churches, and fresh seafood. From North Goa''s party beaches to South Goa''s serene coves, every traveller finds their rhythm here.',
 14999, 11999, 4, 3, 'November - February', 'Mumbai',
 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80',
 4.6, 4200, 1, 1, 1, 1, 0, 'Calangute Beach, Basilica of Bom Jesus, Dudhsagar Falls, Spice Plantations', 15.2993, 74.1240),

('Ladakh High Altitude Adventure', 'Ladakh, India', 'Adventure',
 'The Land of High Passes — moonscapes, monasteries and crystal-clear mountain lakes at 11,000 ft.',
 'Ladakh is one of the world''s most spectacular destinations. Experience the stark beauty of Pangong Lake, ancient Tibetan monasteries, Nubra Valley''s double-humped camels, and the adrenaline of riding on some of the world''s highest motorable roads.',
 34999, 29999, 7, 6, 'June - September', 'Delhi',
 'https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&w=600&q=80',
 4.9, 1650, 1, 1, 1, 1, 0, 'Pangong Lake, Nubra Valley, Khardung La Pass, Diskit Monastery', 34.1526, 77.5770),

('Shimla & Manali Hill Retreat', 'Himachal Pradesh, India', 'Hill Station',
 'Colonial charm meets snow-capped peaks in this iconic Himalayan escape.',
 'Shimla, the former summer capital of British India, retains its Victorian charm with beautiful heritage buildings. Manali offers adventure sports, the Solang Valley, and the gateway to Spiti. A perfect summer getaway from the plains.',
 19999, 16499, 6, 5, 'April - June', 'Delhi',
 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=600&q=80',
 4.6, 2780, 1, 1, 0, 1, 0, 'Mall Road Shimla, Rohtang Pass, Hadimba Temple, Solang Valley', 32.2396, 77.1887),

('Varanasi Spiritual Journey', 'Varanasi, Uttar Pradesh, India', 'Spiritual',
 'Experience the eternal city — Ganga Aarti, ancient ghats and the soul of Hindu civilization.',
 'Varanasi, one of the world''s oldest continuously inhabited cities, is the spiritual heart of India. Witness the mesmerizing Ganga Aarti ceremony at Dashashwamedh Ghat, take an early morning boat ride on the Ganges, and explore centuries-old temples.',
 12999, 9999, 4, 3, 'October - March', 'Delhi',
 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?auto=format&fit=crop&w=600&q=80',
 4.7, 1920, 1, 1, 0, 1, 1, 'Dashashwamedh Ghat, Kashi Vishwanath Temple, Sarnath, Morning Boat Ride', 25.3176, 82.9739),

('Andaman Island Explorer', 'Andaman & Nicobar Islands, India', 'Beach',
 'Crystal-clear turquoise waters, white sand beaches and vibrant coral reefs in the Bay of Bengal.',
 'The Andaman Islands are India''s tropical paradise. Explore the pristine beaches of Havelock Island, snorkel among rainbow-coloured reefs at Elephant Beach, visit the historic Cellular Jail in Port Blair, and enjoy bioluminescent plankton at night.',
 37999, 31999, 6, 5, 'October - May', 'Chennai',
 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=600&q=80',
 4.9, 1340, 1, 1, 1, 1, 0, 'Radhanagar Beach, Cellular Jail, Elephant Beach Snorkeling, Ross Island', 11.7401, 92.6586),

('Darjeeling & Sikkim Tea Trail', 'West Bengal & Sikkim, India', 'Hill Station',
 'Toy trains, tea gardens and views of Kangchenjunga — India''s most charming hill escape.',
 'Darjeeling is famous for its tea estates, the UNESCO-listed Darjeeling Himalayan Railway (Toy Train), and stunning sunrise views over the Himalayas from Tiger Hill. The neighbouring state of Sikkim adds monasteries and Yumthang Valley to the itinerary.',
 21999, 17999, 7, 6, 'March - May', 'Kolkata',
 'https://images.unsplash.com/photo-1544085311-11a028465b03?auto=format&fit=crop&w=600&q=80',
 4.7, 1080, 1, 0, 0, 1, 1, 'Tiger Hill Sunrise, Darjeeling Toy Train, Rumtek Monastery, Yumthang Valley', 27.0410, 88.2663),

('Hampi Heritage & Ruins', 'Karnataka, India', 'Heritage',
 'Walk among the spectacular ruins of the Vijayanagara Empire — a UNESCO World Heritage Site.',
 'Hampi is a surreal landscape of massive boulders, ancient temples, and banana groves by the Tungabhadra River. The ruins of the Vijayanagara Empire (14th-17th century) span 26 sq km and include the magnificent Virupaksha Temple and Vittala Temple with its famous Stone Chariot.',
 16999, 13999, 4, 3, 'October - February', 'Bengaluru',
 'https://images.unsplash.com/photo-1598091383021-15ddea10925d?auto=format&fit=crop&w=600&q=80',
 4.8, 890, 1, 0, 1, 1, 1, 'Virupaksha Temple, Stone Chariot, Vittala Temple, Matanga Hill Sunset', 15.3350, 76.4600),

('Coorg Coffee Country', 'Karnataka, India', 'Nature',
 'Misty hills, coffee plantations, spice gardens and roaring waterfalls in India''s Scotland.',
 'Coorg (Kodagu) is Karnataka''s most scenic district, blanketed in coffee and cardamom plantations. Known for its crisp air, thick forests, and the brave Kodava culture, it''s perfect for trekking, wildlife spotting at Nagarhole, and white-water rafting on the Barapole River.',
 17999, 14499, 4, 3, 'October - March', 'Bengaluru',
 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=600&q=80',
 4.6, 1240, 1, 0, 0, 1, 0, 'Abbey Falls, Raja''s Seat, Coffee Plantation Tour, Nagarhole Wildlife', 12.4244, 75.7382),

('Udaipur — City of Lakes', 'Rajasthan, India', 'Heritage',
 'The most romantic city in India — white marble palaces, serene lakes and sunset boat rides.',
 'Udaipur is often called the Venice of the East. The City Palace rises magnificently over Lake Pichola, and the island palace Jag Mandir glows golden in the evening. Enjoy boat rides, vintage car museums, and the Bagore Ki Haveli cultural show.',
 19999, 16499, 4, 3, 'October - March', 'Jaipur',
 'https://images.unsplash.com/photo-1477587458883-47145ed31328?auto=format&fit=crop&w=600&q=80',
 4.8, 1620, 1, 1, 0, 1, 0, 'City Palace, Lake Pichola Boat Ride, Jag Mandir, Saheliyon Ki Bari', 24.5854, 73.7125),

('Rann of Kutch White Desert', 'Gujarat, India', 'Nature',
 'The world''s largest salt desert glows white under the full moon at the Rann Utsav festival.',
 'The Great Rann of Kutch is one of the world''s largest seasonal salt marshes. During winter, the Rann Utsav (festival) transforms the area into a cultural extravaganza under star-lit skies. Visit the UNESCO-tentative Dholavira archaeological site and the Flamingo City.',
 23999, 19999, 5, 4, 'November - February', 'Ahmedabad',
 'https://images.unsplash.com/photo-1519955266818-0231b4371449?auto=format&fit=crop&w=600&q=80',
 4.7, 980, 1, 0, 1, 0, 0, 'White Rann, Rann Utsav Festival, Dholavira, Flamingo Sanctuary', 23.7337, 70.2173),

('Khajuraho Temples & Wildlife', 'Madhya Pradesh, India', 'Heritage',
 'Marvel at the intricate erotic sculpture of Khajuraho temples and explore Panna tiger reserve.',
 'Khajuraho''s group of medieval Hindu and Jain temples are famous for their Nagara-style architecture and erotic sculpture carvings. The UNESCO World Heritage complex contains 25 surviving temples. Combine with Panna National Park for tiger and leopard sightings.',
 17999, 14499, 5, 4, 'October - March', 'Delhi',
 'https://images.unsplash.com/photo-1603862088539-d5e617d6c8f3?auto=format&fit=crop&w=600&q=80',
 4.6, 760, 1, 0, 0, 0, 1, 'Western Temple Group, Eastern Temples, Panna Tiger Reserve, Ken Ghariyal Sanctuary', 24.8318, 79.9199),

('Northeast India Tribal Explorer', 'Meghalaya, Nagaland & Assam, India', 'Adventure',
 'Living root bridges, world''s wettest village, hornbill festival and Kaziranga rhinos.',
 'The Seven Sisters of Northeast India remain one of the country''s best-kept secrets. Explore the living root bridges of Meghalaya, the indigenous tribes of Nagaland during the Hornbill Festival, and the UNESCO-listed Kaziranga National Park, home to two-thirds of the world''s one-horned rhinoceros.',
 39999, 34999, 9, 8, 'October - April', 'Guwahati',
 'https://images.unsplash.com/photo-1541544537156-7627a7a4aa1c?auto=format&fit=crop&w=600&q=80',
 4.8, 540, 1, 0, 1, 0, 0, 'Living Root Bridges, Kaziranga Rhinos, Hornbill Festival, Cherrapunji Waterfalls', 25.5788, 91.8933),

('Rishikesh Yoga & Adventure', 'Uttarakhand, India', 'Adventure',
 'Yoga capital of the world meets white-water rafting on the Ganges — body and soul recharge.',
 'Rishikesh sits at the foothills of the Himalayas where the Ganges flows clear. Attend sunrise yoga and meditation at an ashram, brave Grade IV rapids on the Ganges, bungee jump from 83 metres, and attend the Ganga Aarti at Triveni Ghat.',
 14999, 11499, 4, 3, 'February - May', 'Delhi',
 'https://images.unsplash.com/photo-1545389336-cf090694435e?auto=format&fit=crop&w=600&q=80',
 4.7, 2140, 1, 0, 1, 1, 0, 'Ganga Aarti, White-Water Rafting, Laxman Jhula, Yoga Ashrams, Bungee Jumping', 30.0869, 78.2676),

('Munnar & Thekkady Spice Trail', 'Kerala, India', 'Nature',
 'Tea-carpeted hills, elephant safaris in Periyar and spice plantation walks in the Western Ghats.',
 'Munnar is a lush hill station at 1,600 metres with rolling tea estates. Thekkady''s Periyar Wildlife Sanctuary offers boat rides past wild elephants and bison. This package combines the green serenity of the Western Ghats with a spice plantation cooking experience.',
 21999, 17999, 5, 4, 'September - March', 'Kochi',
 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=600&q=80',
 4.8, 1380, 1, 0, 0, 1, 0, 'Munnar Tea Gardens, Eravikulam National Park, Periyar Elephant Safari, Spice Plantation Tour', 9.8616, 77.0597),

('Mysore Palace & Coorg Combo', 'Karnataka, India', 'Heritage',
 'Royal grandeur of Mysore palace combined with the misty coffee hills of Coorg.',
 'Mysore is home to the magnificent Mysore Palace, one of India''s most visited monuments. The palace is brilliantly illuminated on Sunday evenings. Combine with Coorg''s coffee estates for a perfect Karnataka weekend break.',
 18999, 15499, 5, 4, 'September - February', 'Bengaluru',
 'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=600&q=80',
 4.7, 1190, 1, 0, 0, 1, 0, 'Mysore Palace, Chamundi Hills, Brindavan Gardens, Coffee Plantation, Abbey Falls', 12.3051, 76.6551),

('Lakshadweep Coral Island', 'Lakshadweep, India', 'Beach',
 'India''s most pristine island chain with virgin coral reefs, lagoons and snorkelling paradise.',
 'Lakshadweep — Sanskrit for "one hundred thousand islands" — is India''s smallest Union Territory and the most pristine tropical archipelago. Access is restricted to protect its fragile ecosystem. Enjoy kayaking, snorkelling, and glass-bottom boat rides over live coral gardens.',
 49999, 42999, 5, 4, 'October - May', 'Kochi',
 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=600&q=80',
 4.9, 420, 1, 1, 1, 0, 0, 'Agatti Island, Bangaram Atoll, Coral Snorkelling, Kayaking, Lagoon Camping', 10.5667, 72.6417),

('Spiti Valley Monastery Circuit', 'Himachal Pradesh, India', 'Adventure',
 'The hidden valley — ancient cliff-top monasteries, cosmic landscapes and zero light pollution.',
 'Spiti is a high-altitude cold desert valley in the Himalayas, often called a "Little Tibet". Home to the world''s highest motorable village (Komic), 1000-year-old monasteries like Ki and Tabo, and some of the darkest night skies in Asia, this is the ultimate off-grid adventure.',
 32999, 27999, 8, 7, 'June - September', 'Chandigarh',
 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=600&q=80',
 4.8, 680, 1, 0, 1, 0, 0, 'Ki Monastery, Tabo Monastery, Chandratal Lake, Komic Village, Kaza', 31.9020, 78.0330),

('Konark & Puri Temple Circuit', 'Odisha, India', 'Spiritual',
 'The UNESCO Sun Temple of Konark and sacred Puri Jagannath — Odisha''s divine coast.',
 'Odisha''s coastline is lined with ancient temples. The Konark Sun Temple (UNESCO World Heritage Site) is an architectural marvel shaped like a giant chariot of the Sun God. Nearby Puri is one of Hinduism''s four sacred dhams, home to the Jagannath Temple and a beautiful beach.',
 15999, 12999, 4, 3, 'October - February', 'Bhubaneswar',
 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=600&q=80',
 4.6, 870, 1, 0, 0, 0, 1, 'Konark Sun Temple, Puri Jagannath Temple, Puri Beach, Chilika Lake Flamingos', 19.8876, 86.0944),

('Jim Corbett Wildlife Safari', 'Uttarakhand, India', 'Adventure',
 'Track the Bengal tiger in India''s oldest national park in the Himalayan foothills.',
 'Jim Corbett National Park is India''s oldest and most famous national park. Home to over 200 tigers, it offers jeep and elephant safaris through diverse landscapes of grassland, riverine belts, and dense forest. The Ramganga river adds to the scenic splendour.',
 19999, 16499, 3, 2, 'November - June', 'Delhi',
 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?auto=format&fit=crop&w=600&q=80',
 4.7, 1560, 1, 0, 1, 1, 0, 'Tiger Safari, Elephant Rides, Ramganga River, Corbett Museum, Bird Watching', 29.5300, 78.9800),

('Mahabalipuram & Pondicherry', 'Tamil Nadu, India', 'Heritage',
 'Rock-cut temples from 7th century India plus French colonial charm and beach town bliss.',
 'Mahabalipuram (Mamallapuram) is a UNESCO World Heritage Site with remarkable Pallava-era rock-cut temples carved from a single granite outcrop. A short drive away, Pondicherry (Puducherry) enchants with its French Quarter, yellow colonial buildings, and the Sri Aurobindo Ashram.',
 16999, 13499, 5, 4, 'October - March', 'Chennai',
 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=600&q=80',
 4.6, 1030, 1, 0, 0, 1, 1, 'Shore Temple, Arjuna''s Penance, French Quarter, Auroville, Paradise Beach', 12.6200, 80.1927),

('Valley of Flowers Trek', 'Uttarakhand, India', 'Adventure',
 'A UNESCO World Heritage trek through alpine meadows blooming with 500+ species of wildflowers.',
 'The Valley of Flowers National Park is a UNESCO World Heritage Site located in the Western Himalayas. During the monsoon season (July-September), the high-altitude valley bursts into a carpet of 500+ species of wildflowers. The trek also passes Hemkund Sahib, the world''s highest gurudwara.',
 27999, 23999, 6, 5, 'July - September', 'Rishikesh',
 'https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=600&q=80',
 4.9, 560, 1, 0, 1, 0, 1, 'Valley of Flowers, Hemkund Sahib, Ghangaria Base Camp, Pushpawati River', 30.7280, 79.5910),

('Jaisalmer Desert Safari', 'Rajasthan, India', 'Adventure',
 'Camel treks, sand dune sunsets and nights under a billion stars in the Thar Desert.',
 'Jaisalmer, the "Golden City", rises from the Thar Desert like a mirage. The golden sandstone Jaisalmer Fort — a UNESCO World Heritage Site — is one of the few living forts in the world. Experience sunset camel safaris, overnight desert camps, and folk music under the stars at Sam Sand Dunes.',
 21999, 17999, 4, 3, 'October - February', 'Jaipur',
 'https://images.unsplash.com/photo-1605640840605-14ac1855827b?auto=format&fit=crop&w=600&q=80',
 4.8, 1780, 1, 1, 1, 1, 1, 'Jaisalmer Fort, Sam Sand Dunes, Camel Safari, Desert Camp, Patwon Ki Haveli', 26.9157, 70.9083);

-- Seed itineraries for Golden Triangle Tour (id=1)
INSERT INTO destination_itineraries (destination_id, day_number, title, details) VALUES
(1, 1, 'Arrive in Delhi', 'Check-in and evening walk along Rajpath to India Gate. Dinner at Bukhara or Karim''s.'),
(1, 2, 'Delhi Sightseeing', 'Red Fort, Jama Masjid, Qutub Minar, Humayun''s Tomb. Evening flight/train to Agra.'),
(1, 3, 'Agra — Taj Mahal', 'Sunrise at the Taj Mahal, Agra Fort, and Itmad-ud-Daula. Afternoon drive to Jaipur.'),
(1, 4, 'Jaipur Sightseeing', 'Amber Fort, City Palace, Jantar Mantar, Hawa Mahal. Pink City market shopping.'),
(1, 5, 'Departure', 'Morning at leisure. Transfer to Jaipur airport for onward journey.');

-- =============================================================================
-- END OF MIGRATION
-- =============================================================================
