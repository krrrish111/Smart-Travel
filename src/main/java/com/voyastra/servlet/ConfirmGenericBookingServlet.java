package com.voyastra.servlet;

import com.voyastra.dao.BookingDAO;
import com.voyastra.model.Booking;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/confirm-booking")
public class ConfirmGenericBookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Booking currentBooking = (Booking) session.getAttribute("currentBooking");
        
        if (currentBooking == null || !"experience".equals(currentBooking.getType())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Generate unique booking code
        String bookingCode = "EXP-" + System.currentTimeMillis();
        currentBooking.setBookingCode(bookingCode);
        currentBooking.setUserId(user.getId());
        currentBooking.setStatus("PENDING");
        
        // Save generic booking to DB
        int bookingId = bookingDAO.createBooking(currentBooking);
        
        if (bookingId > 0) {
            currentBooking.setId(bookingId);
        }

        session.setAttribute("currentBooking", currentBooking);
        session.setAttribute("paymentAction", "process-payment");
        
        // Redirect to generic payment page
        response.sendRedirect(request.getContextPath() + "/pages/payment.jsp?id=" + bookingId);
    }
}
