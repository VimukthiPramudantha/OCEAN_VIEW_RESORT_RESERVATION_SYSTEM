package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User findByUsernameAndPassword(String username, String password) {
        String sql = "SELECT username, password, full_name, role FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password); // plain text comparison

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password")); // not needed after auth, but ok
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            // In production: log properly (e.g. SLF4J)
            System.err.println("Login DB error: " + e.getMessage());
        }
        return null; // invalid credentials
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("User creation error: " + e.getMessage());
        }
        return false;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Username check error: " + e.getMessage());
        }
        return false;
    }
}