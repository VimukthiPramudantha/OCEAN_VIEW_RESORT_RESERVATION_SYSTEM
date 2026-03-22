package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.model.Guest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Design Pattern: Singleton
// Design Pattern: DAO Pattern
public class GuestDAO implements GuestDAOInterface {

    private static GuestDAO instance;

    private GuestDAO() {}

    public static synchronized GuestDAO getInstance() {
        if (instance == null) {
            instance = new GuestDAO();
        }
        return instance;
    }

    @Override
    public boolean save(Guest guest) {
        int id = saveAndReturnId(guest);
        if (id > 0) {
            guest.setId(id);
            return true;
        }
        return false;
    }

    public int saveAndReturnId(Guest guest) {
        String sql = "INSERT INTO guests (name, nic_passport, adults, children, infants, nationality, contact, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
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
            int rows = ps.executeUpdate();
            if (rows == 0) return -1;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
            return -1;
        } catch (SQLException e) {
            System.err.println("Guest insert failed: " + e.getMessage());
            return -1;
        }
    }

    @Override
    public Guest findById(Integer id) {
        return findById((int) id);
    }

    @Override
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

    @Override
    public Guest findByNicOrContact(String term) {
        String sql = "SELECT * FROM guests WHERE nic_passport = ? OR contact = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, term);
            ps.setString(2, term);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Guest g = new Guest();
                    g.setId(rs.getInt("guest_id"));
                    g.setName(rs.getString("name"));
                    g.setNicPassport(rs.getString("nic_passport"));
                    g.setContact(rs.getString("contact"));
                    g.setEmail(rs.getString("email"));
                    g.setNationality(rs.getString("nationality"));
                    return g;
                }
            }
        } catch (SQLException e) {
            System.err.println("Guest search failed: " + e.getMessage());
        }
        return null;
    }

    public String getGuestNameById(Integer guestId) {
        if (guestId == null || guestId <= 0) return null;
        String sql = "SELECT name FROM guests WHERE guest_id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("name");
            }
        } catch (SQLException e) {
            System.err.println("Failed to fetch guest name for ID " + guestId + ": " + e.getMessage());
        }
        return null;
    }

    public Guest findById(int id) {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
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
            System.err.println("Failed to find guest by ID " + id + ": " + e.getMessage());
        }
        return null;
    }

    public List<Guest> findAll() {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM guests ORDER BY name ASC";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
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
                list.add(g);
            }
        } catch (SQLException e) {
            System.err.println("Failed to fetch all guests: " + e.getMessage());
        }
        return list;
    }

    public List<Guest> searchGuests(String searchTerm) {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM guests WHERE name LIKE ? OR nic_passport LIKE ? OR contact LIKE ? ORDER BY name ASC";
        String likeTerm = "%" + searchTerm.trim() + "%";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, likeTerm);
            ps.setString(2, likeTerm);
            ps.setString(3, likeTerm);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
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
                    list.add(g);
                }
            }
        } catch (SQLException e) {
            System.err.println("Guest search failed: " + e.getMessage());
        }
        return list;
    }
}
