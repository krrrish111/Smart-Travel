package com.voyastra.servlet;

import com.voyastra.dao.HotelBookingDAO;
import com.voyastra.model.HotelBooking;
import com.voyastra.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/process-hotel-payment")
public class HotelPaymentServlet extends HttpServlet {
    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HotelBooking pending = (HotelBooking) session.getAttribute("pendingHotelBooking");
        if (pending == null) {
            response.sendRedirect("hotels");
            return;
        }

        try {
            // Save the booking to the database
            int bookingId = bookingDAO.createBooking(pending);
            if (bookingId > 0) {
                // Send confirmation email with PDF voucher attached
                EmailUtil.sendHotelBookingConfirmationWithVoucher(pending);

                // Send Twilio SMS Confirmation
                com.voyastra.util.SMSUtil.sendHotelBookingSMS(pending);

                // Clean up all hotel booking session attributes
                session.removeAttribute("pendingHotelBooking");
                session.removeAttribute("pendingAddons");
                session.removeAttribute("currentBooking");
                session.removeAttribute("paymentAction");

                response.sendRedirect(request.getContextPath() + "/hotel-confirmation?id=" + bookingId);
            } else {
                request.setAttribute("error", "Failed to confirm booking after payment.");
                response.sendRedirect(request.getContextPath() + "/pages/payment.jsp?error=PaymentFailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/payment.jsp?error=SystemError");
        }
    }
}
