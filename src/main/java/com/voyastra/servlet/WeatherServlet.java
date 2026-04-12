package com.voyastra.servlet;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Proxy Servlet for OpenWeatherMap API.
 * Keeps API keys secure on the server side and provides a clean JSON interface for the frontend.
 */
@WebServlet("/api/weather")
public class WeatherServlet extends HttpServlet {

    // Placeholder Key - User should replace with a real OpenWeatherMap API Key
    private static final String API_KEY = "8c77f0a9b8c7d6e5f4a3b2c1d0e9f8a7"; // Example placeholder
    private static final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String location = request.getParameter("location");
        if (location == null || location.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String encodedLocation = URLEncoder.encode(location, StandardCharsets.UTF_8.name());
            String urlStr = String.format("%s?q=%s&appid=%s&units=metric", BASE_URL, encodedLocation, API_KEY);
            
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            int status = conn.getResponseCode();
            if (status != 200) {
                response.setStatus(status);
                JsonObject err = new JsonObject();
                err.addProperty("error", "Weather service unavailable for " + location);
                response.getWriter().write(err.toString());
                return;
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder content = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            conn.disconnect();

            // Parse and relay the JSON
            JsonObject weatherData = JsonParser.parseString(content.toString()).getAsJsonObject();
            response.getWriter().write(weatherData.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Failed to fetch weather data: " + e.getMessage());
            response.getWriter().write(error.toString());
            e.printStackTrace();
        }
    }
}
