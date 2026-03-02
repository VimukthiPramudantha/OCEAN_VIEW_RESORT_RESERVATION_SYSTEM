package com.hotel.servlet;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/add-user")
public class AddUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only administrators can access this page.");
            return;
        }

        req.getRequestDispatcher("/add-user.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only administrators can create users.");
            return;
        }

        String username = req.getParameter("username");
        String fullName = req.getParameter("fullName");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (username == null || fullName == null || password == null || role == null ||
                username.trim().isEmpty() || fullName.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/add-user.jsp").forward(req, resp);
            return;
        }

        if (userDAO.isUsernameExists(username.trim())) {
            req.setAttribute("error", "Username already exists.");
            req.getRequestDispatcher("/add-user.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setFullName(fullName.trim());
        newUser.setPassword(password.trim());
        newUser.setRole(role);

        if (userDAO.createUser(newUser)) {
            session.setAttribute("successMsg", "User '" + username + "' created successfully.");
            resp.sendRedirect("dashboard");
        } else {
            req.setAttribute("error", "Failed to create user. Please try again.");
            req.getRequestDispatcher("/add-user.jsp").forward(req, resp);
        }
    }
}
