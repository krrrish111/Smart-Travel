package com.voyastra.util;

public class EmailUtil {
    public static void sendBookingConfirmation(String toEmail, String guestName, String hotelName, String bookingCode) {
        // Mock email sending
        System.out.println("=================================================");
        System.out.println("EMAIL SENT TO: " + toEmail);
        System.out.println("SUBJECT: Booking Confirmation - " + hotelName);
        System.out.println("BODY:");
        System.out.println("Hi " + guestName + ",");
        System.out.println("Your booking at " + hotelName + " is confirmed!");
        System.out.println("Booking Reference: " + bookingCode);
        System.out.println("Thank you for choosing Voyastra.");
        System.out.println("=================================================");
    }
}