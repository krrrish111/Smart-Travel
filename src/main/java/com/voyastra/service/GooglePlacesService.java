package com.voyastra.service;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.voyastra.config.ConfigManager;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class GooglePlacesService {

    private final HttpClient httpClient;
    private final String apiKey;

    public GooglePlacesService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.apiKey = ConfigManager.get("GOOGLE_PLACES_API_KEY");
    }

    public JsonObject getAutocompleteSuggestions(String query) {
        JsonObject result = new JsonObject();
        JsonArray predictionsArray = new JsonArray();
        
        System.out.println("[PLACES]");
        System.out.println("Autocomplete Started");
        System.out.println("[PLACES]");
        System.out.println("Query Received: " + query);

        if (this.apiKey == null || this.apiKey.isEmpty() || this.apiKey.equals("YOUR_KEY")) {
            System.err.println("[PLACES] Google Places API Key is missing or invalid.");
            result.addProperty("success", false);
            result.addProperty("error", "API Key missing");
            result.add("predictions", predictionsArray);
            return result;
        }

        try {
            String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8.toString());
            // Restrict to cities/regions by types=(cities) to keep it focused on destinations
            String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" 
                    + encodedQuery + "&types=(cities)&key=" + this.apiKey;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
                if (jsonResponse.has("predictions")) {
                    JsonArray rawPredictions = jsonResponse.getAsJsonArray("predictions");
                    for (JsonElement el : rawPredictions) {
                        JsonObject rawPrediction = el.getAsJsonObject();
                        JsonObject formattedPrediction = new JsonObject();
                        formattedPrediction.addProperty("placeId", rawPrediction.get("place_id").getAsString());
                        formattedPrediction.addProperty("description", rawPrediction.get("description").getAsString());
                        predictionsArray.add(formattedPrediction);
                    }
                    
                    System.out.println("[PLACES]");
                    System.out.println("Results Returned: " + predictionsArray.size());
                    
                    result.addProperty("success", true);
                    result.add("predictions", predictionsArray);
                } else {
                    result.addProperty("success", false);
                    result.add("predictions", predictionsArray);
                }
            } else {
                result.addProperty("success", false);
                result.add("predictions", predictionsArray);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("error", e.getMessage());
            result.add("predictions", predictionsArray);
        }
        
        System.out.println("[PLACES]");
        System.out.println("Autocomplete Complete");

        return result;
    }

    public JsonObject getPlaceDetails(String placeId) {
        JsonObject result = new JsonObject();
        
        System.out.println("[PLACE DETAILS]");
        System.out.println("Started for placeId: " + placeId);

        if (this.apiKey == null || this.apiKey.isEmpty() || this.apiKey.equals("YOUR_KEY")) {
            result.addProperty("success", false);
            result.addProperty("error", "API Key missing");
            return result;
        }

        try {
            String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=" 
                    + placeId + "&fields=name,address_components,geometry,url&key=" + this.apiKey;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
                if (jsonResponse.has("result")) {
                    JsonObject resObj = jsonResponse.getAsJsonObject("result");
                    
                    result.addProperty("success", true);
                    result.addProperty("name", resObj.has("name") ? resObj.get("name").getAsString() : "");
                    
                    if (resObj.has("geometry")) {
                        JsonObject location = resObj.getAsJsonObject("geometry").getAsJsonObject("location");
                        result.addProperty("lat", location.get("lat").getAsDouble());
                        result.addProperty("lng", location.get("lng").getAsDouble());
                        System.out.println("[PLACE DETAILS]");
                        System.out.println("Coordinates Loaded");
                    }
                    
                    if (resObj.has("url")) {
                        result.addProperty("url", resObj.get("url").getAsString());
                    }

                    // Parse address components for city, state, country
                    if (resObj.has("address_components")) {
                        JsonArray components = resObj.getAsJsonArray("address_components");
                        for (JsonElement el : components) {
                            JsonObject comp = el.getAsJsonObject();
                            JsonArray types = comp.getAsJsonArray("types");
                            String val = comp.get("long_name").getAsString();
                            
                            for (JsonElement t : types) {
                                String type = t.getAsString();
                                if (type.equals("country")) {
                                    result.addProperty("country", val);
                                } else if (type.equals("administrative_area_level_1")) {
                                    result.addProperty("state", val);
                                } else if (type.equals("locality") && !result.has("city")) {
                                    result.addProperty("city", val);
                                } else if (type.equals("administrative_area_level_2") && !result.has("city")) {
                                    result.addProperty("city", val);
                                }
                            }
                        }
                    }
                } else {
                    result.addProperty("success", false);
                    result.addProperty("error", "No result found");
                }
            } else {
                result.addProperty("success", false);
                result.addProperty("error", "API Error: " + response.statusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("error", e.getMessage());
        }

        return result;
    }
}
