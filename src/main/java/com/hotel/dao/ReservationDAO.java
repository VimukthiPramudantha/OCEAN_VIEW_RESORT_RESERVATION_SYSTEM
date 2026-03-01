package com.hotel.dao;

import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.Reservation;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO extends BaseDAO {

    // ------------------------------------------------------
    // Constants & Shared Query Logic
    // ------------------------------------------------------

    private static final String BASE_RESERVATION_SELECT = """
                SELECT r.*, g.name AS guest_name, g.adults, g.children
                FROM reservations r
                JOIN guests g ON r.guest_id = g.guest_id
            """;

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

        try {
            dto.setTotalAmount(rs.getDouble("total_amount"));
        } catch (SQLException ignored) {
        }

        return dto;
    }

    // ------------------------------------------------------
    // Summary / Dashboard queries
    // ------------------------------------------------------

    public int countTodayCheckins() {
        String sql = """
                    SELECT COUNT(*)
                    FROM reservations
                    WHERE check_in = CURDATE()
                      AND status = 'confirmed'
                """;
        Integer count = querySingle(sql, rs -> rs.getInt(1));
        return count != null ? count : 0;
    }

    public int countTodayCheckouts() {
        String sql = """
                    SELECT COUNT(*)
                    FROM reservations
                    WHERE check_out = CURDATE()
                      AND status = 'checked_in'
                """;
        Integer count = querySingle(sql, rs -> rs.getInt(1));
        return count != null ? count : 0;
    }

    public BigDecimal sumTodayRevenue() {
        String sql = """
                    SELECT COALESCE(SUM(total_amount), 0.00)
                    FROM reservations
                    WHERE check_out = CURDATE()
                      AND status = 'checked_out'
                """;
        BigDecimal sum = querySingle(sql, rs -> rs.getBigDecimal(1));
        return sum != null ? sum : BigDecimal.ZERO;
    }

    // ------------------------------------------------------
    // CRUD Operations
    // ------------------------------------------------------

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
                    if (rs.next())
                        res.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        }
    }

    public boolean delete(int reservationId, Connection conn) throws SQLException {
        String findRoomSql = "SELECT room_id FROM reservations WHERE reservation_id = ?";
        String deleteSql = "DELETE FROM reservations WHERE reservation_id = ?";
        String freeRoomSql = "UPDATE rooms SET status = 'available' WHERE room_id = ?";

        Integer roomId = querySingle(findRoomSql, rs -> rs.getInt("room_id"), reservationId);
        if (roomId == null)
            return false;

        if (update(deleteSql, conn, reservationId) == 0)
            return false;

        update(freeRoomSql, conn, roomId);
        return true;
    }

    public boolean updateStatus(int reservationId, String newStatus, Connection conn) throws SQLException {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        return update(sql, conn, newStatus, reservationId) > 0;
    }

    public Integer getRoomIdByReservationId(int reservationId, Connection conn) throws SQLException {
        String sql = "SELECT room_id FROM reservations WHERE reservation_id = ?";
        return querySingle(sql, rs -> rs.getInt("room_id"), reservationId);
    }

    // ------------------------------------------------------
    // Query / Display methods
    // ------------------------------------------------------

    public List<ReservationDisplayDTO> findActiveForCancellation() {
        String sql = BASE_RESERVATION_SELECT
                + " WHERE r.status NOT IN ('cancelled', 'checked_out') ORDER BY r.check_in ASC";
        return queryList(sql, this::mapToDisplayDTO);
    }

    public List<ReservationDisplayDTO> findAll() {
        String sql = BASE_RESERVATION_SELECT + " ORDER BY r.check_in DESC";
        return queryList(sql, this::mapToDisplayDTO);
    }

    public List<ReservationDisplayDTO> findActiveForUpdate() {
        String sql = BASE_RESERVATION_SELECT
                + " WHERE r.status NOT IN ('cancelled', 'checked_out') ORDER BY r.check_in DESC";
        return queryList(sql, this::mapToDisplayDTO);
    }

    public List<ReservationDisplayDTO> findByDateRange(Date start, Date end) {
        String sql = BASE_RESERVATION_SELECT + """
                     WHERE (r.check_in <= ? AND r.check_out >= ?)
                        OR (r.check_in >= ? AND r.check_in <= ?)
                        OR (r.check_out >= ? AND r.check_out <= ?)
                     ORDER BY r.check_in DESC
                """;
        return queryList(sql, this::mapToDisplayDTO, end, start, start, end, start, end);
    }

    public boolean delete(int reservationId) {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean success = delete(reservationId, conn);
                if (success)
                    conn.commit();
                return success;
            } catch (SQLException e) {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean updateStatus(int reservationId, String newStatus) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        return update(sql, newStatus, reservationId) > 0;
    }

    public ReservationDisplayDTO findById(int id) {
        String sql = BASE_RESERVATION_SELECT + " WHERE r.reservation_id = ?";
        return querySingle(sql, this::mapToDisplayDTO, id);
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
        Boolean overlap = querySingle(sql, rs -> rs.getBoolean(1),
                reservationId, newCheckOut, newCheckIn, newCheckIn, newCheckOut, newCheckIn, newCheckOut);
        return overlap != null && overlap;
    }

    public List<ReservationDisplayDTO> findByGuestId(int guestId) {
        String sql = BASE_RESERVATION_SELECT + " WHERE r.guest_id = ? ORDER BY r.check_in DESC";
        return queryList(sql, this::mapToDisplayDTO, guestId);
    }

    public boolean updateDetails(int reservationId, String specialRequests, int adults, int children, Date newCheckIn,
            Date newCheckOut) {
        String findGuestSql = "SELECT guest_id FROM reservations WHERE reservation_id = ?";
        String updateGuestSql = "UPDATE guests SET adults = ?, children = ? WHERE guest_id = ?";
        String updateResSql = """
                    UPDATE reservations
                    SET special_requests = ?, check_in = ?, check_out = ?
                    WHERE reservation_id = ?
                """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                Integer guestId = querySingle(findGuestSql, rs -> rs.getInt(1), reservationId);
                if (guestId == null)
                    return false;

                update(updateGuestSql, conn, adults, children, guestId);
                int rows = update(updateResSql, conn, specialRequests, newCheckIn, newCheckOut, reservationId);

                conn.commit();
                return rows > 0;
            } catch (SQLException e) {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public List<ReservationDisplayDTO> findAllActive() {
        String sql = BASE_RESERVATION_SELECT
                + " WHERE r.status IN ('confirmed', 'checked_in', 'pending') ORDER BY r.check_in DESC";
        return queryList(sql, this::mapToDisplayDTO);
    }

    public List<ReservationDisplayDTO> findByStatus(String status) {
        String sql = BASE_RESERVATION_SELECT + " WHERE r.status = ? ORDER BY r.check_in DESC";
        return queryList(sql, this::mapToDisplayDTO, status);
    }

    public ReservationDisplayDTO findByReservationNumber(String reservationNumber) {
        if (reservationNumber == null || reservationNumber.trim().isEmpty())
            return null;
        String sql = BASE_RESERVATION_SELECT + " WHERE r.reservation_number = ?";
        return querySingle(sql, this::mapToDisplayDTO, reservationNumber.trim());
    }

    public List<ReservationDisplayDTO> findByGuestName(String guestName) {
        if (guestName == null || guestName.trim().isEmpty())
            return new ArrayList<>();
        String sql = BASE_RESERVATION_SELECT + " WHERE LOWER(g.name) LIKE ? ORDER BY r.check_in DESC";
        return queryList(sql, this::mapToDisplayDTO, "%" + guestName.trim().toLowerCase() + "%");
    }
}
