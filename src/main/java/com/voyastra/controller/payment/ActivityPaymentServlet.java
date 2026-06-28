package com.voyastra.controller.payment;

import com.voyastra.dao.booking.ActivityBookingDAO;
import com.voyastra.model.booking.Booking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/experience/payment-callback")
public class ActivityPaymentServlet extends HttpServlet {
    private ActivityBookingDAO activityBookingDAO;

    @Override
    public void init() throws ServletException {
        activityBookingDAO = new ActivityBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String paymentId = request.getParameter("razorpay_payment_id");
        String orderId = request.getParameter("razorpay_order_id");
        String signature = request.getParameter("razorpay_signature");
        String bookingIdStr = request.getParameter("bookingId");

        // Verify Razorpay signature
        boolean isValid = false;
        try {
            isValid = RazorpayConfig.verifySignature(orderId, paymentId, signature);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isValid) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                activityBookingDAO.updateBookingStatus(bookingId, "CONFIRMED");
                
                Booking cb = (Booking) session.getAttribute("currentBooking");
                if (cb != null) {
                    cb.setStatus("CONFIRMED");
                    cb.setBookingCode(cb.getBookingCode());
                    session.setAttribute("currentBooking", cb);
                    session.setAttribute("paymentAction", null); // Clear it out
                }
                
                // Redirect to generic confirmation page
                response.sendRedirect(request.getContextPath() + "/pages/confirmation.jsp");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/payment?error=InvalidBooking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/payment?error=PaymentVerificationFailed");
        }
    }
}
