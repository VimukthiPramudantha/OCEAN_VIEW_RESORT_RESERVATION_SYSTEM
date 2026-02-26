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

                // 1. Log cancellation FIRST (reservation still exists)
                logCancellation(conn, reservationId, reason, cancelledBy);

                // 2. Delete reservation (log row auto-deletes via CASCADE)
                if (!reservationDAO.delete(reservationId, conn)) {
                    throw new SQLException("Failed to delete reservation");
                }

                // 3. Free room (using previously fetched roomId or re-query if needed)
                Integer roomId = reservationDAO.getRoomIdByReservationId(reservationId, conn);
                if (roomId != null) {
                    if (!roomDAO.markAsAvailable(roomId, conn)) {
                        throw new SQLException("Failed to free room");
                    }
                }

                conn.commit();

                session.setAttribute("successMsg", "Reservation #" + reservationId + " cancelled and room freed.");
                resp.sendRedirect("view-reservations");

            } catch (SQLException e) {
                rollbackQuietly(conn);
                req.setAttribute("error", "Failed to cancel: " + e.getMessage());
                forwardToList(req, resp);
            } finally {
                resetAutoCommitAndClose(conn);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid reservation ID.");
            forwardToList(req, resp);
        }
    }

    // logCancellation remains the same (fetches guest_id if needed)
    private void logCancellation(Connection conn, int reservationId, String reason, String cancelledBy) throws SQLException {
        Integer guestId = null;
        try (PreparedStatement ps = conn.prepareStatement("SELECT guest_id FROM reservations WHERE reservation_id = ?")) {
            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) guestId = rs.getInt("guest_id");
            }
        }

        if (guestId == null) {
            System.err.println("Warning: Skipping log - no guest_id for res " + reservationId);
            return;
        }

        String sql = """
            INSERT INTO cancellation_log 
            (reservation_id, guest_id, cancelled_by, cancel_reason)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, guestId);
            ps.setString(3, cancelledBy);
            ps.setString(4, reason);
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