import os
import re

# 1. Update EmailService.java
email_service_path = 'src/main/java/com/voyastra/util/EmailService.java'
with open(email_service_path, 'r', encoding='utf-8') as f:
    email_content = f.read()

new_email_method = """
    public static class EmailAttachment {
        public String fileName;
        public java.io.InputStream dataStream;
        public EmailAttachment(String fileName, java.io.InputStream dataStream) {
            this.fileName = fileName;
            this.dataStream = dataStream;
        }
    }

    public static void sendEmailWithAttachments(String to, String subject, String htmlContent, java.util.List<EmailAttachment> attachments) {
        new Thread(() -> {
            try {
                Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
                    }
                });

                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
                message.setSubject(subject);

                Multipart multipart = new jakarta.mail.internet.MimeMultipart();

                // Body part
                jakarta.mail.internet.MimeBodyPart textPart = new jakarta.mail.internet.MimeBodyPart();
                textPart.setContent(htmlContent, "text/html; charset=utf-8");
                multipart.addBodyPart(textPart);

                // Attachments
                long totalAttachmentSize = 0;
                for (EmailAttachment attachment : attachments) {
                    jakarta.mail.internet.MimeBodyPart attachmentPart = new jakarta.mail.internet.MimeBodyPart();
                    java.io.File tempFile = java.io.File.createTempFile("attach_", ".pdf");
                    tempFile.deleteOnExit();
                    try (java.io.FileOutputStream out = new java.io.FileOutputStream(tempFile)) {
                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = attachment.dataStream.read(buffer)) != -1) {
                            out.write(buffer, 0, bytesRead);
                        }
                    }
                    totalAttachmentSize += tempFile.length();
                    attachmentPart.attachFile(tempFile);
                    attachmentPart.setFileName(attachment.fileName);
                    multipart.addBodyPart(attachmentPart);
                }

                message.setContent(multipart);

                if (!"your-app-password".equals(SMTP_PASS)) {
                    Transport.send(message);
                    System.out.println("[EMAIL] Sent successfully with attachments to: " + to);
                } else {
                    System.out.println("[EMAIL MOCK] Email with " + attachments.size() + " attachments sent (Total size: " + totalAttachmentSize + " bytes).");
                }
            } catch (Exception e) {
                System.err.println("[EMAIL ERROR] Failed to send email with attachments to " + to + ": " + e.getMessage());
            }
        }).start();
    }
}
"""

if "sendEmailWithAttachments" not in email_content:
    # Replace the last closing brace with the new method and a closing brace
    email_content = email_content.rsplit('}', 1)[0] + new_email_method
    with open(email_service_path, 'w', encoding='utf-8') as f:
        f.write(email_content)
    print("Updated EmailService.java")
else:
    print("EmailService.java already updated")


