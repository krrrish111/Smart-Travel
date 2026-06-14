package com.voyastra.servlet.journey;

import com.voyastra.dao.JourneyDAO;
import com.voyastra.dao.journey.MyJourneyEcosystemDAO;
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
    private MyJourneyEcosystemDAO ecosystemDAO;

    @Override
    public void init() throws ServletException {
        journeyDAO = new JourneyDAO();
        ecosystemDAO = new MyJourneyEcosystemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/my-journey");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "overview";
        }
        request.setAttribute("activeTab", tab);
        
        // Always fetch active journey
        Journey activeJourney = journeyDAO.getActiveJourneyForUser(String.valueOf(user.getId()));
        request.setAttribute("journey", activeJourney);
        
        // Fetch specific data based on tab, or fetch all if light enough
        if (tab.equals("memories")) {
            request.setAttribute("memories", ecosystemDAO.getMemoriesForUser(user.getId()));
        } else if (tab.equals("family")) {
            request.setAttribute("familyMembers", ecosystemDAO.getFamilyMembersForUser(user.getId()));
        } else if (tab.equals("reports")) {
            request.setAttribute("tripReports", ecosystemDAO.getTripReportsForUser(user.getId()));
        }
        
        // We always go to the main ecosystem dashboard now
        request.getRequestDispatcher("/pages/journey/my-journey.jsp").forward(request, response);
    }
}
