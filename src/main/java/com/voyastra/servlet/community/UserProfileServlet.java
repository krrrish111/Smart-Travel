package com.voyastra.servlet.community;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles public creator profile pages at /community/user/{username}
 * Extracts the username from the URL path and forwards to user-profile.jsp
 */
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Extract username from path: /community/user/{username}
        String pathInfo = request.getPathInfo(); // e.g. "/sarahexplores"
        String username = "explorer";
        if (pathInfo != null && pathInfo.length() > 1) {
            username = pathInfo.substring(1); // strip leading '/'
        }

        // Expose to JSP
        request.setAttribute("profileUsername", username);

        // Check if this is the logged-in user's own profile
        String sessionUser = (String) request.getSession().getAttribute("user_name");
        boolean isOwnProfile = username.equalsIgnoreCase(sessionUser);
        request.setAttribute("isOwnProfile", isOwnProfile);

        request.getRequestDispatcher("/pages/community/user-profile.jsp").forward(request, response);
    }
}
