package com.voyastra.controller.booking;

import com.voyastra.dao.booking.HotelBookingDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.dao.payment.PaymentDAO;
import com.voyastra.model.booking.HotelBooking;
import com.voyastra.model.payment.Payment;
import com.voyastra.util.EmailUtil;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/process-hotel-payment")
public class HotelPaymentServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(HotelPaymentServlet.class.getName());

    private HotelBookingDAO bookingDAO = new HotelBookingDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("HotelPaymentServlet doPost called!");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("Session or user is null. Redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            System.out.println("pendingHotelBooking is null! Redirecting to hotels");
            response.sendRedirect("hotels");
            return;
        }

        System.out.println("pendingHotelBooking found! ID: " + pending.getId());
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!RazorpayConfig.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("Razorpay signature verification failed!");
            response.sendRedirect(request.getContextPath() + "/payment?error=SignatureFailed");
            return;
        }

        try {
            // Update booking status to Confirmed
            boolean statusUpdated = bookingDAO.updateBookingStatus(pending.getId(), "Confirmed");
            
            if (statusUpdated) {
                // Insert a payment transaction
                Payment p = new Payment();
                p.setBookingId(pending.getId());
                p.setUserId(pending.getUserId());
                p.setAmount(pending.getTotalPrice());
                p.setMethod("Razorpay");
                p.setStatus("Success");
                p.setTransactionId(razorpayPaymentId);
                paymentDAO.addPayment(p);

                // Try to send email and SMS, but don't fail booking if it throws an exception
                try {
                    EmailUtil.sendHotelBookingConfirmationWithVoucher(pending);
                    com.voyastra.util.SMSUtil.sendHotelBookingSMS(pending);
                } catch (Throwable notificationEx) {
                    System.err.println("Failed to send confirmation email/SMS: " + notificationEx.getMessage());
                }

                // Clean up all hotel booking session attributes
                session.removeAttribute("pendingHotelBooking");
                session.removeAttribute("pendingAddons");
                session.removeAttribute("currentBooking");
                session.removeAttribute("paymentAction");

                response.sendRedirect(request.getContextPath() + "/hotel-confirmation?id=" + pending.getId());
            } else {
                request.setAttribute("error", "Failed to confirm booking after payment.");
                response.sendRedirect(request.getContextPath() + "/payment?error=PaymentFailed");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect(request.getContextPath() + "/payment?error=SystemError");
        }
    }
}
