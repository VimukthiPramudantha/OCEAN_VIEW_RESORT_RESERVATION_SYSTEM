package com.hotel.dao;

import com.hotel.model.Guest;
import java.sql.*;
import java.util.List;

public class GuestDAO extends BaseDAO {

    /**
     * Mapping result set to Guest object.
     */
    private Guest mapGuest(ResultSet rs) throws SQLException {
        Guest g = new Guest();
        g.setId(rs.getInt("guest_id"));
        g.setName(rs.getString("name"));
        g.setNicPassport(rs.getString("nic_passport"));
        g.setAdults(rs.getInt("adults"));
        g.setChildren(rs.getInt("children"));
        g.setInfants(rs.getInt("infants"));
        g.setNationality(rs.getString("nationality"));
        g.setContact(rs.getString("contact"));
        g.setEmail(rs.getString("email"));
        return g;
    }

    public Guest findByContactOrNic(String contact, String nicPassport) {
        String sql = "SELECT * FROM guests WHERE contact = ? OR nic_passport = ? LIMIT 1";
        return querySingle(sql, this::mapGuest, contact, nicPassport);
    }

    public Guest findByNicOrContact(String term) {
        String sql = "SELECT * FROM guests WHERE nic_passport = ? OR contact = ? LIMIT 1";
        return querySingle(sql, this::mapGuest, term, term);
    }

    public int save(Guest guest) {
        String sql = """
                    INSERT INTO guests (name, nic_passport, adults, children, infants,
                                        nationality, contact, email)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;
        return insertAndGetId(sql,
                guest.getName(),
                guest.getNicPassport(),
                guest.getAdults() != null ? guest.getAdults() : 1,
                guest.getChildren() != null ? guest.getChildren() : 0,
                guest.getInfants() != null ? guest.getInfants() : 0,
                guest.getNationality(),
                guest.getContact(),
                guest.getEmail());
    }

    public String getGuestNameById(Integer guestId) {
        if (guestId == null || guestId <= 0)
            return null;
        String sql = "SELECT name FROM guests WHERE guest_id = ?";
        return querySingle(sql, rs -> rs.getString("name"), guestId);
    }

    public Guest findById(int id) {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";
        return querySingle(sql, this::mapGuest, id);
    }

    public List<Guest> findAll() {
        String sql = "SELECT * FROM guests ORDER BY name ASC";
        return queryList(sql, this::mapGuest);
    }

    public List<Guest> searchGuests(String searchTerm) {
        String sql = """
                    SELECT * FROM guests
                    WHERE name LIKE ? OR nic_passport LIKE ? OR contact LIKE ?
                    ORDER BY name ASC
                """;
        String likeTerm = "%" + searchTerm.trim() + "%";
        return queryList(sql, this::mapGuest, likeTerm, likeTerm, likeTerm);
    }
}
