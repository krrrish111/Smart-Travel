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

            // Construct JSON payload manually to avoid extra dependencies
            String jsonPayload = String.format(
                "{\"amount\": %d, \"currency\": \"INR\", \"receipt\": \"%s\"}",
                amountInPaise, receipt
            );

            // Setup HTTP Connection
            URL url = new URL("https://api.razorpay.com/v1/orders");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", RazorpayConfig.getBasicAuthHeader());
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // Send payload
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            
            // Read response
            BufferedReader br;
            if (responseCode >= 200 && responseCode < 300) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }

            StringBuilder responseBody = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                responseBody.append(line.trim());
            }

            if (responseCode >= 200 && responseCode < 300) {
                // Forward successful response to the frontend
                response.getWriter().write(responseBody.toString());
            } else {
                System.err.println("Razorpay Error: " + responseBody.toString());
                response.setStatus(500);
                response.getWriter().write("{\"error\": \"Payment gateway failed to create order\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"Internal server error generating order\"}");
        }
    }
}
