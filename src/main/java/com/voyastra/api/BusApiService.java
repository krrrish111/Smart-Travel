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

public class BusApiService {

    private static final String API_KEY = "YOUR_REDBUS_API_KEY"; 
    private static final String API_HOST = "api.redbus.com";
    private static final int TIMEOUT_MS = 4000;

    public List<Transport> searchBuses(String origin, String destination, String date, String type) {
        String urlStr = "https://" + API_HOST + "/v1/inventory/search?source=" + origin + "&destination=" + destination + "&doj=" + date;
        
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);

            int code = conn.getResponseCode();
            if (code == 200) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    String json = reader.lines().collect(Collectors.joining());
                    return parseBusJson(json, origin, destination);
                }
            } else {
                throw new Exception("HTTP " + code);
            }
        } catch (Exception e) {
            System.err.println("[BusApiService] Real API failed (" + e.getMessage() + "), falling back to simulated JSON payload...");
            return parseBusJson(getSimulatedJson(origin, destination), origin, destination);
        }
    }

    private List<Transport> parseBusJson(String json, String origin, String destination) {
        List<Transport> list = new ArrayList<>();
        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            if (root.has("inventory") && root.get("inventory").isJsonArray()) {
                JsonArray data = root.getAsJsonArray("inventory");
                for (JsonElement el : data) {
                    JsonObject tObj = el.getAsJsonObject();
                    Transport t = new Transport();
                    t.setType("bus");
                    t.setCompanyLogo("🚌");
                    t.setOriginCode(origin != null ? origin.toUpperCase() : "SRC");
                    t.setDestinationCode(destination != null ? destination.toUpperCase() : "DST");
                    
                    t.setCompanyName(tObj.has("operatorName") ? tObj.get("operatorName").getAsString() : "RedBus Operator");
                    t.setTransportNumber(tObj.has("serviceId") ? tObj.get("serviceId").getAsString() : "UNKNOWN");
                    t.setDepartureTime(tObj.has("departureTime") ? tObj.get("departureTime").getAsString() : "00:00");
                    t.setArrivalTime(tObj.has("arrivalTime") ? tObj.get("arrivalTime").getAsString() : "00:00");
                    t.setDuration(tObj.has("duration") ? tObj.get("duration").getAsString() : "N/A");
                    t.setPrice(tObj.has("fare") ? tObj.get("fare").getAsDouble() : 1000.0);
                    t.setBadge(tObj.has("busType") ? tObj.get("busType").getAsString() : "Standard");
                    t.setStops(tObj.has("stops") ? tObj.get("stops").getAsInt() : 0);
                    list.add(t);
                }
            }
        } catch (Exception e) {
            System.err.println("[BusApiService] JSON Parse Error: " + e.getMessage());
        }
        return list;
    }

    private String getSimulatedJson(String origin, String destination) {
        return "{\"inventory\":[" +
               "{\"operatorName\":\"Volvo AC Sleeper\",\"serviceId\":\"BUS-01\",\"departureTime\":\"09:00 PM\",\"arrivalTime\":\"07:00 AM\",\"duration\":\"10h 00m\",\"fare\":1200.0,\"busType\":\"Luxury\",\"stops\":0}," +
               "{\"operatorName\":\"Scania Semi-Sleeper\",\"serviceId\":\"BUS-02\",\"departureTime\":\"10:30 PM\",\"arrivalTime\":\"06:30 AM\",\"duration\":\"8h 00m\",\"fare\":950.0,\"busType\":\"Comfort\",\"stops\":1}," +
               "{\"operatorName\":\"Non-AC Seater\",\"serviceId\":\"BUS-03\",\"departureTime\":\"08:00 AM\",\"arrivalTime\":\"06:00 PM\",\"duration\":\"10h 00m\",\"fare\":500.0,\"busType\":\"Cheapest\",\"stops\":3}" +
               "]}";
    }
}
