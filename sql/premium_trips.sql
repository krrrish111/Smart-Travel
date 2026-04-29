-- ==========================================================
-- VOYASTRA PREMIUM TRAVEL PACKAGES DATABASE SCHEMA
-- ==========================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Trip Plans Table
DROP TABLE IF EXISTS `trip_plans`;
CREATE TABLE `trip_plans` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `destination` VARCHAR(100) NOT NULL,
  `short_description` VARCHAR(500) NOT NULL,
  `full_description` TEXT NOT NULL,
  `duration` VARCHAR(50) NOT NULL,
  `price_inr` DECIMAL(10,2) NOT NULL,
  `discount_price` DECIMAL(10,2) DEFAULT NULL,
  `image_url` VARCHAR(500) NOT NULL,
  `rating` DECIMAL(3,1) DEFAULT 5.0,
  `category` ENUM('Luxury', 'Honeymoon', 'Family', 'Adventure', 'Cultural') DEFAULT 'Luxury',
  `best_season` VARCHAR(100) DEFAULT NULL,
  `starting_city` VARCHAR(100) DEFAULT NULL,
  `featured` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Trip Itinerary Table
DROP TABLE IF EXISTS `trip_itinerary`;
CREATE TABLE `trip_itinerary` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `trip_id` INT NOT NULL,
  `day_number` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `details` TEXT NOT NULL,
  FOREIGN KEY (`trip_id`) REFERENCES `trip_plans`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Trip Inclusions Table
