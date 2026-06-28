package com.voyastra.service;

import com.voyastra.service.planner.PlannerDebugService;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;
import java.util.concurrent.ConcurrentHashMap;

public class YouTubeService {
    
    private static final ConcurrentHashMap<String, String> cache = new ConcurrentHashMap<>();
    
    private final String apiKey;
    private final HttpClient httpClient;

    public YouTubeService() {
        this.apiKey = com.voyastra.config.ConfigManager.get("YOUTUBE_API_KEY");
        this.httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();
    }

    public String searchDestinationVideos(String sessionId, String destination, String querySuffix, int maxResults) {
        if (apiKey == null || apiKey.isEmpty()) {
            PlannerDebugService.log(sessionId, "YouTube API", "ERROR", "API key missing", 0);
            return "{\"error\": \"API key missing\"}";
        }
        
        long start = System.currentTimeMillis();
        try {
            String cacheKey = destination + "_" + querySuffix;
            if (cache.containsKey(cacheKey)) {
                PlannerDebugService.log(sessionId, "YouTube Cache", "HIT", "Cache hit for " + cacheKey, System.currentTimeMillis() - start);
                return cache.get(cacheKey);
            }

            PlannerDebugService.log(sessionId, "YouTube Cache", "MISS", "Fetching from Google API", 0);

            String query = java.net.URLEncoder.encode(destination + " " + querySuffix, "UTF-8");
            String url = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&videoEmbeddable=true&maxResults=" + maxResults + "&q=" + query + "&key=" + apiKey;
            
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();
                
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            long duration = System.currentTimeMillis() - start;
            if (response.statusCode() == 200) {
                cache.put(cacheKey, response.body());
                PlannerDebugService.log(sessionId, "YouTube API", "SUCCESS", "Fetched " + querySuffix, duration);
                return response.body();
            } else {
                PlannerDebugService.log(sessionId, "YouTube API", "ERROR", "Status Code: " + response.statusCode(), duration);
                return "{\"error\": \"YouTube API returned " + response.statusCode() + "\"}";
            }
        } catch (Exception e) {
            e.printStackTrace();
            PlannerDebugService.log(sessionId, "YouTube API", "EXCEPTION", e.getMessage(), 0);
            return "{\"error\": \"Exception occurred: " + e.getMessage() + "\"}";
        }
    }
}
