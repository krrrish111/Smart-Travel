package com.voyastra.servlet;

import com.voyastra.dao.CommentDAO;
import com.voyastra.model.Comment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/community/post/comment")
public class CommentServlet extends HttpServlet {

    private CommentDAO commentDAO;

    @Override
    public void init() throws ServletException {
        commentDAO = new CommentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Missing postId parameter.\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            List<Comment> comments = commentDAO.getCommentsByPostId(postId);
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < comments.size(); i++) {
                Comment c = comments.get(i);
                json.append("{")
                    .append("\"id\":").append(c.getId()).append(",")
                    .append("\"postId\":").append(c.getPostId()).append(",")
                    .append("\"userId\":").append(c.getUserId()).append(",")
                    .append("\"userName\":\"").append(escapeJson(c.getUserName())).append("\",")
                    .append("\"text\":\"").append(escapeJson(c.getText())).append("\",")
                    .append("\"createdAt\":\"").append(c.getCreatedAt() != null ? c.getCreatedAt().toString() : "").append("\"")
                    .append("}");
                if (i < comments.size() - 1) json.append(",");
            }
            json.append("]");
            
            response.getWriter().print(json.toString());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Invalid postId format.\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to comment.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String postIdStr = request.getParameter("postId");
        String text = request.getParameter("text");

        if (postIdStr == null || text == null || text.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Missing postId or comment text.\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setUserId(userId);
            comment.setText(text.trim());

            boolean success = commentDAO.addComment(comment);
            if (success) {
                response.getWriter().print("{\"status\":\"success\",\"message\":\"Comment added successfully.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"status\":\"error\",\"message\":\"Failed to save comment.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Invalid postId format.\"}");
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
