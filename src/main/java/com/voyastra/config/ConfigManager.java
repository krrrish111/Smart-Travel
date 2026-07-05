package com.voyastra.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class ConfigManager {

    private static final Properties properties = new Properties();

    static {
        long begin = com.voyastra.util.StartupProfiler.mark("ConfigManager Loading");
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
        com.voyastra.util.StartupProfiler.duration("ConfigManager Loading", begin);
    }

    private static void validateRequiredKeys() {
        // Validate Gemini Key as it is critical
        String gemini = get("GEMINI_API_KEY");
        if (gemini == null || gemini.trim().isEmpty()) {
            System.err.println("[ConfigManager WARNING] GEMINI_API_KEY is missing. AI features will not work.");
        }

        // Verify either DB_URL or DB_HOST is present
        String dbUrl = get("DB_URL");
        String dbHost = get("DB_HOST");
        if ((dbUrl == null || dbUrl.trim().isEmpty()) && (dbHost == null || dbHost.trim().isEmpty())) {
            throw new RuntimeException("CRITICAL CONFIGURATION ERROR: Either DB_URL or DB_HOST must be provided. Application cannot start safely.");
        }

        // Check user
        String dbUser = get("DB_USER");
        if (dbUser == null || dbUser.trim().isEmpty()) {
            throw new RuntimeException("CRITICAL CONFIGURATION ERROR: DB_USER is missing. Application cannot start safely.");
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
