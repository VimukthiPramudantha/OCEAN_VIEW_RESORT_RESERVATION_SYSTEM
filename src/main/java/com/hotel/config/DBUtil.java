package com.hotel.config;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBUtil {

    private static DataSource dataSource;

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

    public static Connection getConnection() throws SQLException {
        Connection conn = dataSource.getConnection();
        return conn;
    }
    public static void closeQuietly(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    public static String getPoolStats() {
        if (dataSource instanceof org.apache.tomcat.jdbc.pool.DataSource pool) {
            return String.format("Active: %d, Idle: %d, Waited: %d ms",
                    pool.getActive(), pool.getIdle(), pool.getWaitCount());
        }
        return "No stats available";
    }
}