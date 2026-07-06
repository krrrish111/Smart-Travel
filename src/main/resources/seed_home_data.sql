SET FOREIGN_KEY_CHECKS = 0;

-- Clean existing data in the target tables to avoid duplicate entries when re-running
DELETE FROM trip_plans;
DELETE FROM trip_itinerary;
DELETE FROM trip_inclusions;
DELETE FROM trip_gallery;

-- Delete seeded hotels and activities to prevent primary key constraint violations
DELETE FROM hotels WHERE id >= 6;
DELETE FROM activities WHERE id >= 5;

-- 1. Seed 15 Trip Plans
INSERT INTO trip_plans 
    (id, title, slug, destination, short_description, full_description, duration, price_inr, discount_price, image_url, rating, category, best_season, starting_city, featured) 
VALUES
(1, 'Kashmir Paradise Tour', 'kashmir-paradise-tour', 'Srinagar, Gulmarg & Pahalgam', 'Experience heaven on earth: houseboats, snow peaks and saffron fields.', 'A breathtaking 6-day journey through the gorgeous Kashmir Valley. Stay in a traditional luxury houseboat on Dal Lake, ride the Gulmarg Gondola over snowy peaks, and enjoy horse riding through the meadows of Pahalgam.', '6 Days', 24999.00, 21999.00, 'https://images.unsplash.com/photo-1566837430541-75e53e29f85c?auto=format&fit=crop&w=600&q=80', 4.9, 'Luxury', 'March - October', 'Delhi', 1),
(2, 'Goa Coastal Adventure', 'goa-coastal-adventure', 'North & South Goa', 'Water sports, beach parties, spice plantations and historical churches.', 'Explore the sun-kissed beaches of Goa. This 5-day package covers water sports like parasailing and jet skiing at Baga Beach, a cultural spice plantation tour with lunch, and exploring the Portuguese architecture of Old Goa churches.', '5 Days', 12500.00, 10999.00, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80', 4.7, 'Adventure', 'November - February', 'Mumbai', 1),
(3, 'Ladakh Jeep Expedition', 'ladakh-jeep-expedition', 'Leh, Pangong & Nubra', 'Traverse high mountain passes, crystal lakes, and ancient monasteries.', 'A thrilling 8-day high altitude road trip. Visit the crystal blue Pangong Lake at 14,000 ft, ride double-humped camels in the cold desert of Nubra Valley, cross Khardung La (one of the world\'s highest motorable passes), and visit cliffside Buddhist monasteries.', '8 Days', 34999.00, 29999.00, 'https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&w=600&q=80', 4.9, 'Adventure', 'June - September', 'Delhi', 1),
(4, 'Royal Rajasthan Heritage', 'royal-rajasthan-heritage', 'Jaipur, Jodhpur & Udaipur', 'Palatial stays, camel safaris, and historical forts in land of kings.', 'Experience the royal heritage of India\'s most colourful state. Stay in heritage palaces, explore massive hill forts in Jaipur and Jodhpur, take boat rides on Udaipur\'s scenic Lake Pichola, and shop for traditional handicrafts.', '7 Days', 27999.00, 24500.00, 'https://images.unsplash.com/photo-1477587458883-47145ed31328?auto=format&fit=crop&w=600&q=80', 4.8, 'Cultural', 'October - March', 'Delhi', 1),
(5, 'Kerala Tranquil Backwaters', 'kerala-tranquil-backwaters', 'Munnar, Thekkady & Alleppey', 'Houseboat cruises, spice estates and misty hill stations in Kerala.', 'Embark on a relaxing journey through God\'s Own Country. Explore Munnar\'s sprawling tea estates, look for wild elephants in Periyar Sanctuary, and drift along the tranquil backwaters of Alleppey on a private luxury houseboat.', '6 Days', 18999.00, 15999.00, 'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?auto=format&fit=crop&w=600&q=80', 4.8, 'Family', 'September - March', 'Kochi', 1),
(6, 'Andaman Beach Retreat', 'andaman-beach-retreat', 'Port Blair & Havelock Island', 'Explore pristine white-sand beaches, scuba diving and historic jail.', 'A tropical island getaway. Stay near the world-famous Radhanagar Beach on Havelock Island, go scuba diving among colorful coral reefs, and visit the historic Cellular Jail in Port Blair to witness the light and sound show.', '6 Days', 29999.00, 25999.00, 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=600&q=80', 4.9, 'Honeymoon', 'October - May', 'Kolkata', 1),
(7, 'Shimla Manali Escape', 'shimla-manali-escape', 'Shimla & Manali', 'Snowy adventure, colonial heritage, and shopping on the Mall Road.', 'Enjoy a perfect family getaway in the Himalayas. Stroll through the British colonial-era Mall Road in Shimla, visit Solang Valley for paragliding, and drive through the engineering marvel of Atal Tunnel to Lahaul Valley.', '5 Days', 15999.00, 13999.00, 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=600&q=80', 4.6, 'Family', 'March - June', 'Delhi', 1),
(8, 'Golden Triangle Cultural Circuit', 'golden-triangle-cultural-circuit', 'Delhi, Agra & Jaipur', 'See the Taj Mahal, Hawa Mahal and historic monuments of Delhi.', 'Discover the history, architecture, and heritage of northern India. Take a guided tour of Old and New Delhi, marvel at the Taj Mahal at sunrise in Agra, and visit the pink sandstone palaces of Jaipur.', '5 Days', 14999.00, 12999.00, 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=600&q=80', 4.8, 'Cultural', 'October - March', 'Delhi', 1),
(9, 'Spiritual Varanasi & Sarnath', 'spiritual-varanasi-sarnath', 'Varanasi & Sarnath', 'Mesmerizing Ganga Aarti, boat rides and ancient Buddhist site Sarnath.', 'A soulful journey to the oldest living city in the world. Witness the magical evening Ganga Aarti, take a sunrise boat cruise on the holy Ganges River, visit centuries-old temples, and explore the ancient Buddhist monuments at Sarnath.', '4 Days', 10999.00, 8999.00, 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?auto=format&fit=crop&w=600&q=80', 4.7, 'Cultural', 'October - March', 'Delhi', 1),
(10, 'Hampi Ruins Explorer', 'hampi-ruins-explorer', 'Hampi, Karnataka', 'UNESCO heritage ruins, ancient boulder landscapes and river walks.', 'Step back in time to the majestic Vijayanagara Empire. Wander amongst thousands of boulder-strewn monuments, see the iconic Stone Chariot, cross the Tungabhadra River in a coracle boat, and climb Matanga Hill for a memorable sunset.', '4 Days', 12999.00, 10999.00, 'https://images.unsplash.com/photo-1598091383021-15ddea10925d?auto=format&fit=crop&w=600&q=80', 4.7, 'Cultural', 'October - February', 'Bengaluru', 1),
(11, 'Darjeeling & Gangtok Retreat', 'darjeeling-gangtok-retreat', 'Darjeeling & Gangtok', 'Scenic toy train rides, sprawling tea estates and view of Mount Kanchenjunga.', 'A gorgeous holiday in the eastern Himalayas. Ride the historic Darjeeling Himalayan Toy Train, watch a golden sunrise over Mount Kanchenjunga from Tiger Hill, walk through misty tea estates, and visit high-altitude lakes in Sikkim.', '6 Days', 21999.00, 18999.00, 'https://images.unsplash.com/photo-1544085311-11a028465b03?auto=format&fit=crop&w=600&q=80', 4.7, 'Family', 'March - May', 'Kolkata', 1),
(12, 'Coorg Coffee & Spices Tour', 'coorg-coffee-spices-tour', 'Coorg, Karnataka', 'Breathe in misty coffee plantations and explore cascading waterfalls.', 'Rejuvenate in India\'s coffee capital. Walk through aromatic coffee plantations, trek up to the misty peaks of Tadiandamol, visit Abbey Falls and Raja\'s Seat, and see elephants being trained at Dubare Camp.', '4 Days', 11999.00, 9999.00, 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=600&q=80', 4.6, 'Luxury', 'October - March', 'Bengaluru', 1),
(13, 'Romantic Udaipur Getaway', 'romantic-udaipur-getaway', 'Udaipur, Rajasthan', 'Lake Pichola sunset boat rides and grand stays in historic lake palaces.', 'A fairytale vacation for couples. Stay in Udaipur, the Venice of the East. Take a private sunset cruise past the floating Lake Palace, explore the royal City Palace, and enjoy candle-light rooftop dinners overlooking illuminated lakes.', '4 Days', 17999.00, 15499.00, 'https://images.unsplash.com/photo-1477587458883-47145ed31328?auto=format&fit=crop&w=600&q=80', 4.8, 'Honeymoon', 'October - March', 'Jaipur', 1),
(14, 'Rann of Kutch Salt Desert', 'rann-of-kutch-salt-desert', 'Bhuj & Rann of Kutch', 'Walk on the vast white salt desert and enjoy colorful Gujarati folk arts.', 'Witness the magical white desert of Kutch. Walk on the endless salt marshes during the full moon night, stay in traditional bhunga tents, enjoy Gujarati folk dance and music, and shop for hand-crafted Kutchi embroidery.', '5 Days', 19999.00, 17999.00, 'https://images.unsplash.com/photo-1519955266818-0231b4371449?auto=format&fit=crop&w=600&q=80', 4.7, 'Cultural', 'November - February', 'Ahmedabad', 1),
(15, 'Valley of Flowers Trekking', 'valley-of-flowers-trekking', 'Joshimath & Valley of Flowers', 'UNESCO high-altitude trek amidst hundreds of species of blooming wildflowers.', 'An adventurous trek into the heart of Uttarakhand Himalayas. Trek through pristine alpine valleys carpeted in yellow, pink, and purple flowers, cross roaring glacial streams, and visit the sacred high-altitude lake Hemkund Sahib.', '6 Days', 25999.00, 22999.00, 'https://images.unsplash.com/photo-1589308078059-be1415eab4c3?auto=format&fit=crop&w=600&q=80', 4.9, 'Adventure', 'July - September', 'Rishikesh', 1);


-- 2. Seed Day-by-Day Itineraries (trip_itinerary) - 30+ itineraries
INSERT INTO trip_itinerary (trip_id, day_number, title, details) VALUES
-- Kashmir (ID=1)
(1, 1, 'Arrival & Houseboat Stay', 'Arrive in Srinagar, check-in to a traditional luxury houseboat on Dal Lake. Enjoy a relaxing sunset Shikara ride.'),
(1, 2, 'Srinagar Local Sightseeing', 'Explore the historical Mughal Gardens: Shalimar Bagh, Nishat Bagh, and Chashme Shahi. Enjoy shopping for local pashmina shawls.'),
(1, 3, 'Gulmarg Snow Meadows', 'Day excursion to Gulmarg. Experience the Gondola cable car ride to Apharwat Peak for stunning views and snow fights.'),
(1, 4, 'Valley of Pahalgam', 'Drive to Pahalgam (Valley of Shepherds). Enroute visit saffron fields. Overnight stay near the roaring Lidder River.'),
(1, 5, 'Aru & Betaab Valleys', 'Take local pony rides or cabs to explore the picturesque Betaab Valley and Aru Valley. Evening leisure walk around Pahalgam.'),
(1, 6, 'Departure Transfer', 'Check out from Pahalgam and transfer to Srinagar Airport for your flight back home.'),

-- Goa (ID=2)
(2, 1, 'Welcome to Goa', 'Arrive in Goa, check-in to your beach resort. Spend a relaxed evening walking along Baga Beach and checking out local shacks.'),
(2, 2, 'North Goa Water Sports', 'Brave parasailing, jet skiing, banana boat rides and bumper rides at Calangute Beach. Evening visit to Chapora Fort for sunset views.'),
(2, 3, 'South Goa Heritage Tour', 'Visit the historic churches of Old Goa: Basilica of Bom Jesus and Se Cathedral. Spend the evening cruising down Mandovi River.'),
(2, 4, 'Spice Plantations & Dudhsagar', 'Day trip to Dudhsagar Waterfalls and Sahakari Spice Farm. Enjoy a traditional Goan buffet lunch and elephant shower.'),
(2, 5, 'Departure', 'Morning souvenir shopping in Panaji local markets. Transfer to airport/railway station for departure.'),

-- Ladakh (ID=3)
(3, 1, 'Acclimatization in Leh', 'Arrive at Leh Airport (11,500 ft). Transfer to hotel. Full day rest to acclimatize to high altitude. Light walk in Leh market in evening.'),
(3, 2, 'Sham Valley Sightseeing', 'Visit Hall of Fame museum, Gurudwara Pathar Sahib, Magnetic Hill, and the scenic confluence of Indus and Zanskar Rivers.'),
(3, 3, 'Leh to Nubra Valley', 'Drive over Khardung La Pass (17,580 ft) to Nubra Valley. Check-in to deluxe camps and enjoy camel rides in Hunder sand dunes.'),
(3, 4, 'Diskit Monastery & Pangong Lake', 'Visit the massive Maitreya Buddha statue in Diskit. Drive to the breathtaking saltwater Pangong Lake. Camp overnight near the lake.'),
(3, 5, 'Return to Leh', 'Watch a beautiful sunrise over Pangong Lake. Drive back to Leh via Chang La Pass (17,590 ft). Evening free for shopping in Leh.'),
(3, 6, 'Departure', 'Early morning checkout and transfer to Leh Airport.'),

-- Kerala (ID=5)
(5, 1, 'Welcome to Kochi & Munnar', 'Arrive at Kochi Airport. Drive to Munnar, passing through scenic Valara and Cheeyappara waterfalls. Check-in to hill resort.'),
(5, 2, 'Munnar Tea Estates & Hills', 'Visit the tea museum, Mattupetty Dam, Echo Point, and Eravikulam National Park to spot the rare Nilgiri Tahr mountain goat.'),
(5, 3, 'Munnar to Thekkady', 'Drive to Thekkady. Take a spice plantation walk to learn about cardamom, pepper, and vanilla. Enjoy Kathakali cultural show in the evening.'),
(5, 4, 'Alleppey Houseboat Stay', 'Drive to Alleppey. Board your private traditional houseboat. Cruise slowly through narrow backwater canals past paddy fields.'),
(5, 5, 'Departure', 'Enjoy breakfast on board the houseboat. Disembark and drive back to Kochi Airport for departure.');


-- 3. Seed Inclusions (trip_inclusions)
INSERT INTO trip_inclusions (trip_id, inclusion_name, included) VALUES
(1, '5 Nights Deluxe Accommodation (1 Night Houseboat, 4 Nights Hotels)', 1),
(1, 'Daily Breakfast & Dinner at all accommodations', 1),
(1, 'All sightseeing and airport transfers in a private AC cab', 1),
(1, 'Shikara Ride tickets on Dal Lake', 1),
(1, 'Gulmarg Gondola ride tickets (Phase 1)', 1),
(1, 'Driver allowances, toll taxes, parking fees', 1),
(1, 'Any lunches or alcoholic beverages', 0),
(1, 'Flights/Train tickets to and from Srinagar', 0),

(2, '4 Nights Beachfront Resort Stay in North Goa', 1),
(2, 'Daily buffet breakfast at resort', 1),
(2, 'North Goa & South Goa private sightseeing transfers', 1),
(2, 'Dudhsagar Jeep Safari and Spice Plantation tickets with lunch', 1),
(2, 'Water sports combo package at Calangute beach', 1),
(2, 'Flight tickets or airport transfers', 0),

(3, '5 Nights camp/hotel accommodation in Leh, Nubra, Pangong', 1),
(3, 'All meals (Breakfast, Lunch & Dinner) included', 1),
(3, 'Inner Line Permits and environment fees', 1),
(3, 'Private SUV (Innova/Scorpio) for all transfers', 1),
(3, 'Oxygen cylinder in vehicle during high altitude travel', 1),
(3, 'Personal medications or tips', 0);


-- 4. Seed Gallery Images (trip_gallery)
INSERT INTO trip_gallery (trip_id, image_url, caption) VALUES
(1, 'https://images.unsplash.com/photo-1566837430541-75e53e29f85c?auto=format&fit=crop&w=600&q=80', 'Traditional Shikara boat on Dal Lake, Srinagar'),
(1, 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=600&q=80', 'Scenic view of snow-capped mountains in Gulmarg'),
(1, 'https://images.unsplash.com/photo-1593693411515-c20261bcad6e?auto=format&fit=crop&w=600&q=80', 'Lush saffron fields in Pampore, Kashmir'),

(2, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80', 'Sunset cruise on Mandovi River, Goa'),
(2, 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=600&q=80', 'Old Goa historical churches and monuments'),

(3, 'https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&w=600&q=80', 'Deep blue waters of Pangong Lake, Ladakh'),
(3, 'https://images.unsplash.com/photo-1544085311-11a028465b03?auto=format&fit=crop&w=600&q=80', 'Bactrian double-humped camels in Hunder dunes');


-- 5. Seed 5 Additional Recommended Hotels (id 6 to 10) to have 10 stays total
INSERT INTO hotels 
    (id, name, city, country, address, description, imageUrl, price_per_night, rating, amenities, latitude, longitude, best_seller, recommended, starting_price) 
VALUES
(6, 'Grand Taj Residency', 'Jaipur', 'India', 'Colony Rd, Near City Palace', 'A grand heritage palace offering luxury rooms, royal Rajasthani dining, and a relaxing courtyard pool.', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800', 4500.00, 4.8, 'WiFi,Pool,AC,Spa,Bar,Breakfast', 26.9124, 75.8123, TRUE, TRUE, 4500.0),
(7, 'Himalayan Retreat Lodge', 'Manali', 'India', 'Mall Road, near Hadimba Temple', 'Cozy wooden lodge offering breathtaking mountain views, fireside lounge, and easy access to Mall Road.', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800', 3500.00, 4.7, 'WiFi,Heater,Restaurant,Parking', 32.2396, 77.1887, FALSE, TRUE, 3500.0),
(8, 'Varanasi Heritage Haveli', 'Varanasi', 'India', 'Assi Ghat beachfront', 'A beautifully restored 200-year-old haveli right on Assi Ghat. Watch Ganga Aarti directly from the rooftop terrace.', 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?auto=format&fit=crop&w=800', 2800.00, 4.6, 'WiFi,AC,Breakfast,Room Service', 25.3176, 83.0080, TRUE, TRUE, 2800.0),
(9, 'Kerala Backwater Resort & Spa', 'Alleppey', 'India', 'Lagoons Road near Vembanad Lake', 'Luxury lagoon-side resort offering traditional wooden cottages, Ayurveda therapies, and private backwater boat rides.', 'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?auto=format&fit=crop&w=800', 5500.00, 4.9, 'WiFi,Pool,AC,Spa,Ayurveda,Lake View', 9.4981, 76.3262, TRUE, TRUE, 5500.0),
(10, 'Desert Dunes Luxury Camp', 'Jaisalmer', 'India', 'Sam Sand Dunes', 'Stay under the stars in premium air-conditioned tents. Includes sunset camel safaris and folk dance buffet dinners.', 'https://images.unsplash.com/photo-1605640840605-14ac1855827b?auto=format&fit=crop&w=800', 6000.00, 4.8, 'WiFi,AC,Campfire,Desert Safari,Breakfast', 26.9157, 70.9083, TRUE, TRUE, 6000.0);


-- 6. Seed 6 Additional Activities/Experiences (id 5 to 10) to have 10 experiences total
INSERT INTO activities 
    (id, title, hero_image, description, location, price, duration_minutes, rating, review_count, highlights) 
VALUES
(5, 'Shikara Ride in Dal Lake', 'https://images.unsplash.com/photo-1566837430541-75e53e29f85c?auto=format&fit=crop&w=800', 'Enjoy a peaceful evening ride in a traditional wooden boat past floating gardens and houseboats.', 'Srinagar, Kashmir', 800.00, 120, 4.8, 480, 'Dal Lake views|Sunset photography|Traditional boat'),
(6, 'Kerala Houseboat Cruise', 'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?auto=format&fit=crop&w=800', 'Cruise slowly through calm backwater lagoons and lakes on a luxury traditional houseboat.', 'Alleppey, Kerala', 9500.00, 1440, 4.9, 820, 'All Meals Included|Lush Green Views|Ayurvedic Spa Onboard'),
(7, 'Camel Safari & Desert Camp', 'https://images.unsplash.com/photo-1605640840605-14ac1855827b?auto=format&fit=crop&w=800', 'Trek over gold sand dunes on camels, watch sunset and enjoy traditional folk performances with dinner.', 'Jaisalmer, Rajasthan', 2500.00, 300, 4.8, 640, 'Sunset Camel Ride|Cultural Dance Show|Rajasthani Dinner'),
(8, 'Scuba Diving at Havelock', 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=800', 'Explore the underwater coral reefs and marine life of Andaman with certified divers.', 'Havelock Island, Andaman', 4500.00, 180, 4.9, 1150, 'Certified Instructors|Full Equipment|Underwater Video Included'),
(9, 'Solang Valley Paragliding', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=800', 'Fly high over the valleys and pine forests of Manali with a professional pilot.', 'Manali, Himachal Pradesh', 3200.00, 90, 4.7, 730, 'Tandem Flight|GoPro Recording|Expert Pilot'),
(10, 'Jaipur Royal Palace Tour', 'https://images.unsplash.com/photo-1477587458883-47145ed31328?auto=format&fit=crop&w=800', 'Guided historical walk through Amber Fort, City Palace, Hawa Mahal and astronomical observatory.', 'Jaipur, Rajasthan', 1200.00, 240, 4.7, 980, 'Skip-the-line Ticket|Historical Guide|Local Craft Tasting');


SET FOREIGN_KEY_CHECKS = 1;
