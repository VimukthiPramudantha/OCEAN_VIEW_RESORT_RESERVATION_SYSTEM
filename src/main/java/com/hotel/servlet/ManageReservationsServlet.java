package com.hotel.servlet;

import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.hotel.servlet.SecureServlet;

import java.io.IOException;

@WebServlet("/manage-reservations")
public class ManageReservationsServlet extends SecureServlet {
    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/manage-reservations.jsp");
    }
}