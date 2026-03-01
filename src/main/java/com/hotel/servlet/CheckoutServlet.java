package com.hotel.servlet;

import com.hotel.config.DBUtil;
import com.hotel.dao.ReservationDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        // Optional: pre-fill reservation number from query param
        String resNum = req.getParameter("resNumber");
        if (resNum != null && !resNum.trim().isEmpty()) {
            ReservationDisplayDTO res = reservationDAO.findByReservationNumber(resNum.trim());
            if (res != null) {
                prepareCheckoutData(req, res);
                req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
                return;
            } else {
                req.setAttribute("error", "Reservation not found.");
            }
        }

        req.getRequestDispatcher("/checkout-search.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String action = req.getParameter("action");
        String resIdStr = req.getParameter("reservationId");

        if (resIdStr == null || resIdStr.trim().isEmpty()) {
            req.setAttribute("error", "Reservation ID is required.");
            req.getRequestDispatcher("/checkout-search.jsp").forward(req, resp);
            return;
        }

        try {
            int reservationId = Integer.parseInt(resIdStr.trim());

            if ("confirm_checkout".equals(action)) {
                performCheckout(reservationId, req, resp, session);
            } else {
                // Show checkout confirmation page
                ReservationDisplayDTO res = reservationDAO.findById(reservationId);
                if (res == null) {
                    req.setAttribute("error", "Reservation not found.");
                    req.getRequestDispatcher("/checkout-search.jsp").forward(req, resp);
                    return;
                }
                prepareCheckoutData(req, res);
                req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid reservation ID.");
            req.getRequestDispatcher("/checkout-search.jsp").forward(req, resp);
        }
    }

    private void performCheckout(int reservationId, HttpServletRequest req, HttpServletResponse resp,
            HttpSession session)
            throws ServletException, IOException {

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Get reservation details
            ReservationDisplayDTO res = reservationDAO.findById(reservationId);
            if (res == null) {
                throw new SQLException("Reservation not found");
            }

            if (!"checked_in".equals(res.getStatus()) && !"confirmed".equals(res.getStatus())) {
                throw new SQLException("Only checked-in or confirmed reservations can be checked out.");
            }

            // 2. Update status to checked_out
            if (!reservationDAO.updateStatus(reservationId, "checked_out", conn)) {
                throw new SQLException("Failed to update status to checked_out");
            }

            // 3. Free the room
            Integer roomId = reservationDAO.getRoomIdByReservationId(reservationId, conn);
            if (roomId != null) {
                if (!roomDAO.markAsAvailable(roomId, conn)) {
                    throw new SQLException("Failed to free room");
                }
            }

            conn.commit();

            // Calculate final bill for display
            long nights = ChronoUnit.DAYS.between(res.getCheckIn().toLocalDate(), res.getCheckOut().toLocalDate());
            double total = nights * res.getRatePerNight();

            session.setAttribute("successMsg", "Guest checked out successfully. Room is now available.");
            req.setAttribute("reservation", res);
            req.setAttribute("nights", nights);
            req.setAttribute("totalBill", total);

            req.getRequestDispatcher("/checkout-success.jsp").forward(req, resp);

        } catch (SQLException e) {
            rollbackQuietly(conn);
            req.setAttribute("error", "Checkout failed: " + e.getMessage());
            req.getRequestDispatcher("/checkout-search.jsp").forward(req, resp);
        } finally {
            resetAutoCommitAndClose(conn);
        }
    }

    private void prepareCheckoutData(HttpServletRequest req, ReservationDisplayDTO res) {
        long nights = ChronoUnit.DAYS.between(res.getCheckIn().toLocalDate(), res.getCheckOut().toLocalDate());
        double total = nights * res.getRatePerNight();

        req.setAttribute("reservation", res);
        req.setAttribute("nights", nights);
        req.setAttribute("totalBill", total);
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ignored) {
            }
        }
    }

    private void resetAutoCommitAndClose(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException ignored) {
            }
        }
    }
}