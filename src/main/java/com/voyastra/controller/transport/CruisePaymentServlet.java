package com.voyastra.controller.transport;

import com.voyastra.dao.booking.CruiseBookingDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.model.booking.CruiseBooking;
import com.voyastra.service.payment.PaymentService;
import com.voyastra.util.NotificationManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/transport/cruise/payment", "/transport/cruise/payment-callback"})
public class CruisePaymentServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CruisePaymentServlet.class.getName());

    private CruiseBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new CruiseBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/transport/cruise-payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== CRUISE PAYMENT START ===");

        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        System.out.println("[CruisePayment] Payment ID = " + razorpayPaymentId);
        System.out.println("[CruisePayment] Order ID   = " + razorpayOrderId);
        System.out.println("[CruisePayment] Signature  = " + razorpaySignature);

        if (razorpayPaymentId == null || razorpayOrderId == null || razorpaySignature == null) {
            System.err.println("[CruisePayment] One or more Razorpay parameters are NULL! Aborting.");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cruise&reason=missing_params");
            return;
        }

        if (!PaymentService.verifyPayment(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("[CruisePayment] Razorpay signature verification FAILED!");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cruise&reason=sig_fail");
            return;
        }

        System.out.println("[CruisePayment] Signature Verification SUCCESS");

        CruiseBooking draft = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        if (draft == null) {
            System.err.println("[CruisePayment] Session attribute 'currentCruiseBooking' is NULL! Session may have expired.");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cruise&reason=session_expired");
            return;
        }

        System.out.println("[CruisePayment] Draft booking found. Ship: " + draft.getShipName() + ", Amount: " + draft.getAmount());
        System.out.println("[CruisePayment] Creating Cruise Booking...");

        // Generate Booking ID / Reference dynamically using PaymentService
        String bookingRef = PaymentService.generateBookingReference("cruise");
        draft.setId(bookingRef);
        draft.setStatus("CONFIRMED");

        System.out.println("[CruisePayment] Generated booking reference: " + bookingRef);

        boolean saved = false;
        try {
            saved = bookingDAO.saveBooking(draft);
        } catch (Exception e) {
            System.err.println("[CruisePayment] Exception during saveBooking: " + e.getMessage());
            logger.log(Level.SEVERE, "Exception occurred", e);
        }

        if (saved) {
            System.out.println("[CruisePayment] Cruise Booking Saved successfully: " + bookingRef);

            // Save payment record
            try {
                PaymentService.savePayment(
                    draft.getUserId(),
                    "cruise",
                    bookingRef,
                    razorpayOrderId,
                    razorpayPaymentId,
                    draft.getAmount(),
                    "INR",
                    "Success"
                );
                System.out.println("[CruisePayment] Payment record saved.");
            } catch (Exception e) {
                System.err.println("[CruisePayment] Failed to save payment record: " + e.getMessage());
            }

            // Try to send email and SMS
            System.out.println("[CruisePayment] Sending Email/SMS notification...");
            try {
                NotificationManager.sendTransportBookingSuccess(draft, draft.getUserId());
                System.out.println("[CruisePayment] Notification sent.");
            } catch (Exception e) {
                System.err.println("[CruisePayment] Failed to send notification: " + e.getMessage());
            }

            // Update session with confirmed booking and redirect
            request.getSession().setAttribute("currentCruiseBooking", draft);
            System.out.println("[CruisePayment] Redirecting to Confirmation Page...");
            response.sendRedirect(request.getContextPath() + "/transport/cruise/confirmation");
        } else {
            System.err.println("[CruisePayment] saveBooking() returned FALSE. DB insert failed.");
            response.sendRedirect(request.getContextPath() + "/pages/transport/payment-failed.jsp?type=cruise&reason=db_error");
        }
    }
}
