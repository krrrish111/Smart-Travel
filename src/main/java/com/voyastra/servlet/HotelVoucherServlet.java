package com.voyastra.servlet;

import com.itextpdf.text.BaseColor;
import java.util.logging.Logger;
import java.util.logging.Level;
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
    private static final Logger logger = Logger.getLogger(HotelVoucherServlet.class.getName());

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

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Hotel_Voucher_" + booking.getBookingCode() + ".pdf\"");

            byte[] pdfBytes = com.voyastra.util.PdfGeneratorUtil.generateHotelVoucherPdf(booking);
            response.getOutputStream().write(pdfBytes);

        } catch (NumberFormatException | com.itextpdf.text.DocumentException e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.sendRedirect("profile?tab=bookings");
        }
    }
}
