package com.voyastra.controller.destination;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.voyastra.dao.destination.SavedTripDAO;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * POST /api/destination/save
 *
 * Parameters:
 *   destinationId – integer ID of the destination
 *
 * Returns JSON:
 *   { "success": true,  "alreadySaved": false }   → first time saved
 *   { "success": true,  "alreadySaved": true  }   → was already in wishlist
 *   { "success": false, "message": "..." }         → error
 *
 * Auth: session attribute "user" (com.voyastra.model.profile.User) must exist.
 */
public class SaveTripServlet extends HttpServlet {

    private SavedTripDAO savedTripDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        savedTripDAO = new SavedTripDAO();
        gson = new Gson();
        // Create table if it doesn't exist (idempotent, safe to call every startup)
        savedTripDAO.ensureTableExists();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Auth check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(error("Please log in to save trips."));
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // 2. Parameter validation
        String destIdParam = request.getParameter("destinationId");
        if (destIdParam == null || destIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(error("Missing destinationId."));
            return;
        }

        int destinationId;
        try {
            destinationId = Integer.parseInt(destIdParam.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(error("Invalid destinationId."));
            return;
        }

        // 3. Check if already saved
        boolean alreadySaved = savedTripDAO.isSaved(userId, destinationId);

        // 4. Persist (INSERT IGNORE — safe on duplicate)
        savedTripDAO.saveTrip(userId, destinationId);

        // 5. Return success
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.addProperty("alreadySaved", alreadySaved);
        result.addProperty("message", alreadySaved ? "Already in your wishlist." : "Trip saved to your wishlist!");
        out.print(gson.toJson(result));
    }

    private String error(String msg) {
        JsonObject o = new JsonObject();
        o.addProperty("success", false);
        o.addProperty("message", msg);
        return gson.toJson(o);
    }
}
