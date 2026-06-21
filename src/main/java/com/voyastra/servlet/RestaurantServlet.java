package com.voyastra.servlet;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.voyastra.service.NearbySearchService;
import com.voyastra.service.ExperiencesDebugService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/nearby/restaurants")
public class RestaurantServlet extends HttpServlet {

    private NearbySearchService nearbySearchService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.nearbySearchService = new NearbySearchService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String lat = request.getParameter("lat");
        String lng = request.getParameter("lng");
        String sessionId = request.getSession().getId();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        ExperiencesDebugService.log(sessionId, "Restaurants API", "STARTED", "Fetching nearby restaurants", 0);

        if (lat == null || lng == null || lat.trim().isEmpty() || lng.trim().isEmpty()) {
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("error", "Parameters 'lat' and 'lng' are required.");
            ExperiencesDebugService.log(sessionId, "Restaurants API", "FAILED", "Missing coordinates", 0);
            response.getWriter().write(err.toString());
            return;
        }

        long startTime = System.currentTimeMillis();
        JsonArray results = nearbySearchService.getNearbyPlaces(lat, lng, "restaurant", null);
        long duration = System.currentTimeMillis() - startTime;
        
        JsonObject resultObj = new JsonObject();
        resultObj.addProperty("success", true);
        resultObj.add("data", results);

        System.out.println("[RESTAURANTS] Loaded");
        ExperiencesDebugService.log(sessionId, "Restaurants API", "SUCCESS", "Returned " + results.size() + " restaurants", duration);

        response.getWriter().write(resultObj.toString());
    }
}
