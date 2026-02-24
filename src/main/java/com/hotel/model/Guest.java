package com.hotel.model;

import java.io.Serializable;

public class Guest implements Serializable {
    private Integer id;              // guest_id (auto-generated)
    private String name;
    private String nicPassport;
    private Integer adults;
    private Integer children;
    private Integer infants;
    private String nationality;
    private String contact;
    private String email;
    private String address;          // optional — add if needed later

    // Constructors
    public Guest() {}

    // Getters & Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getNicPassport() { return nicPassport; }
    public void setNicPassport(String nicPassport) { this.nicPassport = nicPassport; }

    public Integer getAdults() { return adults; }
    public void setAdults(Integer adults) { this.adults = adults; }

    public Integer getChildren() { return children; }
    public void setChildren(Integer children) { this.children = children; }

    public Integer getInfants() { return infants; }
    public void setInfants(Integer infants) { this.infants = infants; }

    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    @Override
    public String toString() {
        return "Guest{id=" + id + ", name='" + name + "', contact='" + contact + "'}";
    }
}