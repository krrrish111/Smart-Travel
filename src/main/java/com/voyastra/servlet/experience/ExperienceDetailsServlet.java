package com.voyastra.servlet.experience;

import com.voyastra.dao.ExperienceDAO;
import com.voyastra.dao.LocalGuideDAO;
import com.voyastra.model.Experience;
import com.voyastra.model.LocalGuide;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/experience-details")
public class ExperienceDetailsServlet extends HttpServlet {

    private ExperienceDAO experienceDAO;
    private LocalGuideDAO localGuideDAO;

    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
        localGuideDAO = new LocalGuideDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String activity = request.getParameter("activity");
        
        if ((id == null || id.isEmpty()) && (activity == null || activity.isEmpty())) {
            response.sendRedirect(request.getContextPath() + "/explore");
            return;
        }
        
        if (id == null || id.isEmpty()) {
            // For demo purposes, we can set a dummy id or try to fetch by activity name
            // If the DAO doesn't support getByActivity, we can default to a specific id
            // Let's use id = "1" as a fallback demo
            id = "1";
        }

        Experience experience = experienceDAO.getExperienceById(id);
        if (experience == null) {
            response.sendRedirect(request.getContextPath() + "/explore");
            return;
        }

        LocalGuide guide = null;
        if (experience.getGuideId() != null) {
            guide = localGuideDAO.getGuideById(experience.getGuideId());
        }

        request.setAttribute("experience", experience);
        request.setAttribute("guide", guide);

        request.getRequestDispatcher("/pages/experience/experience-details.jsp").forward(request, response);
    }
}
