package com.voyastra.listener;

import com.voyastra.config.ConfigManager;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Prints a startup summary banner WITHOUT performing any blocking I/O.
 *
 * PRODUCTION RULE: contextInitialized() must never open a DB connection,
 * SMTP socket, or any external network call. Those block Tomcat startup.
 * Live checks are deferred to the /health/* endpoints which are called
 * on-demand after the server is already accepting traffic.
 */
public class StartupObserverListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(StartupObserverListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        long startTime = System.currentTimeMillis();

        // ── 1. Gather environment metadata (no I/O) ──────────────────────────
        String javaVersion   = System.getProperty("java.version", "unknown");
        String tomcatVersion = sce.getServletContext().getServerInfo();
        String appVersion    = "1.0-SNAPSHOT";

        // ── 2. API key presence check (no network calls) ──────────────────────
        // We only verify that keys are configured — actual connectivity is
        // checked lazily via /health/db, /health/payment, /health/email, /health/sms
        String razorpayStatus      = isConfigured("RAZORPAY_KEY")         ? "CONFIGURED" : "NOT CONFIGURED";
        String travelpayoutsStatus = isConfigured("TRAVELPAYOUTS_TOKEN")  ? "CONFIGURED" : "NOT CONFIGURED";
        String emailStatus         = isConfigured("SMTP_HOST")            ? "CONFIGURED" : "NOT CONFIGURED";
        String smsStatus           = isConfigured("TWILIO_SID")           ? "CONFIGURED" : "NOT CONFIGURED";
        String dbStatus            = (isConfigured("DB_URL") || isConfigured("DB_HOST"))
                                     ? "CONFIGURED (connection deferred to first request)"
                                     : "NOT CONFIGURED — application will fail on first DB request!";

        long elapsed = System.currentTimeMillis() - startTime;

        // ── 3. Print banner ───────────────────────────────────────────────────
        System.out.println("\n" +
            "==================================================\n" +
            "         VOYASTRA STARTUP SUMMARY                 \n" +
            "==================================================\n" +
            "Application Version : " + appVersion       + "\n" +
            "Java Version        : " + javaVersion      + "\n" +
            "Tomcat Version      : " + tomcatVersion     + "\n" +
            "Database            : " + dbStatus          + "\n" +
            "Connected APIs (key presence only — live checks via /health/*):\n" +
            "  - Razorpay        : " + razorpayStatus      + "\n" +
            "  - Travelpayouts   : " + travelpayoutsStatus  + "\n" +
            "  - SMTP Email      : " + emailStatus          + "\n" +
            "  - Twilio SMS      : " + smsStatus            + "\n" +
            "Listener Init Time  : " + elapsed + " ms  (no blocking I/O)\n" +
            "==================================================\n"
        );

        logger.info("[STARTUP] StartupObserverListener initialized in {} ms (no DB connection opened).", elapsed);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("[SHUTDOWN] Starting resource cleanup in StartupObserverListener...");
        
        // Shut down shared HttpClient to stop the SelectorManager threads
        com.voyastra.util.HttpClientFactory.shutdown();
        
        // Shut down HikariCP DB connection pool
        com.voyastra.util.DBConnection.shutdown();
        
        // Shut down EmailService executor service
        com.voyastra.util.EmailService.shutdown();
        
        // Shut down SMSService executor service
        com.voyastra.util.SMSService.shutdown();

        // Unregister JDBC Drivers
        java.util.Enumeration<java.sql.Driver> drivers = java.sql.DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            java.sql.Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == sce.getServletContext().getClassLoader()) {
                try {
                    java.sql.DriverManager.deregisterDriver(driver);
                    logger.info("[SHUTDOWN] Unregistered JDBC driver: {}", driver);
                } catch (java.sql.SQLException e) {
                    logger.error("[SHUTDOWN ERROR] Error unregistering JDBC driver: {}", driver, e);
                }
            }
        }
        
        // Stop MySQL abandoned connection cleanup thread
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
            logger.info("[SHUTDOWN] Stopped MySQL abandoned connection cleanup thread.");
        } catch (Throwable t) {
            logger.warn("[SHUTDOWN WARNING] Failed to stop MySQL abandoned connection cleanup thread: {}", t.getMessage());
        }
        
        logger.info("[SHUTDOWN] StartupObserverListener resource cleanup completed.");
    }

    private static boolean isConfigured(String key) {
        String val = ConfigManager.get(key);
        return val != null && !val.trim().isEmpty();
    }
}
