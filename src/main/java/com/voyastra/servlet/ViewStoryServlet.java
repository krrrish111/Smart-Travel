package com.voyastra.servlet;

import com.voyastra.dao.StoryDAO;
import com.voyastra.dao.StoryViewDAO;
import com.voyastra.model.Story;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/community/story/view")
public class ViewStoryServlet extends HttpServlet {

    private StoryViewDAO storyViewDAO;
    private StoryDAO storyDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        storyViewDAO = new StoryViewDAO();
        storyDAO = new StoryDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\":false}");
            return;
        }

        int viewerId = (Integer) session.getAttribute("user_id");
        try {
            int storyId = Integer.parseInt(request.getParameter("storyId"));
            if (storyViewDAO.recordView(storyId, viewerId)) {
                response.getWriter().print("{\"success\":true}");
            } else {
                response.getWriter().print("{\"success\":false}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\":false}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\":false}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        try {
            int storyId = Integer.parseInt(request.getParameter("storyId"));
            Story story = storyDAO.getStoryById(storyId);
            
            if (story == null || story.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }

            List<String> viewers = storyViewDAO.getViewers(storyId);
            int count = storyViewDAO.getViewCount(storyId);

            String json = "{\"success\":true, \"count\":" + count + ", \"viewers\":" + gson.toJson(viewers) + "}";
            response.getWriter().print(json);
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\":false}");
        }
    }
}
