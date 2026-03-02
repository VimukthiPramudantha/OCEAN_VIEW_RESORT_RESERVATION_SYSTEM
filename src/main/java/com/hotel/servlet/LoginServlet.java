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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in → redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            resp.sendRedirect("dashboard");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic server-side validation (add more later)
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByUsernameAndPassword(username.trim(), password.trim());

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout

            // Optional: log last login time (update DB)

            resp.sendRedirect("dashboard.jsp");
        } else {
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}