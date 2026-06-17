package com.voyastra.service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Properties;

public class GeminiService {

    private static final String CONFIG_FILE = "config.properties";
    private static final String MODEL_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=";

    private String apiKey;

    public GeminiService() {
        loadApiKey();
    }

    private void loadApiKey() {
        this.apiKey = com.voyastra.config.ConfigManager.get("GEMINI_API_KEY");
    }

    public String generateTripPlan(Map<String, String> params) throws Exception {
        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.equals("YOUR_API_KEY")) {
            System.out.println("Gemini API Key is missing or default. Using high-fidelity mock trip planner.");
            return generateMockTripPlan(params);
        }

        try {
            String prompt = buildPrompt(params);

            JsonObject requestBody = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject content = new JsonObject();
            JsonArray parts = new JsonArray();
            JsonObject part = new JsonObject();
            
            part.addProperty("text", prompt);
            parts.add(part);
            content.add("parts", parts);
            contents.add(content);
            requestBody.add("contents", contents);

            URL url = new URL(MODEL_ENDPOINT + apiKey);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(60000);
            conn.setReadTimeout(60000);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int status = conn.getResponseCode();
            if (status != 200) {
                throw new Exception("API request failed with HTTP status " + status);
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                sb.append(line);
            }
            in.close();

            String rawResponse = sb.toString();
            System.out.println("Gemini Response: " + rawResponse);
            return parseGeminiResponse(rawResponse);
        } catch (Exception e) {
            System.err.println("Gemini API Error: " + e.getMessage() + ". Falling back to high-fidelity mock trip plan.");
            e.printStackTrace();
            return generateMockTripPlan(params);
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n");
    }