# 2. Create NotificationManager.java
notification_manager_content = """package com.voyastra.util;

import com.voyastra.dao.NotificationDAO;
import com.voyastra.dao.UserDAO;
import com.voyastra.model.Notification;
import com.voyastra.model.User;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;

public class NotificationManager {

    private static final NotificationDAO notificationDAO = new NotificationDAO();
    private static final UserDAO userDAO = new UserDAO();

    public static void sendTransportBookingSuccess(Object bookingObj, int userId) {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            System.err.println("[NotificationManager] User not found for ID: " + userId);
            return;
        }

        String pnr = "";
        String travelDate = "";
        String title = "";
        String type = "";

        if (bookingObj instanceof com.voyastra.model.TrainBooking) {
            com.voyastra.model.TrainBooking b = (com.voyastra.model.TrainBooking) bookingObj;
            pnr = b.getPnr();
            travelDate = b.getTravelDate();
            title = b.getTrainName();
            type = "Train";
        } else if (bookingObj instanceof com.voyastra.model.BusBooking) {
            com.voyastra.model.BusBooking b = (com.voyastra.model.BusBooking) bookingObj;
            pnr = b.getPnr();
            travelDate = b.getTravelDate();
            title = b.getOperator();
            type = "Bus";
        } else if (bookingObj instanceof com.voyastra.model.CabBooking) {
            com.voyastra.model.CabBooking b = (com.voyastra.model.CabBooking) bookingObj;
            pnr = b.getBookingRef();
            travelDate = b.getPickupDate();
            title = b.getVehicleModel();
            type = "Cab";
        } else if (bookingObj instanceof com.voyastra.model.CarBooking) {
            com.voyastra.model.CarBooking b = (com.voyastra.model.CarBooking) bookingObj;
            pnr = b.getBookingRef();
            travelDate = b.getPickupDate();
            title = b.getVehicleModel();
            type = "Self Drive Car";
        } else if (bookingObj instanceof com.voyastra.model.CruiseBooking) {
            com.voyastra.model.CruiseBooking b = (com.voyastra.model.CruiseBooking) bookingObj;
            pnr = b.getBookingRef();
            travelDate = b.getCruiseDate();
            title = b.getCruiseLine();
            type = "Cruise";
        } else if (bookingObj instanceof com.voyastra.model.HelicopterBooking) {
            com.voyastra.model.HelicopterBooking b = (com.voyastra.model.HelicopterBooking) bookingObj;
            pnr = b.getBookingRef();
            travelDate = b.getTravelDate();
            title = "Helicopter (" + b.getFlightClass() + ")";
            type = "Helicopter";
        } else {
            System.err.println("[NotificationManager] Unsupported booking type");
            return;
        }

        // 1. In-App Notification
        Notification n = new Notification(userId, type + " Booking Confirmed", "Your " + type + " booking (" + title + ") for " + travelDate + " is confirmed. PNR/Ref: " + pnr);
        notificationDAO.addNotification(n);

        // 2. Email with PDFs
        String htmlBody = "<html><body style='font-family: Arial, sans-serif;'>" +
                "<h2>" + type + " Booking Confirmed!</h2>" +
                "<p>Hi " + user.getName() + ",</p>" +
                "<p>Your " + type.toLowerCase() + " booking is successfully confirmed.</p>" +
                "<ul>" +
                "<li><b>Booking ID/PNR:</b> " + pnr + "</li>" +
                "<li><b>Travel Date:</b> " + travelDate + "</li>" +
                "<li><b>Details:</b> " + title + "</li>" +
                "</ul>" +
                "<p>We have attached your official Ticket and Invoice to this email.</p>" +
                "<p>Safe travels,<br>The Voyastra Team</p>" +
                "</body></html>";

        try {
            byte[] ticketPdfBytes = TransportPdfGenerator.generateGenericTicketPdf(bookingObj, user);
            byte[] invoicePdfBytes = TransportPdfGenerator.generateGenericInvoicePdf(bookingObj, user);

            List<EmailService.EmailAttachment> attachments = new ArrayList<>();
            attachments.add(new EmailService.EmailAttachment("Ticket_" + pnr + ".pdf", new ByteArrayInputStream(ticketPdfBytes)));
            attachments.add(new EmailService.EmailAttachment("Invoice_" + pnr + ".pdf", new ByteArrayInputStream(invoicePdfBytes)));

            EmailService.sendEmailWithAttachments(user.getEmail(), type + " Booking Confirmation - " + pnr, htmlBody, attachments);

        } catch (Exception e) {
            System.err.println("[NotificationManager] Error generating PDFs: " + e.getMessage());
        }

        // 3. SMS
        SMSService.sendBookingConfirmationSMS(user.getPhone(), pnr, title, travelDate);
    }
}
"""
os.makedirs('src/main/java/com/voyastra/util', exist_ok=True)
with open('src/main/java/com/voyastra/util/NotificationManager.java', 'w', encoding='utf-8') as f:
    f.write(notification_manager_content)
print("Created NotificationManager.java")

