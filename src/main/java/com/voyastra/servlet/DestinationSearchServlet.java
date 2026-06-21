package com.voyastra.servlet;

import com.voyastra.dao.DestinationInsightDAO;
import com.voyastra.model.DestinationInsight;
import com.voyastra.service.GeminiService;
import com.voyastra.service.WikipediaService;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/explore/search")
public class DestinationSearchServlet extends HttpServlet {

    private DestinationInsightDAO insightDAO;
    private WikipediaService wikipediaService;
    private GeminiService geminiService;

    @Override
    public void init() throws ServletException {
        insightDAO = new DestinationInsightDAO();
        wikipediaService = new WikipediaService();
        geminiService = new GeminiService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("{\"error\": \"Query parameter 'q' is missing\"}");
            return;
        }

        String destination = query.trim();
        String sessionId = request.getSession().getId();

        try {
            // 1. Check database cache
            DestinationInsight insight = insightDAO.getInsightByDestination(destination);
            if (insight != null) {
                // Return cached data
                JsonObject responseJson = new JsonObject();
                responseJson.addProperty("destination", insight.getDestination());
                responseJson.addProperty("wiki_summary", insight.getWikiSummary());
                responseJson.addProperty("wiki_url", insight.getWikiUrl());
                responseJson.add("top_attractions", JsonParser.parseString(insight.getTopAttractions()).getAsJsonArray());
                responseJson.add("local_foods", JsonParser.parseString(insight.getLocalFoods()).getAsJsonArray());
                responseJson.addProperty("ai_insights", insight.getAiInsights());
                
                response.getWriter().write(responseJson.toString());
                return;
            }

            // 2. Cache Miss: Fetch from Wikipedia & Gemini
            JsonObject wikiResult = wikipediaService.getSummary(destination);
            String wikiSummary = (wikiResult != null && wikiResult.has("extract")) ? wikiResult.get("extract").getAsString() : "No summary available on Wikipedia.";
            String wikiUrl = (wikiResult != null && wikiResult.has("url")) ? wikiResult.get("url").getAsString() : "https://en.wikipedia.org/wiki/" + destination.replace(" ", "_");

            String aiJsonRaw = geminiService.getDestinationInsights(sessionId, destination);
            JsonObject aiJson = JsonParser.parseString(aiJsonRaw).getAsJsonObject();

            JsonArray topAttractions = aiJson.has("top_attractions") ? aiJson.getAsJsonArray("top_attractions") : new JsonArray();
            JsonArray localFoods = aiJson.has("local_foods") ? aiJson.getAsJsonArray("local_foods") : new JsonArray();
            String aiInsights = aiJson.has("ai_insights") ? aiJson.get("ai_insights").getAsString() : "No custom insights available.";

            // 3. Save to database cache
            DestinationInsight di = new DestinationInsight();
            di.setDestination(destination);
            di.setWikiSummary(wikiSummary);
            di.setWikiUrl(wikiUrl);
            di.setTopAttractions(topAttractions.toString());
            di.setLocalFoods(localFoods.toString());
            di.setAiInsights(aiInsights);
            insightDAO.saveInsight(di);

            // 4. Return response
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("destination", destination);
            responseJson.addProperty("wiki_summary", wikiSummary);
            responseJson.addProperty("wiki_url", wikiUrl);
            responseJson.add("top_attractions", topAttractions);
            responseJson.add("local_foods", localFoods);
            responseJson.addProperty("ai_insights", aiInsights);

            response.getWriter().write(responseJson.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to explore destination insights: " + e.getMessage() + "\"}");
        }
    }
}
