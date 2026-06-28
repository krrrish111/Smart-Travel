package com.voyastra.controller.experience;

import com.voyastra.dao.ExperienceDAO;
import com.voyastra.model.Experience;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/old-experiences")
public class ExperiencesServlet extends HttpServlet {

    private ExperienceDAO experienceDAO;

    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/explore");
    }
}
