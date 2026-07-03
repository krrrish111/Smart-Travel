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
        // Load MySQL Driver explicitly
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("com.mysql.cj.jdbc.Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            logger.error("com.mysql.cj.jdbc.Driver not found", e);
        }

        // Configuration
        HikariConfig config = new HikariConfig();
        
        // 1. Connection settings
        String dbHost = com.voyastra.config.ConfigManager.get("DB_HOST");
        String dbPort = com.voyastra.config.ConfigManager.get("DB_PORT", "3306");
        String dbName = com.voyastra.config.ConfigManager.get("DB_NAME");
        String dbUser = com.voyastra.config.ConfigManager.get("DB_USER");
        String dbPassword = com.voyastra.config.ConfigManager.get("DB_PASSWORD");

        String jdbcUrl;
        if (dbHost != null && !dbHost.trim().isEmpty()) {
            jdbcUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?sslMode=REQUIRED&zeroDateTimeBehavior=convertToNull";
        } else {
            jdbcUrl = com.voyastra.config.ConfigManager.get("DB_URL");
        }

        config.setJdbcUrl(jdbcUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPassword);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // 2. Pool Performance Settings
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(300000); // 5 mins
        config.setConnectionTimeout(30000); // 30 seconds
        config.setValidationTimeout(5000);
        
        // 3. MySQL specific performance optimizations
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");
        
        HikariDataSource ds = null;
        try {
            // Initialize DataSource
            ds = new HikariDataSource(config);
            logger.info("HikariCP Connection Pool initialized successfully.");
        } catch (Exception e) {
            logger.error("HikariCP Connection Pool initialization failed", e);
        }
        dataSource = ds;
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
