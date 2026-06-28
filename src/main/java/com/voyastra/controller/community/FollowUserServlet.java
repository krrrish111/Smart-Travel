package com.voyastra.controller.community;

import com.voyastra.dao.community.FollowDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/community/user/follow")
public class FollowUserServlet extends HttpServlet {

    private FollowDAO followDAO;

    @Override
    public void init() throws ServletException {
        followDAO = new FollowDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to follow creators.\"}");
            return;
        }

        int followerId = (Integer) session.getAttribute("user_id");
        String creatorIdStr = request.getParameter("creatorId");
        if (creatorIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Missing creatorId parameter.\"}");
            return;
        }

        try {
            int followedId = Integer.parseInt(creatorIdStr);
            if (followerId == followedId) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"status\":\"error\",\"message\":\"You cannot follow yourself.\"}");
                return;
            }

            boolean toggled = followDAO.toggleFollow(followerId, followedId);
            boolean following = followDAO.isFollowing(followerId, followedId);

            response.getWriter().print("{\"status\":\"success\",\"following\":" + following + "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Invalid creatorId format.\"}");
        }
    }
}
