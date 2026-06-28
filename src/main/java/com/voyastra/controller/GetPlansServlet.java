package com.voyastra.controller;

import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Plan;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "GetPlansServlet", urlPatterns = {"/getPlans"})
public class GetPlansServlet extends HttpServlet {

    private PlanDAO planDAO;

    @Override
    public void init() throws ServletException {
        planDAO = new PlanDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Fetch all plans and destinations
        List<Plan> plans = planDAO.getPlansWithDestinations();
        List<com.voyastra.model.destination.Destination> destinations = new com.voyastra.dao.destination.DestinationDAO().getAllDestinations();

        // Store data in list as a request attribute
        request.setAttribute("plans", plans);
        request.setAttribute("destinations", destinations);

        // Send to explore.jsp
        request.getRequestDispatcher("/pages/common/explore.jsp").forward(request, response);
    }
}
