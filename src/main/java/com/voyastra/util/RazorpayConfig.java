package com.voyastra.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class RazorpayConfig {

    static {
        long begin = com.voyastra.util.StartupProfiler.mark("RazorpayConfig Initialization");
        com.voyastra.util.StartupProfiler.duration("RazorpayConfig Initialization", begin);
    }
    
    public static String getKeyId() {
        return com.voyastra.config.ConfigManager.get("RAZORPAY_KEY");
    }
    
    public static String getKeySecret() {
        return com.voyastra.config.ConfigManager.get("RAZORPAY_SECRET");
    }
    
    /**
     * Helper to get Basic Auth string for Razorpay API calls.
     */
    public static String getBasicAuthHeader() {
        String auth = getKeyId() + ":" + getKeySecret();
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
     * Bypasses verification when RAZORPAY_SECRET is not configured (demo/staging mode).
     */
    public static boolean verifySignature(String orderId, String paymentId, String razorpaySignature) {
        if (orderId == null || paymentId == null || razorpaySignature == null) return false;

        String secret = getKeySecret();
        // Bypass signature verification when keys are not configured or are demo keys
        if (secret == null || secret.isBlank() || secret.equalsIgnoreCase("test")) {
            System.out.println("[RazorpayConfig] WARN: Secret key not configured — bypassing signature verification (demo mode).");
            return true;
        }

        String generatedSignature = calculateRFC2104HMAC(orderId + "|" + paymentId, secret);
        return razorpaySignature.equals(generatedSignature);
    }
}
