package com.voyastra.controller.destination;

import com.voyastra.api.RazorpayService;
import com.voyastra.dao.booking.DestinationBookingDAO;
import com.voyastra.model.booking.DestinationBooking;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/destination/payment/validate")
public class DestinationPaymentValidateServlet extends HttpServlet {
    private DestinationBookingDAO destinationBookingDAO;

    @Override
    public void init() throws ServletException {
        destinationBookingDAO = new DestinationBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\", \"message\":\"Unauthorized\"}");
            return;
        }

        String orderId = request.getParameter("razorpay_order_id");
        String paymentId = request.getParameter("razorpay_payment_id");
        String signature = request.getParameter("razorpay_signature");

        if (orderId == null || paymentId == null || signature == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"Missing parameters\"}");
            return;
        }

        try {
            boolean isValid = com.voyastra.util.RazorpayConfig.verifySignature(orderId, paymentId, signature);

            if (isValid) {
                DestinationBooking booking = destinationBookingDAO.getBookingByOrderId(orderId);
                if (booking != null) {
                    destinationBookingDAO.updatePaymentStatus(orderId, paymentId, "CONFIRMED");
                    
                    // Set active
                    destinationBookingDAO.setActiveBooking(booking.getUserId(), booking.getId());
                }

                out.print("{\"status\":\"success\", \"message\":\"Payment verified successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"Invalid signature\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Validation failed\"}");
        }
    }
}
