<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View All Reservations</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background: #0077b6; color: white; }
        tr:nth-child(even) { background: #f2f2f2; }
        .filter-form { margin-bottom: 20px; }
        .filter-form input { padding: 8px; margin-right: 10px; }
        .btn { padding: 8px 16px; background: #0077b6; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>

<h1>All Reservations</h1>

<form class="filter-form" method="get">
    <label>From: <input type="date" name="startDate" value="${startDate}"></label>
    <label>To: <input type="date" name="endDate" value="${endDate}"></label>
    <button type="submit" class="btn">Filter</button>
    <a href="view-reservations" class="btn">Clear Filter</a>
</form>

<table>
    <thead>
    <tr>
        <th>Res #</th>
        <th>Guest</th>
        <th>Room</th>
        <th>Check-in</th>
        <th>Check-out</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="res" items="${reservations}">
        <tr>
            <td>${res.reservationNumber}</td>
            <td>${res.guestName}</td>
            <td>${res.roomId}</td>
            <td>${res.checkIn}</td>
            <td>${res.checkOut}</td>
            <td>${res.status}</td>
            <td>
                <a href="update-reservation?id=${res.id}">Edit</a> |
                <a href="cancel-reservation?id=${res.id}">Cancel</a> |
                <a href="delete-reservation?confirm=${res.id}">Delete</a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty reservations}">
        <tr><td colspan="7" style="text-align:center;">No reservations found.</td></tr>
    </c:if>
    </tbody>
</table>

<a href="dashboard">Back to Dashboard</a>

</body>
</html>