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
public class DashboardServlet extends SecureServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getAuthenticatedUser(req);
        req.setAttribute("user", user);

        // Fetch dashboard data
        int todayCheckins = reservationDAO.countTodayCheckins();
        int todayCheckouts = reservationDAO.countTodayCheckouts();
        int currentBooked = roomDAO.countBookedRooms();
        int totalRooms = roomDAO.countTotalRooms();

        double occupancyPercent = totalRooms > 0 ? (double) currentBooked / totalRooms * 100 : 0.0;
        BigDecimal todayRevenue = reservationDAO.sumTodayRevenue();

        req.setAttribute("todayCheckins", todayCheckins);
        req.setAttribute("todayCheckouts", todayCheckouts);
        req.setAttribute("currentBooked", currentBooked);
        req.setAttribute("totalRooms", totalRooms);
        req.setAttribute("occupancyPercent", String.format("%.1f", occupancyPercent));
        req.setAttribute("todayRevenue", todayRevenue.toPlainString());

        // Clear success message after display
        req.getSession().removeAttribute("successMsg");

        forward(req, resp, "/dashboard.jsp");
    }
}
