package com.voyastra.controller;

import com.voyastra.dao.ActivityDAO;
import com.voyastra.dao.destination.DestinationDAO;
import com.voyastra.model.Activity;
import com.voyastra.model.destination.Destination;
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

@WebServlet({"/activities", "/admin/api/activities"})
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
        String redirectUrl = request.getContextPath() + "/admin/activities.jsp";

        // Security Authentication Filter: Only Administrators
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

            if ("add".equals(action)) {
                Activity a = new Activity();
                a.setTitle(request.getParameter("title"));
                
                String destIdStr = request.getParameter("destination_id");
                if (destIdStr != null && !destIdStr.isEmpty()) {
                    Destination d = destinationDAO.getDestinationById(Integer.parseInt(destIdStr));
                    if (d != null) {
                        a.setLocation(d.getName());
                    } else {
                        a.setLocation(request.getParameter("location"));
                    }
                } else {
                    a.setLocation(request.getParameter("location"));
                }
                
                a.setHeroImage(request.getParameter("heroImage"));
                a.setDescription(request.getParameter("description"));
                a.setPrice(Double.parseDouble(request.getParameter("price") != null ? request.getParameter("price") : "0"));
                a.setRating(4.5);
                a.setReviewCount(0);

                activityDAO.addActivity(a);
                AdminLogger.log(request, "ADD", "Activity", 0, "Added activity '" + a.getTitle() + "' at " + a.getLocation());
                
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"status\":\"success\"}");

            } else if ("update".equals(action)) {
                Activity a = new Activity();
                a.setId(Integer.parseInt(request.getParameter("id")));
                a.setTitle(request.getParameter("title"));
                
                String destIdStr = request.getParameter("destination_id");
                if (destIdStr != null && !destIdStr.isEmpty()) {
                    Destination d = destinationDAO.getDestinationById(Integer.parseInt(destIdStr));
                    if (d != null) {
                        a.setLocation(d.getName());
                    } else {
                        a.setLocation(request.getParameter("location"));
                    }
                } else {
                    a.setLocation(request.getParameter("location"));
                }
                
                a.setHeroImage(request.getParameter("heroImage"));
                a.setDescription(request.getParameter("description"));
                a.setPrice(Double.parseDouble(request.getParameter("price") != null ? request.getParameter("price") : "0"));
                a.setRating(Double.parseDouble(request.getParameter("rating") != null ? request.getParameter("rating") : "4.5"));
                a.setReviewCount(Integer.parseInt(request.getParameter("reviewCount") != null ? request.getParameter("reviewCount") : "0"));

                activityDAO.updateActivity(a);
                AdminLogger.log(request, "UPDATE", "Activity", a.getId(), "Updated activity '" + a.getTitle() + "'");
                
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"status\":\"success\"}");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                activityDAO.deleteActivity(id);
                AdminLogger.log(request, "DELETE", "Activity", id, "Deleted activity #" + id);
                
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"status\":\"success\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Unknown action\"}");
            }
    }

    /**
     * Fetches destination activities and relays them to the booking UI.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String destinationIdParam = request.getParameter("destinationId");
        
        // Handle admin request
        if ("/admin/api/activities".equals(request.getServletPath())) {
            if ("list".equals(request.getParameter("action"))) {
                HttpSession session = request.getSession(false);
                if (session == null || !"admin".equals(session.getAttribute("role"))) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
                    return;
                }
                List<Activity> allActivities = activityDAO.getAllActivities();
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                new Gson().toJson(allActivities, response.getWriter());
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Unknown action\"}");
            }
            return;
        }
        
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
                
                request.getRequestDispatcher("/pages/booking/booking.jsp").forward(request, response);
            } else {
                // Return default/all activities if no destination specified
                List<Activity> allActivities = activityDAO.getAllActivities();
                
                if ("json".equals(request.getParameter("format"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.setCharacterEncoding("UTF-8");
                    new Gson().toJson(allActivities, response.getWriter());
                } else {
                    request.setAttribute("activities", allActivities);
                    request.getRequestDispatcher("/pages/booking/booking.jsp").forward(request, response);
                }
            }
    }
}

