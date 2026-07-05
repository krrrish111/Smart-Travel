package com.voyastra.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;
import java.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.List;

public class YouTubeExplorerService {
    
    private static final ConcurrentHashMap<String, String> cache = new ConcurrentHashMap<>();
    private final String apiKey;
    private final HttpClient httpClient;

    public YouTubeExplorerService() {
        this.apiKey = com.voyastra.config.ConfigManager.get("YOUTUBE_API_KEY");
        this.httpClient = com.voyastra.util.HttpClientFactory.get();
    }

    public String searchVideos(String destination, int maxResults) {
        if (apiKey == null || apiKey.isEmpty()) {
            return "{\"error\": \"API key missing\"}";
        }
        
        try {
            String cacheKey = destination + "_hub_" + maxResults;
            if (cache.containsKey(cacheKey)) {
                return cache.get(cacheKey);
            }

            // 1. Search for video IDs
            String query = java.net.URLEncoder.encode(destination + " travel guide", "UTF-8");
            String searchUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&videoEmbeddable=true&maxResults=" + maxResults + "&q=" + query + "&key=" + apiKey;
            
            HttpRequest searchRequest = HttpRequest.newBuilder()
                .uri(URI.create(searchUrl))
                .GET()
                .build();
                
            HttpResponse<String> searchResponse = httpClient.send(searchRequest, HttpResponse.BodyHandlers.ofString());
            
            if (searchResponse.statusCode() != 200) {
                return "{\"error\": \"YouTube Search API returned: " + searchResponse.statusCode() + "\"}";
            }

            JsonObject searchJson = JsonParser.parseString(searchResponse.body()).getAsJsonObject();
            JsonArray items = searchJson.getAsJsonArray("items");
            if (items == null || items.size() == 0) {
                return "{\"items\": []}";
            }

            // Extract IDs
            List<String> videoIds = new ArrayList<>();
            for (int i = 0; i < items.size(); i++) {
                JsonObject item = items.get(i).getAsJsonObject();
                if (item.has("id") && item.getAsJsonObject("id").has("videoId")) {
                    videoIds.add(item.getAsJsonObject("id").get("videoId").getAsString());
                }
            }

            if (videoIds.isEmpty()) {
                return "{\"items\": []}";
            }

            // 2. Query Video Details (to get statistics/views)
            String idsParam = String.join(",", videoIds);
            String detailsUrl = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&id=" + idsParam + "&key=" + apiKey;

            HttpRequest detailsRequest = HttpRequest.newBuilder()
                .uri(URI.create(detailsUrl))
                .GET()
                .build();
                
            HttpResponse<String> detailsResponse = httpClient.send(detailsRequest, HttpResponse.BodyHandlers.ofString());
            
            if (detailsResponse.statusCode() == 200) {
                cache.put(cacheKey, detailsResponse.body());
                return detailsResponse.body();
            } else {
                return "{\"error\": \"YouTube Details API returned: " + detailsResponse.statusCode() + "\"}";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"Exception: " + e.getMessage() + "\"}";
        }
    }
}
