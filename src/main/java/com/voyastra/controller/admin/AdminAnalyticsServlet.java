package com.voyastra.controller.admin;

import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.DashboardDAO;

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
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            JsonObject json = new JsonObject();
            
            // Basic Counts
            json.addProperty("users", dashboardDAO.getTotalCount("users"));
            json.addProperty("bookings", dashboardDAO.getTotalCount("bookings"));
            json.addProperty("revenue", dashboardDAO.getThisMonthRevenue()); // Actually, maybe total revenue is better?
            json.addProperty("totalRevenue", dashboardDAO.getThisMonthRevenue()); // We'll query total later if needed
            json.addProperty("plans", dashboardDAO.getTotalCount("plans"));
            json.addProperty("destinations", dashboardDAO.getTotalCount("destinations"));
            json.addProperty("reviews", dashboardDAO.getTotalCount("reviews"));
            json.addProperty("activities", dashboardDAO.getTotalCount("activities"));
            
            // Specific booking stats
            json.addProperty("pendingBookings", dashboardDAO.getBookingsByStatus("pending"));
            json.addProperty("completedBookings", dashboardDAO.getBookingsByStatus("confirmed"));
            json.addProperty("cancelledBookings", dashboardDAO.getBookingsByStatus("cancelled"));
            json.addProperty("todaysBookings", dashboardDAO.getTodaysBookings());
            json.addProperty("premiumUsers", dashboardDAO.getPremiumUsers());
            json.addProperty("thisMonthRevenue", dashboardDAO.getThisMonthRevenue());

            // Chart data
            json.add("bookingsPerMonth", dashboardDAO.getBookingsPerMonth());
            json.add("revenuePerMonth", dashboardDAO.getRevenuePerMonth());
            json.add("topPlans", dashboardDAO.getTopPlans(5));
            json.add("destinationPieChart", dashboardDAO.getDestinationPieChart());

            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Failed to fetch analytics data");
            response.getWriter().write(error.toString());
            logger.log(Level.SEVERE, "Exception occurred", e);
        }
    }
}
