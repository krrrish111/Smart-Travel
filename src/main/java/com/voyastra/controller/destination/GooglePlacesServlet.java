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

@WebServlet("/api/places/autocomplete")
public class GooglePlacesServlet extends HttpServlet {

    private GooglePlacesService placesService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.placesService = new GooglePlacesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String sessionId = request.getSession().getId();

        // Log starting
        ExperiencesDebugService.log(sessionId, "Places API", "STARTED", "Fetching autocomplete for " + query, 0);

        if (query == null || query.trim().isEmpty()) {
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("error", "Query parameter 'q' is required.");
            
            ExperiencesDebugService.log(sessionId, "Places API", "FAILED", "Query parameter 'q' is required.", 0);
            
            response.getWriter().write(err.toString());
            return;
        }

        long startTime = System.currentTimeMillis();
        JsonObject result = placesService.getAutocompleteSuggestions(query);
        long duration = System.currentTimeMillis() - startTime;
        
        if (result.has("success") && result.get("success").getAsBoolean()) {
            ExperiencesDebugService.log(sessionId, "Places API", "SUCCESS", "Returned " + result.getAsJsonArray("predictions").size() + " suggestions", duration);
        } else {
            ExperiencesDebugService.log(sessionId, "Places API", "FAILED", result.has("error") ? result.get("error").getAsString() : "Unknown error", duration);
        }

        response.getWriter().write(result.toString());
    }
}
