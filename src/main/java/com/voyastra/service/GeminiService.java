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
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            Properties prop = new Properties();
            if (input == null) {
                System.err.println("Sorry, unable to find " + CONFIG_FILE);
                // Fallback or handle missing config
                this.apiKey = System.getenv("GEMINI_API_KEY");
                return;
            }
            prop.load(input);
            String key = prop.getProperty("gemini.api.key");
            this.apiKey = (key != null) ? key.trim() : null;
            if (this.apiKey == null || this.apiKey.isEmpty() || this.apiKey.equals("YOUR_API_KEY")) {
                this.apiKey = System.getenv("GEMINI_API_KEY"); // Fallback
            }
        } catch (Exception ex) {
            System.err.println("Error loading API Key: " + ex.getMessage());
            this.apiKey = System.getenv("GEMINI_API_KEY");
        }
    }

    public String generateTripPlan(Map<String, String> params) throws Exception {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new Exception("API Key is missing. Please configure gemini.api.key in config.properties.");
        }

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

        // System instructions to force JSON could also be added, but appending to prompt works well.

        URL url = new URL(MODEL_ENDPOINT + apiKey);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        // Set timeouts (e.g., 60 seconds)
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
