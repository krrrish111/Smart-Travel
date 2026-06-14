package com.voyastra.servlet.experience;

import com.voyastra.dao.ExperienceDAO;
import com.voyastra.model.Experience;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/experiences")
public class ExperiencesServlet extends HttpServlet {

    private ExperienceDAO experienceDAO;

    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        if (category == null || category.isEmpty()) {
            category = "All";
        }

        List<Experience> experiences = experienceDAO.getExperiencesByCategory(category);
        
        // Pass data to JSP
        request.setAttribute("experiences", experiences);
        request.setAttribute("selectedCategory", category);

        // Forward to the marketplace view
        request.getRequestDispatcher("/pages/experience/marketplace.jsp").forward(request, response);
    }
}
