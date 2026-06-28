package com.voyastra.controller;

import com.voyastra.model.profile.User;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/budget")
public class FinancialDashboardServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(FinancialDashboardServlet.class.getName());


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try (Connection conn = DBConnection.getConnection()) {
            // Check if user has an active budget plan
            Map<String, Object> budgetPlan = null;
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM budget_plans WHERE user_id = ? ORDER BY created_at DESC LIMIT 1")) {
                stmt.setInt(1, user.getId());
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    budgetPlan = new HashMap<>();
                    budgetPlan.put("id", rs.getInt("id"));
                    budgetPlan.put("destination", rs.getString("destination"));
                    budgetPlan.put("total_budget", rs.getDouble("total_budget"));
                    budgetPlan.put("flights", rs.getDouble("flights"));
                    budgetPlan.put("hotel", rs.getDouble("hotel"));
                    budgetPlan.put("food", rs.getDouble("food"));
                    budgetPlan.put("activities", rs.getDouble("activities"));
                    budgetPlan.put("transportation", rs.getDouble("transportation"));
                    budgetPlan.put("emergency", rs.getDouble("emergency"));
                    budgetPlan.put("health_score", rs.getInt("health_score"));
                }
            }

            if (budgetPlan != null) {
                request.setAttribute("budgetPlan", budgetPlan);

                // Fetch predictions
                try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM trip_cost_predictions WHERE budget_plan_id = ?")) {
                    stmt.setInt(1, (int) budgetPlan.get("id"));
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        Map<String, Object> prediction = new HashMap<>();
                        prediction.put("best_case", rs.getDouble("best_case"));
                        prediction.put("expected", rs.getDouble("expected"));
                        prediction.put("worst_case", rs.getDouble("worst_case"));
                        request.setAttribute("prediction", prediction);
                    }
                }

                // Fetch expense logs
                List<Map<String, Object>> expenses = new ArrayList<>();
                double totalSpent = 0;
                try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM expense_logs WHERE budget_plan_id = ? ORDER BY created_at DESC")) {
                    stmt.setInt(1, (int) budgetPlan.get("id"));
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        Map<String, Object> exp = new HashMap<>();
                        exp.put("category", rs.getString("category"));
                        exp.put("amount", rs.getDouble("amount"));
                        exp.put("description", rs.getString("description"));
                        exp.put("created_at", rs.getTimestamp("created_at"));
                        expenses.add(exp);
                        totalSpent += rs.getDouble("amount");
                    }
                }
                request.setAttribute("expenses", expenses);
                request.setAttribute("totalSpent", totalSpent);
                request.setAttribute("remaining", (double) budgetPlan.get("total_budget") - totalSpent);
            }
            
            // Forward to the dashboard
            request.getRequestDispatcher("/pages/common/finance-dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("create_budget".equals(action)) {
                String destination = request.getParameter("destination");
                double totalBudget = Double.parseDouble(request.getParameter("total_budget"));

                // AI Simulated Math Engine
                double flights = totalBudget * 0.30;
                double hotel = totalBudget * 0.35;
                double food = totalBudget * 0.15;
                double activities = totalBudget * 0.12;
                double transportation = totalBudget * 0.04;
                double emergency = totalBudget * 0.04;
                int healthScore = 92; // Simulated healthy score

                int planId = 0;
                try (PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO budget_plans (user_id, destination, total_budget, flights, hotel, food, activities, transportation, emergency, health_score) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setInt(1, user.getId());
                    stmt.setString(2, destination);
                    stmt.setDouble(3, totalBudget);
                    stmt.setDouble(4, flights);
                    stmt.setDouble(5, hotel);
                    stmt.setDouble(6, food);
                    stmt.setDouble(7, activities);
                    stmt.setDouble(8, transportation);
                    stmt.setDouble(9, emergency);
                    stmt.setInt(10, healthScore);
                    stmt.executeUpdate();
                    
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        planId = rs.getInt(1);
                    }
                }

                if (planId > 0) {
                    // Generate AI Predictions based on destination cost index
                    double bestCase = totalBudget * 0.85;
                    double expected = totalBudget;
                    double worstCase = totalBudget * 1.25;

                    try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO trip_cost_predictions (budget_plan_id, best_case, expected, worst_case) VALUES (?, ?, ?, ?)")) {
                        stmt.setInt(1, planId);
                        stmt.setDouble(2, bestCase);
                        stmt.setDouble(3, expected);
                        stmt.setDouble(4, worstCase);
                        stmt.executeUpdate();
                    }
                }
            } else if ("add_expense".equals(action)) {
                int planId = Integer.parseInt(request.getParameter("plan_id"));
                String description = request.getParameter("description");
                String category = request.getParameter("category");
                double amount = Double.parseDouble(request.getParameter("amount"));

                try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO expense_logs (budget_plan_id, category, amount, description) VALUES (?, ?, ?, ?)")) {
                    stmt.setInt(1, planId);
                    stmt.setString(2, category);
                    stmt.setDouble(3, amount);
                    stmt.setString(4, description);
                    stmt.executeUpdate();
                }

                // Update health score dynamically based on total spent vs total budget
                // Simple logic: if total spent > budget, health drops
                // In a real app, you'd check category limits
                double totalBudget = 0;
                try (PreparedStatement stmt = conn.prepareStatement("SELECT total_budget FROM budget_plans WHERE id = ?")) {
                    stmt.setInt(1, planId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        totalBudget = rs.getDouble("total_budget");
                    }
                }
                
                double totalSpent = 0;
                try (PreparedStatement stmt = conn.prepareStatement("SELECT SUM(amount) FROM expense_logs WHERE budget_plan_id = ?")) {
                    stmt.setInt(1, planId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        totalSpent = rs.getDouble(1);
                    }
                }

                if (totalBudget > 0) {
                    double ratio = totalSpent / totalBudget;
                    int newHealthScore = 100 - (int)(ratio * 100);
                    if (newHealthScore < 0) newHealthScore = 0;
                    if (ratio > 1.0) newHealthScore = 0; // Over budget

                    try (PreparedStatement stmt = conn.prepareStatement("UPDATE budget_plans SET health_score = ? WHERE id = ?")) {
                        stmt.setInt(1, newHealthScore);
                        stmt.setInt(2, planId);
                        stmt.executeUpdate();
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/budget");
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect(request.getContextPath() + "/budget?error=1");
        }
    }
}
