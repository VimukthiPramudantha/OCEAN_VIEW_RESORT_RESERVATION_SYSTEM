package com.hotel.dao;

import com.hotel.config.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Abstract base class providing standardized DB interaction helper methods
 * to reduce boilerplate in specific DAO implementations.
 */
public abstract class BaseDAO {

    /**
     * Helper to get a database connection.
     */
    protected Connection getConnection() throws SQLException {
        return DBUtil.getConnection();
    }

    /**
     * Executes a SELECT query and returns a list of mapped objects.
     */
    protected <T> List<T> queryList(String sql, RowMapper<T> mapper, Object... params) {
        List<T> results = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            setParameters(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapper.mapRow(rs));
                }
            }
        } catch (SQLException e) {
            handleException(e, sql);
        }
        return results;
    }

    /**
     * Executes a SELECT query aimed at a single result.
     */
    protected <T> T querySingle(String sql, RowMapper<T> mapper, Object... params) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            setParameters(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapper.mapRow(rs);
                }
            }
        } catch (SQLException e) {
            handleException(e, sql);
        }
        return null;
    }

    /**
     * Executes an INSERT, UPDATE, or DELETE statement using a generic connection.
     */
    protected int update(String sql, Object... params) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            return ps.executeUpdate();
        } catch (SQLException e) {
            handleException(e, sql);
            return 0;
        }
    }

    /**
     * Executes an update using a specific connection (for transactions).
     */
    protected int update(String sql, Connection conn, Object... params) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            return ps.executeUpdate();
        }
    }

    /**
     * Executes an INSERT and returns the first generated key (ID).
     */
    protected int insertAndGetId(String sql, Object... params) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setParameters(ps, params);
            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0)
                return -1;

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            handleException(e, sql);
        }
        return -1;
    }

    /**
     * Helper to set parameters on a PreparedStatement.
     */
    private void setParameters(PreparedStatement ps, Object... params) throws SQLException {
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
        }
    }

    /**
     * Centralized exception handling (could be expanded to use a logger).
     */
    protected void handleException(SQLException e, String sql) {
        System.err.println("SQL Error: " + e.getMessage());
        System.err.println("Query: " + sql);
    }
}
