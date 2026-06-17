package com.voyastra.util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.net.URLEncoder;

public class SMSService {

    // IMPORTANT: Replace these with your actual Twilio Account SID and Auth Token
    private static final String TWILIO_ACCOUNT_SID = com.voyastra.config.ConfigManager.get("TWILIO_SID", "AC_dummy_sid");
    private static final String TWILIO_AUTH_TOKEN = com.voyastra.config.ConfigManager.get("TWILIO_TOKEN", "dummy_token");
    private static final String TWILIO_PHONE_NUMBER = com.voyastra.config.ConfigManager.get("TWILIO_PHONE", "+1234567890");

    public static void sendBookingConfirmationSMS(String toPhoneNumber, String pnr, String flightName, String date) {
        if (toPhoneNumber == null || toPhoneNumber.trim().isEmpty()) {
            System.err.println("[SMSService] No phone number provided.");
            return;
        }

        // Clean up the phone number (assuming it might need country code, defaults to India +91 if length is 10)
        String formattedPhone = toPhoneNumber.replaceAll("[^0-9+]", "");
        if (formattedPhone.length() == 10 && !formattedPhone.startsWith("+")) {
            formattedPhone = "+91" + formattedPhone;
        } else if (!formattedPhone.startsWith("+")) {
            formattedPhone = "+" + formattedPhone;
        }

        String messageBody = "Voyastra Airlines:\nBooking Confirmed!\nPNR: " + pnr + "\nFlight: " + flightName + "\nDate: " + date + "\nThank you for flying with us!";
        
        System.out.println("[SMSService] Attempting to send SMS to " + formattedPhone);

        // Run in thread to not block UI
        final String finalPhone = formattedPhone;
        new Thread(() -> {
            try {
                if ("AC_dummy_sid".equals(TWILIO_ACCOUNT_SID)) {
                    System.out.println("[SMS MOCK] Simulated sending to " + finalPhone + ":\n" + messageBody);
                    return;
                }

                String urlString = "https://api.twilio.com/2010-04-01/Accounts/" + TWILIO_ACCOUNT_SID + "/Messages.json";
                URL url = new URL(urlString);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setDoOutput(true);

                String auth = TWILIO_ACCOUNT_SID + ":" + TWILIO_AUTH_TOKEN;
                String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
                conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
                conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

                String postData = "To=" + URLEncoder.encode(finalPhone, "UTF-8") +
                                  "&From=" + URLEncoder.encode(TWILIO_PHONE_NUMBER, "UTF-8") +
                                  "&Body=" + URLEncoder.encode(messageBody, "UTF-8");

                try (OutputStream os = conn.getOutputStream()) {
                    os.write(postData.getBytes(StandardCharsets.UTF_8));
                }

                int responseCode = conn.getResponseCode();
                if (responseCode >= 200 && responseCode < 300) {
                    System.out.println("[SMSService] SMS successfully sent to " + finalPhone);
                } else {
                    System.err.println("[SMSService ERROR] Failed to send SMS. HTTP Code: " + responseCode);
                }
            } catch (Exception e) {
                System.err.println("[SMSService ERROR] " + e.getMessage());
            }
        }).start();
    }
}
