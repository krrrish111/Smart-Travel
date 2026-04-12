package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;
    private final Gson gson = new Gson();
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
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
            if (jsonRequest == null) throw new IllegalArgumentException("Invalid JSON body");

            String name = jsonRequest.get("name") != null ? jsonRequest.get("name").getAsString() : "";
            String email = jsonRequest.get("email") != null ? jsonRequest.get("email").getAsString() : "";
            String password = jsonRequest.get("password") != null ? jsonRequest.get("password").getAsString() : "";

            // 2. Validation
            if (name.trim().length() < 2 || email.trim().isEmpty() || password.trim().length() < 6) {
                result.put("success", false);
                result.put("message", "Validation Failed: Name (min 2), Email required, Password (min 6).");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            String cleanEmail = email.trim().toLowerCase();
            if (!Pattern.compile(EMAIL_REGEX).matcher(cleanEmail).matches()) {
                result.put("success", false);
                result.put("message", "Invalid email format.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 3. Register logic
            User user = new User();
            user.setName(name.trim());
            user.setEmail(cleanEmail);
            user.setPassword(password);
            user.setRole("user");
            user.setVerified(false);
            user.setVerificationToken(java.util.UUID.randomUUID().toString());

            boolean isRegistered = userDAO.registerUser(user);

            if (isRegistered) {
                // Send Welcome/Verify Link
                String scheme = request.getScheme();
                String serverName = request.getServerName();
                int serverPort = request.getServerPort();
                String contextPath = request.getContextPath();
                String verifyLink = scheme + "://" + serverName + ":" + serverPort + contextPath + "/verify?token=" + user.getVerificationToken();
                
                com.voyastra.util.EmailService.sendWelcomeEmail(cleanEmail, user.getName(), verifyLink);
                
                result.put("success", true);
                result.put("message", "Success! Please check your email to verify your account.");
                result.put("redirect", request.getContextPath() + "/login.jsp?registered=true&needsVerification=true");
            } else {
                result.put("success", false);
                result.put("message", "Registration failed. Email might already be in use.");
            }
            
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.put("success", false);
            result.put("message", "Server error during registration.");
            response.getWriter().write(gson.toJson(result));
        }
    }
}
