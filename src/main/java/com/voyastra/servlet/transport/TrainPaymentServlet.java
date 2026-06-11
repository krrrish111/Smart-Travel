package com.voyastra.servlet.transport;

import com.voyastra.dao.TrainBookingDAO;
import com.voyastra.model.TrainBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/train/payment-callback")
public class TrainPaymentServlet extends HttpServlet {
    private TrainBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new TrainBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!RazorpayConfig.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("Razorpay signature verification failed!");
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Payment%20Verification%20Failed");
            return;
        }

        TrainBooking draft = (TrainBooking) request.getSession().getAttribute("currentTrainBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            // Save to database only after successful payment
            boolean saved = bookingDAO.saveDraft(draft);
            if (saved) {
                // Payment and DB save successful
                response.sendRedirect(request.getContextPath() + "/transport/train/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
