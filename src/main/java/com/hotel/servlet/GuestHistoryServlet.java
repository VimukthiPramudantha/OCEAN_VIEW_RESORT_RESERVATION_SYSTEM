package com.hotel.servlet;

import com.hotel.dao.GuestDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.Guest;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/reservation-history")
public class GuestHistoryServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            req.setAttribute("error", "Access Denied: Only administrators can view guest history.");
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
            return;
        }

        String guestIdStr = req.getParameter("guestId");

        // If guestId is provided → show detailed history for that guest
        if (guestIdStr != null && !guestIdStr.trim().isEmpty()) {
            try {
                int guestId = Integer.parseInt(guestIdStr.trim());
                Guest guest = guestDAO.findById(guestId); // you need this method (see below)

                if (guest == null) {
                    req.setAttribute("error", "Guest not found.");
                    showGuestList(req, resp);
                    return;
                }

                // Load reservations and split into categories (case-insensitive)
                List<ReservationDisplayDTO> allHistory = reservationDAO.findByGuestId(guestId);

                List<ReservationDisplayDTO> current = allHistory.stream()
                        .filter(r -> "confirmed".equalsIgnoreCase(r.getStatus()) ||
                                "checked_in".equalsIgnoreCase(r.getStatus()) ||
                                "pending".equalsIgnoreCase(r.getStatus()))
                        .toList();

                List<ReservationDisplayDTO> previous = allHistory.stream()
                        .filter(r -> "checked_out".equalsIgnoreCase(r.getStatus()))
                        .toList();

                List<ReservationDisplayDTO> cancelled = allHistory.stream()
                        .filter(r -> "cancelled".equalsIgnoreCase(r.getStatus()))
                        .toList();

                req.setAttribute("guest", guest);
                req.setAttribute("currentReservations", current);
                req.setAttribute("previousReservations", previous);
                req.setAttribute("cancelledReservations", cancelled);

                req.getRequestDispatcher("/guest-history.jsp").forward(req, resp);
                return;

            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid guest ID.");
            }
        }

        // Default: show list of all guests
        showGuestList(req, resp);
    }

    private void showGuestList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Guest> guests = guestDAO.findAll();
        req.setAttribute("guests", guests);
        req.getRequestDispatcher("/guest-history.jsp").forward(req, resp);
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

        String searchTerm = req.getParameter("searchTerm");
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            req.setAttribute("error", "Please enter search term.");
            showGuestList(req, resp);
            return;
        }

        List<Guest> guests = guestDAO.searchGuests(searchTerm.trim());

        if (guests.isEmpty()) {
            req.setAttribute("error", "No guests found matching your search.");
        }

        req.setAttribute("guests", guests);
        req.setAttribute("searchTerm", searchTerm.trim());

        req.getRequestDispatcher("/guest-history.jsp").forward(req, resp);
    }
}