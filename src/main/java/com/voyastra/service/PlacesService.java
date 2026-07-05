package com.voyastra.service;

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

public class PlacesService {

    private final HttpClient httpClient;
    private final String apiKey;

    public PlacesService() {
        this.httpClient = com.voyastra.util.HttpClientFactory.get();
        this.apiKey = ConfigManager.get("GOOGLE_PLACES_API_KEY");
    }

    /**
     * Resolves a destination string to its geographic coordinates using Google Places API (Find Place).
     */
    public JsonObject getCoordinatesForDestination(String destination) {
        JsonObject result = new JsonObject();
        result.addProperty("status", "FAILED");

        if (this.apiKey == null || this.apiKey.isEmpty() || this.apiKey.equals("YOUR_KEY")) {
            System.err.println("[PLACES] Google Places API Key is missing.");
            return result;
        }

        try {
            String encodedDest = URLEncoder.encode(destination, StandardCharsets.UTF_8.toString());
            String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" 
                    + encodedDest + "&inputtype=textquery&fields=geometry,place_id,name&key=" + this.apiKey;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
                if ("OK".equals(jsonResponse.get("status").getAsString()) && jsonResponse.has("candidates")) {
                    JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();
                    if (candidate.has("geometry")) {
                        JsonObject location = candidate.getAsJsonObject("geometry").getAsJsonObject("location");
                        result.addProperty("lat", location.get("lat").getAsDouble());
                        result.addProperty("lng", location.get("lng").getAsDouble());
                        result.addProperty("placeId", candidate.has("place_id") ? candidate.get("place_id").getAsString() : "");
                        result.addProperty("name", candidate.has("name") ? candidate.get("name").getAsString() : destination);
                        result.addProperty("status", "OK");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
