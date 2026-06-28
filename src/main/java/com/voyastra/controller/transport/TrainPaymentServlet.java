package com.voyastra.controller.transport;

import com.voyastra.dao.booking.TrainBookingDAO;
import com.voyastra.model.booking.TrainBooking;
import com.voyastra.service.payment.PaymentService;
import com.voyastra.util.NotificationManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/transport/train/payment", "/transport/train/payment-callback"})
public class TrainPaymentServlet extends HttpServlet {
    private TrainBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new TrainBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/transport/train-payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!PaymentService.verifyPayment(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("[TrainPayment] Razorpay signature verification failed!");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=train");
            return;
        }

        TrainBooking draft = (TrainBooking) request.getSession().getAttribute("currentTrainBooking");
        if (draft != null) {
            // Generate Booking ID / Reference dynamically using PaymentService
            String bookingRef = PaymentService.generateBookingReference("train");
            draft.setId(bookingRef);
            draft.setStatus("CONFIRMED");
            
            // Save to database only after successful payment verification
            boolean saved = bookingDAO.saveDraft(draft);
            if (saved) {
                // Save payment record
                double totalAmount = (draft.getFare() * draft.getPassengers().size()) + 150;
                PaymentService.savePayment(
                    draft.getUserId(),
                    "train",
                    bookingRef,
                    razorpayOrderId,
                    razorpayPaymentId,
                    totalAmount,
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
                request.getSession().setAttribute("currentTrainBooking", draft);
                response.sendRedirect(request.getContextPath() + "/transport/train/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=train");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=train");
        }
    }
}
