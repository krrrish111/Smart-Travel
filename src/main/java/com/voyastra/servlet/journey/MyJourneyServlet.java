package com.voyastra.servlet.journey;

import com.voyastra.dao.JourneyDAO;
import com.voyastra.model.Journey;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/my-journey")
public class MyJourneyServlet extends HttpServlet {

    private JourneyDAO journeyDAO;

    @Override
    public void init() throws ServletException {
        journeyDAO = new JourneyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/my-journey");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Fetch active journey for user
        Journey activeJourney = journeyDAO.getActiveJourneyForUser(String.valueOf(user.getId()));
        
        if (activeJourney != null) {
            request.setAttribute("journey", activeJourney);
            request.getRequestDispatcher("/pages/journey/my-journey.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/pages/journey/empty-journey.jsp").forward(request, response);
        }
    }
}
