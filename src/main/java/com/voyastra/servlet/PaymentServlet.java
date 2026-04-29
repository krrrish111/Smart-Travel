package com.voyastra.servlet;

import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.PaymentDAO;
import com.voyastra.model.Booking;
import com.voyastra.model.Payment;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            HttpSession session = request.getSession();
            Booking pendingBooking = (Booking) session.getAttribute("pendingBooking");
            User user = (User) session.getAttribute("user");
            
            if (pendingBooking == null || user == null) {
                response.sendRedirect("login");
                return;
            }
            
            request.getRequestDispatcher("/pages/payment.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        if ("process".equals(action)) {
            Booking pendingBooking = (Booking) session.getAttribute("pendingBooking");
            User user = (User) session.getAttribute("user");
            
            if (pendingBooking == null || user == null) {
                response.sendRedirect("login");
                return;
            }

            String paymentMethod = request.getParameter("paymentMethod");
            if(paymentMethod == null || paymentMethod.isEmpty()) {
                paymentMethod = "Credit Card";
            }
            
            // Insert the booking first since payment needs a booking_id as foreign key
            // However, the booking status is still "CONFIRMED" because payment is complete
            pendingBooking.setStatus("CONFIRMED");
            int bookingId = bookingDAO.addTripBooking(pendingBooking);
            
            if (bookingId > 0) {
                // Now create payment record
                Payment payment = new Payment(
                    bookingId,
                    user.getId(),
                    pendingBooking.getTotalPrice(),
                    paymentMethod,
                    "COMPLETED",
                    "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase()
                );
                
                paymentDAO.addPayment(payment);
                
                String code = pendingBooking.getBookingCode();
                session.removeAttribute("pendingBooking");
                session.removeAttribute("pendingTrip");
                session.removeAttribute("pendingSubtotal");
                session.removeAttribute("pendingTax");
                
                response.sendRedirect("booking?action=success&code=" + code + "&txId=" + payment.getTransactionId());
            } else {
                request.setAttribute("error", "Payment processed but booking failed. Please contact support.");
                request.getRequestDispatcher("/pages/payment.jsp").forward(request, response);
            }
        }
    }
}
