package com.voyastra.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.net.URLEncoder;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SMSService {

    private static final Logger logger = LoggerFactory.getLogger(SMSService.class);

    private static final ExecutorService executor = Executors.newFixedThreadPool(2, r -> {
        Thread t = new Thread(r);
        t.setDaemon(true);
        t.setName("SMSService-Worker");
        return t;
    });

    // IMPORTANT: Replace these with your actual Twilio Account SID and Auth Token
    private static final String TWILIO_ACCOUNT_SID = com.voyastra.config.ConfigManager.get("TWILIO_SID", "AC_dummy_sid");
    private static final String TWILIO_AUTH_TOKEN = com.voyastra.config.ConfigManager.get("TWILIO_TOKEN", "dummy_token");
    private static final String TWILIO_PHONE_NUMBER = com.voyastra.config.ConfigManager.get("TWILIO_PHONE", "+1234567890");

    public static void shutdown() {
        executor.shutdown();
        logger.info("SMSService ExecutorService shut down successfully.");
    }

    public static void sendBookingConfirmationSMS(String toPhoneNumber, String pnr, String flightName, String date) {
        if (toPhoneNumber == null || toPhoneNumber.trim().isEmpty()) {
            logger.warn("No phone number provided for booking confirmation SMS.");
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
        
        logger.info("Attempting to send SMS to {}", formattedPhone);

        // Run in thread pool to not block UI
        final String finalPhone = formattedPhone;
        executor.submit(() -> {
            try {
                if ("AC_dummy_sid".equals(TWILIO_ACCOUNT_SID)) {
                    logger.info("[SMS MOCK] Simulated sending to {}:\n{}", finalPhone, messageBody);
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
                    logger.info("SMS successfully sent to {}", finalPhone);
                } else {
                    logger.error("Failed to send SMS. HTTP Code: {}", responseCode);
                }
            } catch (Exception e) {
                logger.error("Error in SMSService background sender: ", e);
            }
        });
    }
}
