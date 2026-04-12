package com.voyastra.servlet;

import com.voyastra.dao.PlanDAO;
import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Plan;
import com.voyastra.model.Destination;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private PlanDAO planDAO;
    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        planDAO = new PlanDAO();
        destinationDAO = new DestinationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("q");
        String mode    = request.getParameter("mode"); // "suggest" triggers JSON mode

        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp?noQuery=true");
            return;
        }
        
        // Add length validation for performance/security
        if (keyword.length() > 100) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp?error=queryTooLong");
            return;
        }

        String searchTrimmed = keyword.trim();

        // ── AUTOCOMPLETE / SUGGEST mode ──────────────────────────────────────
        if ("suggest".equals(mode)) {
            serveSuggestions(request, response, searchTrimmed);
            return;
        }

        // ── FULL SEARCH mode ─────────────────────────────────────────────────
        try {
            List<Plan> planResults = planDAO.searchPlans(searchTrimmed);
            List<Destination> destResults = destinationDAO.searchDestinations(searchTrimmed);

            request.setAttribute("searchQuery", searchTrimmed);
            request.setAttribute("planResults", planResults);
            request.setAttribute("destResults", destResults);
            request.setAttribute("resultCount", planResults.size() + destResults.size());

            request.getRequestDispatcher("/explore.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/explore.jsp?error=searchFailed");
        }
    }

    private void serveSuggestions(HttpServletRequest request,
                                  HttpServletResponse response,
                                  String keyword) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Simple suggestion logic: take top 4 plans and top 4 destinations
        List<String> planSuggestions = planDAO.searchPlans(keyword).stream()
                .map(Plan::getTitle)
                .limit(4)
                .collect(Collectors.toList());
        
        List<String> destSuggestions = destinationDAO.searchDestinations(keyword).stream()
                .map(Destination::getName)
                .limit(4)
                .collect(Collectors.toList());

        planSuggestions.addAll(destSuggestions);
        
        new Gson().toJson(planSuggestions, response.getWriter());
    }
}
