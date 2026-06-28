package com.voyastra.controller.community;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles the Community AI Engine page (/community/discover).
 * Serves personalized recommendations based on user interests.
 */
public class DiscoverServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/community/discover.jsp").forward(request, response);
    }
}
