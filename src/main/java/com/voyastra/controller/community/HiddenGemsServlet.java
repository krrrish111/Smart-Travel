package com.voyastra.controller.community;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles the Hidden Gems Network page (/community/hidden-gems).
 * Serves the discovery grid for secret locations.
 */
public class HiddenGemsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/community/hidden-gems.jsp").forward(request, response);
    }
}
