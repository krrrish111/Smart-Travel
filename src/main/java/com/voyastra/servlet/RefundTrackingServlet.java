package com.voyastra.servlet;

import com.voyastra.dao.RefundDAO;
import com.voyastra.model.Refund;
import com.voyastra.dao.HotelBookingDAO;
import com.voyastra.model.HotelBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/refund-status")
public class RefundTrackingServlet extends HttpServlet {
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
                    request.getRequestDispatcher("/pages/refund-status.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=refund_not_found");
    }
}
