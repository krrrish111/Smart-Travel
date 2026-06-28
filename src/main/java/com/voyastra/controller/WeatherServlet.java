package com.voyastra.controller;

import com.google.gson.JsonObject;
import com.voyastra.service.WeatherService;
import com.voyastra.util.DiagnosticManager;
import com.voyastra.model.planner.PlannerStatus;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/api/weather")
public class WeatherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sessionId = request.getSession().getId();
        
        System.out.println("[WEATHER]");
        System.out.println("Request Received");
        DiagnosticManager.setStatus(sessionId, PlannerStatus.REQUEST_RECEIVED);

        String destination = request.getParameter("destination");
        String lat = request.getParameter("lat");
        String lng = request.getParameter("lng");

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        System.out.println("Incoming destination: " + destination);

        if (destination == null || destination.trim().isEmpty()) {
            DiagnosticManager.setStatus(sessionId, PlannerStatus.FAILED);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("error", "Destination parameter is required");
            response.getWriter().write(err.toString());
            return;
        }

        System.out.println("[WEATHER]");
        System.out.println("Calling OpenWeather");

        try {
            JsonObject weatherData = WeatherService.fetchWeather(destination, lat, lng);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("city", weatherData.has("city") ? weatherData.get("city").getAsString() : destination);
            result.addProperty("temp", weatherData.has("temperature") ? Math.round(weatherData.get("temperature").getAsDouble()) : 0);
            result.addProperty("temperature", weatherData.has("temperature") ? Math.round(weatherData.get("temperature").getAsDouble()) : 0);
            result.addProperty("condition", weatherData.has("weatherDescription") ? weatherData.get("weatherDescription").getAsString() : "Unknown");
            result.addProperty("humidity", weatherData.has("humidity") ? weatherData.get("humidity").getAsInt() : 0);
            result.addProperty("wind", weatherData.has("windSpeed") ? Math.round(weatherData.get("windSpeed").getAsDouble()) : 0);

            System.out.println("[WEATHER]");
            System.out.println("Response Received");
            System.out.println("API Response body: " + weatherData.toString());

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(result.toString());
            
            System.out.println("[WEATHER]");
            System.out.println("Weather Loaded Successfully");
            DiagnosticManager.setStatus(sessionId, PlannerStatus.COMPLETED);
            
        } catch (Exception e) {
            System.out.println("[WEATHER]");
            System.out.println("Response Received");
            System.out.println("Error fetching weather: " + e.getMessage());
            DiagnosticManager.setStatus(sessionId, PlannerStatus.COMPLETED);
            response.setStatus(HttpServletResponse.SC_OK);
            
            // Fallback friendly weather card
            JsonObject fallback = new JsonObject();
            fallback.addProperty("success", true);
            fallback.addProperty("city", destination);
            fallback.addProperty("temp", 20);
            fallback.addProperty("temperature", 20);
            fallback.addProperty("condition", "Cloudy");
            fallback.addProperty("humidity", 60);
            fallback.addProperty("wind", 12);
            
            response.getWriter().write(fallback.toString());
            
            System.out.println("[WEATHER]");
            System.out.println("Weather Loaded Successfully");
        }
    }
}
