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

        String type = req.getParameter("type");
        String rateStr = req.getParameter("rate");

        if (type != null && rateStr != null) {
            try {
                double rate = Double.parseDouble(rateStr);
                if (roomDAO.addRoom(type, rate)) {
                    session.setAttribute("successMsg", "New room added successfully.");
                    resp.sendRedirect("manage-rooms");
                    return;
                } else {
                    req.setAttribute("error", "Failed to add room.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid rate format.");
            }
        } else {
            req.setAttribute("error", "All fields are required.");
        }

        req.getRequestDispatcher("/add-room.jsp").forward(req, resp);
    }
}
