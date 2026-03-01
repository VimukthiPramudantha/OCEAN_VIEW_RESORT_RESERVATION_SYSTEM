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

    private final ReservationDAO reservationDAO = new ReservationDAO();

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

            // Re-calculate for display on success page
            long nights = ChronoUnit.DAYS.between(reservation.getCheckIn().toLocalDate(),
                    reservation.getCheckOut().toLocalDate());
            if (nights <= 0)
                nights = 1;
            double totalBill = nights * reservation.getRatePerNight();

            try (PreparedStatement psStatus = conn.prepareStatement(updateStatusSql)) {
                psStatus.setInt(1, reservationId);
                psStatus.executeUpdate();
            }

            // 2. Free the room
            String updateRoomSql = "UPDATE rooms SET status = 'available' WHERE room_id = ?";
            try (PreparedStatement psRoom = conn.prepareStatement(updateRoomSql)) {
                psRoom.setInt(1, reservation.getRoomId());
                psRoom.executeUpdate();
            }

            conn.commit();

            // Set attributes for success page
            req.setAttribute("reservation", reservation);
            req.setAttribute("nights", nights);
            req.setAttribute("totalBill", totalBill);

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
