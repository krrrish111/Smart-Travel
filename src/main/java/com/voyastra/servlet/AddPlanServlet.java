package com.voyastra.servlet;

import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Plan;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/addPlan")
public class AddPlanServlet extends HttpServlet {

    private PlanDAO planDAO;

    @Override
    public void init() throws ServletException {
        planDAO = new PlanDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Auth check: Only allow admin
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            // Not authorized, redirect to login or index
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Validate text encoding
        request.setCharacterEncoding("UTF-8");

        try {
            // 2. Accept and Validate plan data
            String title = request.getParameter("title");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            
            // Basic validation: Required and length
            if (title == null || title.trim().isEmpty() || title.length() > 100 ||
                category == null || category.trim().isEmpty() || category.length() > 50) {
                session.setAttribute("errorMsg", "Validation Failed: Title (max 100) and Category (max 50) required.");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
                return;
            }

            int destinationId = 0;
            if (request.getParameter("destination_id") != null && !request.getParameter("destination_id").isEmpty()) {
                destinationId = Integer.parseInt(request.getParameter("destination_id"));
            }
            
            int price = 0;
            if (request.getParameter("price") != null && !request.getParameter("price").isEmpty()) {
                price = Integer.parseInt(request.getParameter("price"));
                if (price < 0) throw new NumberFormatException("Price cannot be negative.");
            }
            
            int days = 0;
            if (request.getParameter("days") != null && !request.getParameter("days").isEmpty()) {
                days = Integer.parseInt(request.getParameter("days"));
                if (days < 1) throw new NumberFormatException("Days must be at least 1.");
            }
            
            int nights = days > 0 ? days - 1 : 0;
            if (request.getParameter("nights") != null && !request.getParameter("nights").isEmpty()) {
                nights = Integer.parseInt(request.getParameter("nights"));
                if (nights < 0) throw new NumberFormatException("Nights cannot be negative.");
            }

            // 3. Assemble model
            Plan plan = new Plan();
            plan.setTitle(title.trim());
            plan.setDestinationId(destinationId);
            plan.setPrice(price);
            plan.setDays(days);
            plan.setNights(nights);
            plan.setCategory(category.trim());
            plan.setDescription(description != null ? description.trim() : "");
            plan.setImage(image != null && !image.trim().isEmpty() ? image.trim() : null);

            // 4. Insert into "plans" table
            boolean success = planDAO.addPlan(plan);

            // 5. Redirect back to admin dashboard
            if (success) {
                AdminLogger.log(request, "ADD", "Plan", plan.getId(), "Created travel plan '" + plan.getTitle() + "'");
                session.setAttribute("successMsg", "✅ Plan '" + plan.getTitle() + "' added successfully!");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            } else {
                session.setAttribute("errorMsg", "Failed to insert the plan into the database.");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            }

        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid number format in AddPlanServlet.");
            session.setAttribute("errorMsg", "Invalid numerical data — please check numbers and try again.");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An unexpected error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        }
    }
}
