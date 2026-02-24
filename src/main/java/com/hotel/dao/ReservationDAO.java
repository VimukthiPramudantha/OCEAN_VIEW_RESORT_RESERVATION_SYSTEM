package com.hotel.dao;

import com.hotel.model.Reservation;

import java.math.BigDecimal;

public class ReservationDAO {
    public int countTodayCheckins() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_in = CURDATE() AND status = 'confirmed'";
        // implement as above
        int count = 0;
        return count;
    }

    public int countTodayCheckouts() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_out = CURDATE() AND status = 'checked_in'";
        // implement
        int count = 0;
        return count;
    }

    public BigDecimal sumTodayRevenue() {
        String sql = "SELECT SUM(total_amount) FROM reservations WHERE check_out = CURDATE() AND status = 'checked_out'";
        // implement with rs.getBigDecimal

        BigDecimal sum = null;
        return sum;
    }

    public void save(Reservation res) {
    }
}