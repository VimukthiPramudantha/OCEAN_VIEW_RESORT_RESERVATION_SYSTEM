package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import com.hotel.dto.RoomAvailabilityDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date; 
import java.util.List;
import java.util.Map;

@WebServlet("/room-availability")
public class RoomAvailabilityServlet extends HttpServlet {

    private final RoomDAO roomDAO = RoomDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String monthParam = req.getParameter("month");
        YearMonth yearMonth;
        try {
            yearMonth = monthParam != null ? YearMonth.parse(monthParam) : YearMonth.now();
        } catch (Exception e) {
            yearMonth = YearMonth.now();
        }

        LocalDate firstOfMonth = yearMonth.atDay(1);
        Date firstDayAsDate = Date.from(firstOfMonth.atStartOfDay(ZoneId.systemDefault()).toInstant());

        LocalDate lastOfMonth = yearMonth.atEndOfMonth();

        String roomType = req.getParameter("type");
        Map<LocalDate, List<RoomAvailabilityDTO>> availability = roomDAO.getAvailabilityByDateRange(firstOfMonth,
                lastOfMonth, roomType);

        List<LocalDate> calendarDays = new ArrayList<>();
        int dayOfWeek = firstOfMonth.getDayOfWeek().getValue() % 7;
        LocalDate startPadding = firstOfMonth.minusDays(dayOfWeek);
        for (int i = 0; i < dayOfWeek; i++) {
            calendarDays.add(startPadding.plusDays(i));
        }
        for (int day = 1; day <= yearMonth.lengthOfMonth(); day++) {
            calendarDays.add(yearMonth.atDay(day));
        }

        req.setAttribute("selectedType", roomType);
        req.setAttribute("yearMonth", yearMonth);
        req.setAttribute("firstDayOfMonth", firstDayAsDate);
        req.setAttribute("calendarDays", calendarDays);
        req.setAttribute("availability", availability);
        req.setAttribute("roomTypes", roomDAO.getAllRoomTypes());

        req.getRequestDispatcher("/room-availability.jsp").forward(req, resp);
    }
}