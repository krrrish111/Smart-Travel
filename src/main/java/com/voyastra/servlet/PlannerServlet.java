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
        request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract Parameters
        String destination = request.getParameter("destination");
        String budget = request.getParameter("budget");
        String days = request.getParameter("days");
        String type = request.getParameter("type");

        if (destination == null || budget == null || days == null || type == null) {
            request.setAttribute("error", "Missing required parameters.");
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 2. Build AI Prompt Dynamically
        String prompt = String.format(
                "Create a detailed travel itinerary for %s for %s days within a budget of %s. " +
                        "The travel style is %s. " +
                        "Include: Day-wise plan, Activities, Estimated cost breakdown, Must-visit places, Travel tips. "
                        +
                        "Return the response ONLY as a clean JSON object with this structure (no markdown tags): " +
                        "{ \"title\": \"Name\", \"days\": [ { \"day\": 1, \"title\": \"Day Title\", \"activities\": [ {\"time\": \"Morning\", \"description\": \"...\"} ] } ], \"budget_summary\": [ {\"category\": \"...\", \"amount\": \"...\"} ], \"must_visit\": [\"...\"], \"travel_tips\": [\"...\"] }",
                destination, days, budget, type);

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

