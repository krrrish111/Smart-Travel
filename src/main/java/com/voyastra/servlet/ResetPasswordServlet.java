package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() { userDAO = new UserDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        User user = userDAO.getUserByResetToken(token);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=invalid_token");
        } else {
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        if (password == null || password.length() < 6 || !password.equals(confirm)) {
            request.setAttribute("errorMsg", "Passwords must match and be at least 6 characters.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByResetToken(token);
        if (user != null) {
            boolean updated = userDAO.updatePassword(user.getId(), password);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?reset=success");
                return;
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=invalid_flow");
    }
}
