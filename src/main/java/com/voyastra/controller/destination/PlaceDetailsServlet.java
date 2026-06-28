package com.voyastra.controller.destination;

import com.google.gson.JsonObject;
import com.voyastra.service.destination.GooglePlacesService;
import com.voyastra.service.ExperiencesDebugService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/places/details")
public class PlaceDetailsServlet extends HttpServlet {

    private GooglePlacesService placesService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.placesService = new GooglePlacesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String placeId = request.getParameter("placeId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String sessionId = request.getSession().getId();

        ExperiencesDebugService.log(sessionId, "Place Details API", "STARTED", "Fetching details for " + placeId, 0);

        if (placeId == null || placeId.trim().isEmpty()) {
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("error", "Query parameter 'placeId' is required.");
            
            ExperiencesDebugService.log(sessionId, "Place Details API", "FAILED", "Query parameter 'placeId' is required.", 0);
            
            response.getWriter().write(err.toString());
            return;
        }

        long startTime = System.currentTimeMillis();
        JsonObject result = placesService.getPlaceDetails(placeId);
        long duration = System.currentTimeMillis() - startTime;
        
        if (result.has("success") && result.get("success").getAsBoolean()) {
            ExperiencesDebugService.log(sessionId, "Place Details API", "SUCCESS", "Returned details for " + result.get("name").getAsString(), duration);
        } else {
            ExperiencesDebugService.log(sessionId, "Place Details API", "FAILED", result.has("error") ? result.get("error").getAsString() : "Unknown error", duration);
        }

        response.getWriter().write(result.toString());
    }
}
