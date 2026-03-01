package com.hotel.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Common base for all servlets providing helper methods.
 */
public abstract class BaseServlet extends HttpServlet {

    protected void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }

    protected void redirect(HttpServletResponse resp, String path) throws IOException {
        resp.sendRedirect(path);
    }

    protected void handleError(HttpServletRequest req, HttpServletResponse resp, String message, String forwardPath)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        forward(req, resp, forwardPath);
    }

    protected int safeParseInt(String s, int defaultValue) {
        if (s == null || s.trim().isEmpty())
            return defaultValue;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    protected String trimOrNull(String s) {
        return (s == null) ? null : s.trim();
    }

    protected boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
