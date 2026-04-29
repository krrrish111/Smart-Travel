package com.voyastra.servlet;

import com.voyastra.dao.PostDAO;
import com.voyastra.model.Post;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/community")
public class PostServlet extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    /**
     * Handles adding a new post (Users) and deleting posts (Admin).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        HttpSession session = request.getSession(false);

        if ("add".equals(action)) {
            // Filter ensures user is logged in
            int userId = (Integer) session.getAttribute("user_id");
                String text = request.getParameter("text");
                String imageUrl = request.getParameter("image_url"); // Optional
                String location = request.getParameter("location"); // Optional

                if (text == null || text.trim().isEmpty()) {
                    throw new IllegalArgumentException("Post text cannot be empty.");
                }

                Post newPost = new Post();
                newPost.setUserId(userId);
                newPost.setText(text.trim());
                newPost.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
                newPost.setLocation(location != null ? location.trim() : "");

                boolean success = postDAO.addPost(newPost);
                
                if(success) {
                    response.sendRedirect(request.getContextPath() + "/community");
                } else {
                    response.sendRedirect(request.getContextPath() + "/community?error=postFailed");
                }

        } else if ("delete".equals(action)) {
            // Security Check: Only Admins can delete community posts
            if (session == null || !"admin".equals(session.getAttribute("role"))) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().print("{\"status\":\"error\", \"message\":\"Not authorized\"}");
                return;
            }

            try {
                int postId = Integer.parseInt(request.getParameter("id"));
                boolean success = postDAO.deletePost(postId);
                
                response.setContentType("application/json;charset=UTF-8");
                if (success) {
                    AdminLogger.log(request, "DELETE", "Post", postId, "Deleted community post #" + postId);
                    response.getWriter().print("{\"status\":\"success\", \"message\":\"Post deleted successfully.\"}");
                } else {
                    response.getWriter().print("{\"status\":\"error\", \"message\":\"Failed to delete post.\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().print("{\"status\":\"error\", \"message\":\"Server error executing operation.\"}");
            }
        }
    }

    /**
     * Initializes the community page by fetching all posts to create the feed.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        if ("list".equals(action)) {
            // Filter handles admin check
            try {
                List<Post> posts = postDAO.getAllPosts(); // admin: no per-user hasLiked
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < posts.size(); i++) {
                    Post p = posts.get(i);
                    json.append("{")
                        .append("\"id\":").append(p.getId()).append(",")
                        .append("\"userName\":\"").append(escapeJson(p.getUserName())).append("\",")
                        .append("\"text\":\"").append(escapeJson(p.getText())).append("\",")
                        .append("\"imageUrl\":\"").append(escapeJson(p.getImageUrl())).append("\",")
                        .append("\"location\":\"").append(escapeJson(p.getLocation())).append("\",")
                        .append("\"likeCount\":").append(p.getLikeCount()).append(",")
                        .append("\"createdAt\":\"").append(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "").append("\"")
                        .append("}");
                    if (i < posts.size() - 1) json.append(",");
                }
                json.append("]");
                
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().print(json.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
            
            // Resolve current user for per-user hasLiked state
            HttpSession session = request.getSession(false);
            int currentUserId = 0;
            if (session != null && session.getAttribute("user_id") != null) {
                currentUserId = (Integer) session.getAttribute("user_id");
            }

            // Fetch live community feed with like counts
            List<Post> posts = postDAO.getAllPosts(currentUserId);
            request.setAttribute("posts", posts);
            
            // Dispatch to the JSP view
            request.getRequestDispatcher("/pages/community.jsp").forward(request, response);
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}

