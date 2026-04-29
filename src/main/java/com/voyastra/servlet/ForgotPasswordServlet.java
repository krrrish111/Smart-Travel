package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;
import com.voyastra.util.EmailService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() { userDAO = new UserDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMsg", "Email is required.");
            request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByEmail(email.trim().toLowerCase());
        if (user != null) {
            String token = UUID.randomUUID().toString();
            userDAO.updateResetToken(email, token);

            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" + 
                               request.getServerPort() + request.getContextPath() + 
                               "/reset-password?token=" + token;
            
            EmailService.sendPasswordResetEmail(user.getEmail(), resetLink);
        }

        // Always show success message for security (prevent email enumeration)
        request.setAttribute("successMsg", "If an account exists for that email, a password reset link has been sent.");
        request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
    }
}
