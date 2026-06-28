package com.voyastra.controller.planner;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/itinerary-details")
public class ItineraryDetailsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Pass any parameters straight through to the JSP
        String city = request.getParameter("city");
        if (city == null || city.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
            return;
        }
        request.setAttribute("city", city);
        
        request.getRequestDispatcher("/pages/planner/itinerary-details.jsp").forward(request, response);
    }
}
