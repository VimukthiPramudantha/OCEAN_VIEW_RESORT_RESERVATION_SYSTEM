package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.Reservation;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // ------------------------------------------------------
    // Summary / Dashboard queries (non-transactional)
    // ------------------------------------------------------

    public int countTodayCheckins() {
        String sql = """
                    SELECT COUNT(*)
                    FROM reservations
                    WHERE check_in = CURDATE()
                      AND status = 'confirmed'
                """;
        return executeCountQuery(sql);
    }

    public int countTodayCheckouts() {
        String sql = """
                    SELECT COUNT(*)
                    FROM reservations
                    WHERE check_out = CURDATE()
                      AND status = 'checked_in'
                """;
        return executeCountQuery(sql);
    }

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
            System.err.println("Error calculating today's revenue: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    // ------------------------------------------------------
    // CRUD Operations (transaction-aware where needed)
    // ------------------------------------------------------

    /**
     * Save new reservation using provided connection (caller manages transaction)
     */
    public boolean save(Reservation res, Connection conn) throws SQLException {
        String sql = """
                    INSERT INTO reservations (
                        reservation_number, guest_id, room_id,
                        check_in, check_out, rate_per_night,
                        special_requests, vehicle_number,
                        wake_up_call, luggage_storage,
                        loyalty_number, room_preference
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

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
                return true;
            }
            return false;
        }
    }

    /**
     * Delete reservation and free room using provided connection
     */
    public boolean delete(int reservationId, Connection conn) throws SQLException {
        String findRoomSql = "SELECT room_id FROM reservations WHERE reservation_id = ?";
        String deleteSql = "DELETE FROM reservations WHERE reservation_id = ?";
        String freeRoomSql = "UPDATE rooms SET status = 'available' WHERE room_id = ?";

        Integer roomId = null;

        // Get room_id first
        try (PreparedStatement psFind = conn.prepareStatement(findRoomSql)) {
            psFind.setInt(1, reservationId);
            try (ResultSet rs = psFind.executeQuery()) {
                if (rs.next()) {
                    roomId = rs.getInt("room_id");
                } else {
                    return false;
                }
            }
        }

        // Delete reservation
        try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
            psDelete.setInt(1, reservationId);
            int rows = psDelete.executeUpdate();
            if (rows == 0)
                return false;
        }

        // Free room if found
        if (roomId != null) {
            try (PreparedStatement psFree = conn.prepareStatement(freeRoomSql)) {
                psFree.setInt(1, roomId);
                psFree.executeUpdate();
            }
        }

        return true;
    }

    /**
     * Update reservation status using provided connection
     */
    public boolean updateStatus(int reservationId, String newStatus, Connection conn) throws SQLException {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, reservationId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Get room_id for a reservation (used in cancel/delete)
     */
    public Integer getRoomIdByReservationId(int reservationId, Connection conn) throws SQLException {
        String sql = "SELECT room_id FROM reservations WHERE reservation_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("room_id");
                }
            }
        }
        return null;
    }

    // ------------------------------------------------------
    // Query / Display methods
    // ------------------------------------------------------

    /**
     * Find only active reservations eligible for cancellation
     * Excludes 'cancelled' and 'checked_out' statuses
     */
    public List<ReservationDisplayDTO> findActiveForCancellation() {
        List<ReservationDisplayDTO> list = new ArrayList<>();
        String sql = """
                    SELECT r.*, g.name AS guest_name
                    FROM reservations r
                    JOIN guests g ON r.guest_id = g.guest_id
                    WHERE r.status NOT IN ('cancelled', 'checked_out')
                    ORDER BY r.check_in ASC
                """;

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapToDisplayDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("Active reservations query failed: " + e.getMessage());
        }
        return list;
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
                list.add(mapToDisplayDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("Failed to fetch all reservations: " + e.getMessage());
        }
        return list;
    }

    /**
     * Find reservations within a date range (overlapping check-in/out)
     */
    public List<ReservationDisplayDTO> findByDateRange(Date start, Date end) {
        List<ReservationDisplayDTO> list = new ArrayList<>();
        String sql = """
                    SELECT r.*, g.name AS guest_name
                    FROM reservations r
                    JOIN guests g ON r.guest_id = g.guest_id
                    WHERE (r.check_in <= ? AND r.check_out >= ?)
                       OR (r.check_in >= ? AND r.check_in <= ?)
                       OR (r.check_out >= ? AND r.check_out <= ?)
                    ORDER BY r.check_in DESC
                """;

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, end);
            ps.setDate(2, start);
            ps.setDate(3, start);
            ps.setDate(4, end);
            ps.setDate(5, start);
            ps.setDate(6, end);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapToDisplayDTO(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Date range query failed: " + e.getMessage());
        }
        return list;
    }

    /**
     * Delete a reservation by ID and free up the associated room
     * Returns true if successful, false otherwise
     */
    public boolean delete(int reservationId) {
        String findRoomSql = "SELECT room_id FROM reservations WHERE reservation_id = ?";
        String deleteResSql = "DELETE FROM reservations WHERE reservation_id = ?";
        String freeRoomSql = "UPDATE rooms SET status = 'available' WHERE room_id = ?";

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Get the room_id BEFORE deleting
            Integer roomId = null;
            try (PreparedStatement psFind = conn.prepareStatement(findRoomSql)) {
                psFind.setInt(1, reservationId);
                try (ResultSet rs = psFind.executeQuery()) {
                    if (rs.next()) {
                        roomId = rs.getInt("room_id");
                    } else {
                        return false; // reservation doesn't exist
                    }
                }
            }

            // Step 2: Delete the reservation
            try (PreparedStatement psDelete = conn.prepareStatement(deleteResSql)) {
                psDelete.setInt(1, reservationId);
                int rowsDeleted = psDelete.executeUpdate();
                if (rowsDeleted == 0) {
                    return false;
                }
            }

            // Step 3: Free the room (only if we found a room_id)
            if (roomId != null) {
                try (PreparedStatement psFree = conn.prepareStatement(freeRoomSql)) {
                    psFree.setInt(1, roomId);
                    psFree.executeUpdate(); // no need to check rows — room might already be free
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Delete + free room failed: " + e.getMessage());
            e.printStackTrace();
            rollbackQuietly(conn);
            return false;
        } finally {
            resetAutoCommitAndClose(conn);
        }
    }

    /**
     * Update reservation status (e.g. 'cancelled', 'checked_in')
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

    // ------------------------------------------------------
    // Query / Display methods
    // ------------------------------------------------------

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
            System.err.println("Failed to fetch reservation ID " + id + ": " + e.getMessage());
        }
        return null;
    }

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
        dto.setStatus(rs.getString("status"));
        return dto;
    }

    // ------------------------------------------------------
    // Helpers
    // ------------------------------------------------------

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

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ignored) {
            }
        }
    }

    private void resetAutoCommitAndClose(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException ignored) {
            }
        }
    }
}