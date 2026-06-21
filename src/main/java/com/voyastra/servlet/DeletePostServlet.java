package com.voyastra.servlet;

import com.voyastra.dao.PostDAO;
import com.voyastra.model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/community/post/delete")
public class DeletePostServlet extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        // 1. Auth check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please log in to delete posts.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String roleStr = (String) session.getAttribute("role");
        boolean isAdmin = "admin".equalsIgnoreCase(roleStr);

        // 2. Validate postId parameter
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Missing postId parameter.\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);

            // 3. Fetch the post to verify ownership
            Post post = postDAO.getPostById(postId);
            if (post == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().print("{\"status\":\"error\",\"message\":\"Post not found.\"}");
                return;
            }

            // 4. Permission check: owner or admin
            if (post.getUserId() != userId && !isAdmin) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"status\":\"error\",\"message\":\"You are not authorized to delete this post.\"}");
                return;
            }

            // 5. Delete from DB
            boolean deleted = postDAO.deletePost(postId);
            if (deleted) {
                response.getWriter().print("{\"status\":\"success\",\"message\":\"Post deleted successfully.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"status\":\"error\",\"message\":\"Unable to delete post.\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Invalid postId format.\"}");
        } catch (Exception e) {
            System.err.println("ERROR: DeletePostServlet failed.");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"An unexpected error occurred.\"}");
        }
    }
}
