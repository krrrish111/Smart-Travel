package com.voyastra.servlet.transport;

import com.voyastra.dao.CabBookingDAO;
import com.voyastra.model.CabBooking;
import com.voyastra.service.PaymentService;
import com.voyastra.util.NotificationManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cab/payment-callback")
public class CabPaymentServlet extends HttpServlet {
    private CabBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new CabBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!PaymentService.verifyPayment(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("[CabPayment] Razorpay signature verification failed!");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cab");
            return;
        }

        CabBooking draft = (CabBooking) request.getSession().getAttribute("currentCabBooking");
        if (draft != null) {
            // Generate Booking ID / Reference dynamically using PaymentService
            String bookingRef = PaymentService.generateBookingReference("cab");
            draft.setId(bookingRef);
            draft.setStatus("CONFIRMED");

            // Save to database only after successful payment verification
            boolean saved = bookingDAO.saveBooking(draft);
            if (saved) {
                // Save payment record
                PaymentService.savePayment(
                    draft.getUserId(),
                    "cab",
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
                request.getSession().setAttribute("currentCabBooking", draft);
                response.sendRedirect(request.getContextPath() + "/transport/cab/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cab");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cab");
        }
    }
}
