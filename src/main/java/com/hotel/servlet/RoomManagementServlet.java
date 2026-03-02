package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import com.hotel.dto.RoomAvailabilityDTO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
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

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            req.setAttribute("error", "Access Denied: Only administrators can manage room inventory.");
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
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

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String roomIdStr = req.getParameter("roomId");
        String status = req.getParameter("status");

        if (roomIdStr != null && status != null) {
            try {
                int roomId = Integer.parseInt(roomIdStr);
                if (roomDAO.updateRoomStatus(roomId, status)) {
                    session.setAttribute("successMsg", "Room status updated successfully.");
                    resp.sendRedirect("manage-rooms");
                    return;
                } else {
                    req.setAttribute("error", "Failed to update room status.");
                }
            } catch (SQLException e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid Room ID.");
            }
        }

        resp.sendRedirect("manage-rooms");
    }
}
