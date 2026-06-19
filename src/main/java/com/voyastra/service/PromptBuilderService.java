package com.voyastra.service;

import java.util.Map;

public class PromptBuilderService {

    public static String buildDynamicPrompt(Map<String, String> params) {
        String source = params.getOrDefault("origin", params.getOrDefault("source", "Anywhere"));
        String destination = params.getOrDefault("destination", "a beautiful destination");
        String startDate = params.getOrDefault("departureDate", params.getOrDefault("startDate", "unknown date"));
        String endDate = params.getOrDefault("returnDate", params.getOrDefault("endDate", "unknown date"));
        String budget = params.getOrDefault("budget", "Flexible");
        String adults = params.getOrDefault("adults", "1");
        String children = params.getOrDefault("children", "0");
        String travelStyle = params.getOrDefault("travelStyle", "Balanced");
        
        return "You are an expert AI Travel Concierge. Generate a strictly formatted JSON trip plan.\n" +
                "Do NOT include any markdown code blocks, just raw JSON.\n\n" +
                "### TRIP PARAMETERS ###\n" +
                "- Source: " + source + "\n" +
                "- Destination: " + destination + "\n" +
                "- Travel Dates: " + startDate + " to " + endDate + "\n" +
                "- Budget: ₹" + budget + "\n" +
                "- Travelers: " + adults + " Adults, " + children + " Children\n" +
                "- Preferred Travel Style: " + travelStyle + "\n\n" +
                "### INSTRUCTIONS ###\n" +
                "Generate a highly realistic, location-specific itinerary for " + destination + ". All place names, food recommendations, and hidden gems must actually exist in or around " + destination + ". Tailor the pacing and activities to a " + travelStyle + " travel style.\n\n" +
                "### REQUIRED JSON SCHEMA ###\n" +
                "{\n" +
                "  \"title\": \"\",\n" +
                "  \"destination_story\": \"\",\n" +
                "  \"trip_score\": 0,\n" +
                "  \"trip_score_breakdown\": {\n" +
                "    \"budget_fit\": 0,\n" +
                "    \"weather\": 0,\n" +
                "    \"safety\": 0,\n" +
                "    \"crowd\": 0,\n" +
                "    \"comfort\": 0,\n" +
                "    \"photography\": 0,\n" +
                "    \"food\": 0\n" +
                "  },\n" +
                "  \"best_season\": \"\",\n" +
                "  \"recommended_duration\": \"\",\n" +
                "  \"best_travel_mode\": \"\",\n" +
                "  \"travel_warnings\": [\"\", \"\"],\n" +
                "  \"ai_recommendation_insight\": \"\",\n" +
                "  \"hidden_gems_detailed\": [\n" +
                "    {\n" +
                "      \"name\": \"\",\n" +
                "      \"category\": \"\",\n" +
                "      \"overall_score\": 0.0,\n" +
                "      \"description\": \"\",\n" +
                "      \"beauty_score\": 0,\n" +
                "      \"peace_score\": 0,\n" +
                "      \"photo_score\": 0,\n" +
                "      \"crowd_score\": 0\n" +
                "    }\n" +
                "  ],\n" +
                "  \"must_visit\": [\"\"],\n" +
                "  \"hidden_gems\": [\"\"],\n" +
                "  \"instagram_spots\": [\"\"],\n" +
                "  \"food_discovery\": [\"\"],\n" +
                "  \"local_food_specialties\": [\"\"],\n" +
                "  \"food_discovery_detailed\": [\n" +
                "    {\n" +
                "      \"name\": \"\",\n" +
                "      \"category\": \"\",\n" +
                "      \"rating\": 0.0,\n" +
                "      \"price_range\": \"\",\n" +
                "      \"crowd_level\": \"\",\n" +
                "      \"description\": \"\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"local_experiences\": [\n" +
                "    {\n" +
                "      \"type\": \"\",\n" +
                "      \"name\": \"\",\n" +
                "      \"short_story\": \"\",\n" +
                "      \"authenticity_score\": 0,\n" +
                "      \"fun_score\": 0,\n" +
                "      \"photography_score\": 0\n" +
                "    }\n" +
                "  ],\n" +
                "  \"food_trails\": [\n" +
                "    {\n" +
                "      \"title\": \"\",\n" +
                "      \"breakfast\": \"\",\n" +
                "      \"lunch\": \"\",\n" +
                "      \"evening\": \"\",\n" +
                "      \"dinner\": \"\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"events_detected\": [\"\"],\n" +
                "  \"days\": [\n" +
                "    {\n" +
                "      \"day\": 1,\n" +
                "      \"title\": \"\",\n" +
                "      \"difficulty_level\": \"\",\n" +
                "      \"weather_forecast\": \"\",\n" +
                "      \"walking_km\": \"\",\n" +
                "      \"daily_story\": \"\",\n" +
                "      \"activities\": [\n" +
                "        {\n" +
                "          \"time_slot\": \"\",\n" +
                "          \"title\": \"\",\n" +
                "          \"category\": \"\",\n" +
                "          \"recommended_duration\": \"\",\n" +
                "          \"description\": \"\"\n" +
                "        }\n" +
                "      ]\n" +
                "    }\n" +
                "  ],\n" +
                "  \"budget_breakdown\": {\n" +
                "    \"flights\": \"\",\n" +
                "    \"hotel\": \"\",\n" +
                "    \"food\": \"\",\n" +
                "    \"activities\": \"\",\n" +
                "    \"transportation\": \"\",\n" +
                "    \"emergency_fund\": \"\"\n" +
                "  },\n" +
                "  \"travel_tips\": [\"\"],\n" +
                "  \"gamification\": [\"\"],\n" +
                "  \"trip_summary\": \"\"\n" +
                "}";
    }
}
