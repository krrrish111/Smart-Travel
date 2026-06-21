package com.voyastra.servlet;

import com.voyastra.dao.DestinationInsightDAO;
import com.voyastra.model.DestinationInsight;
import com.voyastra.service.GeminiService;
import com.voyastra.service.WikipediaService;
import com.voyastra.service.UnsplashDestinationService;
import com.voyastra.service.YouTubeExplorerService;
import com.voyastra.service.DestinationMapService;
import com.voyastra.util.DBConnection;
import com.voyastra.service.ExperiencesDebugService;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

import com.voyastra.api.BookingIntegrationService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet("/experiences")
public class DestinationExplorerServlet extends HttpServlet {

    private DestinationInsightDAO insightDAO;
    private WikipediaService wikipediaService;
    private GeminiService geminiService;
    private UnsplashDestinationService unsplashDestinationService;
    private YouTubeExplorerService youtubeExplorerService;
    private BookingIntegrationService bookingIntegrationService;
    private DestinationMapService destinationMapService;

    // Alphanumeric, spaces, commas, hyphens, and periods allowed
    private static final Pattern VALID_CHARS = Pattern.compile("^[a-zA-Z0-9\\s,.-]+$");

    @Override
    public void init() throws ServletException {
        insightDAO = new DestinationInsightDAO();
        wikipediaService = new WikipediaService();
        geminiService = new GeminiService();
        unsplashDestinationService = new UnsplashDestinationService();
        youtubeExplorerService = new YouTubeExplorerService();
        bookingIntegrationService = new BookingIntegrationService();
        destinationMapService = new DestinationMapService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String sessionId = session.getId();
        ExperiencesDebugService.clearSession(sessionId);

        // Initialize history and recent searches in session if not present
        List<String> searchHistory = (List<String>) session.getAttribute("searchHistory");
        if (searchHistory == null) {
            searchHistory = new ArrayList<>();
            session.setAttribute("searchHistory", searchHistory);
        }

        List<String> recentSearches = (List<String>) session.getAttribute("recentSearches");
        if (recentSearches == null) {
            recentSearches = new ArrayList<>();
            session.setAttribute("recentSearches", recentSearches);
        }

        String query = request.getParameter("q");
        String placeName = request.getParameter("placeName");
        String country = request.getParameter("country");
        String lat = request.getParameter("lat");
        String lng = request.getParameter("lng");

        if (query != null) {
            String trimmedQuery = query.trim();
            
            if (placeName != null && !placeName.trim().isEmpty()) {
                trimmedQuery = placeName.trim() + (country != null && !country.trim().isEmpty() ? ", " + country.trim() : "");
            }
            
            if (lat != null && lng != null && !lat.isEmpty() && !lng.isEmpty()) {
                request.setAttribute("destLat", lat);
                request.setAttribute("destLng", lng);
                session.setAttribute("destLat", lat);
                session.setAttribute("destLng", lng);
            }

            // 1. Validation
            long valStart = System.currentTimeMillis();
            if (trimmedQuery.isEmpty()) {
                ExperiencesDebugService.log(sessionId, "Input Validation", "ERROR", "Empty destination", System.currentTimeMillis() - valStart);
                request.setAttribute("errorMessage", "Destination search term cannot be empty.");
            } else if (!VALID_CHARS.matcher(trimmedQuery).matches()) {
                ExperiencesDebugService.log(sessionId, "Input Validation", "ERROR", "Invalid characters", System.currentTimeMillis() - valStart);
                request.setAttribute("errorMessage", "Destination contains invalid characters. Use alphanumeric and basic punctuation only.");
            } else {
                ExperiencesDebugService.log(sessionId, "Input Validation", "SUCCESS", "Valid destination: " + trimmedQuery, System.currentTimeMillis() - valStart);
                // 2. Success path: Store in Session
                session.setAttribute("destination", trimmedQuery);

                // Add to Search History (unique list)
                if (!searchHistory.contains(trimmedQuery)) {
                    searchHistory.add(0, trimmedQuery);
                    if (searchHistory.size() > 5) {
                        searchHistory.remove(searchHistory.size() - 1);
                    }
                }

                // Add to Recent Searches (always moves to front, can contain duplicates or just unique)
                recentSearches.remove(trimmedQuery);
                recentSearches.add(0, trimmedQuery);
                if (recentSearches.size() > 5) {
                    recentSearches.remove(recentSearches.size() - 1);
                }

                // 3. Fetch data for this destination (Wikipedia, Gemini, Media)
                fetchAndSetDestinationData(request, trimmedQuery);
                request.setAttribute("searchQuery", trimmedQuery);
            }
        }

        // Forward to experiences.jsp
        long renderStart = System.currentTimeMillis();
        request.getRequestDispatcher("/pages/experiences.jsp").forward(request, response);
        ExperiencesDebugService.log(session.getId(), "Page Rendering", "SUCCESS", "Forwarded to experiences.jsp", System.currentTimeMillis() - renderStart);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("addExperience".equals(action)) {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String price = request.getParameter("price");
            String duration = request.getParameter("duration");

            HttpSession session = request.getSession();
            List<JsonObject> selectedExperiences = (List<JsonObject>) session.getAttribute("selectedExperiences");
            if (selectedExperiences == null) {
                selectedExperiences = new ArrayList<>();
                session.setAttribute("selectedExperiences", selectedExperiences);
            }

            boolean exists = false;
            for (JsonObject item : selectedExperiences) {
                if (item.get("name").getAsString().equals(name)) {
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                JsonObject exp = new JsonObject();
                exp.addProperty("name", name);
                exp.addProperty("category", category);
                exp.addProperty("price", price);
                exp.addProperty("duration", duration);
                selectedExperiences.add(exp);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            JsonArray arr = new JsonArray();
            for (JsonObject item : selectedExperiences) {
                arr.add(item);
            }
            JsonObject res = new JsonObject();
            res.addProperty("success", true);
            res.add("cart", arr);
            response.getWriter().write(res.toString());
            return;
        }

        if ("bookHotel".equals(action)) {
            String hotelName = request.getParameter("hotelName");
            String guestName = request.getParameter("guestName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            int guests = 1;
            try {
                guests = Integer.parseInt(request.getParameter("guests"));
            } catch (Exception e) {}

            JsonObject res = bookingIntegrationService.bookHotelRoom(hotelName, guestName, email, phone, checkIn, checkOut, guests);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(res.toString());
            return;
        }

        if ("reserveRestaurant".equals(action)) {
            String restaurantName = request.getParameter("restaurantName");
            String guestName = request.getParameter("guestName");
            String email = request.getParameter("email");
            String date = request.getParameter("date");
            String time = request.getParameter("time");
            int guests = 2;
            try {
                guests = Integer.parseInt(request.getParameter("guests"));
            } catch (Exception e) {}

            JsonObject res = bookingIntegrationService.reserveRestaurantTable(restaurantName, guestName, email, date, time, guests);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(res.toString());
            return;
        }

        doGet(request, response);
    }

    private void fetchAndSetDestinationData(HttpServletRequest request, String destination) {
        String sessionId = request.getSession().getId();
        JsonObject pipelineStats = new JsonObject();
        JsonObject wikiStats = new JsonObject();
        JsonObject geminiStats = new JsonObject();
        JsonObject unsplashStats = new JsonObject();
        JsonObject youtubeStats = new JsonObject();
        pipelineStats.add("wikipedia", wikiStats);
        pipelineStats.add("gemini", geminiStats);
        pipelineStats.add("unsplash", unsplashStats);
        pipelineStats.add("youtube", youtubeStats);
        
        System.out.println("[Destination Explorer] Started for: " + destination);
        
        try {
            // Wikipedia & Gemini Insights
            DestinationInsight insight = insightDAO.getInsightByDestination(destination);
            String wikiSummary = "";
            String wikiUrl = "";
            JsonArray topAttractions = new JsonArray();
            JsonArray localFoods = new JsonArray();
            JsonObject experiences = new JsonObject();
            JsonArray hotels = new JsonArray();
            JsonArray restaurants = new JsonArray();
            JsonObject travelTips = new JsonObject();
            JsonArray itineraryPreviews = new JsonArray();
            String aiInsights = "";
            String country = "";
            String bestTime = "";
            String language = "";
            String currency = "";
            String timezone = "";

            if (insight != null) {
                wikiStats.addProperty("status", "CACHE");
                wikiStats.addProperty("time", 0);
                geminiStats.addProperty("status", "CACHE");
                geminiStats.addProperty("time", 0);
                ExperiencesDebugService.log(sessionId, "Destination Processing", "CACHE", "Loaded from DB", 0);
                ExperiencesDebugService.log(sessionId, "Wikipedia Fetch", "CACHE", "Skipped", 0);
                ExperiencesDebugService.log(sessionId, "Gemini Recommendations", "CACHE", "Skipped", 0);
                ExperiencesDebugService.log(sessionId, "Food Suggestions", "CACHE", "Loaded", 0);
                ExperiencesDebugService.log(sessionId, "Hotel Suggestions", "CACHE", "Loaded", 0);
                ExperiencesDebugService.log(sessionId, "Experience Suggestions", "CACHE", "Loaded", 0);
                wikiSummary = insight.getWikiSummary();
                wikiUrl = insight.getWikiUrl();
                topAttractions = JsonParser.parseString(insight.getTopAttractions()).getAsJsonArray();
                localFoods = JsonParser.parseString(insight.getLocalFoods()).getAsJsonArray();
                
                String expRaw = insight.getExperiences();
                experiences = (expRaw != null && !expRaw.isEmpty()) ? JsonParser.parseString(expRaw).getAsJsonObject() : new JsonObject();
                
                String hotelsRaw = insight.getHotels();
                hotels = (hotelsRaw != null && !hotelsRaw.isEmpty()) ? JsonParser.parseString(hotelsRaw).getAsJsonArray() : new JsonArray();
                
                String restaurantsRaw = insight.getRestaurants();
                restaurants = (restaurantsRaw != null && !restaurantsRaw.isEmpty()) ? JsonParser.parseString(restaurantsRaw).getAsJsonArray() : new JsonArray();
                
                String tipsRaw = insight.getTravelTips();
                travelTips = (tipsRaw != null && !tipsRaw.isEmpty()) ? JsonParser.parseString(tipsRaw).getAsJsonObject() : new JsonObject();
                
                String itinerariesRaw = insight.getItineraryPreviews();
                itineraryPreviews = (itinerariesRaw != null && !itinerariesRaw.isEmpty()) ? JsonParser.parseString(itinerariesRaw).getAsJsonArray() : new JsonArray();
                
                aiInsights = insight.getAiInsights();
                country = insight.getCountry();
                bestTime = insight.getBestTime();
                language = insight.getLanguage();
                currency = insight.getCurrency();
                timezone = insight.getTimezone();
            } else {
                // Fetch live and write to cache
                System.out.println("[Wikipedia] Started");
                ExperiencesDebugService.log(sessionId, "Destination Processing", "SUCCESS", "Parsed Request", 0);
                wikiStats.addProperty("status", "RUNNING");
                long wikiStart = System.currentTimeMillis();
                JsonObject wikiResult = null;
                try {
                    wikiResult = wikipediaService.getSummary(destination);
                    wikiStats.addProperty("status", "SUCCESS");
                    ExperiencesDebugService.log(sessionId, "Wikipedia Fetch", "SUCCESS", "Fetched summary", System.currentTimeMillis() - wikiStart);
                    System.out.println("[Wikipedia] Success");
                } catch (Exception e) {
                    wikiStats.addProperty("status", "FAILED");
                    wikiStats.addProperty("error", e.getMessage());
                    ExperiencesDebugService.log(sessionId, "Wikipedia Fetch", "ERROR", e.getMessage(), System.currentTimeMillis() - wikiStart);
                    System.out.println("[Wikipedia] Failed");
                }
                wikiStats.addProperty("time", System.currentTimeMillis() - wikiStart);
                wikiStats.addProperty("url", "https://en.wikipedia.org/wiki/" + destination.replace(" ", "_"));

                wikiSummary = (wikiResult != null && wikiResult.has("extract")) ? wikiResult.get("extract").getAsString() : "No summary available on Wikipedia.";
                wikiUrl = (wikiResult != null && wikiResult.has("url")) ? wikiResult.get("url").getAsString() : "https://en.wikipedia.org/wiki/" + destination.replace(" ", "_");

                System.out.println("[Gemini] Started");
                geminiStats.addProperty("status", "RUNNING");
                long geminiStart = System.currentTimeMillis();
                String aiJsonRaw = "{}";
                try {
                    aiJsonRaw = geminiService.getDestinationInsights(sessionId, destination);
                    geminiStats.addProperty("status", "SUCCESS");
                    ExperiencesDebugService.log(sessionId, "Gemini Recommendations", "SUCCESS", "Generated insights", System.currentTimeMillis() - geminiStart);
                    ExperiencesDebugService.setAiOutput(sessionId, aiJsonRaw);
                    System.out.println("[Gemini] Success");
                } catch (Exception e) {
                    geminiStats.addProperty("status", "FAILED");
                    geminiStats.addProperty("error", e.getMessage());
                    ExperiencesDebugService.log(sessionId, "Gemini Recommendations", "ERROR", e.getMessage(), System.currentTimeMillis() - geminiStart);
                    System.out.println("[Gemini] Failed");
                }
                geminiStats.addProperty("time", System.currentTimeMillis() - geminiStart);
                JsonObject aiJson = JsonParser.parseString(aiJsonRaw).getAsJsonObject();

                long parseStart = System.currentTimeMillis();
                topAttractions = aiJson.has("top_attractions") ? aiJson.getAsJsonArray("top_attractions") : new JsonArray();
                localFoods = aiJson.has("local_foods") ? aiJson.getAsJsonArray("local_foods") : new JsonArray();
                for (int i = 0; i < localFoods.size(); i++) {
                    try {
                        JsonObject foodItem = localFoods.get(i).getAsJsonObject();
                        String wikiTitle = foodItem.has("wikipedia_title") ? foodItem.get("wikipedia_title").getAsString() : foodItem.get("name").getAsString();
                        JsonObject foodWiki = wikipediaService.getSummary(wikiTitle);
                        if (foodWiki != null) {
                            if (foodWiki.has("image")) {
                                foodItem.addProperty("image", foodWiki.get("image").getAsString());
                            }
                            if (foodWiki.has("url")) {
                                foodItem.addProperty("wikipedia_url", foodWiki.get("url").getAsString());
                            }
                        }
                        if (!foodItem.has("image") || foodItem.get("image").getAsString().isEmpty()) {
                            foodItem.addProperty("image", "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80");
                        }
                    } catch (Exception fe) {
                        fe.printStackTrace();
                    }
                }
                ExperiencesDebugService.log(sessionId, "Food Suggestions", "SUCCESS", "Processed " + localFoods.size() + " foods", System.currentTimeMillis() - parseStart);
                
                long extraStart = System.currentTimeMillis();
                experiences = aiJson.has("experiences") ? aiJson.getAsJsonObject("experiences") : new JsonObject();
                hotels = aiJson.has("hotels") ? aiJson.getAsJsonArray("hotels") : new JsonArray();
                ExperiencesDebugService.log(sessionId, "Hotel Suggestions", "SUCCESS", "Parsed " + hotels.size() + " hotels", System.currentTimeMillis() - extraStart);
                ExperiencesDebugService.log(sessionId, "Experience Suggestions", "SUCCESS", "Parsed experiences", System.currentTimeMillis() - extraStart);
                restaurants = aiJson.has("restaurants") ? aiJson.getAsJsonArray("restaurants") : new JsonArray();
                travelTips = aiJson.has("travel_tips") ? aiJson.getAsJsonObject("travel_tips") : new JsonObject();
                itineraryPreviews = aiJson.has("itinerary_previews") ? aiJson.getAsJsonArray("itinerary_previews") : new JsonArray();
                
                aiInsights = aiJson.has("ai_insights") ? aiJson.get("ai_insights").getAsString() : "No custom insights available.";
                country = aiJson.has("country") ? aiJson.get("country").getAsString() : "Unknown Country";
                bestTime = aiJson.has("best_time") ? aiJson.get("best_time").getAsString() : "N/A";
                language = aiJson.has("language") ? aiJson.get("language").getAsString() : "Local";
                currency = aiJson.has("currency") ? aiJson.get("currency").getAsString() : "N/A";
                timezone = aiJson.has("timezone") ? aiJson.get("timezone").getAsString() : "N/A";

                DestinationInsight di = new DestinationInsight();
                di.setDestination(destination);
                di.setWikiSummary(wikiSummary);
                di.setWikiUrl(wikiUrl);
                di.setTopAttractions(topAttractions.toString());
                di.setLocalFoods(localFoods.toString());
                di.setExperiences(experiences.toString());
                di.setHotels(hotels.toString());
                di.setRestaurants(restaurants.toString());
                di.setTravelTips(travelTips.toString());
                di.setItineraryPreviews(itineraryPreviews.toString());
                di.setAiInsights(aiInsights);
                di.setCountry(country);
                di.setBestTime(bestTime);
                di.setLanguage(language);
                di.setCurrency(currency);
                di.setTimezone(timezone);
                insightDAO.saveInsight(di);
            }

            // Build unified map markers from all categories
            JsonArray mapMarkers = destinationMapService.buildMarkers(
                topAttractions, hotels, restaurants, experiences);

            request.setAttribute("wikiSummary", wikiSummary);
            request.setAttribute("wikiUrl", wikiUrl);
            com.google.gson.Gson gson = new com.google.gson.Gson();
            java.lang.reflect.Type listType = new com.google.gson.reflect.TypeToken<java.util.List<java.util.Map<String, Object>>>(){}.getType();
            java.lang.reflect.Type mapType = new com.google.gson.reflect.TypeToken<java.util.Map<String, Object>>(){}.getType();

            request.setAttribute("attractions", gson.fromJson(topAttractions, listType));
            request.setAttribute("foods", gson.fromJson(localFoods, listType));
            request.setAttribute("experiences", gson.fromJson(experiences, mapType));
            request.setAttribute("hotels", gson.fromJson(hotels, listType));
            request.setAttribute("restaurants", gson.fromJson(restaurants, listType));
            request.setAttribute("travelTips", gson.fromJson(travelTips, mapType));
            request.setAttribute("itineraryPreviews", gson.fromJson(itineraryPreviews, listType));
            request.setAttribute("mapMarkers", gson.fromJson(mapMarkers, listType));

            request.setAttribute("attractionsJsonString", topAttractions.toString());
            request.setAttribute("foodsJsonString", localFoods.toString());
            request.setAttribute("experiencesJsonString", experiences.toString());
            request.setAttribute("travelTipsJsonString", travelTips.toString());
            request.setAttribute("itineraryPreviewsJsonString", itineraryPreviews.toString());
            request.setAttribute("mapMarkersJsonString", mapMarkers.toString());
            request.setAttribute("aiInsights", aiInsights);
            request.setAttribute("country", country);
            request.setAttribute("bestTime", bestTime);
            request.setAttribute("language", language);
            request.setAttribute("currency", currency);
            request.setAttribute("timezone", timezone);

            // Fetch Media
            JsonArray images = new JsonArray();
            JsonArray videos = new JsonArray();

            java.util.List<java.util.Map<String, Object>> imagesList = new java.util.ArrayList<>();
            java.util.List<java.util.Map<String, Object>> videosList = new java.util.ArrayList<>();

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "SELECT media_type, url, title, extra_data FROM destination_media_cache WHERE LOWER(destination) = LOWER(?)"
                 )) {
                stmt.setString(1, destination);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        String type = rs.getString("media_type");
                        JsonObject item = new JsonObject();
                        item.addProperty("url", rs.getString("url"));
                        item.addProperty("title", rs.getString("title"));
                        String extraRaw = rs.getString("extra_data");
                        if (extraRaw != null && !extraRaw.isEmpty()) {
                            item.add("extra_data", JsonParser.parseString(extraRaw));
                        }

                        if ("IMAGE".equalsIgnoreCase(type)) {
                            images.add(item);
                        } else if ("VIDEO".equalsIgnoreCase(type)) {
                            videos.add(item);
                        }
                    }
                }
            }

            if (images.size() > 0) {
                unsplashStats.addProperty("status", "CACHE");
                unsplashStats.addProperty("time", 0);
                unsplashStats.addProperty("count", images.size());
                ExperiencesDebugService.log(sessionId, "Image Search", "CACHE", "Loaded " + images.size() + " images from DB", 0);
            }
            if (videos.size() > 0) {
                youtubeStats.addProperty("status", "CACHE");
                youtubeStats.addProperty("time", 0);
                youtubeStats.addProperty("count", videos.size());
                ExperiencesDebugService.log(sessionId, "Video Search", "CACHE", "Loaded " + videos.size() + " videos from DB", 0);
            }
            
            if (images.size() == 0 && videos.size() == 0) {
                // Fetch live from Unsplash & YouTube
                System.out.println("[Unsplash] Started");
                unsplashStats.addProperty("status", "RUNNING");
                long unsplashStart = System.currentTimeMillis();
                String unsplashRaw = "{}";
                try {
                    unsplashRaw = unsplashDestinationService.searchPhotos(destination, 15);
                    unsplashStats.addProperty("status", "SUCCESS");
                    ExperiencesDebugService.log(sessionId, "Image Search", "SUCCESS", "Fetched images", System.currentTimeMillis() - unsplashStart);
                    System.out.println("[Unsplash] Success");
                } catch (Exception e) {
                    unsplashStats.addProperty("status", "FAILED");
                    unsplashStats.addProperty("error", e.getMessage());
                    ExperiencesDebugService.log(sessionId, "Image Search", "ERROR", e.getMessage(), System.currentTimeMillis() - unsplashStart);
                    System.out.println("[Unsplash] Failed");
                }
                unsplashStats.addProperty("time", System.currentTimeMillis() - unsplashStart);
                unsplashStats.addProperty("url", "https://api.unsplash.com/search/photos?query=" + destination);

                JsonObject unsplashJson = JsonParser.parseString(unsplashRaw).getAsJsonObject();
                if (unsplashJson.has("results")) {
                    JsonArray results = unsplashJson.getAsJsonArray("results");
                    for (int i = 0; i < results.size(); i++) {
                        JsonObject photo = results.get(i).getAsJsonObject();
                        String imgUrl = photo.getAsJsonObject("urls").get("regular").getAsString();
                        String title = photo.has("alt_description") && !photo.get("alt_description").isJsonNull() 
                            ? photo.get("alt_description").getAsString() 
                            : destination + " tourism view";
                        JsonObject item = new JsonObject();
                        item.addProperty("url", imgUrl);
                        item.addProperty("title", title);

                        JsonObject extra = new JsonObject();
                        if (photo.has("user")) {
                            JsonObject userObj = photo.getAsJsonObject("user");
                            String author = userObj.has("name") ? userObj.get("name").getAsString() : "Unknown";
                            String authorLink = userObj.has("links") && userObj.getAsJsonObject("links").has("html") 
                                ? userObj.getAsJsonObject("links").get("html").getAsString() : "https://unsplash.com";
                            extra.addProperty("author", author);
                            extra.addProperty("author_link", authorLink);
                        }
                        item.add("extra_data", extra);
                        images.add(item);

                        saveMediaItem(destination, "IMAGE", imgUrl, title, extra.toString());
                    }
                }

                if (images.size() == 0) {
                    // Fallback images
                    String[] fallbacks = {
                        "https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=800&q=80",
                        "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                        "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=800&q=80",
                        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80"
                    };
                    for (int i = 0; i < fallbacks.length; i++) {
                        JsonObject item = new JsonObject();
                        item.addProperty("url", fallbacks[i]);
                        item.addProperty("title", destination + " landscape " + (i+1));
                        JsonObject extra = new JsonObject();
                        extra.addProperty("author", "Voyastra Explorer");
                        extra.addProperty("author_link", "https://unsplash.com");
                        item.add("extra_data", extra);
                        images.add(item);
                    }
                }

                System.out.println("[YouTube] Started");
                youtubeStats.addProperty("status", "RUNNING");
                long ytStart = System.currentTimeMillis();
                String youtubeRaw = "{}";
                try {
                    youtubeRaw = youtubeExplorerService.searchVideos(destination, 6);
                    youtubeStats.addProperty("status", "SUCCESS");
                    ExperiencesDebugService.log(sessionId, "Video Search", "SUCCESS", "Fetched videos", System.currentTimeMillis() - ytStart);
                    System.out.println("[YouTube] Success");
                } catch (Exception e) {
                    youtubeStats.addProperty("status", "FAILED");
                    youtubeStats.addProperty("error", e.getMessage());
                    ExperiencesDebugService.log(sessionId, "Video Search", "ERROR", e.getMessage(), System.currentTimeMillis() - ytStart);
                    System.out.println("[YouTube] Failed");
                }
                youtubeStats.addProperty("time", System.currentTimeMillis() - ytStart);
                youtubeStats.addProperty("url", "https://www.googleapis.com/youtube/v3/search?q=" + destination);
                JsonObject youtubeJson = JsonParser.parseString(youtubeRaw).getAsJsonObject();
                if (youtubeJson.has("items")) {
                    JsonArray items = youtubeJson.getAsJsonArray("items");
                    for (int i = 0; i < items.size(); i++) {
                        JsonObject video = items.get(i).getAsJsonObject();
                        if (video.has("id") && video.get("id").isJsonPrimitive()) {
                            String videoId = video.get("id").getAsString();
                            JsonObject snippet = video.getAsJsonObject("snippet");
                            String title = snippet.get("title").getAsString();
                            String channelTitle = snippet.get("channelTitle").getAsString();
                            String publishedAt = snippet.get("publishedAt").getAsString();
                            String thumbUrl = snippet.getAsJsonObject("thumbnails")
                                .getAsJsonObject("high").get("url").getAsString();
                            
                            String views = "0";
                            if (video.has("statistics") && video.getAsJsonObject("statistics").has("viewCount")) {
                                views = video.getAsJsonObject("statistics").get("viewCount").getAsString();
                            }

                            JsonObject item = new JsonObject();
                            item.addProperty("url", "https://www.youtube.com/watch?v=" + videoId);
                            item.addProperty("title", title);
                            JsonObject extra = new JsonObject();
                            extra.addProperty("videoId", videoId);
                            extra.addProperty("thumbnail", thumbUrl);
                            extra.addProperty("channel", channelTitle);
                            extra.addProperty("views", views);
                            extra.addProperty("publishDate", publishedAt);
                            item.add("extra_data", extra);
                            videos.add(item);

                            saveMediaItem(destination, "VIDEO", "https://www.youtube.com/watch?v=" + videoId, title, extra.toString());
                        }
                    }
                }

                if (videos.size() == 0) {
                    // Fallback videos
                    String[][] videoData = {
                        {"dQw4w9WgXcQ", "Voyastra Travel Guide: " + destination, "Voyastra Guide Team", "125000", "2026-01-15T00:00:00Z"},
                        {"9bZkp7q19f0", "10 Things to do in " + destination, "Explore Channel", "84000", "2026-02-20T00:00:00Z"}
                    };
                    for (String[] v : videoData) {
                        JsonObject item = new JsonObject();
                        item.addProperty("url", "https://www.youtube.com/watch?v=" + v[0]);
                        item.addProperty("title", v[1]);
                        JsonObject extra = new JsonObject();
                        extra.addProperty("videoId", v[0]);
                        extra.addProperty("thumbnail", "https://images.unsplash.com/photo-1488646953014-85cb44e25828");
                        extra.addProperty("channel", v[2]);
                        extra.addProperty("views", v[3]);
                        extra.addProperty("publishDate", v[4]);
                        item.add("extra_data", extra);
                        videos.add(item);
                    }
                }
            }

            unsplashStats.addProperty("count", images.size());
            youtubeStats.addProperty("count", videos.size());
            pipelineStats.addProperty("attractions", topAttractions != null ? topAttractions.size() : 0);
            pipelineStats.addProperty("experiences", experiences != null ? experiences.size() : 0);
            for (int i = 0; i < images.size(); i++) {
                imagesList.add(gson.fromJson(images.get(i), mapType));
            }
            for (int i = 0; i < videos.size(); i++) {
                videosList.add(gson.fromJson(videos.get(i), mapType));
            }
            
            System.out.println("[Explorer] Render Complete");
            request.setAttribute("pipelineStatsJson", pipelineStats.toString());
            request.setAttribute("images", imagesList);
            request.setAttribute("videos", videosList);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorDetail", e.getMessage());
        }
    }

    private void saveMediaItem(String destination, String mediaType, String url, String title, String extraData) {
        String sql = "INSERT INTO destination_media_cache (destination, media_type, url, title, extra_data) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, destination);
            stmt.setString(2, mediaType);
            stmt.setString(3, url);
            stmt.setString(4, title);
            stmt.setString(5, extraData);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Failed to cache media item: " + e.getMessage());
        }
    }
}
