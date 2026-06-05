package com.voyastra.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Production-ready Email Service using Jakarta Mail.
 * Configuration can be externalized to environment variables or a properties file.
 */
public class EmailService {

    // --- Configuration (Environment Variables preferred in Production) ---
    private static final String SMTP_HOST = System.getenv("SMTP_HOST") != null ? System.getenv("SMTP_HOST") : "smtp.gmail.com";
    private static final String SMTP_PORT = System.getenv("SMTP_PORT") != null ? System.getenv("SMTP_PORT") : "587";
    private static final String SMTP_USER = System.getenv("SMTP_USER") != null ? System.getenv("SMTP_USER") : "voyastra.travel@gmail.com"; 
    private static final String SMTP_PASS = System.getenv("SMTP_PASS") != null ? System.getenv("SMTP_PASS") : "your-app-password";         
    private static final String FROM_EMAIL = System.getenv("FROM_EMAIL") != null ? System.getenv("FROM_EMAIL") : "no-reply@voyastra.com";
    private static final String FROM_NAME  = "Voyastra Travel";

    private static final Properties props = new Properties();

    static {
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.debug", "false"); // Set to true for troubleshooting
    }

    /**
     * Sends a plain HTML email.
     */
    public static void sendEmail(String to, String subject, String htmlContent) {
        // Run in a thread to prevent blocking the web request
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
                message.setContent(htmlContent, "text/html; charset=utf-8");

                Transport.send(message);
                System.out.println("[EMAIL] Sent successfully to: " + to);

            } catch (Exception e) {
                System.err.println("[EMAIL ERROR] Failed to send to " + to + ": " + e.getMessage());
            }
        }).start();
    }

    public static void sendWelcomeEmail(String to, String name, String verifyLink) {
        String html = "<html><body style='font-family: Arial, sans-serif; color: #333;'>" +
                "<h1>Welcome to Voyastra, " + name + "!</h1>" +
                "<p>We're thrilled to have you join our community of world explorers.</p>" +
                "<p>Please click the button below to verify your email address and unlock all features:</p>" +
                "<div style='margin: 20px 0;'>" +
                "<a href='" + verifyLink + "' style='background-color: #3b82f6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: bold;'>Verify My Account</a>" +
                "</div>" +
                "<p>If the button doesn't work, copy and paste this link: <br>" + verifyLink + "</p>" +
                "<br><p>Happy Travels,<br>The Voyastra Team</p>" +
                "</body></html>";
        sendEmail(to, "Confirm your Voyastra Account", html);
    }

    public static void sendPasswordResetEmail(String to, String resetLink) {
        String html = "<html><body style='font-family: Arial, sans-serif;'>" +
                "<h2>Password Reset Request</h2>" +
                "<p>We received a request to reset your Voyastra password.</p>" +
                "<p>Click the link below to set a new password. This link is valid for 1 hour.</p>" +
                "<div style='margin: 20px 0;'>" +
                "<a href='" + resetLink + "' style='background-color: #1f2937; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;'>Reset Password</a>" +
                "</div>" +
                "<p>If you didn't request this, you can safely ignore this email.</p>" +
                "</body></html>";
        sendEmail(to, "Reset your Voyastra Password", html);
    }

    public static void sendTicketEmail(String to, java.io.InputStream pdfData, String fileName) {
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
                message.setSubject("Voyastra Flight Ticket");

                jakarta.mail.internet.MimeBodyPart textPart = new jakarta.mail.internet.MimeBodyPart();
                textPart.setText("Thank you for booking with Voyastra Airlines!\n\nPlease find your e-ticket attached to this email. You can present this boarding pass at the counter.\n\nSafe travels,\nThe Voyastra Team");

                jakarta.mail.internet.MimeBodyPart attachmentPart = new jakarta.mail.internet.MimeBodyPart();
                
                // Write InputStream to a temporary file because raw byte[] content might throw UnsupportedDataTypeException without jakarta.activation DataHandler
                java.io.File tempFile = java.io.File.createTempFile("ticket_", ".pdf");
                tempFile.deleteOnExit();
                try (java.io.FileOutputStream out = new java.io.FileOutputStream(tempFile)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = pdfData.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
                attachmentPart.attachFile(tempFile);
                attachmentPart.setFileName(fileName);

                Multipart multipart = new jakarta.mail.internet.MimeMultipart();
                multipart.addBodyPart(textPart);
                multipart.addBodyPart(attachmentPart);

                message.setContent(multipart);
                
                // If using dummy credentials, skip Transport.send to avoid exception spam
                if (!"your-app-password".equals(SMTP_PASS)) {
                    Transport.send(message);
                    System.out.println("[EMAIL] Ticket sent successfully to: " + to);
                } else {
                    System.out.println("[EMAIL MOCK] Ticket email 'sent' (using dummy credentials). Attachment length: " + tempFile.length() + " bytes.");
                }
            } catch (Exception e) {
                System.err.println("[EMAIL ERROR] Failed to send ticket to " + to + ": " + e.getMessage());
            }
        }).start();
    }
}
