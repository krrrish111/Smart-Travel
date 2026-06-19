package com.voyastra.servlet;

import com.voyastra.service.GeminiService;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.service.PlannerDebugService;
import com.voyastra.model.User;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/planner", "/my-plans", "/planner-debug"})
public class PlannerServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(PlannerServlet.class.getName());


    private GeminiService geminiService;

    @Override
    public void init() throws ServletException {
        super.init();
        geminiService = new GeminiService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("STEP 1: PlannerServlet Entered");
        System.out.println("PlannerServlet Reached (GET)");
        
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

        request.setAttribute("youtubeApiKey", com.voyastra.config.ConfigManager.get("YOUTUBE_API_KEY"));
        request.setAttribute("unsplashApiKey", com.voyastra.config.ConfigManager.get("UNSPLASH_ACCESS_KEY"));
        
        String debugMode = com.voyastra.config.ConfigManager.get("PLANNER_DEBUG");
        request.setAttribute("isDebugMode", "true".equalsIgnoreCase(debugMode));

        String path = request.getServletPath();
        if ("/planner-debug".equals(path)) {
            request.getRequestDispatcher("/pages/planner-debug.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("===== PLANNER SERVLET HIT =====");
        System.out.println("STEP 1: PlannerServlet Entered");
        System.out.println("PlannerServlet Started");
        System.out.println("PlannerServlet Reached (POST)");
        System.out.println("GeneratePlanServlet Started");
        try {
            Map<String, String> params = new HashMap<>();
            int adults = 1;
            int children = 0;
            int seniors = 0;

            String contentType = request.getContentType();
            if (contentType != null && contentType.contains("application/json")) {
                StringBuilder sb = new StringBuilder();
                String line;
                try (java.io.BufferedReader reader = request.getReader()) {
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                }
                String jsonStr = sb.toString();
                System.out.println("Received JSON body: " + jsonStr);
                try {
                    com.google.gson.JsonObject jsonObj = com.google.gson.JsonParser.parseString(jsonStr).getAsJsonObject();
                    params.put("source", jsonObj.has("origin") ? jsonObj.get("origin").getAsString() : "");
                    params.put("destination", jsonObj.has("destination") ? jsonObj.get("destination").getAsString() : "");
                    params.put("startDate", (jsonObj.has("departureDate") && !jsonObj.get("departureDate").getAsString().isEmpty()) ? jsonObj.get("departureDate").getAsString() : new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
                    params.put("endDate", (jsonObj.has("returnDate") && !jsonObj.get("returnDate").getAsString().isEmpty()) ? jsonObj.get("returnDate").getAsString() : new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date(System.currentTimeMillis() + 5L * 24L * 60L * 60L * 1000L)));
                    params.put("budget", jsonObj.has("budget") ? jsonObj.get("budget").getAsString() : "");
                    params.put("travelStyle", jsonObj.has("interests") ? jsonObj.get("interests").getAsString() : "");
                    
                    String travelersVal = jsonObj.has("travelers") ? jsonObj.get("travelers").getAsString() : "1";
                    params.put("travelers", travelersVal);
                    adults = Integer.parseInt(travelersVal);
                } catch (Exception ex) {
                    System.err.println("JSON parse error: " + ex.getMessage());
                }
            } else {
                params.put("source", request.getParameter("startLocation"));
                params.put("destination", request.getParameter("destination"));
                params.put("startDate", request.getParameter("departureDate"));
                params.put("endDate", request.getParameter("returnDate"));
                params.put("budget", request.getParameter("budget"));
                params.put("travelStyle", request.getParameter("type"));
                params.put("interests", request.getParameter("interests"));
                
                adults = Integer.parseInt(request.getParameter("adults") != null && !request.getParameter("adults").isEmpty() ? request.getParameter("adults") : "1");
                children = Integer.parseInt(request.getParameter("children") != null && !request.getParameter("children").isEmpty() ? request.getParameter("children") : "0");
                seniors = Integer.parseInt(request.getParameter("seniors") != null && !request.getParameter("seniors").isEmpty() ? request.getParameter("seniors") : "0");
                int totalTravelers = adults + children + seniors;
                params.put("travelers", String.valueOf(totalTravelers));
            }

            String sessionId = request.getSession().getId();
            PlannerDebugService.log(sessionId, "Input Validation", "SUCCESS", "Captured inputs: " + params.get("destination"), 0);

            System.out.println("--- Planner Form Submitted ---");
            System.out.println("Origin = " + params.get("source"));
            System.out.println("Destination = " + params.get("destination"));
            System.out.println("Start Date: " + params.get("startDate"));
            System.out.println("End Date: " + params.get("endDate"));
            System.out.println("Budget: " + params.get("budget"));

            if (params.get("source") == null || params.get("destination") == null || 
                params.get("startDate") == null || params.get("endDate") == null || params.get("budget") == null) {
                System.err.println("Validation failed: Missing required parameters.");
                PlannerDebugService.log(sessionId, "Input Validation", "ERROR", "Missing required parameters.", 0);
                request.setAttribute("error", "Missing required parameters.");
                request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
                return;
            }

            // DB save
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
                pstmt.setString(2, params.get("source"));
                pstmt.setString(3, params.get("destination"));
                pstmt.setString(4, params.get("startDate"));
                pstmt.setString(5, params.get("endDate"));
                pstmt.setBigDecimal(6, new java.math.BigDecimal(params.get("budget")));
                pstmt.setString(7, params.get("travelStyle"));
                pstmt.setInt(8, adults);
                pstmt.setInt(9, children);
                pstmt.setInt(10, seniors);
                pstmt.executeUpdate();
                System.out.println("Saved planner request to database.");
            } catch (Exception e) {
                System.err.println("Failed to save planner request: " + e.getMessage());
            }

            System.out.println("Calling Gemini...");
            PlannerDebugService.log(sessionId, "Gemini API", "STARTED", "Generating trip to " + params.get("destination"), 0);
            long geminiStart = System.currentTimeMillis();
            
            String itineraryJson = geminiService.generateTripPlan(sessionId, params);
            
            PlannerDebugService.log(sessionId, "Gemini API", "SUCCESS", "Generated JSON payload", System.currentTimeMillis() - geminiStart);
            System.out.println("Gemini Response = " + itineraryJson);
            
            // Initialize empty lists to avoid NPE in JSPTL
            java.lang.reflect.Type type = new com.google.gson.reflect.TypeToken<java.util.Map<String, Object>>(){}.getType();
            java.util.Map<String, Object> plan = new com.google.gson.Gson().fromJson(itineraryJson, type);
            
            // Store generated itinerary
            request.setAttribute("generatedPlan", plan);
            request.setAttribute("tripData", itineraryJson);
            request.setAttribute("itineraryJson", itineraryJson);
            
            System.out.println("STEP 2: Trip Generated");
            System.out.println("Trip Generated");
            System.out.println("STEP 3: Forwarding To planner-result.jsp");
            System.out.println("Forwarding To planner-result.jsp");
            request.getRequestDispatcher("/pages/planner-result.jsp").forward(request, response);

        } catch (Exception e) {
            String sid = request.getSession().getId();
            com.voyastra.service.PlannerDebugService.log(sid, "System Error", "EXCEPTION", e.getMessage(), 0);
            logger.log(Level.SEVERE, "Exception occurred", e);
            request.setAttribute("error", "Gemini API Error: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
        }
    }
}
