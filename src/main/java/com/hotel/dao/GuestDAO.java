package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.model.Guest;

import java.sql.*;

public class GuestDAO {

    /**
     * Find existing guest by contact number or NIC/passport
     * Used to avoid duplicate guests
     */
    public Guest findByContactOrNic(String contact, String nicPassport) {
        String sql = "SELECT * FROM guests WHERE contact = ? OR nic_passport = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, contact);
            ps.setString(2, nicPassport);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
            }
        } catch (SQLException e) {
            System.err.println("Guest lookup error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Save new guest and return the generated ID
     */
    public int save(Guest guest) {
        String sql = "INSERT INTO guests (name, nic_passport, adults, children, infants, " +
                "nationality, contact, email) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, guest.getName());
            ps.setString(2, guest.getNicPassport());
            ps.setInt(3, guest.getAdults() != null ? guest.getAdults() : 1);
            ps.setInt(4, guest.getChildren() != null ? guest.getChildren() : 0);
            ps.setInt(5, guest.getInfants() != null ? guest.getInfants() : 0);
            ps.setString(6, guest.getNationality());
            ps.setString(7, guest.getContact());
            ps.setString(8, guest.getEmail());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Guest save error: " + e.getMessage());
        }
        return -1; // failure
    }

    /**
     * Retrieves the full name of a guest by their guest_id.
     * Returns null if no guest is found with that ID.
     */
    public String getGuestNameById(Integer guestId) {
        if (guestId == null || guestId <= 0) {
            return null; // invalid ID
        }

        String sql = "SELECT name FROM guests WHERE guest_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, guestId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                }
            }
        } catch (SQLException e) {
            System.err.println("Failed to fetch guest name for ID " + guestId + ": " + e.getMessage());
            // In production: use proper logging (SLF4J/Log4j), not System.err
        }

        return null;  // guest not found
    }
}