package com.voyastra.util;

import com.voyastra.dao.NotificationDAO;
import com.voyastra.dao.profile.UserDAO;
import com.voyastra.model.Notification;
import com.voyastra.model.profile.User;

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
        String travelDate = "TBD";
        String title = "";
        String type = "";

        if (bookingObj instanceof com.voyastra.model.booking.TrainBooking) {
            com.voyastra.model.booking.TrainBooking b = (com.voyastra.model.booking.TrainBooking) bookingObj;
            pnr = b.getId();
            title = b.getTrainNumber();
            type = "Train";
        } else if (bookingObj instanceof com.voyastra.model.booking.BusBooking) {
            com.voyastra.model.booking.BusBooking b = (com.voyastra.model.booking.BusBooking) bookingObj;
            pnr = b.getId();
            title = b.getBusName();
            type = "Bus";
        } else if (bookingObj instanceof com.voyastra.model.booking.CabBooking) {
            com.voyastra.model.booking.CabBooking b = (com.voyastra.model.booking.CabBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getDate();
            title = b.getVehicleType();
            type = "Cab";
        } else if (bookingObj instanceof com.voyastra.model.booking.CarBooking) {
            com.voyastra.model.booking.CarBooking b = (com.voyastra.model.booking.CarBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getPickupDate();
            title = b.getCarModel();
            type = "Self Drive Car";
        } else if (bookingObj instanceof com.voyastra.model.booking.CruiseBooking) {
            com.voyastra.model.booking.CruiseBooking b = (com.voyastra.model.booking.CruiseBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getCruiseDate();
            title = b.getShipName();
            type = "Cruise";
        } else if (bookingObj instanceof com.voyastra.model.booking.HelicopterBooking) {
            com.voyastra.model.booking.HelicopterBooking b = (com.voyastra.model.booking.HelicopterBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getTravelDate();
            title = "Helicopter (" + b.getFlightType() + ")";
            type = "Helicopter";
        } else if (bookingObj instanceof com.voyastra.model.booking.FlightBooking) {
            com.voyastra.model.booking.FlightBooking b = (com.voyastra.model.booking.FlightBooking) bookingObj;
            b.parseDetails();
            pnr = b.getBookingCode();
            travelDate = b.getTravelDate();
            title = b.getAirlineName() + " (" + b.getFlightNumber() + ")";
            type = "Flight";
        } else if (bookingObj instanceof com.voyastra.model.booking.HotelBooking) {
            com.voyastra.model.booking.HotelBooking b = (com.voyastra.model.booking.HotelBooking) bookingObj;
            pnr = b.getBookingCode();
            travelDate = b.getCheckIn() != null ? b.getCheckIn().toString() : "TBD";
            title = (b.getHotel() != null ? b.getHotel().getName() : "Premium Hotel") + " (" + (b.getRoom() != null ? b.getRoom().getType() : "Standard Room") + ")";
            type = "Hotel";
        } else {
            System.err.println("[NotificationManager] Unsupported booking type");
            return;
        }

        // 1. In-App Notification
        Notification n = new Notification(userId, type + " Booking Confirmed", "Your " + type + " booking (" + title + ") for " + travelDate + " is confirmed. PNR/Ref: " + pnr);
        long tNotifyDAOStart = System.currentTimeMillis();
        boolean notifySaved = notificationDAO.addNotification(n);
        long tNotifyDAODuration = System.currentTimeMillis() - tNotifyDAOStart;
        com.voyastra.util.ObservabilityLogger.logStep("NotificationDAO", "addNotification", notifySaved ? "SUCCESS" : "ERROR", tNotifyDAODuration, "Save in-app notification in DB", userId, pnr);

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
            long tPdfStart = System.currentTimeMillis();
            byte[] ticketPdfBytes;
            String pdfFileName;
            if (bookingObj instanceof com.voyastra.model.booking.HotelBooking) {
                ticketPdfBytes = PdfGeneratorUtil.generateHotelVoucherPdf((com.voyastra.model.booking.HotelBooking) bookingObj);
                pdfFileName = "Voucher_" + pnr + ".pdf";
            } else {
                ticketPdfBytes = TransportPdfGenerator.generateGenericTicketPdf(bookingObj, user);
                pdfFileName = "Ticket_" + pnr + ".pdf";
            }
            byte[] invoicePdfBytes = TransportPdfGenerator.generateGenericInvoicePdf(bookingObj, user);
            long tPdfDuration = System.currentTimeMillis() - tPdfStart;
            com.voyastra.util.ObservabilityLogger.logStep("TransportPdfGenerator", "generatePDFs", "SUCCESS", tPdfDuration, "Generate ticket and invoice PDFs", userId, pnr);

            List<EmailService.EmailAttachment> attachments = new ArrayList<>();
            attachments.add(new EmailService.EmailAttachment(pdfFileName, new ByteArrayInputStream(ticketPdfBytes)));
            attachments.add(new EmailService.EmailAttachment("Invoice_" + pnr + ".pdf", new ByteArrayInputStream(invoicePdfBytes)));

            long tEmailStart = System.currentTimeMillis();
            EmailService.sendEmailWithAttachments(user.getEmail(), type + " Booking Confirmation - " + pnr, htmlBody, attachments);
            long tEmailDuration = System.currentTimeMillis() - tEmailStart;
            com.voyastra.util.ObservabilityLogger.logStep("EmailService", "sendEmailWithAttachments", "SUCCESS", tEmailDuration, "Send confirmation email to: " + user.getEmail(), userId, pnr);

        } catch (Exception e) {
            com.voyastra.util.ObservabilityLogger.logError("NotificationManager", "PDF_Email_Dispatch", e, userId, pnr);
            System.err.println("[NotificationManager] Error generating PDFs or sending email: " + e.getMessage());
        }

        // 3. SMS
        long tSmsStart = System.currentTimeMillis();
        SMSService.sendBookingConfirmationSMS(user.getPhone(), pnr, title, travelDate);
        long tSmsDuration = System.currentTimeMillis() - tSmsStart;
        com.voyastra.util.ObservabilityLogger.logStep("SMSService", "sendBookingConfirmationSMS", "SUCCESS", tSmsDuration, "Send SMS to: " + user.getPhone(), userId, pnr);
    }
}
