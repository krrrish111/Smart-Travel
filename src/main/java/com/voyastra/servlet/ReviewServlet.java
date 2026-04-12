package com.voyastra.servlet;

import com.voyastra.dao.ReviewDAO;
import com.voyastra.model.Review;
import com.voyastra.util.AdminLogger;

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
import java.util.stream.Collectors;
import com.google.gson.Gson;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    /**
     * Handles adding (by User) and deleting (by Admin) reviews.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        HttpSession session = request.getSession(false);

        if ("add".equals(action)) {
            // Filter ensures user is logged in for add action
            try {
                int userId = (Integer) session.getAttribute("user_id");
                String destIdStr = request.getParameter("destination_id");
                String ratingStr = request.getParameter("rating");
                String comment = request.getParameter("comment");

                if (destIdStr == null || destIdStr.isEmpty() || ratingStr == null || ratingStr.isEmpty()) {
                    session.setAttribute("errorMsg", "Invalid review submission.");
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    return;
                }

                int destinationId = Integer.parseInt(destIdStr);
                int rating = Integer.parseInt(ratingStr);

                // 1. Validate Rating Range (1-5)
                if (rating < 1 || rating > 5) {
                    session.setAttribute("errorMsg", "Rating must be between 1 and 5 stars.");
                    response.sendRedirect(request.getContextPath() + "/destination?id=" + destinationId);
                    return;
                }
                
                // 2. Validate Comment Length (max 500)
                if (comment != null && comment.trim().length() > 500) {
                    session.setAttribute("errorMsg", "Comment is too long (max 500 characters).");
                    response.sendRedirect(request.getContextPath() + "/destination?id=" + destinationId);
                    return;
                }

                Review rv = new Review();
                rv.setUserId(userId);
                rv.setDestinationId(destinationId);
                rv.setRating(rating);
                rv.setComment(comment != null ? comment.trim() : "");

                // Add to database
                reviewDAO.addReview(rv);

                // Redirect back to the destination page
                response.sendRedirect(request.getContextPath() + "/destination?id=" + destinationId + "&reviewed=true");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=reviewFailed");
            }

        } else if ("delete".equals(action)) {
            // Filter handles admin check for delete/list implicitly or we keep it here for double-layered protection
            try {
                int reviewId = Integer.parseInt(request.getParameter("id"));
                boolean success = reviewDAO.deleteReview(reviewId);
                
                Map<String, String> res = new HashMap<>();
                if(success) {
                    AdminLogger.log(request, "DELETE", "Review", reviewId, "Deleted review #" + reviewId);
                    res.put("status", "success");
                    res.put("message", "Review deleted successfully.");
                } else {
                    res.put("status", "error");
                    res.put("message", "Failed to delete review.");
                }
                
                response.setContentType("application/json");
                gson.toJson(res, response.getWriter());

            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error executing operation.\"}");
            }
        } else if ("list".equals(action)) {
            // 3. Auth Check: Admin only
            if (session == null || !"admin".equals(session.getAttribute("role"))) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            try {
                List<Review> list = reviewDAO.getAllReviews();
                
                // Map to a more JSON-friendly structure for the JS data table
                List<Map<String, Object>> mappedResults = list.stream().map(r -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", r.getId());
                    map.put("userName", r.getUserName());
                    map.put("location", r.getDestinationName() != null ? r.getDestinationName() : "Unknown (" + r.getDestinationId() + ")");
                    map.put("rating", r.getRating());
                    map.put("comment", r.getComment());
                    map.put("createdAt", r.getCreatedAt() != null ? r.getCreatedAt().toString() : "");
                    map.put("approved", true); // All in DB are considered active
                    return map;
                }).collect(Collectors.toList());
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                gson.toJson(mappedResults, response.getWriter());

            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }

    /**
     * Handles fetching reviews for a specific destination via GET
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String destIdParam = request.getParameter("destination_id");
        if (destIdParam != null && !destIdParam.trim().isEmpty()) {
            try {
                int destinationId = Integer.parseInt(destIdParam);
                
                // Instead of rendering directly, redirect to the new DestinationDetailsServlet
                response.sendRedirect(request.getContextPath() + "/destination?id=" + destinationId);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/explore.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
        }
    }
}