    private String generateMockTripPlan(Map<String, String> params) {
        String destination = params.getOrDefault("destination", "Goa");
        String travelStyle = params.getOrDefault("travelStyle", "Relaxation");
        if (travelStyle == null || travelStyle.isEmpty()) {
            travelStyle = params.getOrDefault("interests", "Relaxation");
        }
        String budget = params.getOrDefault("budget", "50000");

        destination = escapeJson(destination);
        travelStyle = escapeJson(travelStyle);
        budget = escapeJson(budget);

        return "{\n" +
            "  \"title\": \"Splendid Getaway to " + destination + "\",\n" +
            "  \"destination_story\": \"Experience the scenic wonder and local culture of " + destination + ", tailored for your " + travelStyle + " trip.\",\n" +
            "  \"trip_score\": 94,\n" +
            "  \"trip_score_breakdown\": {\n" +
            "    \"budget_fit\": 9,\n" +
            "    \"weather\": 8,\n" +
            "    \"safety\": 9,\n" +
            "    \"crowd\": 7,\n" +
            "    \"comfort\": 8,\n" +
            "    \"photography\": 10,\n" +
            "    \"food\": 9\n" +
            "  },\n" +
            "  \"best_season\": \"October to May\",\n" +
            "  \"recommended_duration\": \"4-5 Days\",\n" +
            "  \"best_travel_mode\": \"Cab / Local Transit\",\n" +
            "  \"travel_warnings\": [\n" +
            "    \"Carry cash for small local merchants.\",\n" +
            "    \"Stay hydrated during afternoon sightseeing.\"\n" +
            "  ],\n" +
            "  \"ai_recommendation_insight\": \"Since you prefer " + travelStyle + ", I have focused on local heritage, peaceful spots, and signature food trails.\",\n" +
            "  \"hidden_gems_detailed\": [\n" +
            "    {\n" +
            "      \"name\": \"Secret Panoramic Cliff\",\n" +
            "      \"category\": \"Nature\",\n" +
            "      \"overall_score\": 9.5,\n" +
            "      \"description\": \"A tranquil cliffside view overlooking the beautiful valley, perfect for sunset photographs.\",\n" +
            "      \"beauty_score\": 10,\n" +
            "      \"peace_score\": 9,\n" +
            "      \"photo_score\": 10,\n" +
            "      \"crowd_score\": 9\n" +
            "    },\n" +
            "    {\n" +
            "      \"name\": \"Artisanal Pottery Village\",\n" +
            "      \"category\": \"Culture\",\n" +
            "      \"overall_score\": 9.1,\n" +
            "      \"description\": \"Witness traditional craftsmen modeling clay and try your hand at the wheel.\",\n" +
            "      \"beauty_score\": 8,\n" +
            "      \"peace_score\": 8,\n" +
            "      \"photo_score\": 9,\n" +
            "      \"crowd_score\": 8\n" +
            "    }\n" +
            "  ],\n" +
            "  \"must_visit\": [\n" +
            "    \"Main Historical Temple\",\n" +
            "    \"Botanical Gardens\"\n" +
            "  ],\n" +
            "  \"hidden_gems\": [\n" +
            "    \"Secret Panoramic Cliff\",\n" +
            "    \"Artisanal Pottery Village\"\n" +
            "  ],\n" +
            "  \"instagram_spots\": [\n" +
            "    \"Umbrella Garden Path\",\n" +
            "    \"Old Town Clocktower\"\n" +
            "  ],\n" +
            "  \"food_discovery\": [\n" +
            "    \"Local Traditional Thali\",\n" +
            "    \"Spicy Crispy Street Fritters\"\n" +
            "  ],\n" +
            "  \"local_food_specialties\": [\n" +
            "    \"Signature Brewed Spiced Tea\",\n" +
            "    \"Traditional Milk Sweets\"\n" +
            "  ],\n" +
            "  \"food_discovery_detailed\": [\n" +
            "    {\n" +
            "      \"name\": \"Heritage Dining House\",\n" +
            "      \"category\": \"Traditional\",\n" +
            "      \"rating\": 4.7,\n" +
            "      \"price_range\": \"₹\u200B₹\",\n" +
            "      \"crowd_level\": \"Moderate\",\n" +
            "      \"description\": \"Well-known for serving the absolute best authentic local thali in region.\"\n" +
            "    }\n" +
            "  ],\n" +
            "  \"local_experiences\": [\n" +
            "    {\n" +
            "      \"type\": \"Adventure\",\n" +
            "      \"name\": \"Forest Canopy Walk\",\n" +
            "      \"short_story\": \"Walk amongst rooftops on a suspended wooden bridge system.\",\n" +
            "      \"authenticity_score\": 9,\n" +
            "      \"fun_score\": 9,\n" +
            "      \"photography_score\": 9\n" +
            "    }\n" +
            "  ],\n" +
            "  \"food_trails\": [\n" +
            "    {\n" +
            "      \"title\": \"Canal Street Walk\",\n" +
            "      \"breakfast\": \"Hot Spiced Tea & Fritters at Canal Corner\",\n" +
            "      \"lunch\": \"Grand Local Thali at Heritage Dining House\",\n" +
            "      \"evening\": \"Sweet Milk Delights at Royal Sweet Corner\",\n" +
            "      \"dinner\": \"Clay Pot Curry at Old Market Grill\"\n" +
            "    }\n" +
            "  ],\n" +
            "  \"events_detected\": [\n" +
            "    \"Weekend Folk Music Show\",\n" +
            "    \"Seasonal Flower Exhibition\"\n" +
            "  ],\n" +
            "  \"days\": [\n" +
            "    {\n" +
            "      \"day\": 1,\n" +
            "      \"title\": \"Arrival & Old Town Exploration\",\n" +
            "      \"difficulty_level\": \"Easy\",\n" +
            "      \"weather_forecast\": \"Clear Skies\",\n" +
            "      \"walking_km\": \"2.0 km\",\n" +
            "      \"daily_story\": \"Arrive, unpack, and explore the charming architecture of the town center.\",\n" +
            "      \"activities\": [\n" +
            "        {\n" +
            "          \"time_slot\": \"10:00 AM\",\n" +
            "          \"title\": \"Hotel Check-in\",\n" +
            "          \"category\": \"Logistics\",\n" +
            "          \"recommended_duration\": \"1.5 hours\",\n" +
            "          \"description\": \"Check into your premium accommodation and settle in.\"\n" +
            "        },\n" +
            "        {\n" +
            "          \"time_slot\": \"01:00 PM\",\n" +
            "          \"title\": \"Traditional Thali Lunch\",\n" +
            "          \"category\": \"Food\",\n" +
            "          \"recommended_duration\": \"1.5 hours\",\n" +
            "          \"description\": \"Feast on authentic local recipes at Heritage Dining House.\"\n" +
            "        },\n" +
            "        {\n" +
            "          \"time_slot\": \"04:00 PM\",\n" +
            "          \"title\": \"Pottery Village visit\",\n" +
            "          \"category\": \"Hidden Gem\",\n" +
            "          \"recommended_duration\": \"2 hours\",\n" +
            "          \"description\": \"Observe craftsmen creating beautiful local artifacts.\"\n" +
            "        }\n" +
            "      ]\n" +
            "    },\n" +
            "    {\n" +
            "      \"day\": 2,\n" +
            "      \"title\": \"Valley Nature Trek & Sunset\",\n" +
            "      \"difficulty_level\": \"Moderate\",\n" +
            "      \"weather_forecast\": \"Pleasant\",\n" +
            "      \"walking_km\": \"4.5 km\",\n" +
            "      \"daily_story\": \"Dive into natural wonders with a canopy walk and end with an amazing sunset view.\",\n" +
            "      \"activities\": [\n" +
            "        {\n" +
            "          \"time_slot\": \"08:30 AM\",\n" +
            "          \"title\": \"Forest Canopy Walk\",\n" +
            "          \"category\": \"General\",\n" +
            "          \"recommended_duration\": \"2.5 hours\",\n" +
            "          \"description\": \"Explore forest trails on wooden suspended pathways.\"\n" +
            "        },\n" +
            "        {\n" +
            "          \"time_slot\": \"04:00 PM\",\n" +
            "          \"title\": \"Secret Panoramic Cliff Sunset\",\n" +
            "          \"category\": \"Hidden Gem\",\n" +
            "          \"recommended_duration\": \"2 hours\",\n" +
            "          \"description\": \"Relax on the cliff side with panoramic scenic views of the sun dipping below the mountains.\"\n" +
            "        }\n" +
            "      ]\n" +
            "    }\n" +
            "  ],\n" +
            "  \"alternative_plans\": [\n" +
            "    {\n" +
            "      \"plan_name\": \"Heritage & History Path\",\n" +
            "      \"description\": \"Focus on visiting ancient forts, museum galleries, and historical landmarks.\"\n" +
            "    },\n" +
            "    {\n" +
            "      \"plan_name\": \"Wellness & Spa Path\",\n" +
            "      \"description\": \"Spend your days at yoga retreats, health resorts, and meditation gardens.\"\n" +
            "    }\n" +
            "  ],\n" +
            "  \"budget_breakdown\": {\n" +
            "    \"flights\": \"₹16,000\",\n" +
            "    \"hotel\": \"₹14,000\",\n" +
            "    \"food\": \"₹6,000\",\n" +
            "    \"activities\": \"₹4,000\",\n" +
            "    \"transportation\": \"₹5,000\",\n" +
            "    \"emergency_fund\": \"₹3,000\"\n" +
            "  },\n" +
            "  \"weather\": \"Partly Cloudy, 22°C\",\n" +
            "  \"travel_tips\": [\n" +
            "    \"Wear comfortable shoes for walking trails.\",\n" +
            "    \"Keep cash handy for small vendors.\"\n" +
            "  ],\n" +
            "  \"gamification\": [\n" +
            "    \"Earn the Scenic Photographer badge by taking a photo at the Sunset Cliff!\",\n" +
            "    \"Earn the Culinary Explorer badge by trying local tea & thali!\"\n" +
            "  ],\n" +
            "  \"trip_summary\": \"A perfect blend of culture, culinary delights, and scenic nature designed for your " + travelStyle + " style.\"\n" +
            "}";
    }

