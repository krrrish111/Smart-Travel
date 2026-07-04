package com.voyastra.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Optimized Database Connection Utility using HikariCP for high-performance pooling in production.
 */
public class DBConnection {

    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);
    private static HikariDataSource dataSource = null;

    static {
        logger.info("[DB] Initializing HikariCP...");

        // Load MySQL Driver explicitly
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            logger.error("[DB] MySQL driver com.mysql.cj.jdbc.Driver not found!", e);
            throw new RuntimeException("MySQL driver load failure", e);
        }

        // Resolve connection parameters
        String dbHost = com.voyastra.config.ConfigManager.get("DB_HOST");
        String dbPort = com.voyastra.config.ConfigManager.get("DB_PORT", "3306");
        String dbName = com.voyastra.config.ConfigManager.get("DB_NAME");
        String dbUser = com.voyastra.config.ConfigManager.get("DB_USER");
        String dbPassword = com.voyastra.config.ConfigManager.get("DB_PASSWORD");
        String rawDbUrl = com.voyastra.config.ConfigManager.get("DB_URL");

        String jdbcUrl = null;
        if (dbHost != null && !dbHost.trim().isEmpty()) {
            jdbcUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?sslMode=REQUIRED&zeroDateTimeBehavior=convertToNull";
        } else if (rawDbUrl != null && !rawDbUrl.trim().isEmpty()) {
            rawDbUrl = rawDbUrl.trim();
            if (rawDbUrl.startsWith("mysql://")) {
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
                        }
                        if (dbPassword == null || dbPassword.trim().isEmpty()) {
                            dbPassword = credentials.substring(colonIndex + 1);
                        }
                    }
                    
                    jdbcUrl = "jdbc:mysql://" + hostPortDb;
                } catch (Exception parseEx) {
                    jdbcUrl = "jdbc:" + rawDbUrl;
                }
            } else {
                jdbcUrl = rawDbUrl;
            }
        }

        if (jdbcUrl != null) {
            if (!jdbcUrl.contains("zeroDateTimeBehavior")) {
                jdbcUrl += (jdbcUrl.contains("?") ? "&" : "?") + "zeroDateTimeBehavior=convertToNull";
            }
            if (!jdbcUrl.contains("sslMode") && !jdbcUrl.contains("useSSL")) {
                jdbcUrl += "&sslMode=REQUIRED";
            }
        }

        // Print resolved host and database safely without credentials
        logger.info("[DB] Resolved JDBC: {}", getSafeUrlInfo(jdbcUrl));

        // Hikari Configuration
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

        try {
            dataSource = new HikariDataSource(config);

            // Verify with a lightweight check
            try (Connection conn = dataSource.getConnection();
                 Statement stmt = conn.createStatement()) {
                stmt.execute("SELECT 1");
                logger.info("[DB] Connected to MySQL ({})", (dbName != null ? dbName : "defaultdb"));
            }
            logger.info("[DB] Connection pool initialized successfully. Size: {}", config.getMaximumPoolSize());
        } catch (Throwable t) {
            logger.error("[DB] [CRITICAL ERROR] HikariCP Connection Pool initialization or validation check failed!");
            throw new RuntimeException("HikariCP connection pool initialization failed permanently.", t);
        }
    }

    private static String getSafeUrlInfo(String url) {
        if (url == null) return "Unknown host";
        try {
            String clean = url;
            if (clean.startsWith("jdbc:")) {
                clean = clean.substring(5);
            }
            if (clean.startsWith("mysql://")) {
                clean = clean.substring(8);
            }
            int slashIndex = clean.indexOf("/");
            String hostPort = (slashIndex != -1) ? clean.substring(0, slashIndex) : clean;
            String dbName = "";
            if (slashIndex != -1) {
                int queryIndex = clean.indexOf("?", slashIndex);
                dbName = (queryIndex != -1) ? clean.substring(slashIndex + 1, queryIndex) : clean.substring(slashIndex + 1);
            }
            return "host=" + hostPort + ", database=" + dbName;
        } catch (Exception e) {
            return "Unknown host/database";
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
                logger.info("[DB] HikariCP Connection Pool shut down successfully.");
            } catch (Exception e) {
                logger.error("[DB] Error shutting down HikariCP Connection Pool", e);
            } finally {
                dataSource = null;
            }
        }
    }
}
