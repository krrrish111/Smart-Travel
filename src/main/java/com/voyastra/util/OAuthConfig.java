package com.voyastra.util;

import com.voyastra.config.ConfigManager;

public class OAuthConfig {

    public static String getClientId() {
        return ConfigManager.get("GOOGLE_CLIENT_ID", "YOUR_CLIENT_ID");
    }

    public static String getClientSecret() {
        return ConfigManager.get("GOOGLE_CLIENT_SECRET", "YOUR_CLIENT_SECRET");
    }

    public static String getTravelpayoutsToken() {
        return ConfigManager.get("TRAVELPAYOUTS_TOKEN", "YOUR_TRAVELPAYOUTS_TOKEN");
    }

    public static String getTravelpayoutsMarker() {
        return ConfigManager.get("TRAVELPAYOUTS_MARKER", "YOUR_TRAVELPAYOUTS_MARKER");
    }

    public static String getRapidApiKey() {
        return ConfigManager.get("RAPIDAPI_KEY", "YOUR_RAPIDAPI_KEY");
    }

    public static String getRazorpayKeyId() {
        return ConfigManager.get("RAZORPAY_KEY", "rzp_test_YourTestKeyId123");
    }

    public static String getRazorpayKeySecret() {
        return ConfigManager.get("RAZORPAY_SECRET", "YourTestSecretKey123");
    }
}
