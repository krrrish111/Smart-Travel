package com.voyastra.servlet.destination;

import com.voyastra.dao.SavedDestinationDAO;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/destination/save")
public class SaveDestinationServlet extends HttpServlet {
    private SavedDestinationDAO savedDestinationDAO;

    @Override
    public void init() throws ServletException {
        savedDestinationDAO = new SavedDestinationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false, \"message\":\"Unauthorized\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String destinationIdStr = request.getParameter("destination_id");
        String action = request.getParameter("action"); // 'save' or 'remove'

        if (destinationIdStr == null || destinationIdStr.trim().isEmpty() || action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false, \"message\":\"Missing parameters\"}");
            return;
        }

        try {
            int destinationId = Integer.parseInt(destinationIdStr);
            boolean success = false;
            
            if ("save".equalsIgnoreCase(action)) {
                success = savedDestinationDAO.addSavedDestination(user.getId(), destinationId);
            } else if ("remove".equalsIgnoreCase(action)) {
                success = savedDestinationDAO.removeSavedDestination(user.getId(), destinationId);
            }

            response.setContentType("application/json");
            response.getWriter().write("{\"success\":" + success + "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false, \"message\":\"Invalid ID\"}");
        }
    }
}
