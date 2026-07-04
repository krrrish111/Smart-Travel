package com.voyastra.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Enhanced Database Connection Utility using HikariCP for high-performance pooling.
 */
public class DBConnection {

    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);
    private static HikariDataSource dataSource = null;

    static {
        logger.info("=== HIKARICP STARTUP ROOT-CAUSE DIAGNOSTICS ===");
        
        // 1. Log environment variables (mask passwords, secrets, keys)
        System.getenv().forEach((k, v) -> {
            String upper = k.toUpperCase();
            if (upper.contains("PASSWORD") || upper.contains("SECRET") || upper.contains("KEY") || upper.contains("TOKEN") || upper.contains("PASS")) {
                logger.info("  ENV: {} = [MASKED] (length: {})", k, v != null ? v.length() : 0);
            } else {
                logger.info("  ENV: {} = {}", k, v);
            }
        });

        // 2. Load driver explicitly and check it
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("com.mysql.cj.jdbc.Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            logger.error("com.mysql.cj.jdbc.Driver not found!", e);
        }

        // 3. Resolve connection parameters
        String dbHost = com.voyastra.config.ConfigManager.get("DB_HOST");
        String dbPort = com.voyastra.config.ConfigManager.get("DB_PORT", "3306");
        String dbName = com.voyastra.config.ConfigManager.get("DB_NAME");
        String dbUser = com.voyastra.config.ConfigManager.get("DB_USER");
        String dbPassword = com.voyastra.config.ConfigManager.get("DB_PASSWORD");
        String rawDbUrl = com.voyastra.config.ConfigManager.get("DB_URL");

        logger.info("Configuration parameters read: DB_HOST='{}', DB_PORT='{}', DB_NAME='{}', DB_USER='{}', hasDBPassword={}", 
            dbHost, dbPort, dbName, dbUser, (dbPassword != null && !dbPassword.trim().isEmpty()));

        String jdbcUrl = null;
        if (dbHost != null && !dbHost.trim().isEmpty()) {
            jdbcUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?sslMode=REQUIRED&zeroDateTimeBehavior=convertToNull";
        } else if (rawDbUrl != null && !rawDbUrl.trim().isEmpty()) {
            rawDbUrl = rawDbUrl.trim();
            if (rawDbUrl.startsWith("mysql://")) {
                logger.info("Parsing raw mysql:// URL for embedded credentials.");
                try {
                    String cleanUrl = rawDbUrl.substring("mysql://".length());
                    String credentials = "";
                    String hostPortDb = "";
                    if (cleanUrl.contains("@")) {
                        int atIndex = cleanUrl.indexOf("@");
                        credentials = cleanUrl.substring(0, atIndex);
                        hostPortDb = cleanUrl.substring(atIndex + 1);
                    } else {
                        hostPortDb = cleanUrl;
                    }
                    
                    if (!credentials.isEmpty() && credentials.contains(":")) {
                        int colonIndex = credentials.indexOf(":");
                        if (dbUser == null || dbUser.trim().isEmpty()) {
                            dbUser = credentials.substring(0, colonIndex);
                            logger.info("Extracted user from URL: {}", dbUser);
                        }
                        if (dbPassword == null || dbPassword.trim().isEmpty()) {
                            dbPassword = credentials.substring(colonIndex + 1);
                            logger.info("Extracted password from URL.");
                        }
                    }
                    
                    jdbcUrl = "jdbc:mysql://" + hostPortDb;
                } catch (Exception parseEx) {
                    logger.error("Failed to parse mysql:// connection URI, using raw URL.", parseEx);
                    jdbcUrl = "jdbc:" + rawDbUrl;
                }
            } else {
                jdbcUrl = rawDbUrl;
            }
        }

        if (jdbcUrl != null) {
            // Append essential parameters if they are missing
            if (!jdbcUrl.contains("zeroDateTimeBehavior")) {
                jdbcUrl += (jdbcUrl.contains("?") ? "&" : "?") + "zeroDateTimeBehavior=convertToNull";
            }
            if (!jdbcUrl.contains("sslMode") && !jdbcUrl.contains("useSSL")) {
                jdbcUrl += "&sslMode=REQUIRED";
            }
        }

        logger.info("Final Resolved JDBC URL: {}", jdbcUrl);

        // 4. Hikari Configuration
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPassword);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(300000);
        config.setConnectionTimeout(30000);
        config.setValidationTimeout(5000);
        
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");

        logger.info("=== HIKARI CONFIGURATION ===");
        logger.info("  JdbcUrl: {}", config.getJdbcUrl());
        logger.info("  Username: {}", config.getUsername());
        logger.info("  DriverClassName: {}", config.getDriverClassName());
        logger.info("  MaximumPoolSize: {}", config.getMaximumPoolSize());
        logger.info("  MinimumIdle: {}", config.getMinimumIdle());
        logger.info("  IdleTimeout: {}", config.getIdleTimeout());
        logger.info("  ConnectionTimeout: {}", config.getConnectionTimeout());
        logger.info("  ValidationTimeout: {}", config.getValidationTimeout());
        logger.info("============================");

        try {
            // Initialize pool
            dataSource = new HikariDataSource(config);
            logger.info("HikariCP Connection Pool initialized successfully.");

            // 5. Verify by creating a test connection immediately
            logger.info("Creating validation connection immediately after Hikari initialization...");
            try (Connection conn = dataSource.getConnection()) {
                logger.info("Validation connection status: SUCCESS");
                java.sql.DatabaseMetaData metaData = conn.getMetaData();
                
                String dbProductName = metaData.getDatabaseProductName();
                String dbProductVersion = metaData.getDatabaseProductVersion();
                String drvName = metaData.getDriverName();
                String drvVersion = metaData.getDriverVersion();
                
                logger.info("Database Product Name: {}", dbProductName);
                logger.info("Database Product Version: {}", dbProductVersion);
                logger.info("Driver Name: {}", drvName);
                logger.info("Driver Version: {}", drvVersion);
                
                try (java.sql.Statement stmt = conn.createStatement()) {
                    try (java.sql.ResultSet rs = stmt.executeQuery("SELECT DATABASE()")) {
                        if (rs.next()) {
                            logger.info("SELECT DATABASE() returned: {}", rs.getString(1));
                        }
                    }
                    try (java.sql.ResultSet rs = stmt.executeQuery("SELECT VERSION()")) {
                        if (rs.next()) {
                            logger.info("SELECT VERSION() returned: {}", rs.getString(1));
                        }
                    }
                    try (java.sql.ResultSet rs = stmt.executeQuery("SHOW STATUS LIKE 'Ssl_cipher'")) {
                        if (rs.next()) {
                            logger.info("SSL status: {} = {}", rs.getString(1), rs.getString(2));
                        } else {
                            logger.info("SSL status: No active SSL cipher.");
                        }
                    }
                }
            }
        } catch (Throwable t) {
            logger.error("[CRITICAL ERROR] HikariCP Connection Pool initialization failed or validation check failed!");
            logger.error("Error Class: {}", t.getClass().getName());
            logger.error("Error Message: {}", t.getMessage());
            logger.error("Error Cause: {}", t.getCause());
            
            // Print full stack trace
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            t.printStackTrace(pw);
            logger.error("Full Exception Stack Trace:\n{}", sw.toString());
            
            // Fail startup immediately
            throw new RuntimeException("HikariCP connection pool initialization failed permanently.", t);
        }
    }

    private DBConnection() {}

    /**
     * Retrieves a connection from the HikariCP pool.
     * Must be closed by the caller (returns it to the pool).
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource not initialized");
        }
        return dataSource.getConnection();
    }

    /**
     * Shuts down the connection pool (call during app shutdown).
     */
    public static void shutdown() {
        if (dataSource != null) {
            try {
                dataSource.close();
                logger.info("HikariCP Connection Pool shut down successfully.");
            } catch (Exception e) {
                logger.error("Error shutting down HikariCP Connection Pool", e);
            } finally {
                dataSource = null;
            }
        }
    }
}
