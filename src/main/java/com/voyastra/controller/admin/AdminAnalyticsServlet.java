package com.voyastra.controller.admin;

import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.DashboardDAO;

import com.voyastra.util.PerformanceProfiler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/stats")
public class AdminAnalyticsServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminAnalyticsServlet.class.getName());
    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long tStart = System.currentTimeMillis();
        PerformanceProfiler.start(request.getRequestURI());
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            long tDaoStart = System.currentTimeMillis();
            JsonObject json = dashboardDAO.getDashboardMetrics();
            dashboardDAO.getMonthlyStats(json);
            json.add("topPlans", dashboardDAO.getTopPlans(5));
            json.add("destinationPieChart", dashboardDAO.getDestinationPieChart());
            PerformanceProfiler.record("DAO", System.currentTimeMillis() - tDaoStart);

            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Failed to fetch analytics data");
            response.getWriter().write(error.toString());
            logger.log(Level.SEVERE, "Exception occurred", e);
        } finally {
            PerformanceProfiler.record("Servlet", System.currentTimeMillis() - tStart);
            PerformanceProfiler.log();
        }
    }
}
