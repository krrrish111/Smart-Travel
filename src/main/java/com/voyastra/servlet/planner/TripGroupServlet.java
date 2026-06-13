package com.voyastra.servlet.planner;

import com.voyastra.dao.TripGroupDAO;
import com.voyastra.model.TripGroup;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/trip-groups")
public class TripGroupServlet extends HttpServlet {
    private TripGroupDAO groupDAO = new TripGroupDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // In a full implementation, we would load the user's groups here
        request.getRequestDispatcher("/pages/trip-groups.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            String name = request.getParameter("groupName");
            TripGroup group = new TripGroup();
            group.setName(name);
            group.setCreatorId(user.getId());
            
            int groupId = groupDAO.createGroup(group);
            if (groupId > 0) {
                // Redirect to the specific group page
                response.sendRedirect(request.getContextPath() + "/trip-groups?id=" + groupId);
            } else {
                request.setAttribute("error", "Failed to create group.");
                doGet(request, response);
            }
        }
    }
}
