package com.voyastra.util;

// import com.twilio.Twilio;
// import com.twilio.rest.api.v2010.account.Message;
// import com.twilio.type.PhoneNumber;
import com.voyastra.model.HotelBooking;

public class SMSUtil {

    // Dummy credentials - in a real app, these should be injected via environment variables
    public static final String ACCOUNT_SID = "AC_dummy_account_sid_replace_in_prod";
    public static final String AUTH_TOKEN = "dummy_auth_token_replace_in_prod";
    public static final String TWILIO_PHONE_NUMBER = "+1800VOYASTRA";
    public static final String SUPPORT_NUMBER = "+1-800-VOYASTRA";

    public static void sendHotelBookingSMS(HotelBooking booking) {
        String guestPhone = booking.getGuestPhone();
        if (guestPhone == null || guestPhone.trim().isEmpty()) {
            System.err.println("Cannot send SMS: Guest phone number is missing.");
            return;
        }

        String hotelName = booking.getHotel() != null ? booking.getHotel().getName() : "Your Hotel";
        String bookingCode = booking.getBookingCode();
        String checkInDate = booking.getCheckIn() != null ? booking.getCheckIn().toString() : "TBD";

        String smsBody = "Voyastra: Hotel Booking Confirmed!\n"
                       + "Booking ID: " + bookingCode + "\n"
                       + "Hotel: " + hotelName + "\n"
                       + "Check-in: " + checkInDate + "\n"
                       + "Support: " + SUPPORT_NUMBER;

        try {
            // Initialize Twilio client
            // Twilio.init(ACCOUNT_SID, AUTH_TOKEN); // <-- Commented out to prevent crash with dummy credentials

            /* 
            // Actual code to send the message
            Message message = Message.creator(
                    new PhoneNumber(guestPhone),
                    new PhoneNumber(TWILIO_PHONE_NUMBER),
                    smsBody)
                .create();
            */

            System.out.println("=================================================");
            System.out.println("REAL TWILIO SMS CONSTRUCTED & READY TO SEND:");
            System.out.println("TO PHONE: " + guestPhone);
            System.out.println("MESSAGE:");
            System.out.println(smsBody);
            System.out.println("=================================================");

        } catch (Exception e) {
            System.err.println("Failed to send Twilio SMS: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
