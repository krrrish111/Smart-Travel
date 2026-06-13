package com.voyastra.servlet;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.voyastra.util.DBConnection;
import com.voyastra.model.User;

/**
 * AI-powered Trip Planner Servlet.
 * Uses Google Gemini API to generate personalized itineraries.
 */
@WebServlet(urlPatterns = {"/generatePlan", "/planner", "/my-plans"})
public class PlannerServlet extends HttpServlet {

    // API Key moved to Configurable property (Env var preferred in Production)
    private static final String DEFAULT_API_KEY = "AIzaSyBkjbg2b3kUoK7srVbIPCeUOPHpTpjyecY";
    private static final String API_KEY = System.getenv("GEMINI_API_KEY") != null ? System.getenv("GEMINI_API_KEY") : DEFAULT_API_KEY;
    
    private static final String GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key="
            + API_KEY;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Track planner_sessions
        String sessionId = request.getSession().getId();
        User user = (User) request.getSession().getAttribute("user");
        int userId = user != null ? user.getId() : -1;
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO planner_sessions (session_id, user_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE last_active = CURRENT_TIMESTAMP";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sessionId);
            if (userId != -1) {
                pstmt.setInt(2, userId);
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.err.println("Failed to track planner session: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract Parameters
        String origin = request.getParameter("startLocation");
        String destination = request.getParameter("destination");
        String departureDate = request.getParameter("departureDate");
        String returnDate = request.getParameter("returnDate");
        String budgetStr = request.getParameter("budget");
        String type = request.getParameter("type");
        int adults = Integer.parseInt(request.getParameter("adults") != null ? request.getParameter("adults") : "1");
        int children = Integer.parseInt(request.getParameter("children") != null ? request.getParameter("children") : "0");
        int seniors = Integer.parseInt(request.getParameter("seniors") != null ? request.getParameter("seniors") : "0");

        if (origin == null || destination == null || departureDate == null || returnDate == null || budgetStr == null) {
            request.setAttribute("error", "Missing required parameters.");
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // Calculate Days
        LocalDate dep = LocalDate.parse(departureDate);
        LocalDate ret = LocalDate.parse(returnDate);
        long days = ChronoUnit.DAYS.between(dep, ret);
        if (days < 1) days = 1;

        // Save Planner Request to Database
        User user = (User) request.getSession().getAttribute("user");
        int userId = user != null ? user.getId() : -1;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO planner_requests (user_id, origin, destination, departure_date, return_date, budget, travel_style, adults, children, seniors) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            if (userId != -1) {
                pstmt.setInt(1, userId);
            } else {
                pstmt.setNull(1, java.sql.Types.INTEGER);
            }
            pstmt.setString(2, origin);
            pstmt.setString(3, destination);
            pstmt.setString(4, departureDate);
            pstmt.setString(5, returnDate);
            pstmt.setBigDecimal(6, new java.math.BigDecimal(budgetStr));
            pstmt.setString(7, type);
            pstmt.setInt(8, adults);
            pstmt.setInt(9, children);
            pstmt.setInt(10, seniors);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.err.println("Failed to save planner request: " + e.getMessage());
        }

        // 2. Build AI Prompt Dynamically for AI Concierge
        String prompt = String.format(
                "You are an expert Gen-Z AI Travel Concierge. Create an interactive, personalized itinerary for %s for %d days. " +
                "The user's budget is INR %s and their travel style is %s. " +
                "Your response must feel like an Instagram-inspired dynamic planner, not a standard form. " +
                "Include: " +
                "1. Trip Summary (Why Visit). " +
                "2. Recommended Duration. " +
                "3. Best Season. " +
                "4. Best Travel Mode. " +
                "5. Travel Warnings. " +
                "6. Hidden Gems (unique lesser-known spots). " +
                "7. Food Discovery (local cuisines and cafes). " +
                "8. Smart Weather (what to pack). " +
                "9. Instagram Spots (highly photogenic areas). " +
                "10. Gamification tips (challenges or fun things to do). " +
                "11. Daily plan broken down by morning/afternoon/evening. " +
                "Return the response ONLY as a strictly formatted JSON object with no markdown wrappers or extra text. " +
                "Structure: " +
                "{" +
                "  \"title\": \"Epic Trip to [Destination]\"," +
                "  \"trip_summary\": \"A dynamic and culturally rich city...\",\n" +
                "  \"destination_story\": \"Wake up to the sound of waves, spend your mornings exploring hidden beaches...\",\n" +
                "  \"trip_score\": 94,\n" +
                "  \"recommended_duration\": \"4 Days\",\n" +
                "  \"best_season\": \"October to March\",\n" +
                "  \"best_travel_mode\": \"Metro / Cab\",\n" +
                "  \"travel_warnings\": [\"Beware of tourist traps\", \"Drink bottled water\"],\n" +
                "  \"weather\": \"Sunny with a chance of adventure\",\n" +
                "  \"must_visit\": [\"Place 1\", \"Place 2\"],\n" +
                "  \"hidden_gems_detailed\": [\n" +
                "    {\n" +
                "      \"name\": \"Secret Beach\",\n" +
                "      \"description\": \"Hidden behind forest trails, this beach offers unparalleled peace.\",\n" +
                "      \"category\": \"Secret Beach\",\n" +
                "      \"beauty_score\": 9.8,\n" +
                "      \"peace_score\": 9.7,\n" +
                "      \"photo_score\": 9.6,\n" +
                "      \"crowd_score\": 2.1,\n" +
                "      \"authenticity_score\": 9.4,\n" +
                "      \"overall_score\": 9.5,\n" +
                "      \"best_time\": \"5 PM\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"instagram_spots_detailed\": [\n" +
                "    {\n" +
                "      \"name\": \"Sunset Point\",\n" +
                "      \"photo_score\": 9.8,\n" +
                "      \"difficulty\": \"Easy\",\n" +
                "      \"best_time\": \"Golden Hour\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"food_discovery_detailed\": [\n" +
                "    {\n" +
                "      \"name\": \"Local Seafood Shack\",\n" +
                "      \"description\": \"The best fresh catch of the day.\",\n" +
                "      \"price_range\": \"$\",\n" +
                "      \"category\": \"Street Food\",\n" +
                "      \"location\": \"Near Beach\"\n" +
                "    }\n" +
                "  ],\n" +
                "  \"ai_recommendation_insight\": \"Most tourists visit X. Based on your preference for Y, I recommend Z.\",\n" +
                "  \"gamification\": [\"Try surfing\", \"Take a polaroid\"],\n" +
                "  \"travel_tips\": [\"Tip 1\", \"Tip 2\"],\n" +
                "  \"budget_summary\": [{\"category\": \"Stay\", \"amount\": \"Rs. 10000\"}],\n" +
                "  \"days\": [ { \"day\": 1, \"title\": \"Arrival\", \"activities\": [ {\"time\": \"Morning\", \"description\": \"...\"} ] } ]\n" +
                "}",
                destination, days, budgetStr, type);

        // 3. Call Gemini API
        try {
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

            URL url = new URL(GEMINI_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int status = conn.getResponseCode();
            if (status != 200) {
                request.setAttribute("error", "AI service unavailable (Status: " + status + "). Please check API Key.");
                request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
                return;
            }

            // Read Response
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                sb.append(line);
            }
            in.close();

            // Parse and extract inner text
            JsonObject geminiResponse = JsonParser.parseString(sb.toString()).getAsJsonObject();

            // Null safety for Gemini response
            if (!geminiResponse.has("candidates") || geminiResponse.get("candidates").getAsJsonArray().size() == 0) {
                throw new Exception("AI generated an empty response. Please try again.");
            }

            String rawAiText = geminiResponse.get("candidates").getAsJsonArray()
                    .get(0).getAsJsonObject()
                    .get("content").getAsJsonObject()
                    .get("parts").getAsJsonArray()
                    .get(0).getAsJsonObject()
                    .get("text").getAsString();

            // 4. Robust JSON Extraction (multi-stage sanitization)
            try {
                int firstBrace = rawAiText.indexOf("{");
                int lastBrace = rawAiText.lastIndexOf("}");
                if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
                    rawAiText = rawAiText.substring(firstBrace, lastBrace + 1);
                }
                
                // Clean any potential markdown wrappers
                rawAiText = rawAiText.replace("```json", "").replace("```", "").trim();
                
                // Validate if it's still parsable JSON
                JsonParser.parseString(rawAiText);
                
                // 5. Send AI response using request attribute
                request.setAttribute("itineraryJson", rawAiText);
                request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
                
            } catch (Exception parseError) {
                System.err.println("AI Parser Error: " + parseError.getMessage());
                request.setAttribute("error", "AI returned an invalid format. Please refine your request.");
                request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Failed to generate plan: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
        }
    }
}

