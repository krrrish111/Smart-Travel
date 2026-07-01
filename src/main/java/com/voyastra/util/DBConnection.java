package com.voyastra.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Enhanced Database Connection Utility using HikariCP for high-performance pooling.
 */
public class DBConnection {

    private static final HikariDataSource dataSource;

    static {
        // Configuration
        HikariConfig config = new HikariConfig();
        
        // 1. Connection settings
        String dbHost = com.voyastra.config.ConfigManager.get("DB_HOST", "127.0.0.1");
        String dbPort = com.voyastra.config.ConfigManager.get("DB_PORT", "3306");
        String dbName = com.voyastra.config.ConfigManager.get("DB_NAME", "voyastra");
        String defaultUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

        config.setJdbcUrl(com.voyastra.config.ConfigManager.get("DB_URL", defaultUrl));
        config.setUsername(com.voyastra.config.ConfigManager.get("DB_USER", "root"));
        
        String password = com.voyastra.config.ConfigManager.get("DB_PASSWORD");
        if (password == null || password.isEmpty()) {
            password = com.voyastra.config.ConfigManager.get("DB_PASS", "Home@123");
        }
        config.setPassword(password);
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
        
        // Initialize DataSource
        dataSource = new HikariDataSource(config);
        
        System.out.println("[DB] HikariCP Connection Pool initialized successfully.");
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
            dataSource.close();
        }
    }
}