    private String buildPrompt(Map<String, String> params) {
        String source = params.getOrDefault("source", "");
        String destination = params.getOrDefault("destination", "");
        String startDate = params.getOrDefault("startDate", "");
        String endDate = params.getOrDefault("endDate", "");
        String budget = params.getOrDefault("budget", "");
        String travelers = params.getOrDefault("travelers", "1");
        String travelStyle = params.getOrDefault("travelStyle", "");
        String interests = params.getOrDefault("interests", "");

        return "You are an expert AI Travel Concierge. Generate a personalized trip plan based on the following details:\n" +
                "Source: " + source + "\n" +
                "Destination: " + destination + "\n" +
                "Start Date: " + startDate + "\n" +
                "End Date: " + endDate + "\n" +
                "Budget: " + budget + "\n" +
                "Travelers: " + travelers + "\n" +
                "Travel Style: " + travelStyle + "\n" +
                "Interests: " + interests + "\n\n" +
                "You must return ONLY a JSON object. Do not include markdown code blocks like ```json or any other text.\n" +
                "The JSON must strictly follow this structure:\n" +
                "{\n" +
                "  \"tripSummary\": {\n" +
                "    \"destination\": \"\",\n" +
                "    \"durationDays\": 0,\n" +
                "    \"budget\": \"\",\n" +
                "    \"overview\": \"\"\n" +
                "  },\n" +
                "  \"estimatedBudget\": {\n" +
                "    \"transport\": 0,\n" +
                "    \"hotel\": 0,\n" +
                "    \"food\": 0,\n" +
                "    \"activities\": 0,\n" +
                "    \"total\": 0\n" +
                "  },\n" +
                "  \"recommendedHotels\": [\n" +
                "    {\n" +
                "      \"name\": \"\",\n" +
                "      \"location\": \"\",\n" +
                "      \"pricePerNight\": 0,\n" +
                "      \"rating\": 0\n" +
                "    }\n" +
                "  ],\n" +
                "  \"itinerary\": [\n" +
                "    {\n" +
                "      \"day\": 1,\n" +
                "      \"morning\": [\"\", \"\"],\n" +
                "      \"afternoon\": [\"\"],\n" +
                "      \"evening\": [\"\"],\n" +
                "      \"estimatedCost\": 0\n" +
                "    }\n" +
                "  ],\n" +
                "  \"foodRecommendations\": [\"\", \"\"],\n" +
                "  \"transportOptions\": [\"\", \"\"],\n" +
                "  \"travelTips\": [\"\", \"\"]\n" +
                "}";
    }

