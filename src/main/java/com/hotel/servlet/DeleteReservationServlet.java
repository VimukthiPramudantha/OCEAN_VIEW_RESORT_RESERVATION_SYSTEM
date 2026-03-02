package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dao.GuestDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/delete-reservation")
public class DeleteReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            req.setAttribute("error", "Access Denied: Only administrators can purge records.");
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
            return;
        }

        List<ReservationDisplayDTO> reservations = reservationDAO.findAll();
        req.setAttribute("reservations", reservations);

        req.getRequestDispatcher("/delete-reservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = req.getParameter("action");

        if ("confirm_delete".equals(action)) {
            try {
                int reservationId = Integer.parseInt(req.getParameter("reservationId"));
                String typedGuestName = req.getParameter("confirmGuestName").trim();

                ReservationDisplayDTO res = reservationDAO.findById(reservationId);
                if (res == null) {
                    req.setAttribute("error", "Reservation not found.");
                    forwardToList(req, resp);
                    return;
                }

                String realGuestName = guestDAO.getGuestNameById(res.getGuestId());

                if (realGuestName == null || !realGuestName.trim().equalsIgnoreCase(typedGuestName)) {
                    req.setAttribute("error", "Guest name does not match. Deletion cancelled.");
                    forwardToList(req, resp);
                    return;
                }

                boolean deleted = reservationDAO.delete(reservationId);
                if (deleted) {
                    session.setAttribute("successMsg", "Reservation #" + reservationId + " deleted successfully.");
                } else {
                    req.setAttribute("error", "Failed to delete reservation.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid reservation ID.");
            }
        }

        forwardToList(req, resp);
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ReservationDisplayDTO> reservations = reservationDAO.findAll();
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("/delete-reservation.jsp").forward(req, resp);
    }
}