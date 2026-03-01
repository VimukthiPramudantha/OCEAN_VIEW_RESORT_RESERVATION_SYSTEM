package com.hotel.dao;

import java.sql.*;

public class RoomDAO extends BaseDAO {

    /**
     * Counts total number of rooms in the system (all types, all statuses)
     */
    public int countTotalRooms() {
        String sql = "SELECT COUNT(*) FROM rooms";
        Integer count = querySingle(sql, rs -> rs.getInt(1));
        return count != null ? count : 0;
    }

    /**
     * Counts currently booked rooms (status = 'booked')
     */
    public int countBookedRooms() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'booked'";
        Integer count = querySingle(sql, rs -> rs.getInt(1));
        return count != null ? count : 0;
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

        Integer id = querySingle(sql, rs -> rs.getInt("room_id"),
                checkOut, checkIn, checkOut, checkIn, checkIn, checkOut, roomType);
        return id != null ? id : -1;
    }

    /**
     * Finds the first currently available room of the given type (ignores dates).
     */
    public Integer findAvailableRoomId(String roomType) {
        String sql = """
                    SELECT room_id
                    FROM rooms
                    WHERE type = ?
                      AND status = 'available'
                    LIMIT 1
                """;
        return querySingle(sql, rs -> rs.getInt("room_id"), roomType);
    }

    /**
     * Marks room as available (used in cancel/delete)
     */
    public boolean markAsAvailable(int roomId, Connection conn) throws SQLException {
        String sql = "UPDATE rooms SET status = 'available' WHERE room_id = ?";
        return update(sql, conn, roomId) > 0;
    }

    /**
     * Marks the room as booked using provided connection (for transaction)
     */
    public boolean markAsBooked(int roomId, Connection conn) throws SQLException {
        String sql = """
                    UPDATE rooms
                    SET status = 'booked'
                    WHERE room_id = ? AND status = 'available'
                """;
        return update(sql, conn, roomId) > 0;
    }

    /**
     * Returns the standard rate per night for the given room type.
     */
    public double getRateForType(String roomType) {
        String sql = "SELECT rate_per_night FROM rooms WHERE type = ? LIMIT 1";
        Double rate = querySingle(sql, rs -> rs.getDouble("rate_per_night"), roomType);
        return rate != null ? rate : 0.0;
    }
}
