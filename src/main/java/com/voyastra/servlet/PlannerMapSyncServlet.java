package com.voyastra.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.voyastra.util.DBConnection;

@WebServlet("/api/planner/map-sync")
public class PlannerMapSyncServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String sessionId = request.getSession().getId();
        String placeName = request.getParameter("placeName");
        String category = request.getParameter("category");
        String latStr = request.getParameter("lat");
        String lngStr = request.getParameter("lng");

        if (placeName == null || latStr == null || lngStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Missing parameters\"}");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO planner_selected_places (session_id, place_name, category, lat, lng) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sessionId);
            pstmt.setString(2, placeName);
            pstmt.setString(3, category);
            pstmt.setBigDecimal(4, new java.math.BigDecimal(latStr));
            pstmt.setBigDecimal(5, new java.math.BigDecimal(lngStr));
            pstmt.executeUpdate();
            
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
