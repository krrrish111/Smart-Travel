package com.voyastra.servlet;

import com.voyastra.dao.StoryDAO;
import com.voyastra.model.Story;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/community/story/list")
public class StoriesServlet extends HttpServlet {

    private StoryDAO storyDAO;

    @Override
    public void init() throws ServletException {
        storyDAO = new StoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("Story API Hit");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<StoryDAO.StoryGroup> groupedStories = storyDAO.getGroupedStories();
            
            StringBuilder json = new StringBuilder("[");
            for (int g = 0; g < groupedStories.size(); g++) {
                StoryDAO.StoryGroup group = groupedStories.get(g);
                json.append("{")
                    .append("\"userId\":").append(group.getUserId()).append(",")
                    .append("\"username\":\"").append(escapeJson(group.getUsername())).append("\",")
                    .append("\"stories\":[");
                
                List<Story> stories = group.getStories();
                for (int i = 0; i < stories.size(); i++) {
                    Story s = stories.get(i);
                    json.append("{")
                        .append("\"id\":").append(s.getId()).append(",")
                        .append("\"userId\":").append(s.getUserId()).append(",")
                        .append("\"userName\":\"").append(escapeJson(s.getUserName())).append("\",")
                        .append("\"mediaUrl\":\"").append(escapeJson(s.getMediaUrl())).append("\",")
                        .append("\"mediaType\":\"").append(escapeJson(s.getMediaType())).append("\",")
                        .append("\"caption\":\"").append(escapeJson(s.getCaption())).append("\",")
                        .append("\"location\":\"").append(escapeJson(s.getLocation())).append("\",")
                        .append("\"createdAt\":\"").append(s.getCreatedAt() != null ? s.getCreatedAt().toString() : "").append("\",")
                        .append("\"expiresAt\":\"").append(s.getExpiresAt() != null ? s.getExpiresAt().toString() : "").append("\"")
                        .append("}");
                    if (i < stories.size() - 1) json.append(",");
                }
                json.append("]}");
                if (g < groupedStories.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
