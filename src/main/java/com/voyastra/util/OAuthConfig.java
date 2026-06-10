package com.voyastra.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

/**
 * Loads all external API credentials from oauth.properties (git-ignored).
 * Falls back to environment variables, then to placeholder strings.
 *
 * Credentials managed:
 *   GOOGLE_CLIENT_ID / GOOGLE_CLIENT_SECRET  → Google OAuth login
 *   RAPIDAPI_KEY                              → Hotel search (Booking.com via RapidAPI)
 *   TRAVELPAYOUTS_TOKEN                       → Travelpayouts flight API token
 *   TRAVELPAYOUTS_MARKER                      → Travelpayouts affiliate partner marker
 */
public class OAuthConfig {

    private static final Properties props = new Properties();

    static {
        // Try loading from file in the project root / working directory
        try (InputStream is = new FileInputStream("oauth.properties")) {
            props.load(is);
            System.out.println("[OAuthConfig] Loaded oauth.properties from working directory.");
        } catch (Exception e1) {
            // Try classpath as fallback
            try (InputStream is = OAuthConfig.class.getClassLoader().getResourceAsStream("oauth.properties")) {
                if (is != null) {
                    props.load(is);
                    System.out.println("[OAuthConfig] Loaded oauth.properties from classpath.");
                }
            } catch (Exception e2) {
                System.err.println("[OAuthConfig] oauth.properties not found. Using env vars or defaults.");
            }
        }

        // ── Startup validation: log presence of Travelpayouts credentials ──────
        // Only logs the length of the value — never logs the actual secret.
        logCredential("TRAVELPAYOUTS_TOKEN",  getTravelpayoutsToken());
        logCredential("TRAVELPAYOUTS_MARKER", getTravelpayoutsMarker());
        logCredential("RAZORPAY_KEY_ID", getRazorpayKeyId());
    }

    /**
     * Logs whether a credential is present and its character length.
     * Never prints the actual credential value.
     */
    private static void logCredential(String name, String value) {
        boolean missing = (value == null || value.isEmpty() || value.startsWith("YOUR_"));
        if (missing) {
            System.err.println("[OAuthConfig] WARNING: " + name
                    + " is NOT configured. Set it in oauth.properties or as an env var.");
        } else {
            System.out.println("[OAuthConfig] " + name + " loaded OK (length=" + value.length() + ").");
        }
    }

    public static String getClientId() {
        // 1. Check properties file
        String val = props.getProperty("GOOGLE_CLIENT_ID");
        if (val != null && !val.isEmpty()) return val.trim();
        // 2. Check environment variable
        val = System.getenv("GOOGLE_CLIENT_ID");
        if (val != null && !val.isEmpty()) return val.trim();
        // 3. Placeholder
        return "YOUR_CLIENT_ID";
    }

    public static String getClientSecret() {
        String val = props.getProperty("GOOGLE_CLIENT_SECRET");
        if (val != null && !val.isEmpty()) return val.trim();
        val = System.getenv("GOOGLE_CLIENT_SECRET");
        if (val != null && !val.isEmpty()) return val.trim();
        return "YOUR_CLIENT_SECRET";
    }

    public static String getTravelpayoutsToken() {
        String val = props.getProperty("TRAVELPAYOUTS_TOKEN");
        if (val != null && !val.isEmpty()) return val.trim();
        val = System.getenv("TRAVELPAYOUTS_TOKEN");
        if (val != null && !val.isEmpty()) return val.trim();
        return "YOUR_TRAVELPAYOUTS_TOKEN";
    }

    /**
     * Returns the Travelpayouts affiliate partner marker.
     * Required by the live Flight Search API (/v1/search) for signature generation.
     * Obtain from: https://www.travelpayouts.com/developers/api
     */
    public static String getTravelpayoutsMarker() {
        String val = props.getProperty("TRAVELPAYOUTS_MARKER");
        if (val != null && !val.isEmpty()) return val.trim();
        val = System.getenv("TRAVELPAYOUTS_MARKER");
        if (val != null && !val.isEmpty()) return val.trim();
        return "YOUR_TRAVELPAYOUTS_MARKER";
    }

    public static String getRapidApiKey() {
        String val = props.getProperty("RAPIDAPI_KEY");
        if (val != null && !val.isEmpty()) return val.trim();
        val = System.getenv("RAPIDAPI_KEY");
        if (val != null && !val.isEmpty()) return val.trim();
        return "YOUR_RAPIDAPI_KEY";
    }

    public static String getRazorpayKeyId() {
        String val = props.getProperty("RAZORPAY_KEY_ID");
        if (val != null && !val.isEmpty()) return val.trim();
        val = System.getenv("RAZORPAY_KEY_ID");
        if (val != null && !val.isEmpty()) return val.trim();
        return "rzp_test_YourTestKeyId123";
    }

    public static String getRazorpayKeySecret() {
        String val = props.getProperty("RAZORPAY_KEY_SECRET");
        if (val != null && !val.isEmpty()) return val.trim();
        val = System.getenv("RAZORPAY_KEY_SECRET");
        if (val != null && !val.isEmpty()) return val.trim();
        return "YourTestSecretKey123";
    }
}
