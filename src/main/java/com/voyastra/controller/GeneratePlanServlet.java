package com.voyastra.controller;

import com.voyastra.service.GeminiService;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/generatePlan")
public class GeneratePlanServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(GeneratePlanServlet.class.getName());
    private GeminiService geminiService;

    @Override
    public void init() throws ServletException {
        super.init();
        geminiService = new GeminiService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("PlannerServlet Reached");

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("X-Content-Type-Options", "nosniff");

        // Session check — return JSON error, never redirect from an AJAX endpoint
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"message\":\"Session expired. Please log in again.\"}");
            return;
        }

        String sessionId = session.getId();
        com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.REQUEST_RECEIVED);

        try {
            com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.VALIDATING_INPUT);
            
            // Parse JSON body (sent as application/json from fetch)
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) sb.append(line);
            }
            
            JsonObject body = JsonParser.parseString(sb.toString()).getAsJsonObject();

            String origin        = body.has("origin") ? body.get("origin").getAsString().trim() : "";
            String destination   = body.has("destination") ? body.get("destination").getAsString().trim() : "";
            String departureDate = body.has("departureDate") ? body.get("departureDate").getAsString() : "";
            String returnDate    = body.has("returnDate") ? body.get("returnDate").getAsString() : "";
            String travelStyle   = body.has("travelStyle") ? body.get("travelStyle").getAsString() : "Relaxation";
            String budget        = body.has("budget") ? body.get("budget").getAsString() : "50000";
            String adults        = body.has("adults") ? body.get("adults").getAsString() : "1";
            String children      = body.has("children") ? body.get("children").getAsString() : "0";
            String seniors       = body.has("seniors") ? body.get("seniors").getAsString() : "0";

            if (origin.isEmpty() || destination.isEmpty()) {
                com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.FAILED);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"message\":\"Origin and destination are required.\"}");
                return;
            }

            Map<String, String> params = new HashMap<>();
            params.put("source", origin);
            params.put("destination", destination);
            params.put("startDate", departureDate);
            params.put("endDate", returnDate);
            params.put("travelStyle", travelStyle);
            params.put("budget", budget);
            
            try {
                int totalTravelers = Integer.parseInt(adults) + Integer.parseInt(children) + Integer.parseInt(seniors);
                params.put("travelers", String.valueOf(totalTravelers));
            } catch (NumberFormatException e) {
                params.put("travelers", "1");
            }

            com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.GENERATING_ITINERARY);
            String itineraryJson = geminiService.generateTripPlan(sessionId, params);

            // itineraryJson is already a valid JSON string from GeminiService
            com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.COMPLETED);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(itineraryJson);

        } catch (Exception e) {
            com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.FAILED);
            logger.log(Level.SEVERE, "Itinerary generation failed", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                "{\"message\":\"AI generation failed. Please try again later.\"}"
            );
            // NO sendRedirect here — ever
        }
    }
}