    private String parseGeminiResponse(String responseBody) throws Exception {
        JsonObject geminiResponse = JsonParser.parseString(responseBody).getAsJsonObject();

        if (!geminiResponse.has("candidates") || geminiResponse.get("candidates").getAsJsonArray().size() == 0) {
            throw new Exception("AI generated an empty response.");
        }

        String rawText = geminiResponse.get("candidates").getAsJsonArray()
                .get(0).getAsJsonObject()
                .get("content").getAsJsonObject()
                .get("parts").getAsJsonArray()
                .get(0).getAsJsonObject()
                .get("text").getAsString();

        // Multi-stage sanitization to ensure pure JSON
        int firstBrace = rawText.indexOf("{");
        int lastBrace = rawText.lastIndexOf("}");
        if (firstBrace != -1 && lastBrace != -1 && lastBrace >= firstBrace) {
            rawText = rawText.substring(firstBrace, lastBrace + 1);
        }

        rawText = rawText.replace("```json", "").replace("```", "").trim();

        // Validate JSON
        JsonParser.parseString(rawText);

        return rawText;
    }

    public String getAIResponse(String message, String contextPage, Map<String, String> userContext) {
        try {
            if (apiKey == null || apiKey.trim().isEmpty()) {
                return "AI Service is currently unavailable.";
            }

            String prompt = "You are AIBuddy for Voyastra. User says: " + message + ". Context page: " + contextPage + ". User Context: " + userContext;

            JsonObject requestBody = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject content = new JsonObject();
            JsonArray parts = new JsonArray();
            JsonObject part = new JsonObject();
            
            part.addProperty("text", prompt);
            parts.add(part);
            content.add("parts", parts);
            contents.add(content);
            requestBody.add("contents", contents);

            URL url = new URL(MODEL_ENDPOINT + apiKey);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(60000);
            conn.setReadTimeout(60000);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            if (conn.getResponseCode() != 200) {
                return "Error from AI Service.";
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                sb.append(line);
            }
            in.close();

            JsonObject geminiResponse = JsonParser.parseString(sb.toString()).getAsJsonObject();
            if (!geminiResponse.has("candidates") || geminiResponse.get("candidates").getAsJsonArray().size() == 0) {
                return "No response.";
            }

            return geminiResponse.get("candidates").getAsJsonArray()
                    .get(0).getAsJsonObject()
                    .get("content").getAsJsonObject()
                    .get("parts").getAsJsonArray()
                    .get(0).getAsJsonObject()
                    .get("text").getAsString().trim();

        } catch (Exception e) {
            e.printStackTrace();
            return "Sorry, I encountered an error.";
        }
    }
}
