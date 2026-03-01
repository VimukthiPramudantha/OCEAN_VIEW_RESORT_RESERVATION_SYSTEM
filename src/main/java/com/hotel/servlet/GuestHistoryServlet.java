package com.hotel.servlet;

import com.hotel.dao.GuestDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.Guest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/reservation-history")
public class GuestHistoryServlet extends SecureServlet {

    private final GuestDAO guestDAO = new GuestDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String guestIdStr = req.getParameter("guestId");

        // If guestId is provided → show detailed history for that guest
        if (!isBlank(guestIdStr)) {
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

                forward(req, resp, "/guest-history.jsp");
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
        forward(req, resp, "/guest-history.jsp");
    }

    @Override
    protected void doSecurePost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String searchTerm = req.getParameter("searchTerm");
        if (isBlank(searchTerm)) {
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

        forward(req, resp, "/guest-history.jsp");
    }
}
