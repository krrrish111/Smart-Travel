package com.voyastra.servlet;

import com.voyastra.model.HotelBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet("/api/razorpay/create-order")
public class RazorpayOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            response.setStatus(400);
            response.getWriter().write("{\"error\": \"No pending booking found\"}");
            return;
        }

        try {
            // Razorpay amount is in paise (multiply by 100)
            int amountInPaise = (int) (pending.getTotalPrice() * 100);
            String receipt = "rcpt_" + UUID.randomUUID().toString().substring(0, 8);

            // Call the Razorpay API service
            String jsonResponse = com.voyastra.api.RazorpayService.createOrder(amountInPaise, receipt);

            // Forward successful response to the frontend
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            System.err.println("[RazorpayOrderServlet] Order Creation Exception:");
            e.printStackTrace();
            
            response.setStatus(500);
            
            // Escape double quotes in the error message for JSON safety
            String safeErrorMessage = e.getMessage().replace("\"", "\\\"");
            response.getWriter().write("{\"error\": \"" + safeErrorMessage + "\"}");
        }
    }
}
