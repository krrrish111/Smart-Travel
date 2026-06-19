package com.voyastra.servlet;

import com.voyastra.service.YouTubeService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/youtube/search")
public class YouTubeServlet extends HttpServlet {
    
    private YouTubeService youtubeService;

    @Override
    public void init() throws ServletException {
        this.youtubeService = new YouTubeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("YouTube Search Started");
        String destination = request.getParameter("destination");
        String queryType = request.getParameter("type"); // e.g., "tourism", "food", "culture"
        String sessionId = request.getSession().getId();
        
        com.voyastra.util.DiagnosticManager.setStatus(sessionId, com.voyastra.model.PlannerStatus.FETCHING_VIDEOS);

        if (destination == null || destination.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing destination parameter\"}");
            return;
        }

        String suffix = queryType != null ? queryType : "travel vlog";
        String jsonResponse = youtubeService.searchDestinationVideos(sessionId, destination, suffix, 3);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
    }
}
