package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/room-availability")
public class RoomAvailabilityServlet<Room> extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        // Get month parameter or default to current
        String monthParam = req.getParameter("month");
        YearMonth yearMonth;

        if (monthParam != null && !monthParam.isEmpty()) {
            try {
                yearMonth = YearMonth.parse(monthParam, DateTimeFormatter.ofPattern("yyyy-MM"));
            } catch (DateTimeParseException e) {
                yearMonth = YearMonth.now();
            }
        } else {
            yearMonth = YearMonth.now();
        }

        // Get all rooms
        List<Room> rooms = roomDAO.findAllRooms();  // you need this method

        // Get occupancy map: roomId → list of reserved dates in this month
        Map<Integer, List<LocalDate>> occupancy = reservationDAO.getOccupancyForMonth(yearMonth);

        req.setAttribute("yearMonth", yearMonth);
        req.setAttribute("rooms", rooms);
        req.setAttribute("occupancy", occupancy);
        req.setAttribute("daysInMonth", yearMonth.lengthOfMonth());
        req.setAttribute("firstDayOfMonth", yearMonth.atDay(1).getDayOfWeek().getValue()); // 1 = Monday, 7 = Sunday

        req.getRequestDispatcher("/room-availability.jsp").forward(req, resp);
    }
}