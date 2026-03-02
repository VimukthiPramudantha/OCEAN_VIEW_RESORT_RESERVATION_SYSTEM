package com.hotel.dao;

import com.hotel.config.DBUtil;
import com.hotel.dto.RoomAvailabilityDTO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class RoomDAO { // ← Removed incorrect generic <RoomAvailabilityDTO>

    /**
     * Counts total number of rooms in the system (all types, all statuses)
     */
    public int countTotalRooms() {
        String sql = "SELECT COUNT(*) FROM rooms";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting total rooms: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Counts currently booked rooms (status = 'booked')
     */
    public int countBookedRooms() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'booked'";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting booked rooms: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Returns availability status for each date in the range, grouped by date.
     */
    public Map<LocalDate, List<RoomAvailabilityDTO>> getAvailabilityByDateRange(LocalDate start, LocalDate end,
            String roomType) {
        Map<LocalDate, List<RoomAvailabilityDTO>> map = new TreeMap<>();

        LocalDate current = start;
        while (!current.isAfter(end)) {
            List<RoomAvailabilityDTO> daily = getDailyAvailability(current, roomType);
            map.put(current, daily);
            current = current.plusDays(1);
        }

        return map;
    }

    private List<RoomAvailabilityDTO> getDailyAvailability(LocalDate date, String roomType) {
        List<RoomAvailabilityDTO> list = new ArrayList<>();

        String sql = """
                    SELECT r.room_id, r.type,
                           CASE
                               WHEN res.reservation_id IS NULL THEN 'available'
                               ELSE res.status
                           END as status
                    FROM rooms r
                    LEFT JOIN reservations res
                      ON r.room_id = res.room_id
                      AND res.status NOT IN ('cancelled', 'checked_out', 'deleted')
                      AND ? BETWEEN res.check_in AND DATE_SUB(res.check_out, INTERVAL 1 DAY)
                    WHERE 1=1
                """;

        if (roomType != null && !roomType.isEmpty()) {
            sql += " AND r.type = ?";
        }

        sql += " ORDER BY r.room_id";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(date));
            if (roomType != null && !roomType.isEmpty()) {
                ps.setString(2, roomType);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomAvailabilityDTO dto = new RoomAvailabilityDTO();
                    dto.roomId = rs.getInt("room_id");
                    dto.roomType = rs.getString("type");
                    dto.status = rs.getString("status");
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            System.err.println("Daily availability lookup failed: " + e.getMessage());
        }

        return list;
    }

    public List<String> getAllRoomTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT type FROM rooms ORDER BY type";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        } catch (SQLException e) {
            System.err.println("Failed to fetch room types: " + e.getMessage());
        }
        return types;
    }

    /**
     * Finds the first available room ID for the given type and date range.
     * This is the correct method to use during actual booking.
     * Returns -1 if no room is available in the requested period.
     */
    public int findAvailableRoomId(String roomType, Date checkIn, Date checkOut) {
        String sql = """
                    SELECT r.room_id
                    FROM rooms r
                    LEFT JOIN reservations res
                      ON r.room_id = res.room_id
                      AND res.status NOT IN ('cancelled', 'checked_out')
                      AND (
                          (res.check_in <= ? AND res.check_out >= ?) OR
                          (res.check_in <= ? AND res.check_out >= ?) OR
                          (res.check_in >= ? AND res.check_out <= ?)
                      )
                    WHERE r.type = ?
                      AND r.status = 'available'
                      AND res.room_id IS NULL
                    LIMIT 1
                """;

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, checkOut);
            ps.setDate(2, checkIn);
            ps.setDate(3, checkOut);
            ps.setDate(4, checkIn);
            ps.setDate(5, checkIn);
            ps.setDate(6, checkOut);
            ps.setString(7, roomType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("room_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Date-range availability check failed: " + e.getMessage());
        }

        return -1; // No available room in the period
    }

    /**
     * Finds the first currently available room of the given type (ignores dates).
     * Use this only for non-booking flows (e.g. dashboard "available now" display).
     * Returns null if no room is currently available.
     *
     * WARNING: This method DOES NOT check future bookings → do NOT use it for
     * actual reservations!
     */
    public Integer findAvailableRoomId(String roomType) {
        String sql = """
                    SELECT room_id
                    FROM rooms
                    WHERE type = ?
                      AND status = 'available'
                    LIMIT 1
                """;

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("room_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Current availability check failed: " + e.getMessage());
        }

        return null; // No currently available room
    }

    /**
     * Marks room as available (used in cancel/delete)
     */
    public boolean markAsAvailable(int roomId, Connection conn) throws SQLException {
        String sql = "UPDATE rooms SET status = 'available' WHERE room_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Marks the room as booked using provided connection (for transaction)
     * Returns true if updated successfully
     */
    public boolean markAsBooked(int roomId, Connection conn) throws SQLException {
        String sql = """
                    UPDATE rooms
                    SET status = 'booked'
                    WHERE room_id = ? AND status = 'available'
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            int rows = ps.executeUpdate();
            return rows > 0; // true only if it was available and updated
        }
    }

    /**
     * Returns the standard rate per night for the given room type.
     * Returns 0.0 on failure (consider throwing exception in production).
     */
    public double getRateForType(String roomType) {
        String sql = "SELECT rate_per_night FROM rooms WHERE type = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("rate_per_night");
                }
            }
        } catch (SQLException e) {
            System.err.println("Rate lookup failed for type " + roomType + ": " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * Adds a new room to the system with a manual Room ID.
     */
    public boolean addRoom(int roomId, String type, double rate) throws SQLException {
        String sql = "INSERT INTO rooms (room_id, room_number, type, rate_per_night, status) VALUES (?, ?, ?, ?, 'available')";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setString(2, String.valueOf(roomId)); // Use roomId as room_number
            ps.setString(3, type);
            ps.setDouble(4, rate);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Updates the status of a specific room.
     */
    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating room status: " + e.getMessage());
        }
        return false;
    }

    /**
     * Retrieves all rooms in the system.
     */
    public List<RoomAvailabilityDTO> getAllRooms() {
        List<RoomAvailabilityDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_id";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomAvailabilityDTO dto = new RoomAvailabilityDTO();
                dto.roomId = rs.getInt("room_id");
                dto.roomType = rs.getString("type");
                dto.status = rs.getString("status");
                list.add(dto);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all rooms: " + e.getMessage());
        }
        return list;
    }
}