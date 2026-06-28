package com.voyastra.controller.community;

import com.voyastra.dao.community.LikeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/community/post/like")
public class LikePostServlet extends HttpServlet {

    private LikeDAO likeDAO;

    @Override
    public void init() throws ServletException {
        likeDAO = new LikeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to like posts.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Missing postId parameter.\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            boolean toggled = likeDAO.toggleLike(postId, userId);
            boolean liked = likeDAO.hasLiked(postId, userId);
            int count = likeDAO.getLikeCount(postId);

            response.getWriter().print("{\"status\":\"success\",\"liked\":" + liked + ",\"likeCount\":" + count + "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Invalid postId format.\"}");
        }
    }
}
