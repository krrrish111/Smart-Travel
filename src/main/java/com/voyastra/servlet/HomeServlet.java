package com.voyastra.servlet;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Destination;

import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Plan;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller for the Homepage.
 * Loads featured destinations for the splash section.
 */
@WebServlet(urlPatterns = {"/index", ""}) // Handle root and /index
public class HomeServlet extends HttpServlet {

    private DestinationDAO destinationDAO;
    private PlanDAO planDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        planDAO = new PlanDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Fetch destinations and pick the top 3 as "Featured"
        List<Destination> allDestinations = destinationDAO.getAllDestinations();
        List<Destination> featuredDest = allDestinations.stream()
                .limit(3)
                .collect(Collectors.toList());
        
        // Fetch plans and pick top 6 for the infinite scroll
        List<Plan> allPlans = planDAO.getPlansWithDestinations();
        List<Plan> featuredPlans = allPlans.stream()
                .limit(6)
                .collect(Collectors.toList());
        
        request.setAttribute("featuredDestinations", featuredDest);
        request.setAttribute("featuredPlans", featuredPlans);
        
        // Forward to index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
