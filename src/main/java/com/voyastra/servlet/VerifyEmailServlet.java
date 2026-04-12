package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/verify")
public class VerifyEmailServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() { userDAO = new UserDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        if (token == null || token.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid_token");
            return;
        }

        boolean verified = userDAO.verifyUser(token);
        if (verified) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?verified=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=verification_failed");
        }
    }
}
