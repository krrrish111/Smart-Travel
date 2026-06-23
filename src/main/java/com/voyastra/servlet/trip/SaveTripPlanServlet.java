package com.voyastra.servlet.trip;

import com.voyastra.dao.SavedTripPlanDAO;
import com.voyastra.model.User;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/trip/save")
public class SaveTripPlanServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject json = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            json.addProperty("success", false);
            json.addProperty("message", "Unauthorized. Please log in.");
            response.getWriter().write(json.toString());
            return;
        }

        try {
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            String action = request.getParameter("action"); // "save" or "remove"
            User user = (User) session.getAttribute("user");
            
            SavedTripPlanDAO dao = new SavedTripPlanDAO();
            boolean success = false;
            
            if ("remove".equalsIgnoreCase(action)) {
                success = dao.removeSavedPlan(user.getId(), tripId);
                json.addProperty("message", success ? "Plan removed from saved." : "Failed to remove plan.");
            } else {
                success = dao.savePlan(user.getId(), tripId);
                json.addProperty("message", success ? "Plan saved successfully." : "Plan already saved or failed to save.");
            }
            json.addProperty("success", success);
            
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Invalid request parameters.");
        }
        
        response.getWriter().write(json.toString());
    }
}
