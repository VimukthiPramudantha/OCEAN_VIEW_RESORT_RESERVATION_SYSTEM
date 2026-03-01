package com.hotel.dao;

import com.hotel.model.Checkout;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class CheckoutDAO {

    public boolean save(Checkout checkout, Connection conn) throws SQLException {
        String sql = """
                    INSERT INTO checkouts (
                        reservation_id, service_charge, tax,
                        additional_charges, total_amount
                    ) VALUES (?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, checkout.getReservationId());
            ps.setDouble(2, checkout.getServiceCharge() != null ? checkout.getServiceCharge() : 0.0);
            ps.setDouble(3, checkout.getTax() != null ? checkout.getTax() : 0.0);
            ps.setDouble(4, checkout.getAdditionalCharges() != null ? checkout.getAdditionalCharges() : 0.0);
            ps.setDouble(5, checkout.getTotalAmount());

            return ps.executeUpdate() > 0;
        }
    }
}
