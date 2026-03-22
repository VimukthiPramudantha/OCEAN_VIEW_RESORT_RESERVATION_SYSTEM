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
import java.util.List;

@WebServlet("/reservation-search")
public class ReservationSearchServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = ReservationDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String statusFilter = req.getParameter("status");
        String guestName = req.getParameter("guestName");

        List<ReservationDisplayDTO> reservations;

        if (statusFilter != null && !statusFilter.isEmpty()) {
            reservations = reservationDAO.findByStatus(statusFilter);
        } else if (guestName != null && !guestName.trim().isEmpty()) {
            reservations = reservationDAO.findByGuestName(guestName.trim());
        } else {
            reservations = reservationDAO.findAllActive();
        }

        req.setAttribute("reservations", reservations);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("guestName", guestName);

        req.getRequestDispatcher("/reservation-search.jsp").forward(req, resp);
    }
}