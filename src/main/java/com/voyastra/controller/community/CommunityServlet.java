package com.voyastra.controller.community;

import com.voyastra.dao.community.PostDAO;
import com.voyastra.dao.community.FollowDAO;
import com.voyastra.dao.StoryDAO;
import com.voyastra.model.community.Post;
import com.voyastra.model.Story;
import com.voyastra.config.ConfigManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/community")
public class CommunityServlet extends HttpServlet {

    private PostDAO postDAO;
    private FollowDAO followDAO;
    private StoryDAO storyDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
        followDAO = new FollowDAO();
        storyDAO = new StoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int currentUserId = 0;
        if (session != null && session.getAttribute("user_id") != null) {
            currentUserId = (Integer) session.getAttribute("user_id");
        }

        String action = request.getParameter("action");
        if ("feed".equals(action)) {
            // AJAX request for feed items
            String category = request.getParameter("category");
            int offset = 0;
            int limit = 5;
            try {
                if (request.getParameter("offset") != null) {
                    offset = Integer.parseInt(request.getParameter("offset"));
                }
                if (request.getParameter("limit") != null) {
                    limit = Integer.parseInt(request.getParameter("limit"));
                }
            } catch (NumberFormatException e) {
                // Keep default
            }

            List<Post> posts = postDAO.getFeedPosts(currentUserId, category, offset, limit);
            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < posts.size(); i++) {
                Post p = posts.get(i);
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"userId\":").append(p.getUserId()).append(",")
                    .append("\"userName\":\"").append(escapeJson(p.getUserName())).append("\",")
                    .append("\"userRole\":\"").append(escapeJson(p.getUserRole())).append("\",")
                    .append("\"text\":\"").append(escapeJson(p.getText())).append("\",")
                    .append("\"imageUrl\":\"").append(escapeJson(p.getImageUrl())).append("\",")
                    .append("\"location\":\"").append(escapeJson(p.getLocation())).append("\",")
                    .append("\"category\":\"").append(escapeJson(p.getCategory())).append("\",")
                    .append("\"hashtags\":\"").append(escapeJson(p.getHashtags())).append("\",")
                    .append("\"rating\":").append(p.getRating() != null ? p.getRating() : "null").append(",")
                    .append("\"createdAt\":\"").append(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "").append("\",")
                    .append("\"likeCount\":").append(p.getLikeCount()).append(",")
                    .append("\"commentCount\":").append(p.getCommentCount()).append(",")
                    .append("\"hasLiked\":").append(p.isHasLiked()).append(",")
                    .append("\"hasSaved\":").append(p.isHasSaved()).append(",")
                    .append("\"followingCreator\":").append(p.isFollowingCreator())
                    .append("}");
                if (i < posts.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().print(json.toString());
            return;
        } else if ("my_posts".equals(action)) {
            // AJAX request for Profile page My Posts
            String filter = request.getParameter("filter");
            String search = request.getParameter("search");
            
            List<Post> posts = postDAO.getUserPosts(currentUserId, currentUserId, filter, search);
            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < posts.size(); i++) {
                Post p = posts.get(i);
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"userId\":").append(p.getUserId()).append(",")
                    .append("\"userName\":\"").append(escapeJson(p.getUserName())).append("\",")
                    .append("\"userRole\":\"").append(escapeJson(p.getUserRole())).append("\",")
                    .append("\"text\":\"").append(escapeJson(p.getText())).append("\",")
                    .append("\"imageUrl\":\"").append(escapeJson(p.getImageUrl())).append("\",")
                    .append("\"location\":\"").append(escapeJson(p.getLocation())).append("\",")
                    .append("\"category\":\"").append(escapeJson(p.getCategory())).append("\",")
                    .append("\"hashtags\":\"").append(escapeJson(p.getHashtags())).append("\",")
                    .append("\"rating\":").append(p.getRating() != null ? p.getRating() : "null").append(",")
                    .append("\"createdAt\":\"").append(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "").append("\",")
                    .append("\"likeCount\":").append(p.getLikeCount()).append(",")
                    .append("\"commentCount\":").append(p.getCommentCount()).append(",")
                    .append("\"hasLiked\":").append(p.isHasLiked()).append(",")
                    .append("\"hasSaved\":").append(p.isHasSaved()).append(",")
                    .append("\"followingCreator\":").append(p.isFollowingCreator())
                    .append("}");
                if (i < posts.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().print(json.toString());
            return;
        } else if ("stories".equals(action)) {
            List<Story> stories = storyDAO.getRecentStories();
            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder("[");
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
            json.append("]");
            response.getWriter().print(json.toString());
            return;
        }

        // Standard GET: Set up sidebar widgets and stories
        List<Story> stories = storyDAO.getRecentStories();
        List<FollowDAO.Explorer> topExplorers = followDAO.getTopExplorers(currentUserId, 5);

        request.setAttribute("stories", stories);
        request.setAttribute("topExplorers", topExplorers);
        request.setAttribute("googlePlacesApiKey", ConfigManager.get("GOOGLE_PLACES_API_KEY"));

        request.getRequestDispatcher("/pages/community/community.jsp").forward(request, response);
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
