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
public class CheckoutServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = ReservationDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String resNumber = req.getParameter("resNumber");
        if (resNumber == null || resNumber.trim().isEmpty()) {
            resp.sendRedirect("reservation-search");
            return;
        }

        ReservationDisplayDTO reservation = reservationDAO.findByReservationNumber(resNumber);
        if (reservation == null) {
            req.setAttribute("error", "Reservation not found.");
            req.getRequestDispatcher("/reservation-search.jsp").forward(req, resp);
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

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String reservationIdStr = req.getParameter("reservationId");
        if (reservationIdStr == null || reservationIdStr.isEmpty()) {
            resp.sendRedirect("reservation-search");
            return;
        }

        int reservationId = Integer.parseInt(reservationIdStr);
        ReservationDisplayDTO reservation = reservationDAO.findById(reservationId);

        if (reservation == null) {
            resp.sendRedirect("reservation-search");
            return;
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Update reservation status to 'checked_out'
            String updateStatusSql = "UPDATE reservations SET status = 'checked_out' WHERE reservation_id = ?";

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

            // 1. Update reservation status to 'checked_out'
            try (PreparedStatement psStatus = conn.prepareStatement(updateStatusSql)) {
                psStatus.setInt(1, reservationId);
                psStatus.executeUpdate();
            } catch (SQLException e) {
                throw new SQLException("Error updating reservation status: " + e.getMessage());
            }

            // 2. Save detailed checkout record
            try {
                com.hotel.model.Checkout checkoutRecord = new com.hotel.model.Checkout();
                checkoutRecord.setReservationId(reservationId);
                checkoutRecord.setServiceCharge(serviceCharge);
                checkoutRecord.setTax(tax);
                checkoutRecord.setAdditionalCharges(additionalCharges);
                checkoutRecord.setTotalAmount(totalAmount);
                new com.hotel.dao.CheckoutDAO().save(checkoutRecord, conn);
            } catch (SQLException e) {
                throw new SQLException("Error saving checkout record: " + e.getMessage());
            }

            // 3. Set the room to 'cleaning' status
            String updateRoomSql = "UPDATE rooms SET status = 'cleaning' WHERE room_id = ?";
            try (PreparedStatement psRoom = conn.prepareStatement(updateRoomSql)) {
                psRoom.setInt(1, reservation.getRoomId());
                psRoom.executeUpdate();
            } catch (SQLException e) {
                throw new SQLException("Error updating room status: " + e.getMessage());
            }

            conn.commit();

            // Set attributes for success page
            req.setAttribute("reservation", reservation);
            req.setAttribute("nights", nights);
            req.setAttribute("totalBill", totalAmount); // Use the final total amount
            req.setAttribute("serviceCharge", serviceCharge);
            req.setAttribute("tax", tax);
            req.setAttribute("additionalCharges", additionalCharges);

            req.getRequestDispatcher("/checkout-success.jsp").forward(req, resp);

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            req.setAttribute("error", "Checkout failed: " + e.getMessage());
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
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
