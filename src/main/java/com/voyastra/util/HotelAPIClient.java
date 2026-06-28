package com.voyastra.util;

import com.voyastra.model.booking.Hotel;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Arrays;

public class HotelAPIClient {

    public static List<Hotel> fetchHotelsFromAPI(String destination, String type, String requiredAmenities) {
        // Simulating external API call delay
        try { Thread.sleep(500); } catch (Exception e) {}

        List<Hotel> dynamicHotels = new ArrayList<>();
        Random rand = new Random();

        String[] prefixes = {"Grand", "Royal", "Sunset", "Ocean", "Mountain", "Urban", "Crystal"};
        String[] suffixes = {"Resort", "Hotel", "Villa", "Lodge", "Inn", "Hostel", "Suites"};
        
        List<String> validTypes = Arrays.asList("Budget", "Luxury", "Resort", "Villa", "Hostel");
        String finalType = validTypes.contains(type) ? type : "Hotel";

        // Generate 5 dynamic results based on criteria
        for (int i = 1; i <= 5; i++) {
            Hotel h = new Hotel();
            h.setId(100 + rand.nextInt(900)); // Dynamic High ID to avoid conflict with DB
            
            String name = prefixes[rand.nextInt(prefixes.length)] + " " + (destination == null || destination.isEmpty() ? "City" : destination) + " " + finalType;
            h.setName(name);
            h.setCity(destination != null && !destination.isEmpty() ? destination : "Anywhere");
            h.setAddress(rand.nextInt(999) + " Dynamic Ave, " + h.getCity());
            h.setDescription("A beautiful " + finalType.toLowerCase() + " property provided by Voyastra Partner Network offering comfortable stays.");
            h.setRating(3.0 + (rand.nextDouble() * 2)); // 3.0 to 5.0
            
            // Randomly select image
            String[] images = {
                "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                "https://images.unsplash.com/photo-1551882547-ff40c0d5f8af?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                "https://images.unsplash.com/photo-1496417263034-38ec4f0b665a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"
            };
            h.setImageUrl(images[rand.nextInt(images.length)]);
            
            // Combine required amenities with some random ones
            String baseAmenities = requiredAmenities != null && !requiredAmenities.isEmpty() ? requiredAmenities : "WiFi,AC";
            h.setAmenities(baseAmenities + ",TV,Minibar");

            // Mock advanced fields
            h.setReviewCount(50 + rand.nextInt(1500));
            h.setStartingPrice(50.0 + rand.nextInt(450));
            h.setCancellationPolicy(rand.nextBoolean() ? "Free Cancellation" : "Non-Refundable");
            h.setDistanceFromCenter(0.5 + (rand.nextDouble() * 10.0));
            h.setAvailableRooms(1 + rand.nextInt(15));

            dynamicHotels.add(h);
        }

        return dynamicHotels;
    }
}