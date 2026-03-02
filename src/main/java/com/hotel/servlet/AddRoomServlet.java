package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/add-room")
public class AddRoomServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }
        req.getRequestDispatcher("/add-room.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        String roomIdStr = req.getParameter("roomNumber");
        String type = req.getParameter("type");
        String rateStr = req.getParameter("rate");

        if (roomIdStr != null && type != null && rateStr != null) {
            try {
                int roomId = Integer.parseInt(roomIdStr);
                double rate = Double.parseDouble(rateStr);
                if (roomDAO.addRoom(roomId, type, rate)) {
                    session.setAttribute("successMsg", "New room #" + roomId + " added successfully.");
                    resp.sendRedirect("manage-rooms");
                    return;
                } else {
                    req.setAttribute("error", "Failed to add room. (Check if Room ID already exists)");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid number format for Room ID or Rate.");
            }
        } else {
            req.setAttribute("error", "All fields are required.");
        }

        req.getRequestDispatcher("/add-room.jsp").forward(req, resp);
    }
}