# 3. Create TransportPdfGenerator.java
pdf_gen_content = """package com.voyastra.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import com.voyastra.model.User;

import java.io.ByteArrayOutputStream;

public class TransportPdfGenerator {

    public static byte[] generateGenericTicketPdf(Object bookingObj, User user) throws DocumentException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();

        Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);

        document.add(new Paragraph("VOYASTRA E-TICKET", headerFont));
        document.add(new Paragraph("Passenger: " + user.getName(), normalFont));
        
        String pnr = getPnr(bookingObj);
        document.add(new Paragraph("PNR / Booking Ref: " + pnr, normalFont));
        document.add(new Paragraph("Type: " + bookingObj.getClass().getSimpleName(), normalFont));
        document.add(new Paragraph("Status: CONFIRMED", normalFont));

        document.add(new Paragraph("--------------------------------------------------"));
        document.add(new Paragraph("Thank you for booking with Voyastra!", normalFont));
        
        document.close();
        return baos.toByteArray();
    }

    public static byte[] generateGenericInvoicePdf(Object bookingObj, User user) throws DocumentException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();

        Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);

        document.add(new Paragraph("TAX INVOICE", headerFont));
        document.add(new Paragraph("Customer: " + user.getName(), normalFont));
        
        String pnr = getPnr(bookingObj);
        document.add(new Paragraph("Invoice Number: INV-" + pnr, normalFont));
        document.add(new Paragraph("Booking Ref: " + pnr, normalFont));
        document.add(new Paragraph("Date: " + new java.util.Date().toString(), normalFont));

        document.add(new Paragraph("--------------------------------------------------"));
        document.add(new Paragraph("Amount Paid: Confirmed", normalFont));
        
        document.close();
        return baos.toByteArray();
    }
    
    private static String getPnr(Object bookingObj) {
        if (bookingObj instanceof com.voyastra.model.TrainBooking) {
            return ((com.voyastra.model.TrainBooking) bookingObj).getPnr();
        } else if (bookingObj instanceof com.voyastra.model.BusBooking) {
            return ((com.voyastra.model.BusBooking) bookingObj).getPnr();
        } else if (bookingObj instanceof com.voyastra.model.CabBooking) {
            return ((com.voyastra.model.CabBooking) bookingObj).getBookingRef();
        } else if (bookingObj instanceof com.voyastra.model.CarBooking) {
            return ((com.voyastra.model.CarBooking) bookingObj).getBookingRef();
        } else if (bookingObj instanceof com.voyastra.model.CruiseBooking) {
            return ((com.voyastra.model.CruiseBooking) bookingObj).getBookingRef();
        } else if (bookingObj instanceof com.voyastra.model.HelicopterBooking) {
            return ((com.voyastra.model.HelicopterBooking) bookingObj).getBookingRef();
        }
        return "UNKNOWN";
    }
}
"""
with open('src/main/java/com/voyastra/util/TransportPdfGenerator.java', 'w', encoding='utf-8') as f:
    f.write(pdf_gen_content)
print("Created TransportPdfGenerator.java")

# 4. Update Servlets
def update_payment_servlet(servlet_path, attr_name):
    if not os.path.exists(servlet_path):
        return
    with open(servlet_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add import
    if "import com.voyastra.util.NotificationManager;" not in content:
        content = content.replace("import com.voyastra.util.RazorpayConfig;", "import com.voyastra.util.RazorpayConfig;\nimport com.voyastra.util.NotificationManager;")
    
    # Add notification call
    old_code = 'draft.setStatus("CONFIRMED");\n            // Save to database only after successful payment\n            boolean saved = bookingDAO.saveDraft(draft);'
    new_code = 'draft.setStatus("CONFIRMED");\n            // Save to database only after successful payment\n            boolean saved = bookingDAO.saveDraft(draft);\n            if (saved) {\n                NotificationManager.sendTransportBookingSuccess(draft, draft.getUserId());\n            }'
    
    if "NotificationManager.sendTransportBookingSuccess" not in content:
        content = content.replace(old_code, new_code)
        with open(servlet_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {os.path.basename(servlet_path)}")

update_payment_servlet('src/main/java/com/voyastra/servlet/transport/TrainPaymentServlet.java', 'currentTrainBooking')
update_payment_servlet('src/main/java/com/voyastra/servlet/transport/BusPaymentServlet.java', 'currentBusBooking')
update_payment_servlet('src/main/java/com/voyastra/servlet/transport/CabPaymentServlet.java', 'currentCabBooking')
update_payment_servlet('src/main/java/com/voyastra/servlet/transport/CarPaymentServlet.java', 'currentCarBooking')
update_payment_servlet('src/main/java/com/voyastra/servlet/transport/CruisePaymentServlet.java', 'currentCruiseBooking')
update_payment_servlet('src/main/java/com/voyastra/servlet/transport/HelicopterPaymentServlet.java', 'currentHelicopterBooking')

