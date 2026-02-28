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

        // Show all guests by default
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

        String searchTerm = req.getParameter("searchTerm");
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            req.setAttribute("error", "Please enter NIC, Passport, Name or Contact.");
            forwardToList(req, resp);
            return;
        }

        searchTerm = searchTerm.trim();

        // Search guests
        List<Guest> guests = guestDAO.searchGuests(searchTerm);

        if (guests.isEmpty()) {
            req.setAttribute("error", "No guest found matching your search.");
            forwardToList(req, resp);
            return;
        }

        if (guests.size() == 1) {
            // If exactly one result, show details directly
            showGuestDetails(req, resp, guests.get(0));
        } else {
            // Multiple results → show list
            req.setAttribute("guests", guests);
            req.setAttribute("searchTerm", searchTerm);
            forwardToList(req, resp);
        }
    }

    private void showGuestDetails(HttpServletRequest req, HttpServletResponse resp, Guest guest) throws ServletException, IOException {
        List<ReservationDisplayDTO> allHistory = reservationDAO.findByGuestId(guest.getId());

        // Split into categories
        List<ReservationDisplayDTO> current = allHistory.stream()
                .filter(r -> "confirmed".equals(r.getStatus()) || "checked_in".equals(r.getStatus()) || "pending".equals(r.getStatus()))
                .toList();

        List<ReservationDisplayDTO> previous = allHistory.stream()
                .filter(r -> "checked_out".equals(r.getStatus()))
                .toList();

        List<ReservationDisplayDTO> cancelled = allHistory.stream()
                .filter(r -> "cancelled".equals(r.getStatus()))
                .toList();

        req.setAttribute("guest", guest);
        req.setAttribute("currentReservations", current);
        req.setAttribute("previousReservations", previous);
        req.setAttribute("cancelledReservations", cancelled);

        req.getRequestDispatcher("/guest-history.jsp").forward(req, resp);
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/guest-history.jsp").forward(req, resp);
    }
}