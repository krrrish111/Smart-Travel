package com.voyastra.controller;

import com.voyastra.service.UnsplashService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/unsplash/search")
public class UnsplashServlet extends HttpServlet {
    
    private UnsplashService unsplashService;

    @Override
    public void init() throws ServletException {
        this.unsplashService = new UnsplashService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Unsplash Search Started");
        String destination = request.getParameter("destination");
        String category = request.getParameter("category"); // e.g., "landscape", "food"
        String sessionId = request.getSession().getId();
        
        com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.planner.PlannerStatus.FETCHING_IMAGES);

        if (destination == null || destination.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing destination parameter\"}");
            return;
        }

        String queryCat = category != null ? category : "tourism";
        String jsonResponse = unsplashService.searchDestinationImages(sessionId, destination, queryCat, 5);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
    }
}
