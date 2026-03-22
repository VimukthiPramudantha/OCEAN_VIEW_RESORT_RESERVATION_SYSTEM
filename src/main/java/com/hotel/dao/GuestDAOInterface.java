package com.hotel.dao;

import com.hotel.model.Guest;
import java.util.List;

// Abstraction
public interface GuestDAOInterface extends BaseDAO<Guest, Integer> {
    Guest findByContactOrNic(String contact, String nicPassport);
    Guest findByNicOrContact(String term);
    List<Guest> searchGuests(String searchTerm);
    String getGuestNameById(Integer guestId);
}
