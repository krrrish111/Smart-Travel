package com.voyastra.api;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.voyastra.model.transport.Transport;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class CabApiService {

    private static final String API_KEY = "YOUR_UBER_SERVER_TOKEN"; 
    private static final String API_HOST = "api.uber.com";
    private static final int TIMEOUT_MS = 4000;

    public List<Transport> searchCabs(String pickup, String drop, String date, String type) {
        // Mock geocodes for API request
        String urlStr = "https://" + API_HOST + "/v1.2/estimates/price?start_latitude=19.076&start_longitude=72.877&end_latitude=18.520&end_longitude=73.856";
        
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setRequestProperty("Authorization", "Token " + API_KEY);
            conn.setRequestProperty("Accept-Language", "en_US");

            int code = conn.getResponseCode();
            if (code == 200) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    String json = reader.lines().collect(Collectors.joining());
                    return parseCabJson(json, pickup, drop);
                }
            } else {
                throw new Exception("HTTP " + code);
            }
        } catch (Exception e) {
            System.err.println("[CabApiService] Real API failed (" + e.getMessage() + "), falling back to simulated JSON payload...");
            return parseCabJson(getSimulatedJson(pickup, drop), pickup, drop);
        }
    }

    private List<Transport> parseCabJson(String json, String pickup, String drop) {
        List<Transport> list = new ArrayList<>();
        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            if (root.has("prices") && root.get("prices").isJsonArray()) {
                JsonArray data = root.getAsJsonArray("prices");
                for (JsonElement el : data) {
                    JsonObject tObj = el.getAsJsonObject();
                    Transport t = new Transport();
                    t.setType("cab");
                    t.setCompanyLogo("🚕");
                    t.setOriginCode(pickup != null ? pickup : "Pickup");
                    t.setDestinationCode(drop != null ? drop : "Drop");
                    
                    t.setCompanyName(tObj.has("display_name") ? "Uber " + tObj.get("display_name").getAsString() : "Uber");
                    t.setTransportNumber(tObj.has("display_name") ? tObj.get("display_name").getAsString() : "UNKNOWN");
                    t.setDepartureTime("On Demand");
                    t.setArrivalTime("N/A");
                    t.setDuration("Route Dependent");
                    t.setPrice(tObj.has("high_estimate") ? tObj.get("high_estimate").getAsDouble() : 1500.0);
                    t.setBadge(tObj.has("localized_display_name") ? tObj.get("localized_display_name").getAsString() : "Popular");
                    t.setStops(0);
                    list.add(t);
                }
            }
        } catch (Exception e) {
            System.err.println("[CabApiService] JSON Parse Error: " + e.getMessage());
        }
        return list;
    }

    private String getSimulatedJson(String pickup, String drop) {
        return "{\"prices\":[" +
               "{\"display_name\":\"Sedan\",\"high_estimate\":1200.0,\"localized_display_name\":\"Popular\"}," +
               "{\"display_name\":\"SUV\",\"high_estimate\":1800.0,\"localized_display_name\":\"Spacious\"}" +
               "]}";
    }
}
