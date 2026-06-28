package com.voyastra.controller.payment;

import com.voyastra.model.booking.HotelBooking;
import java.util.logging.Logger;
import java.util.logging.Level;
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
    private static final Logger logger = Logger.getLogger(RazorpayOrderServlet.class.getName());


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

        String amountStr = request.getParameter("amount");
        String receipt = request.getParameter("receipt");
        int amountInPaise = 0;

        if (amountStr != null && !amountStr.trim().isEmpty()) {
            try {
                double amount = Double.parseDouble(amountStr);
                amountInPaise = (int) Math.round(amount * 100.0);
                if (receipt == null || receipt.trim().isEmpty()) {
                    receipt = "rcpt_" + UUID.randomUUID().toString().substring(0, 8);
                }
            } catch (NumberFormatException e) {
                response.setStatus(400);
                response.getWriter().write("{\"error\": \"Invalid amount format\"}");
                return;
            }
        } else {
            com.voyastra.model.booking.Booking currentBooking = (com.voyastra.model.booking.Booking) session.getAttribute("currentBooking");
            if (currentBooking != null) {
                amountInPaise = (int) (currentBooking.getTotalPrice() * 100);
                receipt = "rcpt_" + UUID.randomUUID().toString().substring(0, 8);
            } else {
                HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
                if (pending == null) {
                    response.setStatus(400);
                    response.getWriter().write("{\"error\": \"No pending booking found or amount specified\"}");
                    return;
                }
                amountInPaise = (int) (pending.getTotalPrice() * 100);
                receipt = "rcpt_" + UUID.randomUUID().toString().substring(0, 8);
            }
        }

        try {
            // Call the Razorpay API service
            String jsonResponse = com.voyastra.api.RazorpayService.createOrder(amountInPaise, receipt);

            // Forward successful response to the frontend
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            System.err.println("[RazorpayOrderServlet] Order Creation Exception:");
            logger.log(Level.SEVERE, "Exception occurred", e);
            
            response.setStatus(500);
            
            // Escape double quotes in the error message for JSON safety
            String safeErrorMessage = e.getMessage().replace("\"", "\\\"");
            response.getWriter().write("{\"error\": \"" + safeErrorMessage + "\"}");
        }
    }
}
