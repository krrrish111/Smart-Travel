package com.voyastra.listener;

import com.voyastra.util.DBConnection;
import com.voyastra.config.ConfigManager;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StartupObserverListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(StartupObserverListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        long startTime = System.currentTimeMillis();
        
        // 1. Gather Java and Container Versions
        String javaVersion = System.getProperty("java.version");
        String tomcatVersion = sce.getServletContext().getServerInfo();
        String appVersion = "1.0-SNAPSHOT";
        String gitCommit = "N/A";
        
        // Try to retrieve git commit hash
        try {
            java.util.Scanner s = new java.util.Scanner(Runtime.getRuntime().exec("git rev-parse --short HEAD").getInputStream()).useDelimiter("\\A");
            if (s.hasNext()) {
                gitCommit = s.next().trim();
            }
        } catch (Exception ignored) {}

        // 2. Validate DB connection
        String dbInfo = "DISCONNECTED";
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            dbInfo = meta.getDatabaseProductName() + " " + meta.getDatabaseProductVersion() + " @ " + meta.getURL();
        } catch (Exception e) {
            dbInfo = "ERROR: " + e.getMessage();
        }

        // 3. API Integrations check
        String razorpayStatus = (ConfigManager.get("RAZORPAY_KEY_ID") != null) ? "ENABLED" : "DISABLED";
        String travelpayoutsStatus = (ConfigManager.get("TRAVELPAYOUTS_TOKEN") != null) ? "ENABLED" : "DISABLED";
        String emailStatus = (ConfigManager.get("SMTP_HOST") != null) ? "ENABLED" : "DISABLED";
        String smsStatus = (ConfigManager.get("TWILIO_ACCOUNT_SID") != null) ? "ENABLED" : "DISABLED";

        long startupDuration = System.currentTimeMillis() - startTime;

        // Print Structured Console Box
        System.out.println("\n" +
            "==================================================\n" +
            "              VOYASTRA STARTUP SUMMARY            \n" +
            "==================================================\n" +
            "Application Version : " + appVersion + "\n" +
            "Git Commit          : " + gitCommit + "\n" +
            "Java Version        : " + javaVersion + "\n" +
            "Tomcat Version      : " + tomcatVersion + "\n" +
            "Database            : " + dbInfo + "\n" +
            "Connected APIs:\n" +
            "  - Razorpay        : " + razorpayStatus + "\n" +
            "  - Travelpayouts   : " + travelpayoutsStatus + "\n" +
            "  - SMTP Email      : " + emailStatus + "\n" +
            "  - Twilio SMS      : " + smsStatus + "\n" +
            "Startup Time        : " + startupDuration + " ms\n" +
            "==================================================\n"
        );
        
        logger.info("[STARTUP] Voyastra initialization summary printed successfully.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup resources
    }
}
