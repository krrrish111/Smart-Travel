package com.voyastra.servlet;

import com.voyastra.service.GeminiService;
import com.voyastra.model.User;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/generatePlan", "/planner", "/my-plans"})
public class PlannerServlet extends HttpServlet {

    private GeminiService geminiService;

    @Override
    public void init() throws ServletException {
        super.init();
        geminiService = new GeminiService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String sessionId = request.getSession().getId();
        User user = (User) request.getSession().getAttribute("user");
        int userId = user != null ? user.getId() : -1;
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO planner_sessions (session_id, user_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE last_active = CURRENT_TIMESTAMP";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sessionId);
            if (userId != -1) {
                pstmt.setInt(2, userId);
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.err.println("Failed to track planner session: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, String> params = new HashMap<>();
        params.put("source", request.getParameter("startLocation"));
        params.put("destination", request.getParameter("destination"));
        params.put("startDate", request.getParameter("departureDate"));
        params.put("endDate", request.getParameter("returnDate"));
        params.put("budget", request.getParameter("budget"));
        params.put("travelStyle", request.getParameter("type"));
        params.put("interests", request.getParameter("interests"));
        
        int adults = Integer.parseInt(request.getParameter("adults") != null && !request.getParameter("adults").isEmpty() ? request.getParameter("adults") : "1");
        int children = Integer.parseInt(request.getParameter("children") != null && !request.getParameter("children").isEmpty() ? request.getParameter("children") : "0");
        int seniors = Integer.parseInt(request.getParameter("seniors") != null && !request.getParameter("seniors").isEmpty() ? request.getParameter("seniors") : "0");
        int totalTravelers = adults + children + seniors;
        params.put("travelers", String.valueOf(totalTravelers));

        System.out.println("--- Planner Form Submitted ---");
        System.out.println("Source: " + params.get("source"));
        System.out.println("Destination: " + params.get("destination"));
        System.out.println("Start Date: " + params.get("startDate"));
        System.out.println("End Date: " + params.get("endDate"));
        System.out.println("Budget: " + params.get("budget"));

        if (params.get("source") == null || params.get("destination") == null || 
            params.get("startDate") == null || params.get("endDate") == null || params.get("budget") == null) {
            System.err.println("Validation failed: Missing required parameters.");
            request.setAttribute("error", "Missing required parameters.");
            request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            return;
        }

        // DB save
        User user = (User) request.getSession().getAttribute("user");
        int userId = user != null ? user.getId() : -1;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO planner_requests (user_id, origin, destination, departure_date, return_date, budget, travel_style, adults, children, seniors) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            if (userId != -1) {
                pstmt.setInt(1, userId);
            } else {
                pstmt.setNull(1, java.sql.Types.INTEGER);
            }
            pstmt.setString(2, params.get("source"));
            pstmt.setString(3, params.get("destination"));
            pstmt.setString(4, params.get("startDate"));
            pstmt.setString(5, params.get("endDate"));
            pstmt.setBigDecimal(6, new java.math.BigDecimal(params.get("budget")));
            pstmt.setString(7, params.get("travelStyle"));
            pstmt.setInt(8, adults);
            pstmt.setInt(9, children);
            pstmt.setInt(10, seniors);
            pstmt.executeUpdate();
            System.out.println("Saved planner request to database.");
        } catch (Exception e) {
            System.err.println("Failed to save planner request: " + e.getMessage());
        }

        String acceptHeader = request.getHeader("Accept");
        boolean isJsonRequested = (acceptHeader != null && acceptHeader.contains("application/json")) ||
                "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            System.out.println("Calling Gemini...");
            String itineraryJson = geminiService.generateTripPlan(params);
            System.out.println("Gemini Response Parsed Successfully.");
            
            if (isJsonRequested) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(itineraryJson);
                System.out.println("Sent itinerary JSON response directly.");
            } else {
                request.setAttribute("itineraryJson", itineraryJson);
                System.out.println("Forwarding to planner-result.jsp...");
                request.getRequestDispatcher("/pages/planner-result.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("Gemini API Error: " + e.getMessage());
            e.printStackTrace();
            if (isJsonRequested) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String errMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"").replace("\n", " ") : "Unknown error";
                response.getWriter().write("{\"error\": \"" + errMsg + "\"}");
            } else {
                request.setAttribute("error", "Unable to generate trip plan. Please check Gemini API configuration.");
                request.getRequestDispatcher("/pages/planner.jsp").forward(request, response);
            }
        }
    }
}
