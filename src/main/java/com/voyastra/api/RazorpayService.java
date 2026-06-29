package com.voyastra.api;

import com.voyastra.util.RazorpayConfig;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class RazorpayService {

    public static String createOrder(long amountInPaise, String receiptId) throws Exception {
        // Phase 4 — Validate Razorpay Credentials
        String keyId = RazorpayConfig.getKeyId();
        if (keyId == null || !keyId.startsWith("rzp_test_")) {
            throw new IllegalArgumentException("Invalid Razorpay Key: Must start with rzp_test_");
        }
        
        String jsonPayload = String.format(
            "{\"amount\": %d, \"currency\": \"INR\", \"receipt\": \"%s\"}",
            amountInPaise, receiptId
        );

        URL url = new URL("https://api.razorpay.com/v1/orders");
        
        // Phase 2 — Improve RazorpayService Logging
        System.out.println("POST " + url.toString());
        System.out.println("Key ID: " + keyId);
        System.out.println("Payload:\n" + jsonPayload);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", RazorpayConfig.getBasicAuthHeader());
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        } catch (Exception e) {
            System.err.println("[RazorpayService] Failed to write payload: " + e.getMessage());
            throw new Exception("Network error while connecting to Razorpay.", e);
        }

        int responseCode = conn.getResponseCode();
        System.out.println("Response Code: " + responseCode);

        BufferedReader br;
        boolean isSuccess = (responseCode >= 200 && responseCode < 300);

        if (isSuccess) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
        }

        StringBuilder responseBody = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            responseBody.append(line.trim());
        }

        System.out.println("Response:\n" + responseBody.toString());

        if (isSuccess) {
            return responseBody.toString();
        } else {
            // Phase 6 — Investigate Razorpay Response
            try {
                JsonObject jsonObject = JsonParser.parseString(responseBody.toString()).getAsJsonObject();
                if (jsonObject.has("error")) {
                    JsonObject error = jsonObject.getAsJsonObject("error");
                    String code = error.has("code") ? error.get("code").getAsString() : "N/A";
                    String description = error.has("description") ? error.get("description").getAsString() : "N/A";
                    String field = error.has("field") && !error.get("field").isJsonNull() ? error.get("field").getAsString() : "N/A";
                    String reason = error.has("reason") && !error.get("reason").isJsonNull() ? error.get("reason").getAsString() : "N/A";

                    System.err.println("Razorpay Error Code: " + code);
                    System.err.println("Razorpay Error Description: " + description);
                    System.err.println("Razorpay Error Field: " + field);
                    System.err.println("Razorpay Error Reason: " + reason);
                    
                    throw new Exception("Razorpay Error: " + description);
                }
            } catch (Exception e) {
                if (e.getMessage().startsWith("Razorpay Error")) {
                    throw e;
                }
            }
            throw new Exception("Payment gateway returned error (" + responseCode + "): " + responseBody.toString());
        }
    }
}
