package com.voyastra.servlet;

import com.google.gson.JsonObject;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.DestinationDAO;
import com.voyastra.dao.PlanDAO;
import com.voyastra.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for providing dashboard-wide analytics as JSON.
 * Accessible only by administrators (enforced by SecurityFilter).
 */
@WebServlet("/admin/stats")
public class AdminAnalyticsServlet extends HttpServlet {

    private UserDAO userDAO;
    private BookingDAO bookingDAO;
    private PlanDAO planDAO;
    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        bookingDAO = new BookingDAO();
        planDAO = new PlanDAO();
        destinationDAO = new DestinationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int totalUsers = userDAO.getTotalUserCount();
            int totalBookings = bookingDAO.getTotalBookingCount();
            double totalRevenue = bookingDAO.getTotalRevenue();
            int totalPlans = planDAO.getTotalPlanCount();
            int totalDestinations = destinationDAO.getTotalDestinationCount();

            JsonObject json = new JsonObject();
            json.addProperty("users", totalUsers);
            json.addProperty("bookings", totalBookings);
            json.addProperty("revenue", totalRevenue);
            json.addProperty("plans", totalPlans);
            json.addProperty("destinations", totalDestinations);

            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Failed to fetch analytics data");
            response.getWriter().write(error.toString());
            e.printStackTrace();
        }
    }
}

