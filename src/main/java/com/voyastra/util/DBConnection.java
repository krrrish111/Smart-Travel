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
        // Using 'localhost' instead of '127.0.0.1' for consistent behavior
        config.setJdbcUrl("jdbc:mysql://localhost:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        config.setUsername("root");
        config.setPassword("Home@123");
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
