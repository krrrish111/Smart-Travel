package com.voyastra.servlet;

import com.voyastra.dao.PlanDAO;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/deletePlan")
public class DeletePlanServlet extends HttpServlet {

    private PlanDAO planDAO;

    @Override
    public void init() throws ServletException {
        planDAO = new PlanDAO();
    }

    // Only allow deletion via POST for structural confirmation handling and security
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

        try {
            // 2. Accept plan id
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Plan ID is required for deletion.");
                response.sendRedirect(request.getContextPath() + "/admin/plans.jsp");
                return;
            }
            int id = Integer.parseInt(idParam);

            // 3. Delete from database
            boolean success = planDAO.deletePlan(id);

            // 4. Redirect to admin dashboard
            if (success) {
                AdminLogger.log(request, "DELETE", "Plan", id, "Deleted travel plan #" + id);
                session.setAttribute("successMsg", "🗑️ Plan #" + id + " deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/admin/plans.jsp");
            } else {
                session.setAttribute("errorMsg", "Failed to delete the plan from the database.");
                response.sendRedirect(request.getContextPath() + "/admin/plans.jsp");
            }

        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid number format in DeletePlanServlet.");
            session.setAttribute("errorMsg", "Invalid Plan ID provided.");
            response.sendRedirect(request.getContextPath() + "/admin/plans.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An unexpected error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/admin/plans.jsp");
        }
    }

    // Reject direct GET requests to prevent accidental or malicious deletion via URL execution
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/plans.jsp");
    }
}
