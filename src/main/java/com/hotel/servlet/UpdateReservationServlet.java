package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dto.ReservationDisplayDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/update-reservation")
public class UpdateReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = ReservationDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                ReservationDisplayDTO res = reservationDAO.findById(id);
                if (res != null) {
                    req.setAttribute("reservation", res);
                    req.getRequestDispatcher("/update-reservation.jsp").forward(req, resp);
                    return;
                } else {
                    req.setAttribute("error", "Reservation #" + id + " not found.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid reservation ID.");
            }
        }

        List<ReservationDisplayDTO> reservations = reservationDAO.findActiveForUpdate();
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("/update-reservation-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String idStr = req.getParameter("reservationId");
        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("error", "Reservation ID is missing.");
            forwardToList(req, resp);
            return;
        }

        try {
            int reservationId = Integer.parseInt(idStr.trim());

            String specialRequests = req.getParameter("specialRequests");
            String adultsStr = req.getParameter("adults");
            String childrenStr = req.getParameter("children");
            String checkInStr = req.getParameter("checkIn");
            String checkOutStr = req.getParameter("checkOut");

            if (checkInStr == null || checkOutStr == null || adultsStr == null) {
                req.setAttribute("error", "Check-in, check-out, and adults are required.");
                forwardToList(req, resp);
                return;
            }

            Date newCheckIn = Date.valueOf(checkInStr);
            Date newCheckOut = Date.valueOf(checkOutStr);

            if (newCheckOut.before(newCheckIn) || newCheckOut.equals(newCheckIn)) {
                req.setAttribute("error", "Check-out must be after check-in date.");
                forwardToList(req, resp);
                return;
            }

            boolean hasConflict = reservationDAO.hasOverlapExcludingSelf(reservationId, newCheckIn, newCheckOut);
            if (hasConflict) {
                req.setAttribute("error", "Selected dates overlap with another active booking.");
                forwardToList(req, resp);
                return;
            }

            int adults = safeParseInt(adultsStr, 1);
            int children = safeParseInt(childrenStr, 0);

            boolean success = reservationDAO.updateDetails(
                    reservationId, specialRequests, adults, children, newCheckIn, newCheckOut);

            if (success) {
                session.setAttribute("successMsg", "Reservation #" + reservationId + " updated successfully.");
                resp.sendRedirect("view-reservations");
            } else {
                req.setAttribute("error", "Failed to update reservation (no changes made or database error).");
                req.setAttribute("reservation", res);
                req.getRequestDispatcher("/update-reservation.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid number format in form fields.");
            forwardToEdit(req, resp, idStr);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Invalid date format.");
            forwardToEdit(req, resp, idStr);
        } catch (Exception e) {
            req.setAttribute("error", "Unexpected error: " + e.getMessage());
            forwardToEdit(req, resp, idStr);
        }
    }

    private void forwardToEdit(HttpServletRequest req, HttpServletResponse resp, String idStr)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(idStr.trim());
            ReservationDisplayDTO res = reservationDAO.findById(id);
            req.setAttribute("reservation", res);
        } catch (Exception ignored) {
        }
        req.getRequestDispatcher("/update-reservation.jsp").forward(req, resp);
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ReservationDisplayDTO> reservations = reservationDAO.findActiveForUpdate();
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("/update-reservation-list.jsp").forward(req, resp);
    }

    private int safeParseInt(String s, int defaultValue) {
        if (s == null || s.trim().isEmpty())
            return defaultValue;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}