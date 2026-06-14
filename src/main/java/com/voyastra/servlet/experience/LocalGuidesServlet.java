package com.voyastra.servlet.experience;

import com.voyastra.dao.LocalGuideDAO;
import com.voyastra.model.LocalGuide;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/guides")
public class LocalGuidesServlet extends HttpServlet {

    private LocalGuideDAO localGuideDAO;

    @Override
    public void init() throws ServletException {
        localGuideDAO = new LocalGuideDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<LocalGuide> guides = localGuideDAO.getAllGuides();
        
        request.setAttribute("guides", guides);
        
        request.getRequestDispatcher("/pages/experience/guide-directory.jsp").forward(request, response);
    }
}
