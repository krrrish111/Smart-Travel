package com.voyastra.servlet;

import com.voyastra.service.UnsplashService;
import com.voyastra.service.YouTubeService;
import com.voyastra.util.DBConnection;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/api/explore/media")
public class DestinationMediaServlet extends HttpServlet {

    private UnsplashService unsplashService;
    private YouTubeService youtubeService;

    @Override
    public void init() throws ServletException {
        unsplashService = new UnsplashService();
        youtubeService = new YouTubeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("{\"error\": \"Query parameter 'q' is missing\"}");
            return;
        }

        String destination = query.trim();
        String sessionId = request.getSession().getId();

        try {
            // 1. Try reading from database cache
            JsonArray images = new JsonArray();
            JsonArray videos = new JsonArray();
            
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

            // If we have cached images and videos, return them
            if (images.size() > 0 || videos.size() > 0) {
                JsonObject cachedResponse = new JsonObject();
                cachedResponse.add("images", images);
                cachedResponse.add("videos", videos);
                response.getWriter().write(cachedResponse.toString());
                return;
            }

            // 2. Cache Miss: Query External APIs
            // Fetch images
            String unsplashRaw = unsplashService.searchDestinationImages(sessionId, destination, "travel", 8);
            JsonObject unsplashJson = JsonParser.parseString(unsplashRaw).getAsJsonObject();
            if (unsplashJson.has("results")) {
                JsonArray results = unsplashJson.getAsJsonArray("results");
                for (int i = 0; i < results.size(); i++) {
                    JsonObject photo = results.get(i).getAsJsonObject();
                    String imgUrl = photo.getAsJsonObject("urls").get("regular").getAsString();
                    String title = photo.has("alt_description") && !photo.get("alt_description").isJsonNull() 
                        ? photo.get("alt_description").getAsString() 
                        : destination + " view";
                    
                    JsonObject item = new JsonObject();
                    item.addProperty("url", imgUrl);
                    item.addProperty("title", title);
                    images.add(item);

                    // Save to DB
                    saveMediaItem(destination, "IMAGE", imgUrl, title, null);
                }
            }

            // Fetch videos
            String youtubeRaw = youtubeService.searchDestinationVideos(sessionId, destination, "travel guide", 5);
            JsonObject youtubeJson = JsonParser.parseString(youtubeRaw).getAsJsonObject();
            if (youtubeJson.has("items")) {
                JsonArray items = youtubeJson.getAsJsonArray("items");
                for (int i = 0; i < items.size(); i++) {
                    JsonObject video = items.get(i).getAsJsonObject();
                    if (video.has("id") && video.getAsJsonObject("id").has("videoId")) {
                        String videoId = video.getAsJsonObject("id").get("videoId").getAsString();
                        String title = video.getAsJsonObject("snippet").get("title").getAsString();
                        String thumbUrl = video.getAsJsonObject("snippet").getAsJsonObject("thumbnails")
                            .getAsJsonObject("high").get("url").getAsString();
                        
                        JsonObject item = new JsonObject();
                        item.addProperty("url", "https://www.youtube.com/watch?v=" + videoId);
                        item.addProperty("title", title);
                        
                        JsonObject extra = new JsonObject();
                        extra.addProperty("videoId", videoId);
                        extra.addProperty("thumbnail", thumbUrl);
                        item.add("extra_data", extra);
                        videos.add(item);

                        // Save to DB
                        saveMediaItem(destination, "VIDEO", "https://www.youtube.com/watch?v=" + videoId, title, extra.toString());
                    }
                }
            }

            // Return response
            JsonObject responseJson = new JsonObject();
            responseJson.add("images", images);
            responseJson.add("videos", videos);
            response.getWriter().write(responseJson.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to load media: " + e.getMessage() + "\"}");
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
