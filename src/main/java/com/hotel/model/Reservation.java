package com.hotel.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;
import java.time.temporal.ChronoUnit;

// Builder Pattern
// Encapsulation
public class Reservation implements Serializable {
    private Integer id;
    private String reservationNumber;
    private Integer guestId;
    private Integer roomId;
    private Date checkIn;
    private Date checkOut;
    private Double ratePerNight;
    private String specialRequests;
    private String vehicleNumber;
    private Time wakeUpCall;
    private Boolean luggageStorage;
    private String loyaltyNumber;
    private String roomPreference;
    private Double totalAmount;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getReservationNumber() {
        return reservationNumber;
    }

    public void setReservationNumber(String reservationNumber) {
        this.reservationNumber = reservationNumber;
    }

    public Integer getGuestId() {
        return guestId;
    }

    public void setGuestId(Integer guestId) {
        this.guestId = guestId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public Date getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Date checkIn) {
        this.checkIn = checkIn;
    }

    public Date getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public Double getRatePerNight() {
        return ratePerNight;
    }

    public void setRatePerNight(Double ratePerNight) {
        this.ratePerNight = ratePerNight;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public Time getWakeUpCall() {
        return wakeUpCall;
    }

    public void setWakeUpCall(Time wakeUpCall) {
        this.wakeUpCall = wakeUpCall;
    }

    public Boolean getLuggageStorage() {
        return luggageStorage;
    }

    public void setLuggageStorage(Boolean luggageStorage) {
        this.luggageStorage = luggageStorage;
    }

    public String getLoyaltyNumber() {
        return loyaltyNumber;
    }

    public void setLoyaltyNumber(String loyaltyNumber) {
        this.loyaltyNumber = loyaltyNumber;
    }

    public String getRoomPreference() {
        return roomPreference;
    }

    public void setRoomPreference(String roomPreference) {
        this.roomPreference = roomPreference;
    }

    public long getNights() {
        if (checkIn != null && checkOut != null) {
            return ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
        }
        return 0;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public static class Builder {
        private final Reservation reservation = new Reservation();

        public Builder id(Integer id) { reservation.setId(id); return this; }
        public Builder reservationNumber(String reservationNumber) { reservation.setReservationNumber(reservationNumber); return this; }
        public Builder guestId(Integer guestId) { reservation.setGuestId(guestId); return this; }
        public Builder roomId(Integer roomId) { reservation.setRoomId(roomId); return this; }
        public Builder checkIn(Date checkIn) { reservation.setCheckIn(checkIn); return this; }
        public Builder checkOut(Date checkOut) { reservation.setCheckOut(checkOut); return this; }
        public Builder ratePerNight(Double ratePerNight) { reservation.setRatePerNight(ratePerNight); return this; }
        public Builder specialRequests(String specialRequests) { reservation.setSpecialRequests(specialRequests); return this; }
        public Builder vehicleNumber(String vehicleNumber) { reservation.setVehicleNumber(vehicleNumber); return this; }
        public Builder wakeUpCall(Time wakeUpCall) { reservation.setWakeUpCall(wakeUpCall); return this; }
        public Builder luggageStorage(Boolean luggageStorage) { reservation.setLuggageStorage(luggageStorage); return this; }
        public Builder loyaltyNumber(String loyaltyNumber) { reservation.setLoyaltyNumber(loyaltyNumber); return this; }
        public Builder roomPreference(String roomPreference) { reservation.setRoomPreference(roomPreference); return this; }
        public Builder totalAmount(Double totalAmount) { reservation.setTotalAmount(totalAmount); return this; }

        public Reservation build() {
            return reservation;
        }
    }
}
