package com.voyastra.controller.payment;

import com.voyastra.dao.payment.RefundDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.voyastra.model.payment.Refund;
import com.voyastra.dao.booking.HotelBookingDAO;
import com.voyastra.model.booking.HotelBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/refund-status")
public class RefundTrackingServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(RefundTrackingServlet.class.getName());

    private final RefundDAO refundDAO = new RefundDAO();
    private final HotelBookingDAO hotelBookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int bookingId = Integer.parseInt(idStr);
                Refund refund = refundDAO.getRefundByBookingId(bookingId);
                
                if (refund != null) {
                    HotelBooking hb = hotelBookingDAO.getBookingById(bookingId);
                    request.setAttribute("refund", refund);
                    request.setAttribute("booking", hb);
                    request.getRequestDispatcher("/pages/payment/refund-status.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Exception occurred", e);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=refund_not_found");
    }
}
