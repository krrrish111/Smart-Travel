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

@WebServlet("/api/nearby/experiences")
public class ExperienceServlet extends HttpServlet {

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

        ExperiencesDebugService.log(sessionId, "Experiences API", "STARTED", "Fetching nearby experiences", 0);

        if (lat == null || lng == null || lat.trim().isEmpty() || lng.trim().isEmpty()) {
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("error", "Parameters 'lat' and 'lng' are required.");
            ExperiencesDebugService.log(sessionId, "Experiences API", "FAILED", "Missing coordinates", 0);
            response.getWriter().write(err.toString());
            return;
        }

        long startTime = System.currentTimeMillis();
        // Fallback to amusement_park and activities keyword
        JsonArray results = nearbySearchService.getNearbyPlaces(lat, lng, "amusement_park", "activities");
        if (results.size() == 0) {
            results = nearbySearchService.getNearbyPlaces(lat, lng, null, "experiences");
        }
        long duration = System.currentTimeMillis() - startTime;
        
        JsonObject resultObj = new JsonObject();
        resultObj.addProperty("success", true);
        resultObj.add("data", results);

        System.out.println("[EXPERIENCES] Loaded");
        ExperiencesDebugService.log(sessionId, "Experiences API", "SUCCESS", "Returned " + results.size() + " experiences", duration);

        response.getWriter().write(resultObj.toString());
    }
}
