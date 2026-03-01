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
public class CancelReservationServlet extends SecureServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ReservationDisplayDTO> reservations = reservationDAO.findActiveForCancellation();
        req.setAttribute("reservations", reservations);
        forward(req, resp, "/cancel-reservation.jsp");
    }

    @Override
    protected void doSecurePost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getAuthenticatedUser(req);
        String cancelledBy = user.getUsername();

        String resIdStr = req.getParameter("reservationId");
        String reason = trimOrNull(req.getParameter("cancelReason"));

        if (isBlank(resIdStr) || isBlank(reason)) {
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

                // Fetch IDs for logging
                Integer guestId = null;
                Integer roomId = null;

                try (PreparedStatement psInfo = conn.prepareStatement(
                        "SELECT guest_id, room_id FROM reservations WHERE reservation_id = ?")) {
                    psInfo.setInt(1, reservationId);
                    try (ResultSet rs = psInfo.executeQuery()) {
                        if (rs.next()) {
                            guestId = rs.getInt("guest_id");
                            roomId = rs.getInt("room_id");
                        } else {
                            throw new SQLException("Reservation not found");
                        }
                    }
                }

                // 1. Update status to cancelled
                if (!reservationDAO.updateStatus(reservationId, "cancelled", conn)) {
                    throw new SQLException("Failed to cancel reservation");
                }

                // 2. Free the room
                if (roomId != null) {
                    if (!roomDAO.markAsAvailable(roomId, conn)) {
                        throw new SQLException("Failed to free room");
                    }
                }

                // 3. Log cancellation
                if (guestId != null && roomId != null) {
                    logCancellation(conn, reservationId, guestId, roomId, reason, cancelledBy);
                }

                conn.commit();

                req.getSession().setAttribute("successMsg",
                        "Reservation #" + reservationId + " cancelled successfully. Room is now available.");
                redirect(resp, "cancel-reservation");

            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ignored) {
                    }
                }
                req.setAttribute("error", "Failed to cancel: " + e.getMessage());
                forwardToList(req, resp);
            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException ignored) {
                    }
                }
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid reservation ID.");
            forwardToList(req, resp);
        }
    }

    /**
     * Log cancellation with all relevant fields
     */
    private void logCancellation(Connection conn, int reservationId, int guestId, int roomId, String reason,
            String cancelledBy) throws SQLException {
        String sql = """
                    INSERT INTO cancellation_log
                    (reservation_id, guest_id, room_id, cancelled_by, cancel_reason)
                    VALUES (?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, guestId);
            ps.setInt(3, roomId);
            ps.setString(4, cancelledBy);
            ps.setString(5, reason);
            ps.executeUpdate();
        }
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ReservationDisplayDTO> reservations = reservationDAO.findActiveForCancellation();
        req.setAttribute("reservations", reservations);
        forward(req, resp, "/cancel-reservation.jsp");
    }
}
