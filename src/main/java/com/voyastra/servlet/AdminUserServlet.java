package com.voyastra.servlet;

import com.google.gson.Gson;
import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Admin Auth Check
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        String query = request.getParameter("q");
        List<User> users = userDAO.getAllUsers();
        
        if (query != null && !query.trim().isEmpty()) {
            String lowerQ = query.toLowerCase();
            users = users.stream()
                .filter(u -> u.getName().toLowerCase().contains(lowerQ) || u.getEmail().toLowerCase().contains(lowerQ))
                .collect(Collectors.toList());
        }
        
        out.print(gson.toJson(users));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Admin Auth Check
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        String action = request.getParameter("action");
        try {
            boolean success = false;
            
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                
                if (name != null && email != null && password != null) {
                    if (userDAO.emailExists(email)) {
                        out.print("{\"success\":false, \"message\":\"Email already exists\"}");
                        out.flush();
                        return;
                    }
                    User user = new User();
                    user.setName(name);
                    user.setEmail(email);
                    user.setPassword(password);
                    user.setRole(role != null ? role : "user");
                    user.setVerified(true);
                    success = userDAO.registerUser(user);
                }
            } else {
                int userId = Integer.parseInt(request.getParameter("userId"));
                
                if ("delete".equals(action)) {
                    success = userDAO.deleteUser(userId);
                } else if ("updateRole".equals(action)) {
                    String newRole = request.getParameter("role");
                    if (newRole != null) {
                        success = userDAO.updateRole(userId, newRole);
                    }
                } else if ("toggleActive".equals(action)) {
                    User u = userDAO.getUserById(userId);
                    if (u != null) {
                        u.setVerified(!u.isVerified());
                        success = true; 
                    }
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            out.print(gson.toJson(result));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid user ID\"}");
        }
        out.flush();
    }
}
