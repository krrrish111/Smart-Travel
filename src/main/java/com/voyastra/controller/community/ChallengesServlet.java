package com.voyastra.controller.community;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles the Community Challenges page (/community/challenges).
 * Serves the gamification hub with active quests and leaderboards.
 */
public class ChallengesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/community/challenges.jsp").forward(request, response);
    }
}
