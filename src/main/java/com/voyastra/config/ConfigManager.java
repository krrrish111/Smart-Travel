package com.voyastra.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class ConfigManager {

    private static final Properties properties = new Properties();

    static {
        // Load from .env file in root directory if it exists
        try (InputStream input = new FileInputStream(new File(".env"))) {
            properties.load(input);
            System.out.println("[ConfigManager] Loaded .env file from root.");
        } catch (Exception ex) {
            // It's okay if .env doesn't exist (e.g. in production using actual env vars)
            System.out.println("[ConfigManager] No .env file found in root. Relying on System environment variables.");
        }

        // Startup Validation
        validateRequiredKeys();
    }

    private static void validateRequiredKeys() {
        String[] requiredKeys = {
            "GEMINI_API_KEY",
            "DB_URL",
            "DB_USER",
            "DB_PASSWORD"
        };

        for (String key : requiredKeys) {
            String value = get(key);
            if (value == null || value.trim().isEmpty()) {
                throw new RuntimeException("CRITICAL CONFIGURATION ERROR: " + key + " is missing. Application cannot start safely.");
            }
        }
        System.out.println("[ConfigManager] All required environment variables are present.");
    }

    public static String get(String key) {
        // 1. Try system environment variables first
        String envValue = System.getenv(key);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue;
        }
        // 2. Fallback to properties loaded from .env
        return properties.getProperty(key);
    }
    
    public static String get(String key, String defaultValue) {
        String value = get(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    // Explicit Getters requested
    public static String getGeminiKey() {
        return get("GEMINI_API_KEY");
    }

    public static String getDbPassword() {
        return get("DB_PASSWORD");
    }

    public static String getTwilioToken() {
        return get("TWILIO_TOKEN");
    }

    public static String getRazorpaySecret() {
        return get("RAZORPAY_SECRET");
    }
}
