package com.hotel.dao;

import com.hotel.model.User;

public class UserDAO extends BaseDAO {

    public User findByUsernameAndPassword(String username, String password) {
        String sql = "SELECT username, password, full_name, role FROM users WHERE username = ? AND password = ?";

        return querySingle(sql, rs -> {
            User user = new User();
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setFullName(rs.getString("full_name"));
            user.setRole(rs.getString("role"));
            return user;
        }, username, password);
    }
}