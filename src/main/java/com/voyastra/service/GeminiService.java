package com.voyastra.service;

import com.voyastra.service.planner.PlannerDebugService;

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
    private static final String BASE_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/";
    // Primary model → fallback chain (tried in order until one succeeds)
    private static final String[] MODELS = { "gemini-3.5-flash", "gemini-3.1-flash-lite" };

    private String apiKey;

    public GeminiService() {
        loadApiKey();
    }

    private void loadApiKey() {
        this.apiKey = com.voyastra.config.ConfigManager.get("GEMINI_API_KEY");
    }

    public String generateTripPlan(String sessionId, Map<String, String> params) {
        System.out.println("PlannerService Started");
        
        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.equals("YOUR_API_KEY")) {
            PlannerDebugService.log(sessionId, "Gemini Configuration", "WARNING", "API key missing. Falling back.", 0);
            return generateMockTripPlan(params);
        }

        String prompt = buildPrompt(params);

        // Try each model in order until one succeeds
        for (String model : MODELS) {
            try {
                System.out.println("[GeminiService] Trying model: " + model);
                String rawResponse = callGeminiModel(model, prompt);
                String parsedResponse = parseGeminiResponse(rawResponse);
                PlannerDebugService.log(sessionId, "Gemini API", "SUCCESS", "Model: " + model, 0);
                PlannerDebugService.setAiOutput(sessionId, parsedResponse);
                return parsedResponse;
            } catch (Exception e) {
                System.err.println("[GeminiService] Model " + model + " failed: " + e.getMessage());
                PlannerDebugService.log(sessionId, "Gemini API", "WARNING", model + " failed: " + e.getMessage(), 0);
                // Continue to next model in chain
            }
        }

        // All models failed — use local high-fidelity mock
        System.err.println("[GeminiService] All models failed. Using local mock.");
        PlannerDebugService.log(sessionId, "Gemini Fallback", "WARNING", "All models failed. Using local mock.", 0);
        String mock = generateMockTripPlan(params);
        PlannerDebugService.setAiOutput(sessionId, mock);
        return mock;
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n");
    }

    /**
     * Makes a single POST request to the Gemini API for the given model and returns the raw JSON response body.
     * Throws an exception with HTTP status + error body details on any non-200 response.
     */
    private String callGeminiModel(String model, String prompt) throws Exception {
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

        String endpoint = BASE_ENDPOINT + model + ":generateContent?key=" + apiKey;
        System.out.println("[GeminiService] POST → " + BASE_ENDPOINT + model + ":generateContent?key=***");

        URL url = new URL(endpoint);
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
        System.out.println("[GeminiService] HTTP " + status + " ← " + model);

        if (status != 200) {
            StringBuilder errBody = new StringBuilder();
            try (BufferedReader er = new BufferedReader(new InputStreamReader(
                    conn.getErrorStream() != null ? conn.getErrorStream() : conn.getInputStream(),
                    StandardCharsets.UTF_8))) {
                String ln;
                while ((ln = er.readLine()) != null) errBody.append(ln);
            }
            System.err.println("[GeminiService] Error body (" + model + "): " + errBody);
            throw new Exception("HTTP " + status + " from " + model + ": " +
                    errBody.toString().substring(0, Math.min(200, errBody.length())));
        }

        StringBuilder sb = new StringBuilder();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String ln;
            while ((ln = in.readLine()) != null) sb.append(ln);
        }
        return sb.toString();
    }


    private String generateMockTripPlan(Map<String, String> params) {
        String destination = params.getOrDefault("destination", "Goa");
        String travelStyle = params.getOrDefault("travelStyle", "Relaxation");
        if (travelStyle == null || travelStyle.isEmpty()) {
            travelStyle = params.getOrDefault("interests", "Relaxation");
        }
        
        // Use our new dynamic budget engine even in the fallback!
        Map<String, String> budgetMap = BudgetCalculationEngine.calculateDynamicBudget(params);

        destination = escapeJson(destination);
        travelStyle = escapeJson(travelStyle);

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
            "    \"Carry cash for small local merchants in " + destination + ".\",\n" +
            "    \"Stay hydrated during afternoon sightseeing.\"\n" +
            "  ],\n" +
            "  \"ai_recommendation_insight\": \"Since you prefer " + travelStyle + ", I have focused on local heritage, peaceful spots, and signature food trails in " + destination + ".\",\n" +
            "  \"hidden_gems_detailed\": [\n" +
            "    {\n" +
            "      \"name\": \"Secret Panoramic Cliff of " + destination + "\",\n" +
            "      \"category\": \"Nature\",\n" +
            "      \"overall_score\": 9.5,\n" +
            "      \"description\": \"A tranquil cliffside view overlooking the beautiful valley of " + destination + ", perfect for sunset photographs.\",\n" +
            "      \"beauty_score\": 10,\n" +
            "      \"peace_score\": 9,\n" +
            "      \"photo_score\": 10,\n" +
            "      \"crowd_score\": 9\n" +
            "    },\n" +
            "    {\n" +
            "      \"name\": \"Artisanal Pottery Village near " + destination + "\",\n" +
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
            "    \"flights\": \"" + budgetMap.get("flights") + "\",\n" +
            "    \"hotel\": \"" + budgetMap.get("hotel") + "\",\n" +
            "    \"food\": \"" + budgetMap.get("food") + "\",\n" +
            "    \"activities\": \"" + budgetMap.get("activities") + "\",\n" +
            "    \"transportation\": \"" + budgetMap.get("transportation") + "\",\n" +
            "    \"emergency_fund\": \"" + budgetMap.get("emergency_fund") + "\"\n" +
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
        return PromptBuilderService.buildDynamicPrompt(params);
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

            URL url = new URL(BASE_ENDPOINT + MODELS[0] + ":generateContent?key=" + apiKey);
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

    public String getDestinationInsights(String sessionId, String destination) {
        System.out.println("[AI]");
        System.out.println("Recommendations Generated");
        PlannerDebugService.log(sessionId, "AI Insights", "STARTED", "Generating insights for " + destination, 0);
        
        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.equals("YOUR_API_KEY")) {
            return generateMockDestinationInsights(destination);
        }

        String prompt = "You are an expert travel planner for Voyastra. Generate a structured JSON object containing " +
            "detailed exploration data for the destination: \"" + destination + "\".\n" +
            "The JSON must strictly conform to this schema and contain no markdown block formatting, just the raw JSON:\n" +
            "{\n" +
            "  \"country\": \"Country Name\",\n" +
            "  \"best_time\": \"Best Month range to visit (e.g. October to March)\",\n" +
            "  \"language\": \"Main official/local language spoken\",\n" +
            "  \"currency\": \"Currency Name (e.g. Euro (EUR) or Indian Rupee (INR))\",\n" +
            "  \"timezone\": \"GMT/UTC Offset (e.g. UTC+5:30 or GMT+1)\",\n" +
            "  \"top_attractions\": [\n" +
            "    {\n" +
            "      \"name\": \"Attraction Name\",\n" +
            "      \"lat\": 12.3456,\n" +
            "      \"lng\": 78.9012,\n" +
            "      \"desc\": \"Brief descriptive highlight of the attraction.\",\n" +
            "      \"why_visit\": \"A compelling sentence explaining why travelers must visit this specific spot.\",\n" +
            "      \"best_time\": \"Ideal time of day or season to visit (e.g., Morning, October to March)\",\n" +
            "      \"duration\": \"Typical duration needed (e.g., 2-3 Hours)\"\n" +
            "    }\n" +
            "  ],\n" +
            "  \"local_foods\": [\n" +
            "    {\n" +
            "      \"name\": \"Dish Name\",\n" +
            "      \"desc\": \"Description of the taste and origin.\",\n" +
            "      \"type\": \"Veg/Non-Veg/Dessert/Drink\",\n" +
            "      \"region\": \"Specific region/state of origin (e.g. Malabar, Kerala)\",\n" +
            "      \"wikipedia_title\": \"Exact or closest Wikipedia page title for the dish (e.g. Kerala Sadya or Appam or Malabar Biryani)\",\n" +
            "      \"must_try\": true\n" +
            "    }\n" +
            "  ],\n" +
            "  \"experiences\": {\n" +
            "    \"Adventure\": [\n" +
            "      {\"name\": \"Experience Name\", \"desc\": \"Description\", \"price\": \"Price (e.g. ₹1,500)\", \"duration\": \"Duration (e.g. 2 Hours)\", \"difficulty\": \"Easy/Medium/Hard\", \"rating\": 4.8}\n" +
            "    ],\n" +
            "    \"Food Trails\": [\n" +
            "      {\"name\": \"Experience Name\", \"desc\": \"Description\", \"price\": \"Price (e.g. ₹1,000)\", \"duration\": \"Duration (e.g. 3 Hours)\", \"difficulty\": \"Easy/Medium/Hard\", \"rating\": 4.9}\n" +
            "    ],\n" +
            "    \"Culture\": [\n" +
            "      {\"name\": \"Experience Name\", \"desc\": \"Description\", \"price\": \"Price (e.g. ₹500)\", \"duration\": \"Duration (e.g. 2 Hours)\", \"difficulty\": \"Easy/Medium/Hard\", \"rating\": 4.7}\n" +
            "    ],\n" +
            "    \"Spiritual\": [\n" +
            "      {\"name\": \"Experience Name\", \"desc\": \"Description\", \"price\": \"Price (e.g. Free or ₹200)\", \"duration\": \"Duration (e.g. 1 Hour)\", \"difficulty\": \"Easy/Medium/Hard\", \"rating\": 4.6}\n" +
            "    ],\n" +
            "    \"Nature\": [\n" +
            "      {\"name\": \"Experience Name\", \"desc\": \"Description\", \"price\": \"Price (e.g. ₹800)\", \"duration\": \"Duration (e.g. 4 Hours)\", \"difficulty\": \"Easy/Medium/Hard\", \"rating\": 4.9}\n" +
            "    ]\n" +
            "  },\n" +
            "  \"hotels\": [\n" +
            "    {\"name\": \"Hotel Name\", \"desc\": \"Comfortable boutique stay with stunning views.\", \"budget\": \"Budget/Mid-range/Luxury\", \"lat\": 12.3456, \"lng\": 78.9012, \"maps_link\": \"Google Maps Search link for this hotel\"}\n" +
            "  ],\n" +
            "  \"restaurants\": [\n" +
            "    {\"name\": \"Restaurant Name\", \"desc\": \"Authentic local dishes and elegant setting.\", \"budget\": \"Budget/Mid-range/Luxury\", \"lat\": 12.3456, \"lng\": 78.9012, \"maps_link\": \"Google Maps Search link for this restaurant\"}\n" +
            "  ],\n" +
            "  \"travel_tips\": {\n" +
            "    \"safety\": [\"Tip 1\", \"Tip 2\", \"Tip 3\"],\n" +
            "    \"transport\": [\"Tip 1\", \"Tip 2\", \"Tip 3\"],\n" +
            "    \"local_etiquette\": [\"Tip 1\", \"Tip 2\", \"Tip 3\"],\n" +
            "    \"packing_tips\": [\"Tip 1\", \"Tip 2\", \"Tip 3\"],\n" +
            "    \"budget_advice\": [\"Tip 1\", \"Tip 2\", \"Tip 3\"]\n" +
            "  },\n" +
            "  \"itinerary_previews\": [\n" +
            "    { \"days\": 3, \"title\": \"The Highlight Reel\", \"description\": \"Perfect for a weekend getaway. Covers the absolute must-sees.\" },\n" +
            "    { \"days\": 5, \"title\": \"The Explorer\", \"description\": \"A balanced mix of popular attractions and hidden gems.\" },\n" +
            "    { \"days\": 7, \"title\": \"The Deep Dive\", \"description\": \"Immerse yourself fully. Includes day trips and local experiences.\" }\n" +
            "  ],\n" +
            "  \"ai_insights\": \"An immersive, premium paragraph summarizing the unique vibe of this destination, best season highlights, and expert travel tips.\"\n" +
            "}\n" +
            "Provide at least 3-4 top attractions with correct, real latitudes and longitudes, at least 3 local foods, at least 1-2 experiences per category, at least 3 premium hotels with lat/lng, at least 3 top-rated restaurants with lat/lng, and at least 3-5 actionable tips per travel_tips section, and exactly 3 itinerary previews (3 days, 5 days, 7 days). Ensure all coordinates are accurate real-world values.";

        for (String model : MODELS) {
            try {
                System.out.println("[GeminiService] Fetching destination insights using model: " + model);
                String rawResponse = callGeminiModel(model, prompt);
                String parsedResponse = parseGeminiResponse(rawResponse);
                return parsedResponse;
            } catch (Exception e) {
                System.err.println("[GeminiService] Model " + model + " failed for destination insights: " + e.getMessage());
            }
        }

        return generateMockDestinationInsights(destination);
    }

    private String generateMockDestinationInsights(String destination) {
        String destLower = destination.toLowerCase().trim();
        destination = escapeJson(destination);
        
        if (destLower.contains("kerala")) {
            return "{\n" +
                "  \"country\": \"India\",\n" +
                "  \"best_time\": \"September to March\",\n" +
                "  \"language\": \"Malayalam\",\n" +
                "  \"currency\": \"Indian Rupee (INR)\",\n" +
                "  \"timezone\": \"UTC+5:30\",\n" +
                "  \"top_attractions\": [\n" +
                "    {\n" +
                "      \"name\": \"Munnar\",\n" +
                "      \"lat\": 10.0889,\n" +
                "      \"lng\": 77.0595,\n" +
                "      \"desc\": \"A breathtaking hill station famous for its lush green tea plantations, misty valleys, and winding roads.\",\n" +
                "      \"why_visit\": \"Stunning panoramic views of tea estate carpets and cool mountain atmosphere perfect for trekking.\",\n" +
                "      \"best_time\": \"September to May\",\n" +
                "      \"duration\": \"1-2 Days\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Alleppey\",\n" +
                "      \"lat\": 9.4981,\n" +
                "      \"lng\": 76.3388,\n" +
                "      \"desc\": \"The 'Venice of the East', famous for its pristine backwaters, network of canals, and houseboat cruises.\",\n" +
                "      \"why_visit\": \"Spend a serene night inside a traditional luxury houseboat floating through scenic palm-fringed lagoons.\",\n" +
                "      \"best_time\": \"October to February\",\n" +
                "      \"duration\": \"1 Day\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Kochi\",\n" +
                "      \"lat\": 9.9312,\n" +
                "      \"lng\": 76.2673,\n" +
                "      \"desc\": \"A historic port city showing a blend of Dutch, Portuguese, British, and traditional Malabar influences.\",\n" +
                "      \"why_visit\": \"See the iconic Chinese Fishing Nets and walk through the historic streets of Fort Kochi.\",\n" +
                "      \"best_time\": \"October to March\",\n" +
                "      \"duration\": \"1-2 Days\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Wayanad\",\n" +
                "      \"lat\": 11.6854,\n" +
                "      \"lng\": 76.1320,\n" +
                "      \"desc\": \"A mountainous region adorned with spice plantations, waterfalls, caves, and wildlife sanctuaries.\",\n" +
                "      \"why_visit\": \"Explore the prehistoric rock carvings of Edakkal Caves and trek up to the heart-shaped Chembra Lake.\",\n" +
                "      \"best_time\": \"October to May\",\n" +
                "      \"duration\": \"2 Days\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Thekkady\",\n" +
                "      \"lat\": 9.6025,\n" +
                "      \"lng\": 77.1643,\n" +
                "      \"desc\": \"Home to the famous Periyar National Park, a scenic reserve boasting elephants, tigers, and rare flora.\",\n" +
                "      \"why_visit\": \"Take a tranquil boat safari on Periyar Lake to watch wild elephant herds grazing along the water edge.\",\n" +
                "      \"best_time\": \"October to March\",\n" +
                "      \"duration\": \"1 Day\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"local_foods\": [\n" +
                "    {\n" +
                "      \"name\": \"Kerala Sadya\",\n" +
                "      \"desc\": \"A grand traditional vegetarian banquet served on a banana leaf featuring over 24 delicate dishes.\",\n" +
                "      \"type\": \"Veg\",\n" +
                "      \"region\": \"Statewide, Kerala\",\n" +
                "      \"wikipedia_title\": \"Sadya\",\n" +
                "      \"must_try\": true\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Appam\",\n" +
                "      \"desc\": \"A bowl-shaped thin pancake made from fermented rice batter and coconut milk, crispy at the edges and soft in the center.\",\n" +
                "      \"type\": \"Veg\",\n" +
                "      \"region\": \"South India, Kerala\",\n" +
                "      \"wikipedia_title\": \"Appam\",\n" +
                "      \"must_try\": true\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Malabar Biryani\",\n" +
                "      \"desc\": \"An aromatic rice dish cooked with premium short-grain Kaima rice, ghee, local spices, and marinated chicken or mutton.\",\n" +
                "      \"type\": \"Non-Veg\",\n" +
                "      \"region\": \"Malabar, Kerala\",\n" +
                "      \"wikipedia_title\": \"Mappila cuisine\",\n" +
                "      \"must_try\": true\n" +
                "    }\n" +
                "  ],\n" +
                "  \"experiences\": {\n" +
                "    \"Adventure\": [\n" +
                "      {\"name\": \"Kayaking\", \"desc\": \"Paddle through the calm backwaters of Alleppey lined with coconut trees.\", \"price\": \"₹1,200\", \"duration\": \"3 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.8},\n" +
                "      {\"name\": \"Scuba Diving\", \"desc\": \"Explore the marine life and beautiful corals under the waters of Kovalam.\", \"price\": \"₹4,500\", \"duration\": \"2 Hours\", \"difficulty\": \"Medium\", \"rating\": 4.9}\n" +
                "    ],\n" +
                "    \"Food Trails\": [\n" +
                "      {\"name\": \"Toddy Shop Culinary Tour\", \"desc\": \"Savor extremely spicy local fish curry and kappa paired with fresh coconut toddy.\", \"price\": \"₹800\", \"duration\": \"3 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.7}\n" +
                "    ],\n" +
                "    \"Culture\": [\n" +
                "      {\"name\": \"Kathakali\", \"desc\": \"Witness the classical dance-drama featuring elaborate colorful makeup and storytelling.\", \"price\": \"₹400\", \"duration\": \"2 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.9}\n" +
                "    ],\n" +
                "    \"Spiritual\": [\n" +
                "      {\"name\": \"Ayurvedic Rejuvenation\", \"desc\": \"Experience traditional therapeutic oil massages and wellness consultation.\", \"price\": \"₹2,500\", \"duration\": \"1.5 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.8}\n" +
                "    ],\n" +
                "    \"Nature\": [\n" +
                "      {\"name\": \"Periyar Safari\", \"desc\": \"Spot wild elephants, gaurs, and birds on a boat safari inside the Periyar wildlife reserve.\", \"price\": \"₹600\", \"duration\": \"2.5 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.6}\n" +
                "    ]\n" +
                "  },\n" +
                "  \"hotels\": [\n" +
                "    {\"name\": \"Kumarakom Lake Resort\", \"desc\": \"Luxury heritage resort set along Vembanad Lake.\", \"budget\": \"Luxury\", \"lat\": 9.6126, \"lng\": 76.4320, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Kumarakom+Lake+Resort+Kerala\"},\n" +
                "    {\"name\": \"Spice Village\", \"desc\": \"Eco-friendly tribal-style resort in the highlands of Thekkady.\", \"budget\": \"Mid-range\", \"lat\": 9.5950, \"lng\": 77.1716, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Spice+Village+Thekkady+Kerala\"},\n" +
                "    {\"name\": \"Fort House Hotel\", \"desc\": \"Charming waterfront hotel in historic Fort Kochi.\", \"budget\": \"Budget\", \"lat\": 9.9659, \"lng\": 76.2423, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Fort+House+Hotel+Kochi+Kerala\"}\n" +
                "  ],\n" +
                "  \"restaurants\": [\n" +
                "    {\"name\": \"Villa Maya\", \"desc\": \"Award-winning fine dining in a restored 18th-century palace.\", \"budget\": \"Luxury\", \"lat\": 8.5241, \"lng\": 76.9366, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Villa+Maya+Trivandrum+Kerala\"},\n" +
                "    {\"name\": \"Paragon Restaurant\", \"desc\": \"Famous for legendary, authentic Malabar Biryani.\", \"budget\": \"Budget\", \"lat\": 11.2588, \"lng\": 75.7804, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Paragon+Restaurant+Calicut+Kerala\"},\n" +
                "    {\"name\": \"Kashi Art Cafe\", \"desc\": \"Artsy cafe in Fort Kochi offering great European food and local tea.\", \"budget\": \"Mid-range\", \"lat\": 9.9677, \"lng\": 76.2432, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Kashi+Art+Cafe+Kochi+Kerala\"}\n" +
                "  ],\n" +
                "  \"travel_tips\": {\n" +
                "    \"safety\": [\n" +
                "      \"Kerala is generally very safe; exercise standard precautions in crowded markets and beaches.\",\n" +
                "      \"Store copies of your passport and important documents separately from originals.\",\n" +
                "      \"Avoid swimming at beaches without lifeguard supervision, especially during monsoon season.\",\n" +
                "      \"Keep emergency numbers handy: Police 100, Ambulance 108, Tourist helpline 1800-425-4747.\"\n" +
                "    ],\n" +
                "    \"transport\": [\n" +
                "      \"KSRTC buses connect all major destinations; opt for AC Volvo buses for long inter-city routes.\",\n" +
                "      \"Auto-rickshaws are plentiful — insist on the meter or use app-based cabs (Rapido, Ola) in Kochi.\",\n" +
                "      \"Rent a self-drive car or hire a local taxi for flexible hill-station exploration in Munnar.\",\n" +
                "      \"The Kerala Water Metro in Kochi is a scenic, affordable way to cross the backwaters.\"\n" +
                "    ],\n" +
                "    \"local_etiquette\": [\n" +
                "      \"Remove shoes before entering temples and traditional Keralan homes.\",\n" +
                "      \"Dress modestly at religious sites; carry a scarf to cover shoulders.\",\n" +
                "      \"Ask permission before photographing locals, especially during religious ceremonies.\",\n" +
                "      \"Learn a few Malayalam phrases like 'Nanni' (Thank you) — locals love the effort.\"\n" +
                "    ],\n" +
                "    \"packing_tips\": [\n" +
                "      \"Pack light, breathable cotton clothing for the humid coastal and lowland areas.\",\n" +
                "      \"Bring a light rain jacket or compact umbrella — showers can be sudden even outside monsoon.\",\n" +
                "      \"Comfortable walking shoes are essential for hill treks in Munnar and cave explorations.\",\n" +
                "      \"Carry mosquito repellent for backwater and forest areas, especially at dusk.\"\n" +
                "    ],\n" +
                "    \"budget_advice\": [\n" +
                "      \"Eating at local toddy shops and traditional Kerala restaurants offers the most authentic food at just ₹80-150 per meal.\",\n" +
                "      \"Book houseboats directly from the Alleppey jetty rather than travel agents to save 20-30%.\",\n" +
                "      \"KSRTC buses and shared auto-rickshaws are the cheapest way to travel between nearby towns.\",\n" +
                "      \"Visiting temples and national parks in the early morning avoids peak entry prices and crowds.\"\n" +
                "    ]\n" +
                "  },\n" +
                "  \"itinerary_previews\": [\n" +
                "    { \"days\": 3, \"title\": \"Kerala Snapshot\", \"description\": \"Kochi culture and a night on the backwaters.\" },\n" +
                "    { \"days\": 5, \"title\": \"Hills & Backwaters\", \"description\": \"Add Munnar tea gardens and wildlife in Thekkady.\" },\n" +
                "    { \"days\": 7, \"title\": \"Complete God's Own Country\", \"description\": \"Full loop from beaches to hills, including Wayanad.\" }\n" +
                "  ],\n" +
                "  \"ai_insights\": \"Kerala, globally known as 'God\\'s Own Country', is a sensory paradise. From the misty tea gardens of Munnar to the calming backwater canals of Alleppey, it offers a harmonious blend of nature, history, and authentic Ayurvedic wellness therapies.\"\n" +
                "}";
        } else if (destLower.contains("goa")) {
            return "{\n" +
                "  \"country\": \"India\",\n" +
                "  \"best_time\": \"November to February\",\n" +
                "  \"language\": \"Konkani & English\",\n" +
                "  \"currency\": \"Indian Rupee (INR)\",\n" +
                "  \"timezone\": \"UTC+5:30\",\n" +
                "  \"top_attractions\": [\n" +
                "    {\n" +
                "      \"name\": \"Baga Beach\",\n" +
                "      \"lat\": 15.5553,\n" +
                "      \"lng\": 73.7517,\n" +
                "      \"desc\": \"One of Goa's most popular beaches, known for its energetic nightlife, water sports, and beach shacks.\",\n" +
                "      \"why_visit\": \"Excellent parasailing by day and vibrant music, drinks, and dining directly on the sand by night.\",\n" +
                "      \"best_time\": \"October to May\",\n" +
                "      \"duration\": \"3-4 Hours\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Basilica of Bom Jesus\",\n" +
                "      \"lat\": 15.5009,\n" +
                "      \"lng\": 73.9116,\n" +
                "      \"desc\": \"A UNESCO World Heritage site containing the sacred mortal remains of Saint Francis Xavier.\",\n" +
                "      \"why_visit\": \"Marvel at the stunning Baroque architecture and deep religious history of Portuguese Goa.\",\n" +
                "      \"best_time\": \"Morning\",\n" +
                "      \"duration\": \"1-2 Hours\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Dudhsagar Falls\",\n" +
                "      \"lat\": 15.3185,\n" +
                "      \"lng\": 74.3129,\n" +
                "      \"desc\": \"A spectacular four-tiered waterfall cascading down the Mandovi River, looking like a sea of milk.\",\n" +
                "      \"why_visit\": \"Embark on an exciting open jeep safari through jungle trails to reach the base pool of the falls.\",\n" +
                "      \"best_time\": \"October to May\",\n" +
                "      \"duration\": \"5-6 Hours\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"local_foods\": [\n" +
                "    {\n" +
                "      \"name\": \"Goan Fish Curry\",\n" +
                "      \"desc\": \"A tangy, spiced coconut-based curry loaded with fresh catch, served hot over steamed rice.\",\n" +
                "      \"type\": \"Non-Veg\",\n" +
                "      \"region\": \"Coastal Goa\",\n" +
                "      \"wikipedia_title\": \"Fish curry\",\n" +
                "      \"must_try\": true\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Bebinca\",\n" +
                "      \"desc\": \"A rich, traditional multi-layered pudding made from coconut milk, ghee, sugar, and egg yolks.\",\n" +
                "      \"type\": \"Dessert\",\n" +
                "      \"region\": \"Goa\",\n" +
                "      \"wikipedia_title\": \"Bebinca\",\n" +
                "      \"must_try\": true\n" +
                "    }\n" +
                "  ],\n" +
                "  \"experiences\": {\n" +
                "    \"Adventure\": [\n" +
                "      {\"name\": \"Parasailing at Calangute\", \"desc\": \"Soar high above the Arabian Sea with a parachute.\", \"price\": \"₹1,500\", \"duration\": \"1 Hour\", \"difficulty\": \"Medium\", \"rating\": 4.7},\n" +
                "      {\"name\": \"Scuba Diving at Grande Island\", \"desc\": \"Dive into Goan waters to see corals, fishes, and shipwrecks.\", \"price\": \"₹3,500\", \"duration\": \"4 Hours\", \"difficulty\": \"Medium\", \"rating\": 4.6}\n" +
                "    ],\n" +
                "    \"Food Trails\": [\n" +
                "      {\"name\": \"Spice Plantation Tour & Buffet\", \"desc\": \"Walk through aromatic spice plantations and enjoy a traditional Goan buffet with Feni.\", \"price\": \"₹600\", \"duration\": \"3 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.8}\n" +
                "    ],\n" +
                "    \"Culture\": [\n" +
                "      {\"name\": \"Fontainhas Heritage Walk\", \"desc\": \"Explore the narrow winding streets of the Latin Quarter with its old Portuguese houses.\", \"price\": \"₹500\", \"duration\": \"2 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.9}\n" +
                "    ],\n" +
                "    \"Spiritual\": [\n" +
                "      {\"name\": \"Visit Mangueshi Temple\", \"desc\": \"Pay respects at this beautiful 450-year-old temple dedicated to Lord Shiva.\", \"price\": \"Free\", \"duration\": \"1 Hour\", \"difficulty\": \"Easy\", \"rating\": 4.5}\n" +
                "    ],\n" +
                "    \"Nature\": [\n" +
                "      {\"name\": \"Dolphin Spotting Boat Ride\", \"desc\": \"Take a scenic morning boat trip to watch dolphins playing in the wild.\", \"price\": \"₹400\", \"duration\": \"1.5 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.4}\n" +
                "    ]\n" +
                "  },\n" +
                "  \"hotels\": [\n" +
                "    {\"name\": \"Taj Exotica Resort & Spa\", \"desc\": \"Mediterranean-style luxury resort in Benaulim overlooking the Arabian Sea.\", \"budget\": \"Luxury\", \"lat\": 15.2538, \"lng\": 73.9184, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Taj+Exotica+Resort+Goa\"},\n" +
                "    {\"name\": \"Ahilya by the Sea\", \"desc\": \"Serene boutique hotel nestled in a quiet corner of Coco Beach.\", \"budget\": \"Mid-range\", \"lat\": 15.5149, \"lng\": 73.7677, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Ahilya+by+the+Sea+Goa\"},\n" +
                "    {\"name\": \"Pousada by the Beach\", \"desc\": \"Cozy beachfront cottages in Calangute with great views.\", \"budget\": \"Budget\", \"lat\": 15.5440, \"lng\": 73.7554, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Pousada+by+the+Beach+Goa\"}\n" +
                "  ],\n" +
                "  \"restaurants\": [\n" +
                "    {\"name\": \"Gunpowder\", \"desc\": \"Famous for coastal South Indian food set in a lovely heritage house.\", \"budget\": \"Mid-range\", \"lat\": 15.5785, \"lng\": 73.7890, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Gunpowder+Assagao+Goa\"},\n" +
                "    {\"name\": \"Mum's Kitchen\", \"desc\": \"Preserving traditional Goan culinary heritage in Panaji.\", \"budget\": \"Luxury\", \"lat\": 15.4989, \"lng\": 73.8278, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Mums+Kitchen+Panaji+Goa\"},\n" +
                "    {\"name\": \"Curlies Beach Shack\", \"desc\": \"Iconic beachfront dining and drinks at Anjuna Beach.\", \"budget\": \"Budget\", \"lat\": 15.5733, \"lng\": 73.7404, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Curlies+Beach+Shack+Anjuna+Goa\"}\n" +
                "  ],\n" +
                "  \"travel_tips\": {\n" +
                "    \"safety\": [\n" +
                "      \"Goa is generally safe; stick to well-lit beach areas after dark, especially in North Goa.\",\n" +
                "      \"Beware of scams near tourist areas — always negotiate taxi fares before boarding.\",\n" +
                "      \"Keep valuables secured on crowded beaches and be cautious of unsolicited 'tour guides'.\",\n" +
                "      \"Never swim near rocks or during monsoon red-flag warnings — respect beach flag systems strictly.\"\n" +
                "    ],\n" +
                "    \"transport\": [\n" +
                "      \"Renting a scooter (₹250-400/day) is the most popular and economical way to explore Goa.\",\n" +
                "      \"Taxis in Goa are not metered — always agree on a fare before getting in or use the GoaMiles app.\",\n" +
                "      \"Local Kadamba buses are extremely cheap (₹10-30) for town-to-town travel.\",\n" +
                "      \"The ferry between Panaji and Betim is a charming 5-minute river crossing — a Goa experience in itself.\"\n" +
                "    ],\n" +
                "    \"local_etiquette\": [\n" +
                "      \"Wearing swimwear in restaurants, markets, or churches is disrespectful and frowned upon.\",\n" +
                "      \"Remove shoes and dress modestly when visiting old Portuguese churches and Hindu temples.\",\n" +
                "      \"Bargaining is acceptable in flea markets but not in fixed-price stores.\",\n" +
                "      \"Goa observes a quiet 10 PM noise curfew on beaches — loud music after this time is illegal.\"\n" +
                "    ],\n" +
                "    \"packing_tips\": [\n" +
                "      \"Pack light summer clothes and at least 2-3 swimwear sets for the beach-heavy itinerary.\",\n" +
                "      \"High-SPF sunscreen is essential — tropical sun is extremely intense even on cloudy days.\",\n" +
                "      \"A light cardigan is useful for air-conditioned restaurants and late evening beach breezes.\",\n" +
                "      \"Sandals and flip-flops are standard footwear; bring one pair of walking shoes for heritage visits.\"\n" +
                "    ],\n" +
                "    \"budget_advice\": [\n" +
                "      \"Beach shack food (fish thali, prawn curry, Goan sausage) costs ₹120-300 per plate — far better than tourist restaurants.\",\n" +
                "      \"Stay in South Goa for more exclusivity; North Goa offers value stays closer to the action.\",\n" +
                "      \"Visit the Anjuna Flea Market (Wednesdays) for authentic crafts and souvenirs at negotiable prices.\",\n" +
                "      \"Spice plantation tours (₹500-800/person) include a buffet lunch and are exceptional value.\"\n" +
                "    ]\n" +
                "  },\n" +
                "  \"itinerary_previews\": [\n" +
                "    { \"days\": 3, \"title\": \"Goa Essentials\", \"description\": \"Beaches, shacks, and a touch of Old Goa heritage.\" },\n" +
                "    { \"days\": 5, \"title\": \"Sun, Sand & Spice\", \"description\": \"Explore North and South beaches, plus a spice plantation.\" },\n" +
                "    { \"days\": 7, \"title\": \"The Susegad Life\", \"description\": \"Deep dive into hidden beaches, waterfalls, and local markets.\" }\n" +
                "  ],\n" +
                "  \"ai_insights\": \"Goa brings together Portuguese heritage, sun-soaked coastlines, and a relaxed Susegad lifestyle. Whether you prefer old-world colonial churches, active beach sports, or fresh seafood shacks, Goa is an absolute tropical escape.\"\n" +
                "}";
        } else if (destLower.contains("paris")) {
            return "{\n" +
                "  \"country\": \"France\",\n" +
                "  \"best_time\": \"April to October\",\n" +
                "  \"language\": \"French\",\n" +
                "  \"currency\": \"Euro (EUR)\",\n" +
                "  \"timezone\": \"GMT+1\",\n" +
                "  \"top_attractions\": [\n" +
                "    {\n" +
                "      \"name\": \"Eiffel Tower\",\n" +
                "      \"lat\": 48.8584,\n" +
                "      \"lng\": 2.2945,\n" +
                "      \"desc\": \"The world-famous wrought-iron lattice tower on the Champ de Mars, standing as the symbol of Paris.\",\n" +
                "      \"why_visit\": \"Take the elevator to the summit for an unforgettable panoramic sunset over the Seine.\",\n" +
                "      \"best_time\": \"Sunset / Evening\",\n" +
                "      \"duration\": :\"2-3 Hours\"\n" +
                "    },\n" +
                "    {\n" +
                "      \"name\": \"Louvre Museum\",\n" +
                "      \"lat\": 48.8606,\n" +
                "      \"lng\": 2.3376,\n" +
                "      \"desc\": \"The world's largest art museum, home to the Mona Lisa and thousands of historic masterpieces.\",\n" +
                "      \"why_visit\": \"Witness priceless ancient sculptures, classic paintings, and the famous glass pyramid.\",\n" +
                "      \"best_time\": \"Morning / Night Opening\",\n" +
                "      \"duration\": \"3-4 Hours\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"local_foods\": [\n" +
                "    {\n" +
                "      \"name\": \"Croissant\",\n" +
                "      \"desc\": \"A buttery, flaky, viennoiserie pastry named for its historical crescent shape.\",\n" +
                "      \"type\": \"Veg\",\n" +
                "      \"region\": \"Paris, France\",\n" +
                "      \"wikipedia_title\": \"Croissant\",\n" +
                "      \"must_try\": true\n" +
                "    }\n" +
                "  ],\n" +
                "  \"experiences\": {\n" +
                "    \"Adventure\": [\n" +
                "      {\"name\": \"Seine River Cruise\", \"desc\": \"Glide down the river Seine past iconic monuments.\", \"price\": \"€15\", \"duration\": \"1 Hour\", \"difficulty\": \"Easy\", \"rating\": 4.6}\n" +
                "    ],\n" +
                "    \"Food Trails\": [\n" +
                "      {\"name\": \"Croissant Making Class\", \"desc\": \"Learn the secrets of classic French baking from a professional pastry chef.\", \"price\": \"€80\", \"duration\": \"3 Hours\", \"difficulty\": \"Medium\", \"rating\": 4.9}\n" +
                "    ],\n" +
                "    \"Culture\": [\n" +
                "      {\"name\": \"Louvre Guided Art Tour\", \"desc\": \"Skip the lines and explore the world's greatest works of art with a certified guide.\", \"price\": \"€60\", \"duration\": \"2.5 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.8}\n" +
                "    ],\n" +
                "    \"Spiritual\": [\n" +
                "      {\"name\": \"Notre-Dame Cathedral Walk\", \"desc\": \"Admire the Gothic architecture and historic grandeur from the plaza.\", \"price\": \"Free\", \"duration\": \"1 Hour\", \"difficulty\": \"Easy\", \"rating\": 4.7}\n" +
                "    ],\n" +
                "    \"Nature\": [\n" +
                "      {\"name\": \"Jardin du Luxembourg Stroll\", \"desc\": \"Relax in the beautifully manicured lawns, fountains, and gravel paths of this royal garden.\", \"price\": \"Free\", \"duration\": \"2 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.7}\n" +
                "    ]\n" +
                "  },\n" +
                "  \"hotels\": [\n" +
                "    {\"name\": \"The Peninsula Paris\", \"desc\": \"Ultraluxe palace hotel steps from the Arc de Triomphe.\", \"budget\": \"Luxury\", \"lat\": 48.8738, \"lng\": 2.2953, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=The+Peninsula+Paris\"},\n" +
                "    {\"name\": \"Hotel Caron de Beaumarchais\", \"desc\": \"Boutique 18th-century style hotel in the historic Marais district.\", \"budget\": \"Mid-range\", \"lat\": 48.8557, \"lng\": 2.3536, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Hotel+Caron+de+Beaumarchais+Paris\"},\n" +
                "    {\"name\": \"Generator Paris\", \"desc\": \"Chic, trendy design hostel located in the vibrant 10th Arrondissement.\", \"budget\": \"Budget\", \"lat\": 48.8755, \"lng\": 2.3556, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Generator+Paris\"}\n" +
                "  ],\n" +
                "  \"restaurants\": [\n" +
                "    {\"name\": \"Le Jules Verne\", \"desc\": \"Michelin-starred fine dining located on the second level of the Eiffel Tower.\", \"budget\": \"Luxury\", \"lat\": 48.8584, \"lng\": 2.2945, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Le+Jules+Verne+Paris\"},\n" +
                "    {\"name\": \"Bouillon Chartier\", \"desc\": \"Legendary Belle Époque dining room serving classic French fare at budget prices.\", \"budget\": \"Budget\", \"lat\": 48.8726, \"lng\": 2.3459, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Bouillon+Chartier+Paris\"},\n" +
                "    {\"name\": \"Le Comptoir du Relais\", \"desc\": \"Famous French bistro in Saint-Germain offering phenomenal gourmet plates.\", \"budget\": \"Mid-range\", \"lat\": 48.8538, \"lng\": 2.3390, \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Le+Comptoir+du+Relais+Paris\"}\n" +
                "  ],\n" +
                "  \"travel_tips\": {\n" +
                "    \"safety\": [\n" +
                "      \"Paris is safe but pickpocketing is rife near the Eiffel Tower and Metro lines — keep bags in front.\",\n" +
                "      \"Beware of scam artists near attractions offering friendship bracelets or petitions — politely refuse.\",\n" +
                "      \"Emergency number in France is 112; 15 for medical (SAMU), 17 for Police.\",\n" +
                "      \"Only take official taxis from designated stands at airports; avoid unlicensed drivers.\"\n" +
                "    ],\n" +
                "    \"transport\": [\n" +
                "      \"The Paris Metro is the fastest way around — buy a Navigo Découverte weekly pass (€30) for unlimited travel.\",\n" +
                "      \"RER B connects CDG Airport directly to central Paris in 35 minutes for just €11.80.\",\n" +
                "      \"Vélib bike-sharing stations (€5/day) are ideal for scenic rides along the Seine.\",\n" +
                "      \"Avoid taxis during peak hours — Metro or walking is faster and cheaper in central Paris.\"\n" +
                "    ],\n" +
                "    \"local_etiquette\": [\n" +
                "      \"Always greet shopkeepers with Bonjour before asking anything — skipping this is considered rude.\",\n" +
                "      \"Tipping is not obligatory but leaving small change (€1-2) at cafes is appreciated.\",\n" +
                "      \"Speak softly in restaurants — Parisians tend to keep voices low in dining settings.\",\n" +
                "      \"Photography inside the Louvre is permitted but using flash is strictly prohibited.\"\n" +
                "    ],\n" +
                "    \"packing_tips\": [\n" +
                "      \"Pack layers — a light trench coat works in all four Parisian seasons.\",\n" +
                "      \"Comfortable walking shoes are a must for cobblestone street exploration.\",\n" +
                "      \"A reusable shopping tote doubles as an eco-friendly, chic Parisian accessory for market visits.\",\n" +
                "      \"A universal power adapter is necessary as France uses Type E sockets (230V).\"\n" +
                "    ],\n" +
                "    \"budget_advice\": [\n" +
                "      \"The Paris Museum Pass (€52/2 days) covers 50+ museums including the Louvre with skip-the-line access.\",\n" +
                "      \"Lunch at a brasserie is much cheaper than dinner — the formule midi offers 2 courses for €12-18.\",\n" +
                "      \"Picnicking along the Seine with baguette, cheese, and wine costs under €15 — a true Parisian ritual.\",\n" +
                "      \"Many museums including Rodin Museum have free entry on the first Sunday of every month.\"\n" +
                "    ]\n" +
                "  },\n" +
                "  \"itinerary_previews\": [\n" +
                "    { \"days\": 3, \"title\": \"Paris Highlights\", \"description\": \"Eiffel Tower, Louvre, and a Seine cruise.\" },\n" +
                "    { \"days\": 5, \"title\": \"Art & Romance\", \"description\": \"Add Montmartre, Versailles, and gourmet dining.\" },\n" +
                "    { \"days\": 7, \"title\": \"The Parisian Dream\", \"description\": \"Pace yourself with café culture, hidden museums, and day trips.\" }\n" +
                "  ],\n" +
                "  \"ai_insights\": \"Paris, the City of Light, is the global capital of art, fashion, gastronomy, and culture. Stroll along the Seine, admire gothic architectures, and enjoy world-class culinary crafts in neighborhood bistros.\"\n" +
                "}";
        }
        
        // Default Mock Fallback
        return "{\n" +
            "  \"country\": \"Explore Country\",\n" +
            "  \"best_time\": \"October to May\",\n" +
            "  \"language\": \"English & Local dialects\",\n" +
            "  \"currency\": \"Local Currency\",\n" +
            "  \"timezone\": \"UTC+5:30\",\n" +
            "  \"top_attractions\": [\n" +
            "    {\n" +
            "      \"name\": \"Scenic Valley Overlook in " + destination + "\",\n" +
            "      \"lat\": 15.4989,\n" +
            "      \"lng\": 73.8278,\n" +
            "      \"desc\": \"A breathtaking viewpoint highlighting the local beauty of " + destination + ".\",\n" +
            "      \"why_visit\": \"Offers panoramic vistas, stunning sunset photography, and cool mountain air.\",\n" +
            "      \"best_time\": \"Late Afternoon\",\n" +
            "      \"duration\": \"2 Hours\"\n" +
            "    },\n" +
            "    {\n" +
            "      \"name\": \"Heritage Museum of " + destination + "\",\n" +
            "      \"lat\": 15.5020,\n" +
            "      \"lng\": 73.8300,\n" +
            "      \"desc\": \"Explore the history, art, and artifacts unique to " + destination + ".\",\n" +
            "      \"why_visit\": \"Features rare ancient artifacts, cultural exhibits, and guided tours.\",\n" +
            "      \"best_time\": \"Morning\",\n" +
            "      \"duration\": \"1.5 Hours\"\n" +
            "    }\n" +
            "  ],\n" +
            "  \"local_foods\": [\n" +
            "    {\n" +
            "      \"name\": \"Signature Spiced Curry\",\n" +
            "      \"desc\": \"An aromatic regional dish with spices sourced from local plantations.\",\n" +
            "      \"type\": \"Non-Veg\",\n" +
            "      \"region\": \"Regional\",\n" +
            "      \"wikipedia_title\": \"Curry\",\n" +
            "      \"must_try\": true\n" +
            "    },\n" +
            "    {\n" +
            "      \"name\": \"Traditional Sweet Pudding\",\n" +
            "      \"desc\": \"A popular milk-based dessert served during festivals.\",\n" +
            "      \"type\": \"Dessert\",\n" +
            "      \"region\": \"Regional\",\n" +
            "      \"wikipedia_title\": \"Pudding\",\n" +
            "      \"must_try\": false\n" +
            "    }\n" +
            "  ],\n" +
            "  \"experiences\": {\n" +
            "    \"Adventure\": [\n" +
            "      {\"name\": \"Jungle Hiking\", \"desc\": \"Trek through lush forest paths to discover hidden streams.\", \"price\": \"₹500\", \"duration\": \"3 Hours\", \"difficulty\": \"Medium\", \"rating\": 4.5}\n" +
            "    ],\n" +
            "    \"Food Trails\": [\n" +
            "      {\"name\": \"Street Food Walk\", \"desc\": \"Taste the most popular local street foods and beverages.\", \"price\": \"₹400\", \"duration\": \"2 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.7}\n" +
            "    ],\n" +
            "    \"Culture\": [\n" +
            "      {\"name\": \"Heritage Walking Tour\", \"desc\": \"Walk through old towns and colonial structures with local guides.\", \"price\": \"₹300\", \"duration\": \"2 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.6}\n" +
            "    ],\n" +
            "    \"Spiritual\": [\n" +
            "      {\"name\": \"Meditation Class\", \"desc\": \"Participate in a guided meditation session in a quiet local temple garden.\", \"price\": \"Free\", \"duration\": \"1 Hour\", \"difficulty\": \"Easy\", \"rating\": 4.8}\n" +
            "    ],\n" +
            "    \"Nature\": [\n" +
            "      {\"name\": \"Sunrise Vantage Point\", \"desc\": \"Enjoy the early morning sunrise from the highest local viewpoint.\", \"price\": \"Free\", \"duration\": \"2 Hours\", \"difficulty\": \"Easy\", \"rating\": 4.9}\n" +
            "    ]\n" +
            "  },\n" +
            "  \"hotels\": [\n" +
            "    {\"name\": \"Grand Imperial Hotel\", \"desc\": \"A historic luxury stay with top-tier hospitality and pools.\", \"budget\": \"Luxury\", \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Grand+Imperial+Hotel+\" + destination},\n" +
            "    {\"name\": \"Green View Resort\", \"desc\": \"Mid-range scenic cottages surrounded by local hills.\", \"budget\": \"Mid-range\", \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Green+View+Resort+\" + destination},\n" +
            "    {\"name\": \"Explorer Backpackers\", \"desc\": \"Affordable budget hostel right in the town center.\", \"budget\": \"Budget\", \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Backpackers+\" + destination}\n" +
            "  ],\n" +
            "  \"restaurants\": [\n" +
            "    {\"name\": \"The Local Kitchen\", \"desc\": \"Elegant dining serving authentic regional dishes and desserts.\", \"budget\": \"Luxury\", \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=The+Local+Kitchen+\" + destination},\n" +
            "    {\"name\": \"Bazaar Street Grill\", \"desc\": \"Bustling mid-range barbecue and local grill house.\", \"budget\": \"Mid-range\", \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Bazaar+Street+Grill+\" + destination},\n" +
            "    {\"name\": \"Noodle Corner\", \"desc\": \"Popular budget spot for street-style stir-fries and beverages.\", \"budget\": \"Budget\", \"maps_link\": \"https://www.google.com/maps/search/?api=1&query=Noodle+Corner+\" + destination}\n" +
            "  ],\n" +
            "  \"travel_tips\": {\n" +
            "    \"safety\": [\n" +
            "      \"Research the safety situation for " + destination + " before traveling and register with your embassy.\",\n" +
            "      \"Store a photocopy of your passport and documents in a separate bag from the originals.\",\n" +
            "      \"Purchase comprehensive travel insurance before departing to " + destination + ".\",\n" +
            "      \"Keep emergency contact numbers accessible at all times during your trip.\"\n" +
            "    ],\n" +
            "    \"transport\": [\n" +
            "      \"Research local transport options in advance — public buses and shared taxis are usually most economical.\",\n" +
            "      \"Download offline maps (Maps.me or Google Maps offline) before arrival in " + destination + ".\",\n" +
            "      \"Always agree on cab/taxi fares before boarding where meters are not standard.\",\n" +
            "      \"Renting a local bicycle or scooter can be the most flexible way to explore " + destination + ".\"\n" +
            "    ],\n" +
            "    \"local_etiquette\": [\n" +
            "      \"Learn a few basic phrases in the local language — even a simple greeting is deeply appreciated.\",\n" +
            "      \"Dress conservatively when visiting religious or culturally significant sites in " + destination + ".\",\n" +
            "      \"Always ask permission before photographing local people or ceremonies.\",\n" +
            "      \"Research local tipping customs as they vary significantly by region and culture.\"\n" +
            "    ],\n" +
            "    \"packing_tips\": [\n" +
            "      \"Pack lightweight, layerable clothing appropriate for the climate of " + destination + ".\",\n" +
            "      \"Bring a universal power adapter and portable battery bank for electronics.\",\n" +
            "      \"Include a basic first-aid kit with common medications for stomach upsets and headaches.\",\n" +
            "      \"A reusable water bottle with filter ensures safe hydration across " + destination + ".\"\n" +
            "    ],\n" +
            "    \"budget_advice\": [\n" +
            "      \"Eating where locals eat is always cheaper and more authentic than tourist-facing restaurants.\",\n" +
            "      \"Book accommodation and tours well in advance during peak season for the best rates.\",\n" +
            "      \"Look for combo attraction passes that bundle multiple entry tickets at a discount.\",\n" +
            "      \"Use local ATMs at bank branches for the best exchange rates; avoid airport currency desks.\"\n" +
            "    ]\n" +
            "  },\n" +
            "  \"itinerary_previews\": [\n" +
            "    { \"days\": 3, \"title\": \"The Short Break\", \"description\": \"Perfect for a quick weekend getaway hitting the top sights.\" },\n" +
            "    { \"days\": 5, \"title\": \"The Explorer\", \"description\": \"A balanced mix of popular attractions and hidden local gems.\" },\n" +
            "    { \"days\": 7, \"title\": \"The Deep Dive\", \"description\": \"Immerse yourself fully. Includes day trips and local cultural experiences.\" }\n" +
            "  ],\n" +
            "  \"ai_insights\": \"Welcome to \" + destination + \", a wonderful destination blending historic allure with vibrant local cultures. Whether you want to explore natural attractions or dive into the culinary scene, it offers something unique for every travel style.\"\n" +
            "}";
    }
}
