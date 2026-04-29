package com.voyastra.servlet;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Destination;
import com.voyastra.model.Plan;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller for the Explore page.
 * Loads all available destinations and travel plans from the database.
 */
@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {

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
        
        // Fetch all destinations and plans
        List<Destination> destinations = destinationDAO.getAllDestinations();
        List<Plan> plans = planDAO.getPlansWithDestinations();
        
        // Set as request attributes
        request.setAttribute("destinations", destinations);
        request.setAttribute("plans", plans);
        
        // Forward to explore.jsp
        request.getRequestDispatcher("/pages/explore.jsp").forward(request, response);
    }
}
