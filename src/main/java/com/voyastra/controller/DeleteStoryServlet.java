package com.voyastra.controller;

import com.voyastra.dao.StoryDAO;
import com.voyastra.model.Story;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

@WebServlet("/community/story/delete")
public class DeleteStoryServlet extends HttpServlet {

    private StoryDAO storyDAO;

    @Override
    public void init() throws ServletException {
        storyDAO = new StoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        try {
            int storyId = Integer.parseInt(request.getParameter("storyId"));
            
            // Verify ownership
            Story story = storyDAO.getStoryById(storyId);
            if (story == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().print("{\"success\":false,\"message\":\"Story not found\"}");
                return;
            }

            if (story.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"success\":false,\"message\":\"Not authorized\"}");
                return;
            }

            // Delete from DB
            if (storyDAO.deleteStory(storyId, userId)) {
                // Delete file from storage
                String mediaUrl = story.getMediaUrl();
                if (mediaUrl != null && mediaUrl.startsWith(request.getContextPath())) {
                    String relativePath = mediaUrl.substring(request.getContextPath().length());
                    String absolutePath = getServletContext().getRealPath("") + relativePath;
                    File file = new File(absolutePath);
                    if (file.exists()) {
                        file.delete();
                    }
                }
                response.getWriter().print("{\"success\":true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"success\":false,\"message\":\"Could not delete from database\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\":false,\"message\":\"Invalid request\"}");
        }
    }
}
