package com.voyastra.controller;

import com.voyastra.dao.StoryDAO;
import com.voyastra.model.Story;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/community/story")
public class StoryServlet extends HttpServlet {

    private StoryDAO storyDAO;

    @Override
    public void init() throws ServletException {
        storyDAO = new StoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        List<Story> stories = storyDAO.getRecentStories();
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < stories.size(); i++) {
            Story s = stories.get(i);
            json.append("{")
                .append("\"id\":").append(s.getId()).append(",")
                .append("\"userId\":").append(s.getUserId()).append(",")
                .append("\"userName\":\"").append(escapeJson(s.getUserName())).append("\",")
                .append("\"mediaUrl\":\"").append(escapeJson(s.getMediaUrl())).append("\",")
                .append("\"createdAt\":\"").append(s.getCreatedAt() != null ? s.getCreatedAt().toString() : "").append("\"")
                .append("}");
            if (i < stories.size() - 1) json.append(",");
        }
        json.append("]");
        response.getWriter().print(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to post a story.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String mediaUrl = request.getParameter("mediaUrl");
        if (mediaUrl == null || mediaUrl.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Missing mediaUrl parameter.\"}");
            return;
        }

        Story story = new Story();
        story.setUserId(userId);
        story.setMediaUrl(mediaUrl.trim());

        boolean success = storyDAO.addStory(story);
        if (success) {
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Story posted successfully.\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Failed to save story.\"}");
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
