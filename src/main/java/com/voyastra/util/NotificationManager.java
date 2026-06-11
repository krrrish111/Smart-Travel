package com.voyastra.util;

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
        String travelDate = "TBD";
        String title = "";
        String type = "";

        if (bookingObj instanceof com.voyastra.model.TrainBooking) {
            com.voyastra.model.TrainBooking b = (com.voyastra.model.TrainBooking) bookingObj;
            pnr = b.getId();
            title = b.getTrainNumber();
            type = "Train";
        } else if (bookingObj instanceof com.voyastra.model.BusBooking) {
            com.voyastra.model.BusBooking b = (com.voyastra.model.BusBooking) bookingObj;
            pnr = b.getId();
            title = b.getBusName();
            type = "Bus";
        } else if (bookingObj instanceof com.voyastra.model.CabBooking) {
            com.voyastra.model.CabBooking b = (com.voyastra.model.CabBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getDate();
            title = b.getVehicleType();
            type = "Cab";
        } else if (bookingObj instanceof com.voyastra.model.CarBooking) {
            com.voyastra.model.CarBooking b = (com.voyastra.model.CarBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getPickupDate();
            title = b.getCarModel();
            type = "Self Drive Car";
        } else if (bookingObj instanceof com.voyastra.model.CruiseBooking) {
            com.voyastra.model.CruiseBooking b = (com.voyastra.model.CruiseBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getCruiseDate();
            title = b.getShipName();
            type = "Cruise";
        } else if (bookingObj instanceof com.voyastra.model.HelicopterBooking) {
            com.voyastra.model.HelicopterBooking b = (com.voyastra.model.HelicopterBooking) bookingObj;
            pnr = b.getId();
            travelDate = b.getTravelDate();
            title = "Helicopter (" + b.getFlightType() + ")";
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
