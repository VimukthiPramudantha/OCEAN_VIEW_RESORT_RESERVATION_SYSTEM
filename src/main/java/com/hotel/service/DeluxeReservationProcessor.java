package com.hotel.service;

import com.hotel.model.Reservation;

// Polymorphism
public class DeluxeReservationProcessor implements ReservationProcessor {
    @Override
    public void process(Reservation reservation) {
        System.out.println("Processing deluxe reservation: " + reservation.getReservationNumber());
        reservation.setSpecialRequests((reservation.getSpecialRequests() != null ? reservation.getSpecialRequests() + "; " : "") 
            + "DELUXE WELCOME PACKAGE INCLUDED");
    }
}
