package com.hotel.dto;

import java.sql.Date;
import java.sql.Time;

public class ReservationDisplayDTO {
    private Integer id;
    private String reservationNumber;
    private Integer guestId;
    private String guestName;           // ← display-only field from JOIN
    private Integer roomId;
    private String roomType;            // optional — if you join it
    private Date checkIn;
    private Date checkOut;
    private Double ratePerNight;
    private String specialRequests;
    private String vehicleNumber;
    private Time wakeUpCall;
    private Boolean luggageStorage;
    private String loyaltyNumber;
    private String roomPreference;
    private String status;              // add if you have status in DB

    // Constructors
    public ReservationDisplayDTO() {}

    // Getters & Setters (generate all - IDE can do this)
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public Integer getGuestId() { return guestId; }
    public void setGuestId(Integer guestId) { this.guestId = guestId; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }

    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }

    public Double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(Double ratePerNight) { this.ratePerNight = ratePerNight; }

    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }

    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }

    public Time getWakeUpCall() { return wakeUpCall; }
    public void setWakeUpCall(Time wakeUpCall) { this.wakeUpCall = wakeUpCall; }

    public Boolean getLuggageStorage() { return luggageStorage; }
    public void setLuggageStorage(Boolean luggageStorage) { this.luggageStorage = luggageStorage; }

    public String getLoyaltyNumber() { return loyaltyNumber; }
    public void setLoyaltyNumber(String loyaltyNumber) { this.loyaltyNumber = loyaltyNumber; }

    public String getRoomPreference() { return roomPreference; }
    public void setRoomPreference(String roomPreference) { this.roomPreference = roomPreference; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}