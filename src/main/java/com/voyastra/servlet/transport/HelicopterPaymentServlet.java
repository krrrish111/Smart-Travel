package com.voyastra.servlet.transport;

import com.voyastra.dao.HelicopterBookingDAO;
import com.voyastra.model.HelicopterBooking;
import com.voyastra.service.PaymentService;
import com.voyastra.util.NotificationManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/helicopter/payment-callback")
public class HelicopterPaymentServlet extends HttpServlet {
    private HelicopterBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new HelicopterBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!PaymentService.verifyPayment(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("[HelicopterPayment] Razorpay signature verification failed!");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=helicopter");
            return;
        }

        HelicopterBooking draft = (HelicopterBooking) request.getSession().getAttribute("currentHeliBooking");
        if (draft != null) {
            // Generate Booking ID / Reference dynamically using PaymentService
            String bookingRef = PaymentService.generateBookingReference("helicopter");
            draft.setId(bookingRef);
            draft.setStatus("CONFIRMED");

            // Save to database only after successful payment verification
            boolean saved = bookingDAO.saveBooking(draft);
            if (saved) {
                // Save payment record
                PaymentService.savePayment(
                    draft.getUserId(),
                    "helicopter",
                    bookingRef,
                    razorpayOrderId,
                    razorpayPaymentId,
                    draft.getAmount(),
                    "INR",
                    "Success"
                );

                // Try to send email and SMS
                try {
                    NotificationManager.sendTransportBookingSuccess(draft, draft.getUserId());
                } catch (Exception e) {
                    System.err.println("Failed to send notification: " + e.getMessage());
                }

                // Redirect to confirmation page
                request.getSession().setAttribute("currentHeliBooking", draft);
                response.sendRedirect(request.getContextPath() + "/transport/helicopter/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=helicopter");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=helicopter");
        }
    }
}
