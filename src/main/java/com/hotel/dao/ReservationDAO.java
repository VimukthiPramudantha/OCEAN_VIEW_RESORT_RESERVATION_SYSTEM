package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.Reservation;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
     * Sum total_amount for today's check-outs (never returns null)
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
        return BigDecimal.ZERO;
    }

    /**
     * Save a new reservation with transaction
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
            conn.setAutoCommit(false);

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
                ps.setBoolean(10, Boolean.TRUE.equals(res.getLuggageStorage()));
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
            rollbackQuietly(conn);
        } finally {
            resetAutoCommitAndClose(conn);
        }
        return false;
    }

    /**
     * Delete a reservation by ID
     * Returns true if deleted, false otherwise
     */
    public boolean delete(int reservationId) {
        String deleteResSql = "DELETE FROM reservations WHERE reservation_id = ?";
        String updateRoomSql = """
        UPDATE rooms r
        SET status = 'available'
        WHERE r.room_id = (
            SELECT room_id FROM reservations WHERE reservation_id = ?
        )
    """;

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Delete reservation
            try (PreparedStatement psDelete = conn.prepareStatement(deleteResSql)) {
                psDelete.setInt(1, reservationId);
                int rowsDeleted = psDelete.executeUpdate();
                if (rowsDeleted == 0) {
                    return false; // nothing to delete
                }
            }

            // Step 2: Free the room
            try (PreparedStatement psUpdate = conn.prepareStatement(updateRoomSql)) {
                psUpdate.setInt(1, reservationId);
                psUpdate.executeUpdate();  // no need to check rows — room might already be free
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Delete + free room failed: " + e.getMessage());
            rollbackQuietly(conn);
            return false;
        } finally {
            resetAutoCommitAndClose(conn);
        }
    }

    /**
     * Update reservation status (e.g. to 'cancelled')
     */
    public boolean updateStatus(int reservationId, String newStatus) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Status update failed: " + e.getMessage());
            return false;
        }
    }


    /**
     * Find all reservations with guest name for display
     */
    public List<ReservationDisplayDTO> findAll() {
        List<ReservationDisplayDTO> list = new ArrayList<>();
        String sql = """
            SELECT r.*, g.name AS guest_name
            FROM reservations r
            JOIN guests g ON r.guest_id = g.guest_id
            ORDER BY r.check_in DESC
        """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ReservationDisplayDTO dto = mapToDisplayDTO(rs);
                list.add(dto);
            }
        } catch (SQLException e) {
            System.err.println("Find all reservations failed: " + e.getMessage());
        }
        return list;
    }

    /**
     * Find single reservation by ID with guest name
     */
    public ReservationDisplayDTO findById(int id) {
        String sql = """
            SELECT r.*, g.name AS guest_name
            FROM reservations r
            JOIN guests g ON r.guest_id = g.guest_id
            WHERE r.reservation_id = ?
        """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapToDisplayDTO(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Find reservation by ID failed: " + e.getMessage());
        }
        return null;
    }

    // Helper: map ResultSet to DTO
    private ReservationDisplayDTO mapToDisplayDTO(ResultSet rs) throws SQLException {
        ReservationDisplayDTO dto = new ReservationDisplayDTO();
        dto.setId(rs.getInt("reservation_id"));
        dto.setReservationNumber(rs.getString("reservation_number"));
        dto.setGuestId(rs.getInt("guest_id"));
        dto.setGuestName(rs.getString("guest_name"));
        dto.setRoomId(rs.getInt("room_id"));
        dto.setCheckIn(rs.getDate("check_in"));
        dto.setCheckOut(rs.getDate("check_out"));
        dto.setRatePerNight(rs.getDouble("rate_per_night"));
        dto.setSpecialRequests(rs.getString("special_requests"));
        dto.setVehicleNumber(rs.getString("vehicle_number"));
        dto.setWakeUpCall(rs.getTime("wake_up_call"));
        dto.setLuggageStorage(rs.getBoolean("luggage_storage"));
        dto.setLoyaltyNumber(rs.getString("loyalty_number"));
        dto.setRoomPreference(rs.getString("room_preference"));
        // Add more if needed (e.g. status)
        return dto;
    }

// Helper for COUNT queries
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

    // Helper: rollback without throwing
    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ignored) {}
        }
    }

    // Helper: reset auto-commit and close
    private void resetAutoCommitAndClose(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException ignored) {}
        }
    }
}