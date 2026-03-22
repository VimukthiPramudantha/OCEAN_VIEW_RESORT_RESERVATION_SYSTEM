package com.hotel.service;

import com.hotel.model.Reservation;

// Polymorphism
public class StandardReservationProcessor implements ReservationProcessor {
    @Override
    public void process(Reservation reservation) {
        System.out.println("Processing standard reservation: " + reservation.getReservationNumber());
        
    }
}
