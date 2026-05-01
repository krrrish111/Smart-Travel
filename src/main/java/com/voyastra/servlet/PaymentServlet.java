package com.voyastra.servlet;

import com.voyastra.dao.BookingDAO;
import com.voyastra.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/process-payment")
public class PaymentServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String method = request.getParameter("method");

        int bookingId = 0;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (Exception e) {}

        if (bookingId > 0) {
            // Update status to CONFIRMED in DB
            boolean success = bookingDAO.updateBookingStatus(bookingId, "CONFIRMED");
            
            if (success) {
                HttpSession session = request.getSession();
                Booking cb = (Booking) session.getAttribute("currentBooking");
                if(cb != null) cb.setStatus("CONFIRMED");
                session.setAttribute("paymentSuccess", true);
                response.sendRedirect(request.getContextPath() + "/confirmation?id=" + bookingId);
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/payment.jsp?error=Failed to confirm booking.");
            }
        } else {
            // Simulate success (fallback if DB was offline)
            HttpSession session = request.getSession();
            Booking currentBooking = (Booking) session.getAttribute("currentBooking");
            if (currentBooking != null) {
                currentBooking.setStatus("CONFIRMED");
                session.setAttribute("paymentSuccess", true);
                response.sendRedirect(request.getContextPath() + "/confirmation?id=" + currentBooking.getBookingCode());
            } else {
                response.sendRedirect(request.getContextPath() + "/login?error=Invalid booking session.");
            }
        }
    }
}
