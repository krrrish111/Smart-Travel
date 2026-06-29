package com.voyastra.controller.payment;

import com.voyastra.api.RazorpayService;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet({"/trip-payment", "/api/razorpay/trip-payment-init"})
public class TripPaymentServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(TripPaymentServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/payment/trip-payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            // Read parameters from trip-review.jsp
            String totalPriceStr = request.getParameter("totalPrice");
            if (totalPriceStr == null || totalPriceStr.isEmpty()) {
                throw new IllegalArgumentException("Total price is required.");
            }

            double amount = Double.parseDouble(totalPriceStr);
            long amountInPaise = Math.round(amount * 100.0);

            // Phase 3 — Validate Amount
            if (amount <= 0 || amountInPaise > 50000000) {
                throw new IllegalArgumentException("Invalid payment amount before Razorpay request.");
            }

            // Generate a unique receipt id
            String receipt = "rcpt_" + UUID.randomUUID().toString().substring(0, 8);

            // Phase 1 — Add Debug Logging
            System.out.println("==================================");
            System.out.println("Raw totalPrice = " + totalPriceStr);
            System.out.println("Parsed amount = " + amount);
            System.out.println("Final amountInPaise = " + amountInPaise);
            System.out.println("Receipt = " + receipt);
            System.out.println("==================================");
            
            String exactJson = String.format("{\n  \"amount\":%d,\n  \"currency\":\"INR\",\n  \"receipt\":\"%s\"\n}", amountInPaise, receipt);
            System.out.println("Order JSON:\n" + exactJson);
            System.out.println("==================================");

            // Call Razorpay API to create the order
            String jsonResponse = RazorpayService.createOrder(amountInPaise, receipt);
            System.out.println("[TripPaymentServlet] Complete Razorpay API Response: " + jsonResponse);

            // Extract order_id using Gson
            JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();
            String orderId = jsonObject.get("id").getAsString();
            
            System.out.println("[TripPaymentServlet] Generated Order ID: " + orderId);

            // Set all parameters as request attributes to forward them to the payment page
            request.setAttribute("tripId", request.getParameter("tripId"));
            request.setAttribute("tripTitle", request.getParameter("tripTitle"));
            request.setAttribute("tripDest", request.getParameter("tripDest"));
            request.setAttribute("departureDate", request.getParameter("departureDate"));
            request.setAttribute("firstName", request.getParameter("firstName"));
            request.setAttribute("lastName", request.getParameter("lastName"));
            request.setAttribute("guestEmail", request.getParameter("guestEmail"));
            request.setAttribute("guestPhone", request.getParameter("guestPhone"));
            request.setAttribute("guests", request.getParameter("guests"));
            request.setAttribute("totalPrice", totalPriceStr);
            
            // Pass the exact amount in paise and the generated Razorpay order ID
            request.setAttribute("amountInPaise", amountInPaise);
            request.setAttribute("razorpayOrderId", orderId);

            // Forward to trip-payment.jsp
            request.getRequestDispatcher("/pages/payment/trip-payment.jsp").forward(request, response);

        } catch (Exception e) {
            // Capture Razorpay exception properly (TASK 7)
            System.err.println("===== RAZORPAY EXCEPTION CAUGHT =====");
            System.err.println("Exception Class: " + e.getClass().getName());
            System.err.println("Message: " + e.getMessage());
            System.err.println("Localized Message: " + e.getLocalizedMessage());
            System.err.println("Stack Trace:");
            e.printStackTrace();
            System.err.println("=====================================");

            request.setAttribute("error", e.getMessage());
            // If failed, could redirect to an error page or back to review
            response.sendRedirect(request.getContextPath() + "/pages/trip-review.jsp?error=InitFailed");
        }
    }
}
