package com.hotel.model;



//Inheritance (Extends Person)
//Encapsulation (Private fields with Getters/Setters)
public class Guest extends Person {
    private Integer id;        
    private String nicPassport;
    private Integer adults;
    private Integer children;
    private Integer infants;
    private String nationality;
    private String address;    

    // Constructors
    public Guest() {
        super();
    }

    // Getters & Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

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

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    @Override
    public String toString() {
        return "Guest{id=" + id + ", name='" + getName() + "', contact='" + getContact() + "'}";
    }
}