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
        
        if (slug != null && !slug.trim().isEmpty()) {
            PremiumTrip trip = tripDAO.getTripBySlug(slug);
            
            if (trip != null) {
                request.setAttribute("trip", trip);
                request.getRequestDispatcher("/trip-detail.jsp").forward(request, response);
                return;
            }
        }
        
        // Redirect to explore if not found
        response.sendRedirect("explore.jsp");
    }
}
