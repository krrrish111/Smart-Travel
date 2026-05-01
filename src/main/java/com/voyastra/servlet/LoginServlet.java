package com.voyastra.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;
import com.voyastra.util.AdminLogger;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user_id") != null) {
            String role = (String) session.getAttribute("role");
            response.sendRedirect(request.getContextPath() + ("admin".equals(role) ? "/admin" : "/user-home"));
            return;
        }
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. Parse JSON Request
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) sb.append(line);
            }
            
            JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);
            if (jsonRequest == null) throw new IllegalArgumentException("Invalid JSON");

            String email    = jsonRequest.get("email")    != null ? jsonRequest.get("email").getAsString() : "";
            String password = jsonRequest.get("password") != null ? jsonRequest.get("password").getAsString() : "";
            String target   = jsonRequest.get("redirect") != null ? jsonRequest.get("redirect").getAsString() : "";

            if (email.trim().isEmpty() || password.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Email and password are required.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 2. Lookup & Validate
            User user = userDAO.getUserByEmail(email.trim().toLowerCase());
            boolean validPassword = false;
            
            if (user != null) {
                // Email Verification Check
                if (!user.isVerified() && !"admin".equals(user.getRole())) {
                    result.put("success", false);
                    result.put("message", "Email not verified. Please check your inbox.");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                String stored = user.getPassword();
                if (stored != null) {
                    if (stored.startsWith("$2")) {
                        try { validPassword = BCrypt.checkpw(password.trim(), stored); } catch (Exception e) {}
                    } else {
                        validPassword = password.trim().equals(stored.trim());
                    }
                }
            }

            if (validPassword && user != null) {
                // 3. Create Session (Fixation Protection)
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) oldSession.invalidate();
                HttpSession session = request.getSession(true);

                String userName = (user.getName() != null && !user.getName().isEmpty()) ? user.getName() : "Traveller";
                String userRole = user.getRole() != null ? user.getRole() : "user";

                session.setAttribute("user_id",   user.getId());
                session.setAttribute("name",      userName);
                session.setAttribute("username",  userName);
                session.setAttribute("email",     user.getEmail());
                session.setAttribute("role",      userRole);
                session.setAttribute("user",      user);
                session.setMaxInactiveInterval(30 * 60);

                try { AdminLogger.log(request, "LOGIN", "User", user.getId(), "User '" + user.getEmail() + "' logged in."); } catch (Exception e) {}

                // 4. Return Success (include user data for frontend auth sync)
                result.put("success", true);
                result.put("message", "Login successful! Redirecting...");
                result.put("userId", String.valueOf(user.getId()));
                result.put("name", userName);
                result.put("email", user.getEmail());
                result.put("role", userRole);
                
                String redirect = "admin".equals(userRole) ? "admin" : "user-home";
                if (target != null && !target.isEmpty()) {
                    result.put("redirect", request.getContextPath() + (target.startsWith("/") ? "" : "/") + target);
                } else {
                    result.put("redirect", request.getContextPath() + "/" + redirect);
                }
                
            } else {
                result.put("success", false);
                result.put("message", "Invalid email or password.");
            }
            
            response.getWriter().write(gson.toJson(result));

        } catch (Exception fatal) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.put("success", false);
            result.put("message", "A server error occurred: " + fatal.getMessage());
            response.getWriter().write(gson.toJson(result));
        }
    }
}

