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
import java.util.List;

@WebServlet("/manage-rooms")
public class RoomManagementServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        List<RoomAvailabilityDTO> rooms = roomDAO.getAllRooms();
        req.setAttribute("rooms", rooms);
        req.getRequestDispatcher("/manage-rooms.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String roomIdStr = req.getParameter("roomId");
        String status = req.getParameter("status");

        if (roomIdStr != null && status != null) {
            try {
                int roomId = Integer.parseInt(roomIdStr);
                roomDAO.updateRoomStatus(roomId, status);
                session.setAttribute("successMsg", "Room status updated successfully.");
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid Room ID.");
            }
        }

        resp.sendRedirect("manage-rooms");
    }
}
