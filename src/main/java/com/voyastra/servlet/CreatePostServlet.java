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

@WebServlet("/community/post/create")
public class CreatePostServlet extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to create a post.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String text = request.getParameter("text");
        String location = request.getParameter("location");
        String imageUrl = request.getParameter("image_url");
        String category = request.getParameter("category");
        String hashtags = request.getParameter("hashtags");

        if (text == null || text.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Post content cannot be empty.\"}");
            return;
        }

        Post post = new Post();
        post.setUserId(userId);
        post.setText(text.trim());
        post.setLocation(location != null ? location.trim() : "");
        post.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        post.setCategory(category != null ? category.trim() : "For You");
        post.setHashtags(hashtags != null ? hashtags.trim() : "");

        boolean success = postDAO.addPost(post);
        if (success) {
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Post created successfully!\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Failed to create post in database.\"}");
        }
    }
}
