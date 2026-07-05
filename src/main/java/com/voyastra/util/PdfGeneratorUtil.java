package com.voyastra.util;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.BarcodeQRCode;
import com.itextpdf.text.pdf.PdfWriter;
import com.voyastra.model.booking.HotelBooking;

import java.io.ByteArrayOutputStream;

public class PdfGeneratorUtil {

    static {
        long begin = com.voyastra.util.StartupProfiler.mark("PdfGeneratorUtil Initialization");
        com.voyastra.util.StartupProfiler.duration("PdfGeneratorUtil Initialization", begin);
    }

    public static byte[] generateHotelVoucherPdf(HotelBooking booking) throws DocumentException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();

        Font logoFont   = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, new BaseColor(249, 115, 22));
        Font titleFont  = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLACK);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);

        // 1. Voyastra Logo
        Paragraph logo = new Paragraph("VOYASTRA", logoFont);
        logo.setAlignment(Element.ALIGN_CENTER);
        document.add(logo);
        
        Paragraph subtitle = new Paragraph("Official Hotel Booking Voucher", titleFont);
        subtitle.setAlignment(Element.ALIGN_CENTER);
        document.add(subtitle);
        document.add(new Paragraph(" "));
        document.add(new Paragraph("---------------------------------------------------------------------------------------------------"));
        document.add(new Paragraph(" "));

        // Booking ID and Date
        document.add(new Paragraph("Booking ID: " + booking.getBookingCode(), headerFont));
        document.add(new Paragraph("Status: " + (booking.getStatus() != null ? booking.getStatus().toUpperCase() : "CONFIRMED"), normalFont));
        document.add(new Paragraph("Date Booked: " + (booking.getCreatedAt() != null ? booking.getCreatedAt() : new java.util.Date()), normalFont));
        document.add(new Paragraph(" "));

        // Guest Name
        document.add(new Paragraph("Guest Details", headerFont));
        document.add(new Paragraph("Name: " + booking.getGuestName(), normalFont));
        document.add(new Paragraph("Email: " + booking.getGuestEmail(), normalFont));
        document.add(new Paragraph("Phone: " + booking.getGuestPhone(), normalFont));
        document.add(new Paragraph("Number of Guests: " + booking.getGuests(), normalFont));
        document.add(new Paragraph(" "));

        // Hotel Name & Room Type
        document.add(new Paragraph("Accommodation Details", headerFont));
        if (booking.getHotel() != null) {
            document.add(new Paragraph("Hotel Name: " + booking.getHotel().getName(), normalFont));
            document.add(new Paragraph("Location: " + booking.getHotel().getCity(), normalFont));
        }
        if (booking.getRoom() != null) {
            document.add(new Paragraph("Room Type: " + booking.getRoom().getType(), normalFont));
        }
        
        // Check-in and Check-out
        document.add(new Paragraph("Check-in: " + booking.getCheckIn(), normalFont));
        document.add(new Paragraph("Check-out: " + booking.getCheckOut(), normalFont));
        document.add(new Paragraph(" "));

        // Add-ons & Special Requests
        if (booking.getSpecialRequests() != null && !booking.getSpecialRequests().isEmpty()) {
            document.add(new Paragraph("Add-ons & Special Requests", headerFont));
            String[] parts = booking.getSpecialRequests().split("\\|");
            for (String part : parts) {
                String trimmed = part.trim();
                if (!trimmed.isEmpty()) {
                    document.add(new Paragraph("  • " + trimmed, normalFont));
                }
            }
            document.add(new Paragraph(" "));
        }

        document.add(new Paragraph("Total Paid: $" + booking.getTotalPrice(), headerFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("---------------------------------------------------------------------------------------------------"));
        document.add(new Paragraph(" "));

        // QR Code
        BarcodeQRCode qrCode = new BarcodeQRCode(
            "voyastra.com/verify?code=" + booking.getBookingCode() + "&name=" + (booking.getGuestName() != null ? booking.getGuestName().replaceAll(" ", "%20") : ""),
            150, 150, null
        );
        Image qrImage = qrCode.getImage();
        qrImage.setAlignment(Element.ALIGN_CENTER);
        document.add(qrImage);
        
        Paragraph qrLabel = new Paragraph("Scan QR to verify booking at reception", new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY));
        qrLabel.setAlignment(Element.ALIGN_CENTER);
        document.add(qrLabel);

        document.add(new Paragraph(" "));
        document.add(new Paragraph("---------------------------------------------------------------------------------------------------"));

        // Support Contact
        Paragraph support = new Paragraph("Need Help?", headerFont);
        support.setAlignment(Element.ALIGN_CENTER);
        document.add(support);
        
        Paragraph contact = new Paragraph("Phone: +1-800-VOYASTRA   |   Email: support@voyastra.com", normalFont);
        contact.setAlignment(Element.ALIGN_CENTER);
        document.add(contact);

        Paragraph footer = new Paragraph("This is a computer generated document. Please present this voucher digitally or physically upon check-in.", new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, BaseColor.GRAY));
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();

        return baos.toByteArray();
    }
}
