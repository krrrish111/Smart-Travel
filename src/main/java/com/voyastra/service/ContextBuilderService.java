package com.voyastra.service;

import java.util.HashMap;
import java.util.Map;

public class ContextBuilderService {
    
    /**
     * Retrieves the user's travel context from the database using their session or ID.
     * Includes bookings, preferences, budget constraints, etc.
     */
    public Map<String, String> getUserContext(String userId) {
        // TODO: In a real implementation, query the Voyastra database
        // For example: UserDAO.getUserPreferences(userId)
        
        Map<String, String> context = new HashMap<>();
        
        if (userId != null && !userId.isEmpty()) {
            // Simulated Deep AI Memory & Preferences
            context.put("Memory", "User likes to travel light. Prefers hidden gems over tourist traps. Budget is typically medium-range.");
            context.put("Preferred Destinations", "Beaches, Mountains (Goa, Manali, Bali)");
            context.put("Favorite Food", "Vegetarian, Street food, Local authentic cuisine");
            context.put("Travel Style", "Adventure, Backpacking");
            context.put("Budget Range", "₹10,000 - ₹30,000 per trip");
            
            // Past Activity
            context.put("Past Trips", "3 trips completed this year (Jaipur, Kerala, Spiti Valley)");
            context.put("Saved Places", "Rishikesh riverside camp, Pondicherry French Quarter");
            
            // Current State / Realtime
            context.put("Upcoming Bookings", "Goa Trip starting in 4 days. Includes flight and beachfront hostel.");
            context.put("Planner Data", "User has a draft itinerary for Vietnam next month. Missing hotel bookings.");
        } else {
            context.put("User Profile", "Guest User");
            context.put("Memory", "No prior memory available. Treat as a new user looking for general inspiration.");
        }
        
        // Global / Platform Data Context
        context.put("Hidden Gems", "Varkala cliff beach, Majuli river island, Meghalaya living root bridges");
        context.put("Trending Community", "People are discussing Goa monsoon travel and affordable stays in Bali.");
        context.put("Food Database Access", "Available. Can suggest food trails and highly rated local spots.");
        context.put("Budget Engine", "Active. Can calculate real-time splits and provide optimization strategies.");
        
        // Phase 14: Experiences & Local Guides
        context.put("Experiences Marketplace", "Available. Suggest activities based on User Travel DNA (Top, Hidden, Trending, Budget, Premium). Categories: Adventure, Food, Photography, Nature, Culture, Spiritual, Nightlife, Luxury, Family, Romantic.");
        context.put("Local Guides", "Available. Match users with private, food, or photography guides based on destination.");
        context.put("Experience Matching", "Active. Automatically recommend experiences to fill itinerary gaps. E.g., Photo Walk for Photography enthusiasts.");
        
        return context;
    }
}
