package com.voyastra.servlet;

import com.voyastra.dao.StayDAO;
import com.voyastra.model.Stay;
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

@WebServlet("/stays")
public class StayServlet extends HttpServlet {

    private StayDAO stayDAO;

    @Override
    public void init() throws ServletException {
        stayDAO = new StayDAO();
    }

    /**
     * Endpoint to fetch accommodations filtered by geographic string search.
     * Expects: location (String)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String location = request.getParameter("location");

        try {
            List<Stay> results;
            
            if (location != null && !location.trim().isEmpty()) {
                // Return explicitly filtered stays matching the requested general vicinity via SQL LIKE wildcard
                results = stayDAO.getStaysByLocation(location.trim());
                request.setAttribute("searchLocation", location.trim());
            } else {
                // If they visited /stays blindly, pull the recommended catalog
                results = stayDAO.getAllStays();
            }

            if ("json".equals(request.getParameter("format"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                new Gson().toJson(results, response.getWriter());
            } else {
                // Bind the results wrapper to the JSP and dispatch
                request.setAttribute("stays", results);
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking.jsp?error=stayFetchFailed");
        }
    }

    /**
     * Administration module for handling property onboarding and purging.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin-dashboard.jsp";

        // Filter: Admin Verification Only
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            if ("add".equals(action)) {
                Stay s = new Stay();
                s.setType(request.getParameter("type"));
                s.setName(request.getParameter("name"));
                s.setImageUrl(request.getParameter("image_url"));
                s.setBadge(request.getParameter("badge")); 
                s.setLocation(request.getParameter("location"));
                s.setAmenities(request.getParameter("amenities")); // expecting comma separated format
                s.setOriginalPrice(Double.parseDouble(request.getParameter("original_price")));
                s.setDiscountedPrice(Double.parseDouble(request.getParameter("discounted_price")));
                s.setPriceNote(request.getParameter("price_note"));

                stayDAO.addStay(s);
                AdminLogger.log(request, "ADD", "Stay", 0, "Added stay '" + s.getName() + "' in " + s.getLocation());
                response.sendRedirect(redirectUrl + "?stayAdded=true");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                stayDAO.deleteStay(id);
                AdminLogger.log(request, "DELETE", "Stay", id, "Deleted stay #" + id);
                response.sendRedirect(redirectUrl + "?stayDeleted=true");
            } else {
                response.sendRedirect(redirectUrl);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectUrl + "?error=invalidStayData");
        }
    }
}
