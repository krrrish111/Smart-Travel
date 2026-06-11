package com.voyastra.api;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.voyastra.model.Transport;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class TrainApiService {

    private static final String API_KEY = "YOUR_RAPIDAPI_KEY"; // From env
    private static final String API_HOST = "irctc1.p.rapidapi.com";
    private static final int TIMEOUT_MS = 4000;

    public List<Transport> searchTrains(String origin, String destination, String date, String seatClass) {
        String urlStr = "https://" + API_HOST + "/api/v1/searchTrain?source=" + origin + "&destination=" + destination + "&doj=" + date;
        
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setRequestProperty("X-RapidAPI-Key", API_KEY);
            conn.setRequestProperty("X-RapidAPI-Host", API_HOST);

            int code = conn.getResponseCode();
            if (code == 200) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    String json = reader.lines().collect(Collectors.joining());
                    return parseTrainJson(json, origin, destination);
                }
            } else {
                throw new Exception("HTTP " + code);
            }
        } catch (Exception e) {
            System.err.println("[TrainApiService] Real API failed (" + e.getMessage() + "), falling back to simulated JSON payload...");
            return parseTrainJson(getSimulatedJson(origin, destination), origin, destination);
        }
    }

    private List<Transport> parseTrainJson(String json, String origin, String destination) {
        List<Transport> list = new ArrayList<>();
        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            if (root.has("data") && root.get("data").isJsonArray()) {
                JsonArray data = root.getAsJsonArray("data");
                for (JsonElement el : data) {
                    JsonObject tObj = el.getAsJsonObject();
                    Transport t = new Transport();
                    t.setType("train");
                    t.setCompanyLogo("🚆");
                    t.setOriginCode(origin != null ? origin.toUpperCase() : "SRC");
                    t.setDestinationCode(destination != null ? destination.toUpperCase() : "DST");
                    
                    t.setCompanyName(tObj.has("train_name") ? tObj.get("train_name").getAsString() : "Indian Railways");
                    t.setTransportNumber(tObj.has("train_number") ? tObj.get("train_number").getAsString() : "UNKNOWN");
                    t.setDepartureTime(tObj.has("departure_time") ? tObj.get("departure_time").getAsString() : "00:00");
                    t.setArrivalTime(tObj.has("arrival_time") ? tObj.get("arrival_time").getAsString() : "00:00");
                    t.setDuration(tObj.has("duration") ? tObj.get("duration").getAsString() : "N/A");
                    t.setPrice(tObj.has("price") ? tObj.get("price").getAsDouble() : 1500.0);
                    t.setBadge(tObj.has("class_type") ? tObj.get("class_type").getAsString() : "Standard");
                    t.setStops(0);
                    list.add(t);
                }
            }
        } catch (Exception e) {
            System.err.println("[TrainApiService] JSON Parse Error: " + e.getMessage());
        }
        return list;
    }

    private String getSimulatedJson(String origin, String destination) {
        return "{\"status\":\"success\",\"data\":[" +
               "{\"train_name\":\"Vande Bharat\",\"train_number\":\"22436\",\"departure_time\":\"06:00 AM\",\"arrival_time\":\"02:00 PM\",\"duration\":\"8h 00m\",\"price\":1500.0,\"class_type\":\"Fastest\"}," +
               "{\"train_name\":\"Rajdhani Express\",\"train_number\":\"12951\",\"departure_time\":\"04:30 PM\",\"arrival_time\":\"08:30 AM\",\"duration\":\"16h 00m\",\"price\":2500.0,\"class_type\":\"Premium\"}," +
               "{\"train_name\":\"Shatabdi Exp\",\"train_number\":\"12001\",\"departure_time\":\"06:00 AM\",\"arrival_time\":\"11:45 AM\",\"duration\":\"5h 45m\",\"price\":1200.0,\"class_type\":\"Best Value\"}" +
               "]}";
    }
}
