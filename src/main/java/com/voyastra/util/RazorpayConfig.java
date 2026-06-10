package com.voyastra.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class RazorpayConfig {
    
    // Replace these with actual Razorpay API keys if available.
    // For test mode, these mock strings will be used if real keys aren't provided.
    // NOTE: In production, store these securely in environment variables or properties.
    public static final String KEY_ID = "rzp_test_YourTestKeyId123";
    public static final String KEY_SECRET = "YourTestSecretKey123";
    
    /**
     * Helper to get Basic Auth string for Razorpay API calls.
     */
    public static String getBasicAuthHeader() {
        String auth = KEY_ID + ":" + KEY_SECRET;
        return "Basic " + Base64.getEncoder().encodeToString(auth.getBytes());
    }

    /**
     * Generates HMAC_SHA256 signature to verify Razorpay callbacks.
     * @param payload "order_id|payment_id"
     * @param secret KEY_SECRET
     * @return hex encoded signature string
     */
    public static String calculateRFC2104HMAC(String payload, String secret) {
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(secret.getBytes("UTF-8"), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            byte[] hash = sha256_HMAC.doFinal(payload.getBytes("UTF-8"));
            
            // Convert byte array to Hex String
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            System.err.println("HMAC Calculation failed: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Verifies if the signature passed by Razorpay is valid.
     */
    public static boolean verifySignature(String orderId, String paymentId, String razorpaySignature) {
        if (orderId == null || paymentId == null || razorpaySignature == null) return false;
        
        String generatedSignature = calculateRFC2104HMAC(orderId + "|" + paymentId, KEY_SECRET);
        return razorpaySignature.equals(generatedSignature);
    }
}
