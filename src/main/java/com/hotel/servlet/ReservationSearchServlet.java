package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dto.ReservationDisplayDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/reservation-search")
public class ReservationSearchServlet extends SecureServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String statusFilter = trimOrNull(req.getParameter("status"));
        String guestName = trimOrNull(req.getParameter("guestName"));

        List<ReservationDisplayDTO> reservations;

        if (!isBlank(statusFilter)) {
            reservations = reservationDAO.findByStatus(statusFilter);
        } else if (!isBlank(guestName)) {
            reservations = reservationDAO.findByGuestName(guestName);
        } else {
            reservations = reservationDAO.findAllActive();
        }

        req.setAttribute("reservations", reservations);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("guestName", guestName);

        forward(req, resp, "/reservation-search.jsp");
    }
}