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

@WebServlet("/updatePlan")
public class UpdatePlanServlet extends HttpServlet {

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
            // Not authorized, redirect to login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Validate text encoding
        request.setCharacterEncoding("UTF-8");

            // 2. Accept plan data from form, including the plan ID
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Plan ID is required for update.");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
                return;
            }
            int id = Integer.parseInt(idParam);

            String title = request.getParameter("title");
            
            int destinationId = 0;
            if (request.getParameter("destination_id") != null && !request.getParameter("destination_id").isEmpty()) {
                destinationId = Integer.parseInt(request.getParameter("destination_id"));
            }
            
            int price = 0;
            if (request.getParameter("price") != null && !request.getParameter("price").isEmpty()) {
                price = Integer.parseInt(request.getParameter("price"));
            }
            
            int days = 0;
            if (request.getParameter("days") != null && !request.getParameter("days").isEmpty()) {
                days = Integer.parseInt(request.getParameter("days"));
            }
            
            // Assume nights is days - 1 if not explicitly passed
            int nights = days > 0 ? days - 1 : 0;
            if (request.getParameter("nights") != null && !request.getParameter("nights").isEmpty()) {
                nights = Integer.parseInt(request.getParameter("nights"));
            }

            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String image = request.getParameter("image");

            // Basic validation
            if (title == null || title.trim().isEmpty() || category == null || category.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Title and Category are required fields.");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
                return;
            }

            // 3. Assemble model
            Plan plan = new Plan();
            plan.setId(id);
            plan.setTitle(title.trim());
            plan.setDestinationId(destinationId);
            plan.setPrice(price);
            plan.setDays(days);
            plan.setNights(nights);
            plan.setCategory(category.trim());
            plan.setDescription(description != null ? description.trim() : "");
            plan.setImage(image != null && !image.trim().isEmpty() ? image.trim() : null);

            // 4. Update in "plans" table
            boolean success = planDAO.updatePlan(plan);

            // 5. Redirect back to admin dashboard
            if (success) {
                AdminLogger.log(request, "UPDATE", "Plan", id, "Updated travel plan '" + title + "' (Plan ID: " + id + ")");
                session.setAttribute("successMsg", "✏️ Plan '" + title + "' updated successfully!");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            } else {
                session.setAttribute("errorMsg", "Failed to update the plan in the database.");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            }
    }
}
