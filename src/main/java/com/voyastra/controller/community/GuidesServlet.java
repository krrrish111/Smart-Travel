package com.voyastra.controller.community;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles the Guide Marketplace page (/community/guides).
 * Serves the marketplace where users can browse, save, and book community itineraries.
 */
public class GuidesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/community/guides.jsp").forward(request, response);
    }
}
