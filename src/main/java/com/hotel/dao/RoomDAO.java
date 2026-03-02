package com.hotel.dao;

import com.hotel.config.DBUtil;

import java.sql.*;
import java.util.ArrayList;

public class RoomDAO {

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

    public <Room> List<Room> findAllRooms() {
        List<Room> list = new List<Room>();
        String sql = "SELECT * FROM rooms ORDER BY type, room_number";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = new Room();
                r.setId(rs.getInt("room_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setType(rs.getString("type"));
                r.setStatus(rs.getString("status"));
                r.setRatePerNight(rs.getDouble("rate_per_night"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.err.println("Failed to fetch all rooms: " + e.getMessage());
        }
        return list;
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
}