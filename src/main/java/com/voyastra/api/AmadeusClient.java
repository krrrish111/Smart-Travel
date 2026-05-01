package com.voyastra.api;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.stream.Collectors;

public class AmadeusClient {

    private static final String API_KEY = "YOUR_AMADEUS_API_KEY"; // Placeholder
    private static final String API_SECRET = "YOUR_AMADEUS_API_SECRET"; // Placeholder
    private static final String BASE_URL = "https://test.api.amadeus.com";

    private String accessToken;
    private long tokenExpiryTime;

    private void authenticate() throws Exception {
        if (accessToken != null && System.currentTimeMillis() < tokenExpiryTime) {
            return;
        }

        URL url = new URL(BASE_URL + "/v1/security/oauth2/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        String data = "grant_type=client_credentials&client_id=" + API_KEY + "&client_secret=" + API_SECRET;
        try (OutputStream os = conn.getOutputStream()) {
            os.write(data.getBytes());
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String response = reader.lines().collect(Collectors.joining());
        JsonObject json = JsonParser.parseString(response).getAsJsonObject();

        this.accessToken = json.get("access_token").getAsString();
        this.tokenExpiryTime = System.currentTimeMillis() + (json.get("expires_in").getAsLong() * 1000);
    }

    public String searchFlights(String origin, String destination, String date) {
        try {
            authenticate();
            String endpoint = "/v2/shopping/flight-offers?originLocationCode=" + origin +
                              "&destinationLocationCode=" + destination +
                              "&departureDate=" + date +
                              "&adults=1&max=5";
            
            return makeGetRequest(endpoint);
        } catch (Exception e) {
            System.err.println("Amadeus Flight Search Failed: " + e.getMessage());
            return null;
        }
    }

    private String makeGetRequest(String endpoint) throws Exception {
        URL url = new URL(BASE_URL + endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        if (conn.getResponseCode() != 200) {
            return null;
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        return reader.lines().collect(Collectors.joining());
    }
}
