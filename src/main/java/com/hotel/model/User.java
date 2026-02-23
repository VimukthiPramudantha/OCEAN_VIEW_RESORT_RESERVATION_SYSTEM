package com.hotel.model;

import java.io.Serializable;

public class User implements Serializable {
    private String username;
    private String password;      // plain for now; NEVER in prod
    private String fullName;
    private String role;          // e.g. "admin", "staff"

    // Constructors
    public User() {}

    public User(String username, String password, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
    }

    // Getters & Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    @Override
    public String toString() {
        return "User{username='" + username + "', role='" + role + "'}";
    }
}