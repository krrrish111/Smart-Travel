package com.voyastra.service.destination;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;
import java.util.concurrent.ConcurrentHashMap;

public class UnsplashDestinationService {
    
    private static final ConcurrentHashMap<String, String> cache = new ConcurrentHashMap<>();
    private final String apiKey;
    private final HttpClient httpClient;

    public UnsplashDestinationService() {
        this.apiKey = com.voyastra.config.ConfigManager.get("UNSPLASH_ACCESS_KEY");
        this.httpClient = com.voyastra.util.HttpClientFactory.get();
    }

    public String searchPhotos(String destination, int count) {
        if (apiKey == null || apiKey.isEmpty()) {
            return "{\"error\": \"API key missing\"}";
        }
        
        try {
            String cacheKey = destination + "_tourism_" + count;
            if (cache.containsKey(cacheKey)) {
                return cache.get(cacheKey);
            }

            String query = java.net.URLEncoder.encode(destination + " tourism", "UTF-8");
            String url = "https://api.unsplash.com/search/photos?query=" + query + "&per_page=" + count + "&orientation=landscape&client_id=" + apiKey;
            
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();
                
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                // Return raw response string
                cache.put(cacheKey, response.body());
                return response.body();
            } else {
                return "{\"error\": \"Unsplash API status code: " + response.statusCode() + "\"}";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"Exception: " + e.getMessage() + "\"}";
        }
    }
}
