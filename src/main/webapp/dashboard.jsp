<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotel.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Dashboard - Ocean View Resort</title>
    <style> body { font-family: Arial; padding: 20px; } </style>
</head>
<body>
    <h1>Welcome, <%= user.getFullName() %> (<%= user.getRole() %>)</h1>
    <p>You are logged in.</p>

    <ul>
        <li><a href="add-reservation">Add New Reservation</a></li>
        <li><a href="view-reservation">View Reservations</a></li>
        <li><a href="reports">Reports</a></li>
        <li><a href="help">Help</a></li>
        <li><a href="logout">Logout</a></li>
    </ul>
</body>
</html>