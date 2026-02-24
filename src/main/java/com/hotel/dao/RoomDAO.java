package com.hotel.dao;

import com.hotel.config.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class RoomDAO {

public int countTotalRooms() {
    String sql = "SELECT COUNT(*) FROM rooms";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(String.valueOf(sql));
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        // log
    }
    return 0;
}

    public int countBookedRooms() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'booked'";
        int count = 0;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

}