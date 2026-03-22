package com.hotel.model;



//Inheritance (Extends Person)
//Encapsulation (Private fields with Getters/Setters)
public class User extends Person {
    private String username;
    private String password;
    private String role;

    // Constructors
    public User() {
        super();
    }

    public User(String username, String password, String name, String role) {
        super(name, null, null);
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return getName(); }
    public void setFullName(String fullName) { setName(fullName); }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    @Override
    public String toString() {
        return "User{username='" + username + "', role='" + role + "', name='" + getName() + "'}";
    }
}