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

public class NearbySearchService {

    private final HttpClient httpClient;
    private final String apiKey;

    public NearbySearchService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.apiKey = ConfigManager.get("GOOGLE_PLACES_API_KEY");
    }

    public JsonArray getNearbyPlaces(String lat, String lng, String type, String keyword) {
        JsonArray resultsArray = new JsonArray();

        if (this.apiKey == null || this.apiKey.isEmpty() || this.apiKey.equals("YOUR_KEY")) {
            System.err.println("[NEARBY] Google Places API Key is missing. Falling back to Overpass.");
            return fetchFromOverpass(lat, lng, type, keyword);
        }

        try {
            StringBuilder urlBuilder = new StringBuilder("https://maps.googleapis.com/maps/api/place/nearbysearch/json?");
            urlBuilder.append("location=").append(lat).append(",").append(lng);
            urlBuilder.append("&radius=5000");
            if (type != null && !type.isEmpty()) {
                urlBuilder.append("&type=").append(type);
            }
            if (keyword != null && !keyword.isEmpty()) {
                urlBuilder.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8.toString()));
            }
            urlBuilder.append("&key=").append(this.apiKey);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(urlBuilder.toString()))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
                if (jsonResponse.has("results")) {
                    JsonArray rawResults = jsonResponse.getAsJsonArray("results");
                    int maxResults = Math.min(rawResults.size(), 8); // Limit to 8 items to save API quota on photos

                    for (int i = 0; i < maxResults; i++) {
                        JsonObject rawPlace = rawResults.get(i).getAsJsonObject();
                        JsonObject place = new JsonObject();
                        
                        String placeId = rawPlace.get("place_id").getAsString();
                        
                        place.addProperty("placeId", placeId);
                        place.addProperty("name", rawPlace.has("name") ? rawPlace.get("name").getAsString() : "");
                        place.addProperty("rating", rawPlace.has("rating") ? rawPlace.get("rating").getAsDouble() : 0);
                        place.addProperty("address", rawPlace.has("vicinity") ? rawPlace.get("vicinity").getAsString() : "");
                        
                        if (rawPlace.has("geometry")) {
                            JsonObject location = rawPlace.getAsJsonObject("geometry").getAsJsonObject("location");
                            place.addProperty("lat", location.get("lat").getAsDouble());
                            place.addProperty("lng", location.get("lng").getAsDouble());
                        }

                        // Photo URL
                        if (rawPlace.has("photos") && rawPlace.getAsJsonArray("photos").size() > 0) {
                            String photoReference = rawPlace.getAsJsonArray("photos").get(0).getAsJsonObject().get("photo_reference").getAsString();
                            String photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=" + photoReference + "&key=" + this.apiKey;
                            place.addProperty("photo", photoUrl);
                        } else {
                            place.addProperty("photo", ""); // Fallback needed on frontend
                        }

                        // Google Maps Link
                        String mapsLink = "https://www.google.com/maps/search/?api=1&query=" + place.get("lat").getAsDouble() + "," + place.get("lng").getAsDouble() + "&query_place_id=" + placeId;
                        place.addProperty("maps_link", mapsLink);
                        
                        // Opening Status
                        if (rawPlace.has("opening_hours")) {
                            boolean openNow = rawPlace.getAsJsonObject("opening_hours").has("open_now") && rawPlace.getAsJsonObject("opening_hours").get("open_now").getAsBoolean();
                            place.addProperty("open_now", openNow);
                        }

                        resultsArray.add(place);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (resultsArray.size() == 0) {
            System.err.println("[NEARBY] Google Places API returned 0 results. Falling back to Overpass.");
            return fetchFromOverpass(lat, lng, type, keyword);
        }

        return resultsArray;
    }

    private JsonArray fetchFromOverpass(String lat, String lng, String type, String keyword) {
        JsonArray resultsArray = new JsonArray();
        try {
            // Map Google Places types to Overpass tags loosely
            String overpassTag = "tourism=hotel"; // default
            if ("lodging".equals(type) || "hotel".equals(type)) overpassTag = "tourism=hotel";
            else if ("restaurant".equals(type)) overpassTag = "amenity=restaurant";
            else if ("tourist_attraction".equals(type)) overpassTag = "tourism=attraction";
            else if ("amusement_park".equals(type) || "experiences".equals(type)) overpassTag = "tourism=theme_park";
            
            // Build Overpass QL query: node(around:radius,lat,lon)[tag];out;
            String query = "[out:json];(node(around:5000," + lat + "," + lng + ")[" + overpassTag + "];);out 10;";
            String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8.toString());
            
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://overpass-api.de/api/interpreter?data=" + encodedQuery))
                    .header("User-Agent", "VoyastraTravelApp/1.0")
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
                if (jsonResponse.has("elements")) {
                    JsonArray elements = jsonResponse.getAsJsonArray("elements");
                    for (int i = 0; i < elements.size(); i++) {
                        JsonObject el = elements.get(i).getAsJsonObject();
                        JsonObject place = new JsonObject();
                        
                        String name = "Unknown Place";
                        if (el.has("tags") && el.getAsJsonObject("tags").has("name")) {
                            name = el.getAsJsonObject("tags").get("name").getAsString();
                        }
                        
                        place.addProperty("placeId", el.get("id").getAsString());
                        place.addProperty("name", name);
                        place.addProperty("rating", 4.0); // Dummy rating for fallback
                        place.addProperty("address", "Local coordinates");
                        place.addProperty("lat", el.get("lat").getAsDouble());
                        place.addProperty("lng", el.get("lon").getAsDouble());
                        place.addProperty("photo", ""); 
                        place.addProperty("maps_link", "https://www.openstreetmap.org/node/" + el.get("id").getAsString());
                        place.addProperty("open_now", true);
                        
                        resultsArray.add(place);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultsArray;
    }
}
