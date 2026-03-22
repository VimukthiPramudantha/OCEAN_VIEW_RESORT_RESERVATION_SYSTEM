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

@WebServlet("/view-reservations")
public class ViewReservationsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = ReservationDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        // Optional date filters
        String startStr = req.getParameter("startDate");
        String endStr = req.getParameter("endDate");

        Date start = startStr != null && !startStr.isEmpty() ? Date.valueOf(startStr) : null;
        Date end = endStr != null && !endStr.isEmpty() ? Date.valueOf(endStr) : null;

        List<ReservationDisplayDTO> reservations;

        if (start != null && end != null) {
            reservations = reservationDAO.findByDateRange(start, end);
        } else {
            reservations = reservationDAO.findAll();
        }

        req.setAttribute("reservations", reservations);
        req.setAttribute("startDate", startStr);
        req.setAttribute("endDate", endStr);

        req.getRequestDispatcher("/view-reservations.jsp").forward(req, resp);
    }
}