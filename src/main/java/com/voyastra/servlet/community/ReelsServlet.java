package com.voyastra.servlet.community;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles the Travel Reels page (/community/reels).
 * Serves the vertical video feed interface.
 */
public class ReelsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // In a real app, this would fetch reel data and metadata from the database
        // For now, it forwards to the JSP which has mock reels
        request.getRequestDispatcher("/pages/community/reels.jsp").forward(request, response);
    }
}
