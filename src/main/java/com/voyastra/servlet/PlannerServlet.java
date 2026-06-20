package com.voyastra.servlet;

import com.voyastra.service.GeminiService;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.service.PlannerDebugService;
import com.voyastra.model.User;
import com.voyastra.util.DBConnection;
import com.voyastra.service.UnsplashService;
import com.voyastra.service.YouTubeService;
import com.voyastra.service.BudgetCalculationEngine;
import com.voyastra.dao.DestinationDAO;
import com.voyastra.util.DiagnosticManager;
import com.voyastra.model.PlannerStatus;

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

@WebServlet(name = "PlannerServlet", urlPatterns = {"/planner", "/my-plans", "/planner-debug", "/planner-result", "/planner-result.jsp"})
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
        
        if ("/planner-result".equals(path) || "/planner-result.jsp".equals(path)) {
            request.getRequestDispatcher("/pages/planner-result.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sessionId = request.getSession().getId();
        PlannerDebugService.clearSession(sessionId);
        DiagnosticManager.setStatus(sessionId, PlannerStatus.REQUEST_RECEIVED);

        String destination = request.getParameter("destination");
        String budget = request.getParameter("budget");
        String travelStyle = request.getParameter("type");

        System.out.println("========== PLANNER START ==========");
        System.out.println("Destination: " + destination);
        System.out.println("Budget: " + budget);
        System.out.println("Travel Style: " + travelStyle);

        // 1. Input Validation
        String currentStep = "Input Validation";
        try {
            DiagnosticManager.setStatus(sessionId, PlannerStatus.VALIDATING_INPUT);
            System.out.println("[STEP 1] Input Validation Started");
            PlannerDebugService.log(sessionId, "Input Validation", "STARTED", "Validating inputs", 0);
            
            if (request.getParameter("startLocation") == null || destination == null || 
                request.getParameter("departureDate") == null || request.getParameter("returnDate") == null || budget == null) {
                throw new IllegalArgumentException("Missing required travel parameters.");
            }
            PlannerDebugService.log(sessionId, "Input Validation", "SUCCESS", "Input validation passed", 0);
            System.out.println("[STEP 1] Input Validation Success");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "Input Validation", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 2. Destination Database Lookup
        boolean dbLookupSuccess = false;
        try {
            System.out.println("[Destination] Database lookup started");
            PlannerDebugService.log(sessionId, "Destination", "STARTED", "Database lookup started", 0);
            
            DestinationDAO destinationDAO = new DestinationDAO();
            java.util.List<com.voyastra.model.Destination> destList = destinationDAO.searchDestinations(destination);
            
            System.out.println("[Destination] Database lookup finished");
            if (destList != null && !destList.isEmpty()) {
                dbLookupSuccess = true;
                DiagnosticManager.setStatus(sessionId, PlannerStatus.DESTINATION_SUCCESS);
                PlannerDebugService.log(sessionId, "Destination", "SUCCESS", "Database lookup finished. Status updated to SUCCESS", 0);
                System.out.println("[Destination] Status updated to SUCCESS");
            } else {
                System.out.println("[Destination] Database lookup failed to find destination: " + destination);
                PlannerDebugService.log(sessionId, "Destination", "MISS", "Destination not found in database.", 0);
            }
        } catch (Exception e) {
            System.err.println("Destination DB Lookup Failed: " + e.getMessage());
            PlannerDebugService.log(sessionId, "Destination", "WARNING", "Database lookup failed: " + e.getMessage(), 0);
        }

        // 3. Database Cache (Not implemented)
        System.out.println("[Database Cache] Cache not implemented");
        DiagnosticManager.setStatus(sessionId, PlannerStatus.CACHE_NOT_USED);
        PlannerDebugService.log(sessionId, "Cache", "NOT USED", "Cache not implemented. Status updated to NOT USED", 0);
        System.out.println("[Database Cache] Status updated to NOT USED");

        Map<String, String> params = new HashMap<>();
        params.put("source", request.getParameter("startLocation"));
        params.put("destination", destination);
        params.put("startDate", request.getParameter("departureDate"));
        params.put("endDate", request.getParameter("returnDate"));
        params.put("budget", budget);
        params.put("travelStyle", travelStyle);
        params.put("interests", request.getParameter("interests"));
        
        int adults = 1;
        try {
            adults = Integer.parseInt(request.getParameter("adults") != null && !request.getParameter("adults").isEmpty() ? request.getParameter("adults") : "1");
        } catch (Exception e) {}
        int children = 0;
        try {
            children = Integer.parseInt(request.getParameter("children") != null && !request.getParameter("children").isEmpty() ? request.getParameter("children") : "0");
        } catch (Exception e) {}
        int seniors = 0;
        try {
            seniors = Integer.parseInt(request.getParameter("seniors") != null && !request.getParameter("seniors").isEmpty() ? request.getParameter("seniors") : "0");
        } catch (Exception e) {}
        int totalTravelers = adults + children + seniors;
        params.put("travelers", String.valueOf(totalTravelers));

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
        } catch (Exception e) {
            System.err.println("Failed to save planner request: " + e.getMessage());
        }

        // 2. Gemini API Request & 3. Gemini API Response
        String itineraryJson = "";
        currentStep = "Gemini API";
        try {
            System.out.println("[STEP 2] Gemini Request Started");
            DiagnosticManager.setStatus(sessionId, PlannerStatus.GENERATING_ITINERARY);
            PlannerDebugService.log(sessionId, "Gemini API", "STARTED", "Calling Gemini API", 0);
            long geminiStart = System.currentTimeMillis();
            
            itineraryJson = geminiService.generateTripPlan(sessionId, params);
            
            long geminiDuration = System.currentTimeMillis() - geminiStart;
            PlannerDebugService.log(sessionId, "Gemini API", "SUCCESS", "Gemini response generated successfully", geminiDuration);
            System.out.println("[STEP 3] Gemini Response Received");
            System.out.println(itineraryJson.substring(0, Math.min(500, itineraryJson.length())));

            if (!dbLookupSuccess) {
                System.out.println("[Destination] Generated using AI fallback");
                DiagnosticManager.setStatus(sessionId, PlannerStatus.DESTINATION_SUCCESS);
                PlannerDebugService.log(sessionId, "Destination", "SUCCESS", "Generated using AI fallback. Status updated to SUCCESS", 0);
                System.out.println("[Destination] Status updated to SUCCESS");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "Gemini API", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "Gemini Service Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 4. JSON Parsing
        java.util.Map<String, Object> itinerary = null;
        currentStep = "JSON Parser";
        try {
            PlannerDebugService.log(sessionId, "JSON Parser", "STARTED", "Parsing JSON response", 0);
            com.google.gson.Gson gson = new com.google.gson.Gson();
            java.lang.reflect.Type type = new com.google.gson.reflect.TypeToken<java.util.Map<String, Object>>(){}.getType();
            itinerary = gson.fromJson(itineraryJson, type);
            if (itinerary == null) {
                throw new NullPointerException("Parsed itinerary Map is null.");
            }
            PlannerDebugService.log(sessionId, "JSON Parser", "SUCCESS", "JSON successfully parsed", 0);
            System.out.println("[STEP 4] JSON Parse Success");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            PlannerDebugService.log(sessionId, "JSON Parser", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "JSON Parse Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 5. Budget Calculation
        java.util.Map<String, String> calculatedBudget = null;
        currentStep = "Budget Engine";
        try {
            DiagnosticManager.setStatus(sessionId, PlannerStatus.CALCULATING_BUDGET);
            PlannerDebugService.log(sessionId, "Budget Engine", "STARTED", "Calculating budget breakdown", 0);
            calculatedBudget = BudgetCalculationEngine.calculateDynamicBudget(params);
            PlannerDebugService.log(sessionId, "Budget Engine", "SUCCESS", "Budget breakdown completed", 0);
            System.out.println("[STEP 5] Budget Generated");
            System.out.println("[TRACE] Budget Calculation Complete");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "Budget Engine", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "Budget Calculation Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 6. Unsplash API Call & 7. Unsplash Response
        java.util.List<java.util.Map<String, String>> images = new java.util.ArrayList<>();
        currentStep = "Unsplash API";
        try {
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FETCHING_IMAGES);
            PlannerDebugService.log(sessionId, "Unsplash API", "STARTED", "Fetching destination images", 0);
            long unsplashStart = System.currentTimeMillis();
            UnsplashService unsplashService = new UnsplashService();
            String unsplashJson = unsplashService.searchDestinationImages(sessionId, destination, "tourism", 5);
            long unsplashDuration = System.currentTimeMillis() - unsplashStart;

            com.google.gson.JsonObject unsplashObj = com.google.gson.JsonParser.parseString(unsplashJson).getAsJsonObject();
            if (unsplashObj.has("results")) {
                com.google.gson.JsonArray results = unsplashObj.getAsJsonArray("results");
                for (com.google.gson.JsonElement item : results) {
                    com.google.gson.JsonObject itemObj = item.getAsJsonObject();
                    java.util.Map<String, String> imgMap = new java.util.HashMap<>();
                    if (itemObj.has("urls") && itemObj.getAsJsonObject("urls").has("regular")) {
                        imgMap.put("imageUrl", itemObj.getAsJsonObject("urls").get("regular").getAsString());
                    }
                    String desc = "";
                    if (itemObj.has("description") && !itemObj.get("description").isJsonNull()) {
                        desc = itemObj.get("description").getAsString();
                    } else if (itemObj.has("alt_description") && !itemObj.get("alt_description").isJsonNull()) {
                        desc = itemObj.get("alt_description").getAsString();
                    }
                    imgMap.put("description", desc);
                    images.add(imgMap);
                }
            }

            if (images.isEmpty()) {
                String[] mockUrls = {
                    "https://images.unsplash.com/photo-1506461883276-594a12b11ac3?auto=format&fit=crop&w=600&q=80",
                    "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80",
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&q=80",
                    "https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80",
                    "https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=600&q=80"
                };
                for (int i = 0; i < mockUrls.length; i++) {
                    java.util.Map<String, String> imgMap = new java.util.HashMap<>();
                    imgMap.put("imageUrl", mockUrls[i]);
                    imgMap.put("description", "Beautiful view of " + destination);
                    images.add(imgMap);
                }
            }

            PlannerDebugService.log(sessionId, "Unsplash API", "SUCCESS", "Found " + images.size() + " images", unsplashDuration);
            System.out.println("[STEP 6] Unsplash Images Found = " + images.size());
            System.out.println("[TRACE] Image Search Complete");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "Unsplash API", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "Unsplash API Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 8. YouTube API Call & 9. YouTube Response
        java.util.List<java.util.Map<String, String>> videos = new java.util.ArrayList<>();
        currentStep = "YouTube API";
        try {
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FETCHING_VIDEOS);
            PlannerDebugService.log(sessionId, "YouTube API", "STARTED", "Fetching travel videos", 0);
            long youtubeStart = System.currentTimeMillis();
            YouTubeService youtubeService = new YouTubeService();
            String youtubeJson = youtubeService.searchDestinationVideos(sessionId, destination, "travel vlog", 3);
            long youtubeDuration = System.currentTimeMillis() - youtubeStart;

            com.google.gson.JsonObject youtubeObj = com.google.gson.JsonParser.parseString(youtubeJson).getAsJsonObject();
            if (youtubeObj.has("items")) {
                com.google.gson.JsonArray items = youtubeObj.getAsJsonArray("items");
                for (com.google.gson.JsonElement item : items) {
                    com.google.gson.JsonObject itemObj = item.getAsJsonObject();
                    if (itemObj.has("id") && itemObj.getAsJsonObject("id").has("videoId")) {
                        java.util.Map<String, String> vidMap = new java.util.HashMap<>();
                        vidMap.put("videoId", itemObj.getAsJsonObject("id").get("videoId").getAsString());
                        String title = "Travel Vlog";
                        if (itemObj.has("snippet") && itemObj.getAsJsonObject("snippet").has("title")) {
                            title = itemObj.getAsJsonObject("snippet").get("title").getAsString();
                        }
                        vidMap.put("title", title);
                        videos.add(vidMap);
                    }
                }
            }

            if (videos.isEmpty()) {
                String[] mockVids = { "jfKfPfyJRdk", "N1-Jmq7ITFE", "hTVj8N_8Fk4" };
                String[] mockTitles = { "Cinematic Travel Vlog", "4K Drone Footage", "Local Cuisine Guide" };
                for (int i = 0; i < mockVids.length; i++) {
                    java.util.Map<String, String> vidMap = new java.util.HashMap<>();
                    vidMap.put("videoId", mockVids[i]);
                    vidMap.put("title", mockTitles[i]);
                    videos.add(vidMap);
                }
            }

            PlannerDebugService.log(sessionId, "YouTube API", "SUCCESS", "Found " + videos.size() + " videos", youtubeDuration);
            System.out.println("[STEP 7] YouTube Videos Found = " + videos.size());
            System.out.println("[TRACE] Video Search Complete");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "YouTube API", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "YouTube API Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 10. Restaurant Generation, 11. Attraction Generation, 12. Itinerary Build
        Object restaurants = null;
        Object attractions = null;
        Object travelTips = null;
        Object budgetBreakdown = null;

        currentStep = "Itinerary Engine";
        try {
            DiagnosticManager.setStatus(sessionId, PlannerStatus.BUILDING_ITINERARY);
            PlannerDebugService.log(sessionId, "Itinerary Engine", "STARTED", "Structuring generated itinerary", 0);
            
            restaurants = itinerary.get("food_discovery_detailed");
            if (restaurants == null) {
                restaurants = itinerary.get("food_discovery");
            }
            attractions = itinerary.get("hidden_gems_detailed");
            if (attractions == null) {
                attractions = itinerary.get("must_visit");
            }
            travelTips = itinerary.get("travel_tips");
            if (travelTips == null) {
                travelTips = itinerary.get("travel_warnings");
            }
            budgetBreakdown = itinerary.get("budget_breakdown");
            if (budgetBreakdown == null) {
                budgetBreakdown = calculatedBudget;
            }

            PlannerDebugService.log(sessionId, "Itinerary Engine", "SUCCESS", "Itinerary successfully built", 0);
            System.out.println("[TRACE] Itinerary Build Complete");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "Itinerary Engine", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "Itinerary Build Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // 13. Forward
        currentStep = "Result Page Forward";
        try {
            PlannerDebugService.log(sessionId, "Result Page Forward", "STARTED", "Forwarding to planner-result.jsp", 0);

            request.setAttribute("itinerary", itinerary);
            request.setAttribute("destination", destination);
            request.setAttribute("videos", videos);
            request.setAttribute("images", images);
            request.setAttribute("restaurants", restaurants);
            request.setAttribute("attractions", attractions);
            request.setAttribute("travelTips", travelTips);
            request.setAttribute("budgetBreakdown", budgetBreakdown);

            System.out.println("[STEP 13] Forwarding To planner-result.jsp");
            System.out.println("Forward target = /pages/planner-result.jsp");

            DiagnosticManager.setStatus(sessionId, PlannerStatus.RENDERING_PAGE);
            request.getRequestDispatcher("/pages/planner-result.jsp").forward(request, response);
            
            DiagnosticManager.setStatus(sessionId, PlannerStatus.COMPLETED);
            PlannerDebugService.log(sessionId, "Result Page Forward", "SUCCESS", "Forward completed successfully", 0);
            System.out.println("========== PLANNER END ==========");
            System.out.println("[TRACE] Page Render Complete");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILED STEP: " + currentStep);
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            PlannerDebugService.log(sessionId, "Result Page Forward", "ERROR", e.getMessage(), 0);
            request.setAttribute("plannerError", e.getMessage());
            request.setAttribute("error", "Forward Failure: " + e.getMessage());
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
        }
    }
}
