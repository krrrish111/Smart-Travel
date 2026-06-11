package com.voyastra.servlet.transport;

import com.voyastra.dao.CruiseBookingDAO;
import com.voyastra.model.CruiseBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cruise/payment-callback")
public class CruisePaymentServlet extends HttpServlet {
    private CruiseBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new CruiseBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!RazorpayConfig.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Payment%20Verification%20Failed");
            return;
        }

        CruiseBooking draft = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            if (bookingDAO.saveBooking(draft)) {
                response.sendRedirect(request.getContextPath() + "/transport/cruise/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