DROP TABLE IF EXISTS `trip_inclusions`;
CREATE TABLE `trip_inclusions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `trip_id` INT NOT NULL,
  `inclusion_name` VARCHAR(255) NOT NULL,
  `included` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (`trip_id`) REFERENCES `trip_plans`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Trip Gallery Table
DROP TABLE IF EXISTS `trip_gallery`;
CREATE TABLE `trip_gallery` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `trip_id` INT NOT NULL,
  `image_url` VARCHAR(500) NOT NULL,
  `caption` VARCHAR(255) DEFAULT NULL,
  FOREIGN KEY (`trip_id`) REFERENCES `trip_plans`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================================
-- PREMIUM TRAVEL PACKAGE DATA INSERTIONS
-- ==========================================================

-- Trips
INSERT INTO `trip_plans` (`id`, `title`, `slug`, `destination`, `short_description`, `full_description`, `duration`, `price_inr`, `discount_price`, `image_url`, `rating`, `category`, `best_season`, `starting_city`, `featured`) VALUES
(1, 'Goa Luxury Escape', 'goa-luxury-escape', 'Goa', 'Experience the ultimate luxury retreat at South Goa\'s most pristine beaches.', 'Immerse yourself in the laid-back elegance of Goa. This premium package offers a stay in a 5-star beachfront luxury resort, private yacht sunset cruises, and curated coastal culinary experiences. Perfect for couples and those looking to unwind in absolute style.', '4 Days / 3 Nights', 45000.00, 39999.00, 'images/destinations/goa-hero.jpg', 4.8, 'Luxury', 'Oct - March', 'Mumbai', TRUE),
(2, 'Paradise on Earth', 'kashmir-paradise-on-earth', 'Kashmir', 'A breathtaking journey through the valleys of Srinagar, Gulmarg, and Pahalgam.', 'Experience the majestic beauty of Kashmir. Stay in a premium houseboat on Dal Lake, ride the Gondola in Gulmarg, and witness the pristine valleys of Pahalgam. This package includes a personal chauffeur and premium heritage stays.', '6 Days / 5 Nights', 65000.00, 58000.00, 'images/destinations/kashmir-hero.jpg', 4.9, 'Honeymoon', 'April - October', 'Delhi', TRUE),
(3, 'Manali Snow Retreat', 'manali-snow-retreat', 'Manali', 'An adventurous yet luxurious escape to the snow-capped peaks of Himachal.', 'Wake up to panoramic views of the Himalayas from your luxury boutique suite. Enjoy guided treks, solang valley snow activities, and cozy evenings by the fireplace with curated local dining.', '5 Days / 4 Nights', 35000.00, 32000.00, 'images/destinations/manali-hero.jpg', 4.7, 'Adventure', 'Dec - May', 'Chandigarh', FALSE),
(4, 'Royal Rajasthan Heritage', 'royal-rajasthan-heritage', 'Rajasthan', 'Live like royalty in the palatial heritage properties of Jaipur, Jodhpur, and Udaipur.', 'A cultural odyssey through the land of Kings. Enjoy stays in authentic converted palaces, private desert safaris with gala dinners, and guided tours of majestic forts with expert historians.', '8 Days / 7 Nights', 95000.00, 88000.00, 'images/destinations/rajasthan-hero.jpg', 4.9, 'Cultural', 'Oct - March', 'Jaipur', TRUE),
(5, 'Kerala Backwaters Bliss', 'kerala-backwaters-bliss', 'Kerala', 'Rejuvenate your soul amidst the tranquil backwaters and lush tea gardens.', 'A perfect blend of nature and luxury. Begin with the rolling tea estates of Munnar, followed by an exclusive private houseboat experience in Kumarakom with Ayurvedic spa therapies.', '6 Days / 5 Nights', 55000.00, 49000.00, 'images/destinations/kerala-hero.jpg', 4.8, 'Honeymoon', 'Sept - March', 'Kochi', TRUE),
(6, 'Andaman Island Explorer', 'andaman-island-explorer', 'Andaman', 'Dive into crystal clear waters and relax on white sandy beaches.', 'Discover the untouched beauty of the Andaman Islands. This package features stays at premium beach resorts, private scuba diving sessions in Havelock, and sunset cruises.', '7 Days / 6 Nights', 75000.00, 69999.00, 'images/destinations/andaman-hero.jpg', 4.8, 'Family', 'Oct - May', 'Chennai', FALSE),
(7, 'Dubai City of Gold', 'dubai-city-of-gold', 'Dubai', 'Experience unparalleled opulence, futuristic skylines, and elite shopping.', 'From the heights of Burj Khalifa to premium desert safari experiences. This ultra-luxury package offers 5-star downtown stays, VIP theme park access, and a luxury yacht tour of the Marina.', '5 Days / 4 Nights', 110000.00, 95000.00, 'images/destinations/dubai-hero.jpg', 4.9, 'Luxury', 'Nov - March', 'Mumbai', TRUE),
(8, 'Bali Tropical Paradise', 'bali-tropical-paradise', 'Bali', 'A spiritual and visual feast featuring lush jungles and pristine beaches.', 'Experience the magic of Bali. Stay in private pool villas in Ubud and beachfront luxury in Seminyak. Includes private temple tours, floating breakfasts, and traditional Balinese spa treatments.', '7 Days / 6 Nights', 85000.00, 78000.00, 'images/destinations/bali-hero.jpg', 4.8, 'Honeymoon', 'April - Oct', 'Delhi', TRUE),
(9, 'Maldives Ocean Villa Escape', 'maldives-ocean-villa-escape', 'Maldives', 'The ultimate romantic getaway over the crystal-clear Indian Ocean.', 'Indulge in sheer luxury with a stay in a premium overwater villa. This package includes seaplane transfers, all-inclusive gourmet dining, private snorkeling, and sunset dolphin cruises.', '5 Days / 4 Nights', 250000.00, 225000.00, 'images/destinations/maldives-hero.jpg', 5.0, 'Honeymoon', 'Nov - April', 'Bengaluru', TRUE),
(10, 'Thailand Cultural Odyssey', 'thailand-cultural-odyssey', 'Thailand', 'A vibrant mix of Bangkok cityscapes and Phuket island relaxation.', 'A perfectly balanced itinerary featuring luxury shopping and temples in Bangkok, followed by a premium beachfront resort stay in Phuket with a private Phi Phi island speedboat tour.', '6 Days / 5 Nights', 65000.00, 59999.00, 'images/destinations/thailand-hero.jpg', 4.7, 'Family', 'Nov - March', 'Kolkata', FALSE),
(11, 'Swiss Alps Dream', 'swiss-alps-dream', 'Switzerland', 'A majestic Alpine experience featuring panoramic trains and glacial peaks.', 'Discover the pristine beauty of Switzerland. Includes travel on the Glacier Express, stays in premium Alpine lodges in Zermatt and Interlaken, and a guided tour to Jungfraujoch.', '8 Days / 7 Nights', 320000.00, 295000.00, 'images/destinations/swiss-hero.jpg', 4.9, 'Luxury', 'June - Sept', 'Delhi', TRUE),
(12, 'Paris Romantic Getaway', 'paris-romantic-getaway', 'Paris', 'The ultimate romance in the city of lights, featuring iconic sights and culinary delights.', 'Experience Paris in absolute luxury. Stay in a premium boutique hotel near the Eiffel Tower, enjoy a private Seine river cruise with dinner, and exclusive skip-the-line Louvre access.', '6 Days / 5 Nights', 180000.00, 165000.00, 'images/destinations/paris-hero.jpg', 4.8, 'Honeymoon', 'April - June', 'Mumbai', TRUE);

-- Itineraries
-- Trip 1: Goa
INSERT INTO `trip_itinerary` (`trip_id`, `day_number`, `title`, `details`) VALUES
(1, 1, 'Arrival & Beach Resort Check-in', 'Arrive at Goa Airport. Private luxury transfer to your 5-star beachfront resort in South Goa. Welcome drinks and evening at leisure by the private beach.'),
(1, 2, 'Heritage Tour & Spice Plantation', 'Visit the ancient churches of Old Goa. Enjoy a guided tour of a lush spice plantation followed by a traditional Goan lunch.'),
(1, 3, 'Private Yacht Sunset Cruise', 'Relax by the pool in the morning. In the late afternoon, board a private luxury yacht for a scenic sunset cruise along the Mandovi river with premium champagne.'),
(1, 4, 'Departure', 'Enjoy a lavish breakfast before your private transfer back to the airport.');

-- Trip 2: Kashmir
INSERT INTO `trip_itinerary` (`trip_id`, `day_number`, `title`, `details`) VALUES
(2, 1, 'Arrival in Srinagar & Houseboat Stay', 'Arrive in Srinagar. Transfer to a premium Dal Lake houseboat. Evening Shikara ride during sunset.'),
(2, 2, 'Mughal Gardens Tour', 'Visit the beautiful Shalimar Bagh and Nishat Bagh. Enjoy a premium Wazwan dinner.'),
(2, 3, 'Gulmarg Gondola Ride', 'Day trip to Gulmarg. Experience the phase 2 Gondola ride for breathtaking views of the Apharwat Peak.'),
(2, 4, 'Pahalgam Valley', 'Drive to Pahalgam. Visit Betaab Valley and Aru Valley. Overnight stay in a luxury riverside lodge.'),
(2, 5, 'Srinagar Local Shopping', 'Return to Srinagar. Time for shopping authentic Pashminas and saffron. Farewell dinner.'),
(2, 6, 'Departure', 'Transfer to Srinagar Airport for your onward journey.');

-- Trip 9: Maldives (Example of another itinerary)
INSERT INTO `trip_itinerary` (`trip_id`, `day_number`, `title`, `details`) VALUES
(9, 1, 'Arrival & Seaplane Transfer', 'Arrive at Male Airport. Scenic seaplane transfer to your luxury private island resort. Check into your Overwater Villa.'),
(9, 2, 'At Leisure & Spa Day', 'Enjoy a floating breakfast in your private pool. Afternoon features a 90-minute couple\'s signature spa therapy.'),
(9, 3, 'Private Snorkeling Safari', 'Guided private snorkeling tour exploring the vibrant house reef. Encounters with manta rays and sea turtles.'),
(9, 4, 'Sunset Dolphin Cruise', 'Relax in the morning. Evening private luxury cruise to spot spinner dolphins as the sun sets over the Indian Ocean.'),
(9, 5, 'Departure', 'Breakfast at the resort before taking the seaplane back to Male for your departure flight.');

-- (We provide 3 representative itineraries here to keep the file size reasonable, similar inserts will apply for all 12 trips)

-- Inclusions
-- Goa Inclusions
INSERT INTO `trip_inclusions` (`trip_id`, `inclusion_name`, `included`) VALUES
(1, '5-Star Resort Stay', TRUE), (1, 'Daily Premium Breakfast', TRUE), (1, 'Private Airport Transfers', TRUE), 
(1, 'Private Yacht Cruise', TRUE), (1, 'English Speaking Guide', TRUE), (1, 'Flights', FALSE);

-- Kashmir Inclusions
INSERT INTO `trip_inclusions` (`trip_id`, `inclusion_name`, `included`) VALUES
(2, 'Premium Houseboat Stay', TRUE), (2, 'Breakfast & Dinner', TRUE), (2, 'Private Chauffeur Driven SUV', TRUE), 
(2, 'Gondola Tickets', TRUE), (2, 'Shikara Ride', TRUE), (2, 'Personal Expenses', FALSE);

-- Maldives Inclusions
INSERT INTO `trip_inclusions` (`trip_id`, `inclusion_name`, `included`) VALUES
(9, 'Overwater Villa with Pool', TRUE), (9, 'All-Inclusive Meals & Beverages', TRUE), (9, 'Seaplane Transfers', TRUE), 
(9, 'Spa Credit', TRUE), (9, 'Non-motorized Water Sports', TRUE);

-- Gallery
-- Goa
INSERT INTO `trip_gallery` (`trip_id`, `image_url`, `caption`) VALUES
(1, 'images/destinations/goa-resort.jpg', 'Luxury Beachfront Resort'),
(1, 'old-goa-church.jpg', 'Historic Churches of Old Goa'),
(1, 'goa-yacht.jpg', 'Private Sunset Yacht');

-- Kashmir
INSERT INTO `trip_gallery` (`trip_id`, `image_url`, `caption`) VALUES
(2, 'images/destinations/kashmir-dal.jpg', 'Dal Lake Houseboat'),
(2, 'gulmarg-snow.jpg', 'Snowscapes of Gulmarg'),
(2, 'pahalgam-valley.jpg', 'Riverside in Pahalgam');

-- Maldives
INSERT INTO `trip_gallery` (`trip_id`, `image_url`, `caption`) VALUES
(9, 'images/destinations/maldives-aerial.jpg', 'Resort Aerial View'),
(9, 'maldives-villa.jpg', 'Overwater Pool Villa'),
(9, 'maldives-dining.jpg', 'Romantic Beach Dining');

SET FOREIGN_KEY_CHECKS = 1;
