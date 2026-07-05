package com.voyastra.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Optimized Database Connection Utility using HikariCP for high-performance pooling in production.
 */
public class DBConnection {

    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);
    private static volatile HikariDataSource dataSource = null;
    private static String jdbcUrl = null;
    private static String dbUser = null;
    private static String dbPassword = null;

    static {
        logger.info("[DB] Loading MySQL driver and parsing configuration...");

        // Load MySQL Driver explicitly
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            logger.error("[DB] MySQL driver com.mysql.cj.jdbc.Driver not found!", e);
            throw new RuntimeException("MySQL driver load failure", e);
        }

        // Resolve connection parameters
        dbUser = com.voyastra.config.ConfigManager.get("DB_USER");
        dbPassword = com.voyastra.config.ConfigManager.get("DB_PASSWORD");
        String dbHost = com.voyastra.config.ConfigManager.get("DB_HOST");
        String dbPort = com.voyastra.config.ConfigManager.get("DB_PORT", "3306");
        String dbName = com.voyastra.config.ConfigManager.get("DB_NAME");
        String rawDbUrl = com.voyastra.config.ConfigManager.get("DB_URL");

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
            synchronized (DBConnection.class) {
                if (dataSource == null) {
                    long begin = com.voyastra.util.StartupProfiler.mark("DBConnection & Hikari Initialization");
                    logger.info("[DB] Lazy initializing HikariCP Connection Pool...");

                    HikariConfig config = new HikariConfig();
                    config.setJdbcUrl(jdbcUrl);
                    config.setUsername(dbUser);
                    config.setPassword(dbPassword);
                    config.setDriverClassName("com.mysql.cj.jdbc.Driver");
                    config.setMaximumPoolSize(5);
                    // minimumIdle=0: Hikari will not open any physical connection
                    // until the first getConnection() call from a request thread.
                    config.setMinimumIdle(0);
                    config.setIdleTimeout(300000);
                    // initializationFailTimeout=-1: pool creation succeeds even if DB is
                    // unreachable at startup. First getConnection() will block/fail normally.
                    config.setInitializationFailTimeout(-1);
                    config.setConnectionTimeout(2000);
                    config.setValidationTimeout(5000);
                    config.setKeepaliveTime(60000);
                    
                    config.addDataSourceProperty("cachePrepStmts", "true");
                    config.addDataSourceProperty("prepStmtCacheSize", "250");
                    config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
                    config.addDataSourceProperty("useServerPrepStmts", "true");

                    try {
                        // initializationFailTimeout=-1 means pool creation never blocks on DB.
                        // No physical connection is opened here — only pool metadata is set up.
                        HikariDataSource ds = new HikariDataSource(config);
                        dataSource = ds;
                        logger.info("[DB] HikariCP pool object created (no physical connection yet). " +
                                "Pool will connect on first getConnection() call.");
                    } catch (Throwable t) {
                        logger.error("[DB] [CRITICAL ERROR] HikariCP pool creation failed!", t);
                        throw new RuntimeException("HikariCP connection pool creation failed.", t);
                    }
                    com.voyastra.util.StartupProfiler.duration("DBConnection & Hikari Initialization", begin);
                }
            }
        }
        return dataSource.getConnection();
    }

    /**
     * Shuts down the connection pool (call during app shutdown).
     */
    public static void shutdown() {
        if (dataSource != null) {
            synchronized (DBConnection.class) {
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
    }
}
