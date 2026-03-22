package com.hotel.service;

import com.hotel.model.Reservation;


//Abstraction and Polymorphism
public interface ReservationProcessor {
    void process(Reservation reservation);
}
