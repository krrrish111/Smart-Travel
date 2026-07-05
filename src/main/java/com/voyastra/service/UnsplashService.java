package com.voyastra.service;

import com.voyastra.service.planner.PlannerDebugService;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.concurrent.ConcurrentHashMap;

public class UnsplashService {
    
    private static final ConcurrentHashMap<String, String> cache = new ConcurrentHashMap<>();
    
    private final String apiKey;
    private final HttpClient httpClient;

    public UnsplashService() {
        this.apiKey = com.voyastra.config.ConfigManager.get("UNSPLASH_ACCESS_KEY");
        this.httpClient = com.voyastra.util.HttpClientFactory.get();
    }

    public String searchDestinationImages(String sessionId, String destination, String category, int count) {
        if (apiKey == null || apiKey.isEmpty()) {
            PlannerDebugService.log(sessionId, "Unsplash API", "ERROR", "API key missing", 0);
            return "{\"error\": \"API key missing\"}";
        }
        
        long start = System.currentTimeMillis();
        try {
            String cacheKey = destination + "_" + category;
            if (cache.containsKey(cacheKey)) {
                PlannerDebugService.log(sessionId, "Unsplash Cache", "HIT", "Cache hit for " + cacheKey, System.currentTimeMillis() - start);
                return cache.get(cacheKey);
            }

            PlannerDebugService.log(sessionId, "Unsplash Cache", "MISS", "Fetching from Unsplash API", 0);

            String query = java.net.URLEncoder.encode(destination + " " + category, "UTF-8");
            String url = "https://api.unsplash.com/search/photos?query=" + query + "&per_page=" + count + "&orientation=landscape&client_id=" + apiKey;
            
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();
                
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            long duration = System.currentTimeMillis() - start;
            if (response.statusCode() == 200) {
                cache.put(cacheKey, response.body());
                PlannerDebugService.log(sessionId, "Unsplash API", "SUCCESS", "Fetched " + category, duration);
                return response.body();
            } else {
                PlannerDebugService.log(sessionId, "Unsplash API", "ERROR", "Status Code: " + response.statusCode(), duration);
                return "{\"error\": \"Unsplash API returned " + response.statusCode() + "\"}";
            }
        } catch (Exception e) {
            e.printStackTrace();
            PlannerDebugService.log(sessionId, "Unsplash API", "EXCEPTION", e.getMessage(), 0);
            return "{\"error\": \"Exception occurred: " + e.getMessage() + "\"}";
        }
    }
}
