package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/view-reservations")
public class ViewReservationsServlet extends SecureServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Optional date filters
        String startStr = trimOrNull(req.getParameter("startDate"));
        String endStr = trimOrNull(req.getParameter("endDate"));

        Date start = startStr != null ? Date.valueOf(startStr) : null;
        Date end = endStr != null ? Date.valueOf(endStr) : null;

        List<ReservationDisplayDTO> reservations;

        if (start != null && end != null) {
            reservations = reservationDAO.findByDateRange(start, end);
        } else {
            reservations = reservationDAO.findAll();
        }

        req.setAttribute("reservations", reservations);
        req.setAttribute("startDate", startStr);
        req.setAttribute("endDate", endStr);

        forward(req, resp, "/view-reservations.jsp");
    }
}