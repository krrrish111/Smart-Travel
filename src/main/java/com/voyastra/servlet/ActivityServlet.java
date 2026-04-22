package com.voyastra.servlet;

import com.voyastra.dao.ActivityDAO;
import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Activity;
import com.voyastra.model.Destination;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/activities")
public class ActivityServlet extends HttpServlet {

    private ActivityDAO activityDAO;
    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        activityDAO = new ActivityDAO();
        destinationDAO = new DestinationDAO();
    }

    /**
     * Handles adding, updating, and deleting activities in the system.
     * All operations require an administrative session.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin-dashboard.jsp";

        // Security Authentication Filter: Only Administrators
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

            if ("add".equals(action)) {
                Activity a = new Activity();
                a.setDestinationId(Integer.parseInt(request.getParameter("destination_id")));
                a.setName(request.getParameter("name"));
                a.setImageUrl(request.getParameter("image_url"));
                a.setPrice(Double.parseDouble(request.getParameter("price")));
                // Defaulting new activities to generic rating
                a.setRating(4.5);
                a.setReviewsCount(0);

                activityDAO.addActivity(a);
                AdminLogger.log(request, "ADD", "Activity", 0, "Added activity '" + a.getName() + "' for destination #" + a.getDestinationId());
                response.sendRedirect(redirectUrl + "?activityAdded=true");

            } else if ("update".equals(action)) {
                Activity a = new Activity();
                a.setId(Integer.parseInt(request.getParameter("id")));
                a.setDestinationId(Integer.parseInt(request.getParameter("destination_id")));
                a.setName(request.getParameter("name"));
                a.setImageUrl(request.getParameter("image_url"));
                a.setPrice(Double.parseDouble(request.getParameter("price")));
                a.setRating(Double.parseDouble(request.getParameter("rating")));
                a.setReviewsCount(Integer.parseInt(request.getParameter("reviews_count")));

                activityDAO.updateActivity(a);
                AdminLogger.log(request, "UPDATE", "Activity", a.getId(), "Updated activity '" + a.getName() + "'");
                response.sendRedirect(redirectUrl + "?activityUpdated=true");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                activityDAO.deleteActivity(id);
                AdminLogger.log(request, "DELETE", "Activity", id, "Deleted activity #" + id);
                response.sendRedirect(redirectUrl + "?activityDeleted=true");
            } else {
                response.sendRedirect(redirectUrl);
            }
    }

    /**
     * Fetches destination activities and relays them to the booking UI.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String destinationIdParam = request.getParameter("destinationId");
        
            if (destinationIdParam != null && !destinationIdParam.isEmpty()) {
                // Fetch activities strictly for a specific locale
                int destinationId = Integer.parseInt(destinationIdParam);
                List<Activity> localActivities = activityDAO.getActivitiesByDestination(destinationId);
                
                // Fetch destination name for title context
                Destination dest = destinationDAO.getDestinationById(destinationId);
                if (dest != null) {
                    request.setAttribute("destinationName", dest.getName());
                }
                
                request.setAttribute("activities", localActivities);
                request.setAttribute("selectedDestinationId", destinationId);
                
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            } else {
                // Return default/all activities if no destination specified
                List<Activity> allActivities = activityDAO.getAllActivities();
                
                if ("json".equals(request.getParameter("format"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.setCharacterEncoding("UTF-8");
                    new Gson().toJson(allActivities, response.getWriter());
                } else {
                    request.setAttribute("activities", allActivities);
                    request.getRequestDispatcher("/booking.jsp").forward(request, response);
                }
            }
    }
}

