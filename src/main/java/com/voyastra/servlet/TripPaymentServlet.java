package com.voyastra.servlet;

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

@WebServlet("/api/razorpay/trip-payment-init")
public class TripPaymentServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(TripPaymentServlet.class.getName());

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
            if (amount <= 0) {
                throw new IllegalArgumentException("Amount must be greater than zero.");
            }
            long amountInPaise = Math.round(amount * 100.0);

            // Generate a unique receipt id
            String receipt = "rcpt_" + UUID.randomUUID().toString().substring(0, 8);

            // LOGGING AUDIT
            logger.info("========== RAZORPAY PAYMENT AUDIT ==========");
            logger.info("Original Trip Amount (INR): " + amount);
            logger.info("Amount Sent to Razorpay (Paise): " + amountInPaise);
            logger.info("Currency: INR");

            // Call Razorpay API to create the order
            String jsonResponse = RazorpayService.createOrder(amountInPaise, receipt);
            logger.info("Complete Razorpay API Response: " + jsonResponse);

            // Extract order_id using Gson
            JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();
            String orderId = jsonObject.get("id").getAsString();
            
            logger.info("Generated Order ID: " + orderId);
            logger.info("============================================");

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
            
            // Pass the generated Razorpay order ID
            request.setAttribute("razorpayOrderId", orderId);

            // Forward to trip-payment.jsp
            request.getRequestDispatcher("/pages/trip-payment.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to initialize trip payment", e);
            request.setAttribute("error", e.getMessage());
            // If failed, could redirect to an error page or back to review
            response.sendRedirect(request.getContextPath() + "/pages/trip-review.jsp?error=InitFailed");
        }
    }
}
