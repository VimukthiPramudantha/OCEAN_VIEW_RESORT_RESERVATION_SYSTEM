package com.hotel.dao;

import com.hotel.model.Checkout;
import java.sql.Connection;
import java.sql.SQLException;

public class CheckoutDAO extends BaseDAO {

    public boolean save(Checkout checkout, Connection conn) throws SQLException {
        String sql = """
                    INSERT INTO checkouts (
                        reservation_id, service_charge, tax,
                        additional_charges, total_amount
                    ) VALUES (?, ?, ?, ?, ?)
                """;

        return update(sql, conn,
                checkout.getReservationId(),
                checkout.getServiceCharge() != null ? checkout.getServiceCharge() : 0.0,
                checkout.getTax() != null ? checkout.getTax() : 0.0,
                checkout.getAdditionalCharges() != null ? checkout.getAdditionalCharges() : 0.0,
                checkout.getTotalAmount()) > 0;
    }
}
