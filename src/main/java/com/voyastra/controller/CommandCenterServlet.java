package com.voyastra.controller;

import com.voyastra.model.profile.User;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/command-center")
public class CommandCenterServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CommandCenterServlet.class.getName());


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String destination = request.getParameter("destination");

        // If no destination is specified, show a search prompt/dashboard empty state
        if (destination == null || destination.trim().isEmpty()) {
            request.getRequestDispatcher("/pages/common/command-center-search.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Fetch or simulate Weather Data
            Map<String, Object> weather = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM weather_cache WHERE destination = ?")) {
                stmt.setString(1, destination);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    weather.put("temp", rs.getDouble("temp"));
                    weather.put("humidity", rs.getInt("humidity"));
                    weather.put("rain_prob", rs.getInt("rain_prob"));
                    weather.put("wind_speed", rs.getDouble("wind_speed"));
                    weather.put("aqi", rs.getString("aqi"));
                    weather.put("uv_index", rs.getDouble("uv_index"));
                    weather.put("weather_score", rs.getInt("weather_score"));
                } else {
                    // Simulate insertion for demo purposes
                    weather.put("temp", 28.5);
                    weather.put("humidity", 72);
                    weather.put("rain_prob", 15);
                    weather.put("wind_speed", 12.0);
                    weather.put("aqi", "Good");
                    weather.put("uv_index", 6.5);
                    weather.put("weather_score", 93);
                    
                    try(PreparedStatement insert = conn.prepareStatement("INSERT INTO weather_cache (destination, temp, humidity, rain_prob, wind_speed, aqi, uv_index, weather_score) VALUES (?,?,?,?,?,?,?,?)")) {
                        insert.setString(1, destination);
                        insert.setDouble(2, 28.5);
                        insert.setInt(3, 72);
                        insert.setInt(4, 15);
                        insert.setDouble(5, 12.0);
                        insert.setString(6, "Good");
                        insert.setDouble(7, 6.5);
                        insert.setInt(8, 93);
                        insert.executeUpdate();
                    }
                }
            }
            request.setAttribute("weather", weather);

            // 2. Fetch or simulate Crowd Predictions
            Map<String, Object> crowd = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM crowd_predictions WHERE destination = ?")) {
                stmt.setString(1, destination);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    crowd.put("current_crowd", rs.getString("current_crowd"));
                    crowd.put("expected_crowd", rs.getString("expected_crowd"));
                    crowd.put("peak_season", rs.getString("peak_season"));
                    crowd.put("off_season", rs.getString("off_season"));
                } else {
                    crowd.put("current_crowd", "Moderate");
                    crowd.put("expected_crowd", "High");
                    crowd.put("peak_season", "December");
                    crowd.put("off_season", "July");
                }
            }
            request.setAttribute("crowd", crowd);

            // 3. Fetch or simulate Safety Scores
            Map<String, Object> safety = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM safety_scores WHERE destination = ?")) {
                stmt.setString(1, destination);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    safety.put("overall_score", rs.getDouble("overall_score"));
                    safety.put("night_safety", rs.getString("night_safety"));
                    safety.put("medical_access", rs.getString("medical_access"));
                    safety.put("scam_risk", rs.getString("scam_risk"));
                } else {
                    safety.put("overall_score", 9.1);
                    safety.put("night_safety", "Good");
                    safety.put("medical_access", "Excellent");
                    safety.put("scam_risk", "Low");
                }
            }
            request.setAttribute("safety", safety);

            // 4. Fetch destination insights
            Map<String, Object> insight = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM destination_insights WHERE destination = ?")) {
                stmt.setString(1, destination);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    insight.put("health_score", rs.getInt("health_score"));
                    insight.put("best_time_photos", rs.getString("best_time_photos"));
                    insight.put("sunrise", rs.getString("sunrise"));
                    insight.put("sunset", rs.getString("sunset"));
                } else {
                    insight.put("health_score", 95);
                    insight.put("best_time_photos", "5:45 PM");
                    insight.put("sunrise", "6:15 AM");
                    insight.put("sunset", "6:45 PM");
                }
            }
            request.setAttribute("insight", insight);

            // 5. Fetch Active Travel Alerts
            List<Map<String, String>> alerts = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM travel_alerts WHERE destination = ? AND active = TRUE")) {
                stmt.setString(1, destination);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, String> alert = new HashMap<>();
                    alert.put("type", rs.getString("alert_type"));
                    alert.put("severity", rs.getString("severity"));
                    alert.put("message", rs.getString("message"));
                    alerts.add(alert);
                }
                if (alerts.isEmpty()) {
                    // Inject a mock alert for demo
                    Map<String, String> alert = new HashMap<>();
                    alert.put("type", "Weather");
                    alert.put("severity", "Warning");
                    alert.put("message", "Light rain expected tomorrow evening.");
                    alerts.add(alert);
                }
            }
            request.setAttribute("alerts", alerts);

            request.setAttribute("destination", destination);
            request.getRequestDispatcher("/pages/common/command-center.jsp").forward(request, response);

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
