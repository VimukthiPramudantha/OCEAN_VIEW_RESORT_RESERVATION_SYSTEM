package com.hotel.servlet;

import com.hotel.config.DBUtil;
import com.hotel.dao.ReservationDAO;
import com.hotel.dto.ReservationDisplayDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;

@WebServlet("/checkout")
public class CheckoutServlet extends SecureServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String resNumber = req.getParameter("resNumber");
        if (isBlank(resNumber)) {
            redirect(resp, "reservation-search");
            return;
        }

        ReservationDisplayDTO reservation = reservationDAO.findByReservationNumber(resNumber);
        if (reservation == null) {
            handleError(req, resp, "Reservation not found.", "/reservation-search.jsp");
            return;
        }

        // Calculate nights and total bill
        long nights = ChronoUnit.DAYS.between(reservation.getCheckIn().toLocalDate(),
                reservation.getCheckOut().toLocalDate());
        if (nights <= 0)
            nights = 1; // Minimum 1 night charge

        double totalBill = nights * reservation.getRatePerNight();

        req.setAttribute("reservation", reservation);
        req.setAttribute("nights", nights);
        req.setAttribute("totalBill", totalBill);

        forward(req, resp, "/checkout.jsp");
    }

    @Override
    protected void doSecurePost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String reservationIdStr = req.getParameter("reservationId");
        if (isBlank(reservationIdStr)) {
            redirect(resp, "reservation-search");
            return;
        }

        int reservationId = Integer.parseInt(reservationIdStr);
        ReservationDisplayDTO reservation = reservationDAO.findById(reservationId);

        if (reservation == null) {
            redirect(resp, "reservation-search");
            return;
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Capture billing adjustments
            double serviceCharge = req.getParameter("serviceCharge") != null
                    ? Double.parseDouble(req.getParameter("serviceCharge"))
                    : 0.0;
            double tax = req.getParameter("tax") != null ? Double.parseDouble(req.getParameter("tax")) : 0.0;
            double additionalCharges = req.getParameter("additionalCharges") != null
                    ? Double.parseDouble(req.getParameter("additionalCharges"))
                    : 0.0;
            double totalAmount = req.getParameter("totalAmount") != null
                    ? Double.parseDouble(req.getParameter("totalAmount"))
                    : 0.0;

            // Re-calculate nights for display
            long nights = ChronoUnit.DAYS.between(reservation.getCheckIn().toLocalDate(),
                    reservation.getCheckOut().toLocalDate());
            if (nights <= 0)
                nights = 1;

            // 1. Update reservation status
            if (!reservationDAO.updateStatus(reservationId, "checked_out", conn)) {
                throw new SQLException("Failed to update reservation status");
            }

            // 2. Save detailed checkout record
            com.hotel.model.Checkout checkoutRecord = new com.hotel.model.Checkout();
            checkoutRecord.setReservationId(reservationId);
            checkoutRecord.setServiceCharge(serviceCharge);
            checkoutRecord.setTax(tax);
            checkoutRecord.setAdditionalCharges(additionalCharges);
            checkoutRecord.setTotalAmount(totalAmount);

            new com.hotel.dao.CheckoutDAO().save(checkoutRecord, conn);

            // 3. Free the room
            com.hotel.dao.RoomDAO roomDAO = new com.hotel.dao.RoomDAO();
            if (!roomDAO.markAsAvailable(reservation.getRoomId(), conn)) {
                throw new SQLException("Failed to mark room as available");
            }

            conn.commit();

            // Set attributes for success page
            req.setAttribute("reservation", reservation);
            req.setAttribute("nights", nights);
            req.setAttribute("totalBill", totalAmount); // Use the final total amount
            req.setAttribute("serviceCharge", serviceCharge);
            req.setAttribute("tax", tax);
            req.setAttribute("additionalCharges", additionalCharges);

            forward(req, resp, "/checkout-success.jsp");

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            handleError(req, resp, "Checkout failed: " + e.getMessage(), "/checkout.jsp");
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
