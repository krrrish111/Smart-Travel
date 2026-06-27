package com.voyastra.servlet.destination;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/destination/confirmation")
public class DestinationConfirmationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderId = request.getParameter("order_id");
        request.setAttribute("orderId", orderId);
        request.getRequestDispatcher("/pages/destination-confirmation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("destinationTitle", request.getParameter("destinationTitle"));
        request.setAttribute("travelDate", request.getParameter("travelDate"));
        request.setAttribute("guests", request.getParameter("guests"));
        request.setAttribute("primaryName", request.getParameter("primaryName"));
        request.setAttribute("primaryEmail", request.getParameter("primaryEmail"));
        request.setAttribute("primaryPhone", request.getParameter("primaryPhone"));
        request.setAttribute("finalPrice", request.getParameter("finalPrice"));
        request.setAttribute("paymentId", request.getParameter("paymentId"));
        request.setAttribute("orderId", request.getParameter("orderId"));
        
        request.getRequestDispatcher("/pages/destination-confirmation.jsp").forward(request, response);
    }
}
