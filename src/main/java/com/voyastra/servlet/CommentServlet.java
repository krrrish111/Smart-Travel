package com.voyastra.servlet;

import com.google.gson.Gson;
import com.voyastra.dao.CommentDAO;
import com.voyastra.model.Comment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {
    
    private CommentDAO commentDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        commentDAO = new CommentDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String postIdStr = request.getParameter("postId");
        if (postIdStr != null && !postIdStr.trim().isEmpty()) {
            try {
                int postId = Integer.parseInt(postIdStr);
                List<Comment> comments = commentDAO.getCommentsByPostId(postId);
                out.print(gson.toJson(comments));
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Invalid post ID\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Post ID required\"}");
        }
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int commentId = Integer.parseInt(request.getParameter("commentId"));
                boolean success = commentDAO.deleteComment(commentId, userId);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", success);
                out.print(gson.toJson(result));
            } else {
                // Add new comment
                int postId = Integer.parseInt(request.getParameter("postId"));
                String text = request.getParameter("text");
                
                if (text == null || text.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Comment text cannot be empty\"}");
                    return;
                }

                Comment comment = new Comment();
                comment.setPostId(postId);
                comment.setUserId(userId);
                comment.setText(text.trim());
                
                boolean success = commentDAO.addComment(comment);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", success);
                out.print(gson.toJson(result));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid parameters\"}");
        }
        out.flush();
    }
}
