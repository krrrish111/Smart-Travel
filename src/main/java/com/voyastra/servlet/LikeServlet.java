package com.voyastra.servlet;

import com.voyastra.dao.LikeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/like")
public class LikeServlet extends HttpServlet {

    private LikeDAO likeDAO;

    @Override
    public void init() throws ServletException {
        likeDAO = new LikeDAO();
    }

    /**
     * Handles API requests to toggle likes on a post.
     * Expected parameters: postId (int)
     * Responds with JSON indicating current state.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // Set up JSON response format
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Filter ensures userId exists for all /api/like POST requests
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("user_id");

        try {
            String postIdParam = request.getParameter("postId");

            if (postIdParam == null || postIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing postId parameter\"}");
                out.flush();
                return;
            }

            int postId = Integer.parseInt(postIdParam);

            // Toggle logic using Data Access Object
            boolean currentlyLiked = likeDAO.hasUserLiked(postId, userId);
            boolean success;
            boolean newState;

            if (currentlyLiked) {
                // Remove like
                success = likeDAO.removeLike(postId, userId);
                newState = false;
            } else {
                // Add like
                success = likeDAO.addLike(postId, userId);
                newState = true;
            }
            
            int newTotalCount = likeDAO.getLikeCount(postId);

            if (success) {
                // Return success JSON packet
                out.print("{\"status\": \"success\", \"liked\": " + newState + ", \"likeCount\": " + newTotalCount + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Database transaction failed\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid postId format\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Internal server error occurred\"}");
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }
    
    /**
     * Optional GET method to fetch real-time like count for a post without mutating it.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            int count = likeDAO.getLikeCount(postId);
            out.print("{\"postId\": " + postId + ", \"likeCount\": " + count + "}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid request\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}
