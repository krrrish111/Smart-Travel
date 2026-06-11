package com.voyastra.servlet;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.BarcodeQRCode;
import com.itextpdf.text.pdf.PdfWriter;
import com.voyastra.dao.HotelBookingDAO;
import com.voyastra.model.HotelBooking;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/hotel-voucher")
public class HotelVoucherServlet extends HttpServlet {
    private HotelBookingDAO bookingDAO = new HotelBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("profile?tab=bookings");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            HotelBooking booking = bookingDAO.getBookingById(id);
            User user = (User) session.getAttribute("user");

            if (booking == null || booking.getUserId() != user.getId()) {
                response.sendRedirect("profile?tab=bookings");
                return;
            }

            double total = booking.getTotalPrice();
            double baseAmount = total / 1.18;
            double taxAmount = total - baseAmount;

            request.setAttribute("booking", booking);
            request.setAttribute("baseAmount", String.format("%.2f", baseAmount));
            request.setAttribute("taxAmount", String.format("%.2f", taxAmount));
            request.setAttribute("bookingType", "HOTEL");

            request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("profile?tab=bookings");
        }
    }
}
