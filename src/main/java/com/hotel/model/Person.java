package com.hotel.model;

import java.io.Serializable;

//Abstraction (Abstract Base Class)
//Inheritance (Foundation for User and Guest)
//Encapsulation (Private fields with Getters/Setters)
public abstract class Person implements Serializable {
    private String name;
    private String email;
    private String contact;

    public Person() {}

    public Person(String name, String email, String contact) {
        this.name = name;
        this.email = email;
        this.contact = contact;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    @Override
    public String toString() {
        return "Person{name='" + name + "', email='" + email + "', contact='" + contact + "'}";
    }
}
