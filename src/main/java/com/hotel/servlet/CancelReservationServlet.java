package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.User;
import com.hotel.config.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        List<ReservationDisplayDTO> reservations = reservationDAO.findAll();
        req.setAttribute("reservations", reservations);

        req.getRequestDispatcher("/cancel-reservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String cancelledBy = user.getUsername();

        String resIdStr = req.getParameter("reservationId");
        String reason = req.getParameter("cancelReason");

        if (resIdStr == null || reason == null || reason.trim().isEmpty()) {
            req.setAttribute("error", "Reservation ID and cancellation reason are required.");
            forwardToList(req, resp);
            return;
        }

        try {
            int reservationId = Integer.parseInt(resIdStr);

            Connection conn = null;
            try {
                conn = DBUtil.getConnection();
                conn.setAutoCommit(false);

                // Step 1: Get reservation details BEFORE any change
                ReservationDisplayDTO res = reservationDAO.findById(reservationId);
                if (res == null) {
                    throw new SQLException("Reservation not found");
                }

                if ("cancelled".equals(res.getStatus()) || "checked_out".equals(res.getStatus())) {
                    throw new SQLException("Reservation is already cancelled or checked out");
                }

                // Step 2: Delete the reservation
                if (!reservationDAO.delete(reservationId, conn)) {
                    throw new SQLException("Failed to delete reservation");
                }

                // Step 3: Log cancellation with full details
                logCancellation(conn, reservationId, res.getGuestId(), res.getRoomId(), reason, cancelledBy, res.getRatePerNight());

                conn.commit();

                session.setAttribute("successMsg", "Reservation #" + reservationId + " cancelled and room freed.");
                resp.sendRedirect("view-reservations");

            } catch (SQLException e) {
                rollbackQuietly(conn);
                req.setAttribute("error", "Failed to cancel reservation: " + e.getMessage());
                forwardToList(req, resp);
            } finally {
                resetAutoCommitAndClose(conn);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid reservation ID.");
            forwardToList(req, resp);
        }
    }

    private void logCancellation(Connection conn, int resId, int guestId, int roomId, String reason, String cancelledBy, double totalAmount) throws SQLException {
        String sql = """
            INSERT INTO cancellation_log 
            (reservation_id, guest_id, room_id, cancelled_by, cancel_reason, total_amount)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, resId);
            ps.setInt(2, guestId);
            ps.setInt(3, roomId);
            ps.setString(4, cancelledBy);
            ps.setString(5, reason);
            ps.setDouble(6, totalAmount);
            ps.executeUpdate();
        }
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ReservationDisplayDTO> reservations = reservationDAO.findAll();
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("/cancel-reservation.jsp").forward(req, resp);
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
    }

    private void resetAutoCommitAndClose(Connection conn) {
        if (conn != null) {
            try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }
}