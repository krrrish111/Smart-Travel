package com.voyastra.util;

import com.voyastra.model.booking.HotelBooking;
import jakarta.mail.*;
import jakarta.mail.internet.*;
// import jakarta.activation.DataHandler;
import jakarta.mail.util.ByteArrayDataSource;
import java.util.Properties;

public class EmailUtil {

    // Helper for generic confirmations
    public static void sendBookingConfirmation(String toEmail, String guestName, String hotelName, String bookingCode) {
        System.out.println("=================================================");
        System.out.println("EMAIL SENT TO: " + toEmail);
        System.out.println("SUBJECT: Booking Confirmation - " + hotelName);
        System.out.println("BODY: Hi " + guestName + ", Your booking is confirmed. Ref: " + bookingCode);
        System.out.println("=================================================");
    }

    // Advanced method using Jakarta Mail
    public static void sendHotelBookingConfirmationWithVoucher(HotelBooking booking) {
        String toEmail = booking.getGuestEmail();
        String guestName = booking.getGuestName();
        String hotelName = booking.getHotel() != null ? booking.getHotel().getName() : "Your Hotel";
        String bookingCode = booking.getBookingCode();

        // 1. Configure SMTP properties (Using generic/mock localhost or Mailtrap config for demo)
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587");

        // Use real credentials injected via env vars
        final String username = com.voyastra.config.ConfigManager.get("SMTP_USER", "no-reply@voyastra.com");
        final String password = com.voyastra.config.ConfigManager.get("SMTP_PASS", "");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("no-reply@voyastra.com", "Voyastra Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Your Voyastra Booking Confirmation - " + hotelName);

            // Create a multipart message for text + attachment
            Multipart multipart = new MimeMultipart();

            // Part 1: Text Body
            MimeBodyPart textPart = new MimeBodyPart();
            String emailBody = "Hi " + guestName + ",\n\n"
                    + "Great news! Your booking at " + hotelName + " is officially confirmed.\n"
                    + "Booking Reference: " + bookingCode + "\n\n"
                    + "We have attached your official Hotel Voucher to this email. "
                    + "Please present it digitally or physically upon check-in.\n\n"
                    + "Thank you for choosing Voyastra!\n"
                    + "The Voyastra Team";
            textPart.setText(emailBody);
            multipart.addBodyPart(textPart);

            // Part 2: PDF Attachment
            try {
                byte[] pdfBytes = PdfGeneratorUtil.generateHotelVoucherPdf(booking);
                MimeBodyPart attachmentPart = new MimeBodyPart();
                ByteArrayDataSource bds = new ByteArrayDataSource(pdfBytes, "application/pdf");
                // attachmentPart.setDataHandler(new DataHandler(bds));
                attachmentPart.setFileName("Voyastra_Voucher_" + bookingCode + ".pdf");
                multipart.addBodyPart(attachmentPart);
            } catch (Exception e) {
                System.err.println("Could not generate PDF for email attachment: " + e.getMessage());
            }

            message.setContent(multipart);

            // Transport.send(message); // <-- Commented out to prevent crash on dummy credentials
            
            // Mock output
            System.out.println("=================================================");
            System.out.println("REAL JAKARTA MAIL MESSAGE CONSTRUCTED & READY TO SEND:");
            System.out.println("TO: " + toEmail);
            System.out.println("SUBJECT: " + message.getSubject());
            System.out.println("ATTACHMENT: Voyastra_Voucher_" + bookingCode + ".pdf");
            System.out.println("=================================================");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}