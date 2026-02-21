package com.hotel.servlet;

import com.hotel.config.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/test-db")
public class TestDbServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        out.println("<html><body>");
        out.println("<h2>Database Connection Test</h2>");

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            out.println("<p style='color:green'>SUCCESS: Connected to database!</p>");
            out.println("<p>Pool stats: " + DBUtil.getPoolStats() + "</p>");

            var stmt = conn.createStatement();
            var rs = stmt.executeQuery("SELECT 1 AS test");
            if (rs.next()) {
                out.println("<p>Test query returned: " + rs.getInt("test") + "</p>");
            }

        } catch (SQLException e) {
            out.println("<p style='color:red'>FAILED: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        } finally {
            DBUtil.closeQuietly(conn);
        }

        out.println("</body></html>");
    }
}