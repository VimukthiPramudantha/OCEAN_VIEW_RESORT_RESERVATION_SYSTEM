package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.model.Reservation;

import java.math.BigDecimal;
import java.sql.*;

public class ReservationDAO {

    /**
     * Count reservations where check-in is today and status is 'confirmed'
     */
    public int countTodayCheckins() {
        String sql = """
            SELECT COUNT(*) 
            FROM reservations 
            WHERE check_in = CURDATE() 
              AND status = 'confirmed'
        """;
        return executeCountQuery(sql);
    }

    /**
     * Count reservations where check-out is today and status is 'checked_in'
     */
    public int countTodayCheckouts() {
        String sql = """
            SELECT COUNT(*) 
            FROM reservations 
            WHERE check_out = CURDATE() 
              AND status = 'checked_in'
        """;
        return executeCountQuery(sql);
    }

    /**
     * Sum total_amount for today's check-outs (returns 0.00 if none)
     */
    public BigDecimal sumTodayRevenue() {
        String sql = """
            SELECT COALESCE(SUM(total_amount), 0.00) 
            FROM reservations 
            WHERE check_out = CURDATE() 
              AND status = 'checked_out'
        """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Error calculating today revenue: " + e.getMessage());
        }

        return BigDecimal.ZERO;  // never null
    }

    /**
     * Save a new reservation
     */
    public boolean save(Reservation res) {
        String sql = """
            INSERT INTO reservations (
                reservation_number, guest_id, room_id, 
                check_in, check_out, rate_per_night,
                special_requests, vehicle_number,
                wake_up_call, luggage_storage,
                loyalty_number, room_preference
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);  // transaction

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, res.getReservationNumber());
                ps.setInt(2, res.getGuestId());
                ps.setInt(3, res.getRoomId());
                ps.setDate(4, res.getCheckIn());
                ps.setDate(5, res.getCheckOut());
                ps.setDouble(6, res.getRatePerNight());
                ps.setString(7, res.getSpecialRequests());
                ps.setString(8, res.getVehicleNumber());
                ps.setTime(9, res.getWakeUpCall());
                ps.setBoolean(10, res.getLuggageStorage() != null && res.getLuggageStorage());
                ps.setString(11, res.getLoyaltyNumber());
                ps.setString(12, res.getRoomPreference());

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            res.setId(rs.getInt(1));
                        }
                    }
                    conn.commit();
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Reservation save failed: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Rollback failed: " + rollbackEx.getMessage());
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    System.err.println("Connection close failed: " + closeEx.getMessage());
                }
            }
        }

        return false;
    }

    // Helper: execute COUNT(*) queries safely
    private int executeCountQuery(String sql) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Count query failed: " + e.getMessage());
        }
        return 0;
    }
}