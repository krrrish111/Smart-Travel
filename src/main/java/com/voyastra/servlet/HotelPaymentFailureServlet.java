package com.voyastra.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/hotel-payment-failure")
public class HotelPaymentFailureServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Do not delete pendingHotelBooking here, so they can try again.
            // Just redirect back to payment page with error.
        }
        
        request.setAttribute("error", "Payment was cancelled or failed. Please try again.");
        response.sendRedirect(request.getContextPath() + "/pages/payment.jsp?error=PaymentFailed");
    }
}
