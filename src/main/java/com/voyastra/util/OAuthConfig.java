package com.voyastra.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

/**
 * Loads Google OAuth credentials from oauth.properties (git-ignored).
 * Falls back to environment variables, then to placeholder strings.
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
}
