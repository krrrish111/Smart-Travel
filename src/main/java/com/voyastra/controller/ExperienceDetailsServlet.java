package com.voyastra.controller;

import com.voyastra.dao.ExperienceDAO;
import com.voyastra.model.Experience;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/experience/details")
public class ExperienceDetailsServlet extends HttpServlet {
    private ExperienceDAO experienceDAO;

    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        Experience experience = experienceDAO.getExperienceById(idParam);
        
        if (experience == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.setAttribute("experience", experience);
        request.getRequestDispatcher("/pages/common/experience-details.jsp").forward(request, response);
    }
}
