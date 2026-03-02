package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        req.setAttribute("user", user);

        // Fetch real data
        int todayCheckins = reservationDAO.countTodayCheckins();
        int todayCheckouts = reservationDAO.countTodayCheckouts();
        int currentBooked = roomDAO.countBookedRooms();
        int totalRooms = roomDAO.countTotalRooms();

        double occupancyPercent = totalRooms > 0 ? (double) currentBooked / totalRooms * 100 : 0.0;

        // Revenue - never null thanks to COALESCE in DAO
        BigDecimal todayRevenue = reservationDAO.sumTodayRevenue();

        // Safe string conversion
        String revenueStr = todayRevenue != null ? todayRevenue.toPlainString() : "0.00";

        // Optional: nicer formatting (e.g. 1,234.56)
        // String revenueStr = String.format("%,.2f", todayRevenue != null ?
        // todayRevenue : BigDecimal.ZERO);

        req.setAttribute("todayCheckins", todayCheckins);
        req.setAttribute("todayCheckouts", todayCheckouts);
        req.setAttribute("currentBooked", currentBooked);
        req.setAttribute("totalRooms", totalRooms);
        req.setAttribute("occupancyPercent", String.format("%.1f", occupancyPercent));
        req.setAttribute("todayRevenue", revenueStr);

        // Optional: clear success message after display (prevents it showing forever)
        session.removeAttribute("successMsg");

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}