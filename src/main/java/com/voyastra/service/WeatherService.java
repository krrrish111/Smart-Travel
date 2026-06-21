package com.voyastra.service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.voyastra.config.ConfigManager;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;

public class WeatherService {
    private static final Logger logger = Logger.getLogger(WeatherService.class.getName());
    private static final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

    public static JsonObject fetchWeather(String destination, String lat, String lng) throws Exception {
        long startTime = System.currentTimeMillis();
        
        try {
            String apiKey = ConfigManager.get("OPENWEATHER_API_KEY");
            if (apiKey == null || apiKey.trim().isEmpty() || "your_api_key_here".equals(apiKey)) {
                throw new Exception("Missing API key: OPENWEATHER_API_KEY is not configured");
            }

            String urlStr;
            if (lat != null && lng != null && !lat.isEmpty() && !lng.isEmpty()) {
                System.out.println("[WEATHER] Coordinates Received: " + lat + ", " + lng);
                urlStr = String.format("%s?lat=%s&lon=%s&appid=%s&units=metric", BASE_URL, lat, lng, apiKey);
            } else {
                String encodedLocation = URLEncoder.encode(destination, StandardCharsets.UTF_8.name());
                urlStr = String.format("%s?q=%s&appid=%s&units=metric", BASE_URL, encodedLocation, apiKey);
            }
            
            System.out.println("Generated weather URL: " + urlStr.replace(apiKey, "HIDDEN_API_KEY"));
            
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int status = conn.getResponseCode();
            System.out.println("API response code: " + status);
            
            if (status != 200) {
                if (status == 404) {
                    throw new Exception("Invalid city: " + destination + " not found");
                } else if (status == 401) {
                    throw new Exception("Invalid OpenWeather API Key");
                } else if (status == 429) {
                    throw new Exception("API rate limit exceeded");
                }
                throw new Exception("Weather service returned status: " + status);
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder content = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            conn.disconnect();

            JsonObject rawJson = JsonParser.parseString(content.toString()).getAsJsonObject();
            JsonObject result = new JsonObject();
            
            if (rawJson.has("name")) {
                result.addProperty("city", rawJson.get("name").getAsString());
            }
            
            if (rawJson.has("sys")) {
                JsonObject sys = rawJson.getAsJsonObject("sys");
                if (sys.has("country")) {
                    result.addProperty("country", sys.get("country").getAsString());
                }
                if (sys.has("sunrise")) {
                    result.addProperty("sunrise", sys.get("sunrise").getAsLong());
                }
                if (sys.has("sunset")) {
                    result.addProperty("sunset", sys.get("sunset").getAsLong());
                }
            }

            if (rawJson.has("main")) {
                JsonObject main = rawJson.getAsJsonObject("main");
                result.addProperty("temperature", main.get("temp").getAsDouble());
                result.addProperty("feelsLike", main.get("feels_like").getAsDouble());
                result.addProperty("humidity", main.get("humidity").getAsInt());
            }
            
            if (rawJson.has("wind")) {
                JsonObject wind = rawJson.getAsJsonObject("wind");
                result.addProperty("windSpeed", wind.get("speed").getAsDouble());
            }
            
            if (rawJson.has("visibility")) {
                result.addProperty("visibility", rawJson.get("visibility").getAsInt());
            }
            
            if (rawJson.has("weather") && rawJson.getAsJsonArray("weather").size() > 0) {
                JsonObject weather = rawJson.getAsJsonArray("weather").get(0).getAsJsonObject();
                if (weather.has("description")) {
                    result.addProperty("weatherDescription", weather.get("description").getAsString());
                }
                if (weather.has("icon")) {
                    result.addProperty("weatherIcon", weather.get("icon").getAsString());
                }
            }

            long duration = System.currentTimeMillis() - startTime;
            logger.info("OpenWeather API Request SUCCESS for city: " + destination + " | Response Time: " + duration + "ms");
            return result;
            
        } catch (SocketTimeoutException e) {
            long duration = System.currentTimeMillis() - startTime;
            logger.warning("OpenWeather API Request TIMEOUT for city: " + destination + " | Response Time: " + duration + "ms");
            throw new Exception("API timeout: " + e.getMessage());
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            logger.severe("OpenWeather API Request FAILED for city: " + destination + " | Error: " + e.getMessage() + " | Response Time: " + duration + "ms");
            throw e;
        }
    }
}
