package com.voyastra.servlet;

import com.voyastra.dao.PostDAO;
import com.voyastra.model.Post;
import com.voyastra.util.AdminLogger;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminCommunityServlet")
public class AdminCommunityServlet extends HttpServlet {
    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("list".equals(action)) {
            List<Post> posts = postDAO.getAllPostsForAdmin();
            response.setContentType("application/json;charset=UTF-8");
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < posts.size(); i++) {
                Post p = posts.get(i);
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"userId\":").append(p.getUserId()).append(",")
                    .append("\"userName\":\"").append(escapeJson(p.getUserName())).append("\",")
                    .append("\"userRole\":\"").append(escapeJson(p.getUserRole())).append("\",")
                    .append("\"content\":\"").append(escapeJson(p.getText())).append("\",")
                    .append("\"imageUrl\":\"").append(escapeJson(p.getImageUrl())).append("\",")
                    .append("\"location\":\"").append(escapeJson(p.getLocation())).append("\",")
                    .append("\"category\":\"").append(escapeJson(p.getCategory())).append("\",")
                    .append("\"hashtags\":\"").append(escapeJson(p.getHashtags())).append("\",")
                    .append("\"createdAt\":\"").append(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "").append("\",")
                    .append("\"likeCount\":").append(p.getLikeCount()).append(",")
                    .append("\"commentCount\":").append(p.getCommentCount()).append(",")
                    .append("\"hidden\":").append(p.isHidden())
                    .append("}");
                if (i < posts.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().print(json.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        String action = request.getParameter("action");
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            if ("toggleVisibility".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                boolean hidden = Boolean.parseBoolean(request.getParameter("hidden"));
                
                boolean success = postDAO.setPostVisibility(postId, hidden);
                if (success) {
                    AdminLogger.log(request, "UPDATE", "Community", postId, "Toggled visibility for post #" + postId + " to hidden=" + hidden);
                    response.getWriter().write("{\"success\":true}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to update visibility\"}");
                }
            } else if ("delete".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                
                boolean success = postDAO.deletePost(postId);
                if (success) {
                    AdminLogger.log(request, "DELETE", "Community", postId, "Deleted post #" + postId);
                    response.getWriter().write("{\"success\":true}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to delete post\"}");
                }
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Unknown action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
