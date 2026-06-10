package com.voyastra.api;

import com.voyastra.util.RazorpayConfig;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class RazorpayService {

    /**
     * Creates an order in Razorpay using the provided amount and receipt ID.
     * Includes detailed logging and error handling.
     * 
     * @param amountInPaise the total amount in INR paise
     * @param receiptId a unique receipt string
     * @return the JSON response string from Razorpay
     * @throws Exception if connection fails or API returns an error
     */
    public static String createOrder(int amountInPaise, String receiptId) throws Exception {
        System.out.println("[RazorpayService] Initiating order creation for receipt: " + receiptId);
        System.out.println("[RazorpayService] Amount (paise): " + amountInPaise);

        String jsonPayload = String.format(
            "{\"amount\": %d, \"currency\": \"INR\", \"receipt\": \"%s\"}",
            amountInPaise, receiptId
        );

        URL url = new URL("https://api.razorpay.com/v1/orders");
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
        System.out.println("[RazorpayService] Razorpay API Response Code: " + responseCode);

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

        System.out.println("[RazorpayService] Razorpay API Response Body: " + responseBody.toString());

        if (isSuccess) {
            return responseBody.toString();
        } else {
            if (responseCode == 401) {
                throw new Exception("Unauthorized. Please check if your Razorpay Key ID and Secret in oauth.properties are correct.");
            } else if (responseCode == 400) {
                throw new Exception("Bad Request. The payload sent to Razorpay was invalid: " + responseBody.toString());
            } else {
                throw new Exception("Payment gateway returned error (" + responseCode + "): " + responseBody.toString());
            }
        }
    }
}
