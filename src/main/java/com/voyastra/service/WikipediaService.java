package com.voyastra.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.util.concurrent.ConcurrentHashMap;

public class WikipediaService {
    
    private static final ConcurrentHashMap<String, JsonObject> cache = new ConcurrentHashMap<>();
    private final HttpClient httpClient;

    public WikipediaService() {
        this.httpClient = com.voyastra.util.HttpClientFactory.get();
    }

    public JsonObject getSummary(String destination) {
        try {
            String cacheKey = destination.trim().toLowerCase();
            if (cache.containsKey(cacheKey)) {
                return cache.get(cacheKey);
            }

            // Step 1: Search Wikipedia
            String originalDest = destination.trim();
            // We'll search exactly what the user provided, as Wikipedia's search is robust.
            // If they just type "Manali", Wikipedia search will return location results.
            String searchQuery = originalDest;
            
            System.out.println("[WIKI]");
            System.out.println("Query: " + originalDest);
            
            String encodedSearch = java.net.URLEncoder.encode(searchQuery, "UTF-8");
            String searchUrl = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=" + encodedSearch + "&utf8=&format=json";
            
            HttpRequest searchReq = HttpRequest.newBuilder()
                .uri(URI.create(searchUrl))
                .header("User-Agent", "VoyastraTravelApp/1.0 (contact@voyastra.com)")
                .GET()
                .build();
                
            HttpResponse<String> searchResp = httpClient.send(searchReq, HttpResponse.BodyHandlers.ofString());
            
            if (searchResp.statusCode() == 200) {
                JsonObject searchJson = JsonParser.parseString(searchResp.body()).getAsJsonObject();
                if (searchJson.has("query") && searchJson.getAsJsonObject("query").has("search")) {
                    JsonArray results = searchJson.getAsJsonObject("query").getAsJsonArray("search");
                    
                    System.out.println("[WIKI]");
                    System.out.println("Results Found:");
                    
                    class WikiResult {
                        String title;
                        int score;
                        public WikiResult(String title, int score) {
                            this.title = title;
                            this.score = score;
                        }
                    }
                    java.util.List<WikiResult> scoredResults = new java.util.ArrayList<>();
                    
                    for (int i = 0; i < results.size(); i++) {
                        String title = results.get(i).getAsJsonObject().get("title").getAsString();
                        System.out.println("- " + title);
                        
                        if (title.startsWith("List of ") || title.startsWith("Category:") || title.toLowerCase().contains("disambiguation")) {
                            continue;
                        }
                        
                        int score = 0;
                        String lowerTitle = title.toLowerCase();
                        String lowerDest = originalDest.toLowerCase();
                        
                        if (lowerTitle.equals(lowerDest)) {
                            score = 100;
                        } else if (lowerTitle.equals(lowerDest + " district") || lowerTitle.equals(lowerDest + " (city)") || lowerTitle.equals(lowerDest + " (town)")) {
                            score = 90;
                        } else if (lowerTitle.startsWith(lowerDest)) {
                            score = 80;
                        } else if (lowerTitle.contains(lowerDest)) {
                            score = 50;
                        } else {
                            // Fallback for related travel locations, base score decreases with rank
                            if (lowerTitle.contains("district") || lowerTitle.contains("city") || lowerTitle.contains("town") || lowerTitle.contains("tourism") || lowerTitle.contains("geography")) {
                                score = 20 - i;
                            } else {
                                score = 10 - i;
                            }
                        }
                        
                        if (score > 0) {
                            scoredResults.add(new WikiResult(title, score));
                        }
                    }
                    
                    scoredResults.sort((a, b) -> Integer.compare(b.score, a.score));
                    
                    for (WikiResult bestMatch : scoredResults) {
                        String title = bestMatch.title;
                        
                        // Step 2: Fetch the summary for the title
                        String summaryUrl = "https://en.wikipedia.org/api/rest_v1/page/summary/" + java.net.URLEncoder.encode(title.replace(" ", "_"), "UTF-8");
                        
                        HttpRequest summaryReq = HttpRequest.newBuilder()
                            .uri(URI.create(summaryUrl))
                            .header("User-Agent", "VoyastraTravelApp/1.0 (contact@voyastra.com)")
                            .GET()
                            .build();
                            
                        HttpResponse<String> summaryResp = httpClient.send(summaryReq, HttpResponse.BodyHandlers.ofString());
                        
                        if (summaryResp.statusCode() == 200) {
                            JsonObject summaryJson = JsonParser.parseString(summaryResp.body()).getAsJsonObject();
                            
                            boolean isDisambiguation = summaryJson.has("type") && "disambiguation".equals(summaryJson.get("type").getAsString());
                            if (isDisambiguation) {
                                continue;
                            }
                            
                            String extract = summaryJson.has("extract") ? summaryJson.get("extract").getAsString() : "";
                            
                            // If it's a low confidence match, ensure it actually describes a location
                            if (bestMatch.score <= 10) {
                                String lowerExtract = extract.toLowerCase();
                                if (!lowerExtract.contains("city") && !lowerExtract.contains("town") && !lowerExtract.contains("village") 
                                    && !lowerExtract.contains("district") && !lowerExtract.contains("state") && !lowerExtract.contains("country") 
                                    && !lowerExtract.contains("region") && !lowerExtract.contains("tourism") && !lowerExtract.contains("destination")) {
                                    continue;
                                }
                            }
                            
                            System.out.println("[WIKI]");
                            System.out.println("Selected:");
                            System.out.println(title);

                            JsonObject result = new JsonObject();
                            result.addProperty("extract", extract);
                            
                            if (summaryJson.has("content_urls") && summaryJson.getAsJsonObject("content_urls").has("desktop") && 
                                summaryJson.getAsJsonObject("content_urls").getAsJsonObject("desktop").has("page")) {
                                String pageUrl = summaryJson.getAsJsonObject("content_urls").getAsJsonObject("desktop").get("page").getAsString();
                                result.addProperty("url", pageUrl);
                                
                                System.out.println("[WIKI]");
                                System.out.println("URL:");
                                System.out.println(pageUrl);
                            }
                            
                            if (summaryJson.has("thumbnail") && summaryJson.getAsJsonObject("thumbnail").has("source")) {
                                result.addProperty("image", summaryJson.getAsJsonObject("thumbnail").get("source").getAsString());
                            } else if (summaryJson.has("originalimage") && summaryJson.getAsJsonObject("originalimage").has("source")) {
                                result.addProperty("image", summaryJson.getAsJsonObject("originalimage").get("source").getAsString());
                            }
                            
                            cache.put(cacheKey, result);
                            return result;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
