package com.voyastra.controller.community;

import com.voyastra.dao.community.SavedPostDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/community/post/save")
public class SavePostServlet extends HttpServlet {

    private SavedPostDAO savedPostDAO;

    @Override
    public void init() throws ServletException {
        savedPostDAO = new SavedPostDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to save posts.\"}");
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
            boolean toggled = savedPostDAO.toggleSave(postId, userId);
            boolean saved = savedPostDAO.isSaved(postId, userId);

            response.getWriter().print("{\"status\":\"success\",\"saved\":" + saved + "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Invalid postId format.\"}");
        }
    }
}
