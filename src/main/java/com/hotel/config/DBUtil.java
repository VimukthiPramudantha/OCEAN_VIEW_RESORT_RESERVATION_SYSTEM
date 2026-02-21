package com.hotel.config;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Central point to obtain database connections using Tomcat JNDI DataSource.
 * Thread-safe, pooled, container-managed.
 */
public class DBUtil {

    private static DataSource dataSource;

    // Static initializer - runs once when class is loaded
    static {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context) initContext.lookup("java:comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/hotelDB");

            if (dataSource == null) {
                throw new IllegalStateException("JNDI DataSource 'jdbc/hotelDB' not found");
            }
        } catch (NamingException e) {
            throw new RuntimeException("Failed to initialize JNDI DataSource", e);
        }
    }

    /**
     * Get a connection from the pool.
     * Caller is responsible for closing it (try-with-resources recommended).
     */
    public static Connection getConnection() throws SQLException {
        Connection conn = dataSource.getConnection();
        // Optional: set auto-commit false if you want manual transactions
        // conn.setAutoCommit(false);
        return conn;
    }

    /**
     * Utility to quietly close multiple resources (Connection, Statement, ResultSet)
     */
    public static void closeQuietly(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception ignored) {
                    // log if you want, but usually silent close in finally blocks
                }
            }
        }
    }

    // Optional: for debugging
    public static String getPoolStats() {
        if (dataSource instanceof org.apache.tomcat.jdbc.pool.DataSource pool) {
            return String.format("Active: %d, Idle: %d, Waited: %d ms",
                    pool.getActive(), pool.getIdle(), pool.getWaitCount());
        }
        return "No stats available";
    }
}