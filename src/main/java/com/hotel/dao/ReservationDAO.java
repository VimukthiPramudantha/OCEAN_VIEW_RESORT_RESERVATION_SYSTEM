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
    // Constants & Shared Query Logic
    // ------------------------------------------------------

    private static final String BASE_RESERVATION_SELECT = """
                SELECT r.*, g.name AS guest_name, g.adults, g.children
                FROM reservations r
                JOIN guests g ON r.guest_id = g.guest_id
            """;

    private List<ReservationDisplayDTO> fetchReservations(String sql, Object... params) {
        List<ReservationDisplayDTO> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapToDisplayDTO(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Database query failed: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    private ReservationDisplayDTO fetchSingleReservation(String sql, Object... params) {
        List<ReservationDisplayDTO> results = fetchReservations(sql, params);
        return results.isEmpty() ? null : results.get(0);
    }

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
            int rowsRemoved = psDelete.executeUpdate();
            if (rowsRemoved == 0)
                return false;
        }

        // Free room
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
     */
    public List<ReservationDisplayDTO> findActiveForCancellation() {
        String sql = BASE_RESERVATION_SELECT
                + " WHERE r.status NOT IN ('cancelled', 'checked_out') ORDER BY r.check_in ASC";
        return fetchReservations(sql);
    }

    public List<ReservationDisplayDTO> findAll() {
        String sql = BASE_RESERVATION_SELECT + " ORDER BY r.check_in DESC";
        return fetchReservations(sql);
    }

    /**
     * Find active reservations eligible for details update
     */
    public List<ReservationDisplayDTO> findActiveForUpdate() {
        String sql = BASE_RESERVATION_SELECT
                + " WHERE r.status NOT IN ('cancelled', 'checked_out') ORDER BY r.check_in DESC";
        return fetchReservations(sql);
    }

    public List<ReservationDisplayDTO> findByDateRange(Date start, Date end) {
        String sql = BASE_RESERVATION_SELECT + """
                     WHERE (r.check_in <= ? AND r.check_out >= ?)
                        OR (r.check_in >= ? AND r.check_in <= ?)
                        OR (r.check_out >= ? AND r.check_out <= ?)
                     ORDER BY r.check_in DESC
                """;
        return fetchReservations(sql, end, start, start, end, start, end);
    }

    /**
     * Delete a reservation by ID and free up the associated room
     */
    public boolean delete(int reservationId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            boolean success = delete(reservationId, conn);
            if (success)
                conn.commit();
            return success;
        } catch (SQLException e) {
            System.err.println("Delete + free room failed: " + e.getMessage());
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
        try (Connection conn = DBUtil.getConnection()) {
            return updateStatus(reservationId, newStatus, conn);
        } catch (SQLException e) {
            System.err.println("Status update failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Find single reservation by ID
     */
    public ReservationDisplayDTO findById(int id) {
        String sql = BASE_RESERVATION_SELECT + " WHERE r.reservation_id = ?";
        return fetchSingleReservation(sql, id);
    }

    public boolean hasOverlapExcludingSelf(int reservationId, Date newCheckIn, Date newCheckOut) {
        String sql = """
                    SELECT COUNT(*) > 0
                    FROM reservations
                    WHERE reservation_id != ?
                      AND status NOT IN ('cancelled', 'checked_out')
                      AND (
                          (check_in <= ? AND check_out >= ?) OR
                          (check_in >= ? AND check_in <= ?) OR
                          (check_out >= ? AND check_out <= ?)
                      )
                """;

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            ps.setDate(2, newCheckOut);
            ps.setDate(3, newCheckIn);
            ps.setDate(4, newCheckIn);
            ps.setDate(5, newCheckOut);
            ps.setDate(6, newCheckIn);
            ps.setDate(7, newCheckOut);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Overlap check failed: " + e.getMessage());
        }
        return false;
    }

    public List<ReservationDisplayDTO> findByGuestId(int guestId) {
        String sql = BASE_RESERVATION_SELECT + " WHERE r.guest_id = ? ORDER BY r.check_in DESC";
        return fetchReservations(sql, guestId);
    }

    public boolean updateDetails(int reservationId, String specialRequests, int adults, int children, Date newCheckIn,
            Date newCheckOut) {
        String findGuestSql = "SELECT guest_id FROM reservations WHERE reservation_id = ?";
        String updateGuestSql = "UPDATE guests SET adults = ?, children = ? WHERE guest_id = ?";
        String updateResSql = """
                    UPDATE reservations
                    SET special_requests = ?,
                        check_in = ?,
                        check_out = ?
                    WHERE reservation_id = ?
                """;

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            int guestId = -1;
            try (PreparedStatement ps = conn.prepareStatement(findGuestSql)) {
                ps.setInt(1, reservationId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        guestId = rs.getInt(1);
                }
            }

            if (guestId == -1)
                return false;

            try (PreparedStatement ps = conn.prepareStatement(updateGuestSql)) {
                ps.setInt(1, adults);
                ps.setInt(2, children);
                ps.setInt(3, guestId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(updateResSql)) {
                ps.setString(1, specialRequests);
                ps.setDate(2, newCheckIn);
                ps.setDate(3, newCheckOut);
                ps.setInt(4, reservationId);
                int rows = ps.executeUpdate();
                conn.commit();
                return rows > 0;
            }
        } catch (SQLException e) {
            System.err.println("Update reservation failed: " + e.getMessage());
            rollbackQuietly(conn);
            return false;
        } finally {
            resetAutoCommitAndClose(conn);
        }
    }

    public List<ReservationDisplayDTO> findAllActive() {
        String sql = BASE_RESERVATION_SELECT
                + " WHERE r.status IN ('confirmed', 'checked_in', 'pending') ORDER BY r.check_in DESC";
        return fetchReservations(sql);
    }

    public List<ReservationDisplayDTO> findByStatus(String status) {
        String sql = BASE_RESERVATION_SELECT + " WHERE r.status = ? ORDER BY r.check_in DESC";
        return fetchReservations(sql, status);
    }

    public ReservationDisplayDTO findByReservationNumber(String reservationNumber) {
        if (reservationNumber == null || reservationNumber.trim().isEmpty())
            return null;
        String sql = BASE_RESERVATION_SELECT + " WHERE r.reservation_number = ?";
        return fetchSingleReservation(sql, reservationNumber.trim());
    }

    public List<ReservationDisplayDTO> findByGuestName(String guestName) {
        if (guestName == null || guestName.trim().isEmpty())
            return new ArrayList<>();
        String searchPattern = "%" + guestName.trim().toLowerCase() + "%";
        String sql = BASE_RESERVATION_SELECT + " WHERE LOWER(g.name) LIKE ? ORDER BY r.check_in DESC";
        return fetchReservations(sql, searchPattern);
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
        dto.setAdults(rs.getInt("adults"));
        dto.setChildren(rs.getInt("children"));
        return dto;
    }

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
