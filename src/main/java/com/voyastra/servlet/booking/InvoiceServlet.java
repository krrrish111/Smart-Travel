package com.voyastra.servlet.booking;

import com.voyastra.dao.BookingDAO;
import com.voyastra.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=invoice?code=" + request.getParameter("code"));
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String code = request.getParameter("code");

        if (code == null || code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=invalid_invoice");
            return;
        }

        Booking booking = bookingDAO.getBookingByCode(code);
        
        if (booking == null || booking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=not_found");
            return;
        }

        // GST Calculation (Assuming 18% IGST on the total price for simplicity, or reverse calculating)
        // Reverse calculation: Total = Base + 18% GST => Base = Total / 1.18
        double total = booking.getTotalPrice();
        double baseAmount = total / 1.18;
        double gstAmount = total - baseAmount;

        request.setAttribute("booking", booking);
        request.setAttribute("baseAmount", String.format("%.2f", baseAmount));
        request.setAttribute("gstAmount", String.format("%.2f", gstAmount));

        request.getRequestDispatcher("/pages/booking/invoice.jsp").forward(request, response);
    }
}
