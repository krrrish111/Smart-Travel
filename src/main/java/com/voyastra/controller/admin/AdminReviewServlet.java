package com.voyastra.controller.admin;

import com.voyastra.dao.review.ReviewDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.model.review.Review;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.google.gson.Gson;

@WebServlet("/AdminReviewServlet")
public class AdminReviewServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminReviewServlet.class.getName());
    private ReviewDAO reviewDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // Auth Check: Admin only
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if ("list".equals(action)) {
            try {
                List<Review> list = reviewDAO.getAllReviews();
                
                // Map to a more JSON-friendly structure for the JS data table
                List<Map<String, Object>> mappedResults = list.stream().map(r -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", r.getId());
                    map.put("type", r.getType());
                    map.put("userName", r.getUserName());
                    map.put("location", r.getDestinationName() != null ? r.getDestinationName() : "Unknown");
                    map.put("rating", r.getRating());
                    map.put("comment", r.getComment());
                    map.put("createdAt", r.getCreatedAt() != null ? r.getCreatedAt().toString() : "");
                    map.put("status", r.getStatus() != null ? r.getStatus() : "Approved"); 
                    return map;
                }).collect(Collectors.toList());
                
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                gson.toJson(mappedResults, response.getWriter());

            } catch (Exception e) {
                logger.log(Level.SEVERE, "Exception occurred", e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String type = request.getParameter("type");
                
                boolean success = reviewDAO.deleteReview(id, type);
                
                Map<String, String> res = new HashMap<>();
                if(success) {
                    AdminLogger.log(request, "DELETE", "Review", id, "Deleted review #" + id + " type " + type);
                    res.put("status", "success");
                    res.put("message", "Review deleted successfully.");
                } else {
                    res.put("status", "error");
                    res.put("message", "Failed to delete review.");
                }
                
                response.setContentType("application/json;charset=UTF-8");
                gson.toJson(res, response.getWriter());

            } catch (Exception e) {
                logger.log(Level.SEVERE, "Exception occurred", e);
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error executing operation.\"}");
            }
        } else if ("status".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String type = request.getParameter("type");
                String status = request.getParameter("status");
                
                boolean success = reviewDAO.updateReviewStatus(id, type, status);
                
                Map<String, String> res = new HashMap<>();
                if(success) {
                    AdminLogger.log(request, "UPDATE", "Review", id, "Updated review #" + id + " to " + status);
                    res.put("status", "success");
                    res.put("message", "Review status updated successfully.");
                } else {
                    res.put("status", "error");
                    res.put("message", "Failed to update review status.");
                }
                
                response.setContentType("application/json;charset=UTF-8");
                gson.toJson(res, response.getWriter());

            } catch (Exception e) {
                logger.log(Level.SEVERE, "Exception occurred", e);
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error executing operation.\"}");
            }
        }
    }
}
