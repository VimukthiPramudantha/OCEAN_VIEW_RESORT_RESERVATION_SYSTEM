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
}