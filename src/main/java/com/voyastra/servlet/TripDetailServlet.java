package com.voyastra.servlet;

import com.voyastra.dao.TripDAO;
import com.voyastra.model.PremiumTrip;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/trip")
public class TripDetailServlet extends HttpServlet {
    
    private TripDAO tripDAO;

    @Override
    public void init() throws ServletException {
        tripDAO = new TripDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String slug = request.getParameter("slug");
        String idStr = request.getParameter("id");
        
        PremiumTrip trip = null;
        
        if (slug != null && !slug.trim().isEmpty()) {
            trip = tripDAO.getTripBySlug(slug);
        } else if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                trip = tripDAO.getTripById(Integer.parseInt(idStr));
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
            
            if (trip != null) {
                request.setAttribute("trip", trip);
                request.getRequestDispatcher("/pages/trip-detail.jsp").forward(request, response);
                return;
            }
        
        // Redirect to explore if not found
        response.sendRedirect("explore.jsp");
    }
}
