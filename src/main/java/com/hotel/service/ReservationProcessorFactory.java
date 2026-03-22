package com.hotel.service;

//Factory Method Pattern
public class ReservationProcessorFactory {

    public static ReservationProcessor getProcessor(String roomType) {
        if ("Deluxe".equalsIgnoreCase(roomType) || "Suite".equalsIgnoreCase(roomType)) {
            return new DeluxeReservationProcessor();
        } else {
            return new StandardReservationProcessor();
        }
    }
}
