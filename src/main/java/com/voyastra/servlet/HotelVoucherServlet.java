package com.voyastra.servlet;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
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

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Hotel_Voucher_" + booking.getBookingCode() + ".pdf\"");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());

            document.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);

            document.add(new Paragraph("Voyastra Hotel Booking Voucher", titleFont));
            document.add(new Paragraph(" "));
            
            document.add(new Paragraph("Booking Reference: " + booking.getBookingCode(), headerFont));
            document.add(new Paragraph("Status: " + booking.getStatus(), normalFont));
            document.add(new Paragraph("Date Booked: " + booking.getCreatedAt(), normalFont));
            document.add(new Paragraph(" "));
            
            document.add(new Paragraph("Hotel Details", headerFont));
            if (booking.getHotel() != null) {
                document.add(new Paragraph("Hotel Name: " + booking.getHotel().getName(), normalFont));
                document.add(new Paragraph("Location: " + booking.getHotel().getCity(), normalFont));
            }
            if (booking.getRoom() != null) {
                document.add(new Paragraph("Room Type: " + booking.getRoom().getType(), normalFont));
            }
            document.add(new Paragraph(" "));

            document.add(new Paragraph("Guest Details", headerFont));
            document.add(new Paragraph("Name: " + booking.getGuestName(), normalFont));
            document.add(new Paragraph("Email: " + booking.getGuestEmail(), normalFont));
            document.add(new Paragraph("Phone: " + booking.getGuestPhone(), normalFont));
            document.add(new Paragraph("Guests: " + booking.getGuests(), normalFont));
            document.add(new Paragraph(" "));

            document.add(new Paragraph("Stay Details", headerFont));
            document.add(new Paragraph("Check-in: " + booking.getCheckIn(), normalFont));
            document.add(new Paragraph("Check-out: " + booking.getCheckOut(), normalFont));
            document.add(new Paragraph("Total Price: $" + booking.getTotalPrice(), headerFont));
            document.add(new Paragraph(" "));

            // Add-ons & Special Requests
            if (booking.getSpecialRequests() != null && !booking.getSpecialRequests().isEmpty()) {
                document.add(new Paragraph("Add-ons & Special Requests", headerFont));
                String[] parts = booking.getSpecialRequests().split("\\|");
                for (String part : parts) {
                    String trimmed = part.trim();
                    if (!trimmed.isEmpty()) {
                        document.add(new Paragraph("  " + trimmed, normalFont));
                    }
                }
                document.add(new Paragraph(" "));
            }

            document.add(new Paragraph("--------------------------------------------------", normalFont));
            document.add(new Paragraph("Thank you for choosing Voyastra!", headerFont));
            document.add(new Paragraph("For support: support@voyastra.com", normalFont));
            document.add(new Paragraph("This is your official booking voucher. Please present it at check-in.", normalFont));
            
            document.close();
            
        } catch (NumberFormatException | DocumentException e) {
            e.printStackTrace();
            response.sendRedirect("profile?tab=bookings");
        }
    }
}
