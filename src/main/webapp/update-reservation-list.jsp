<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Reservation - Select</title>
    <style>
        body { font-family: Arial; padding: 40px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border: 1px solid #ddd; }
        th { background: #0077b6; color: white; }
        tr:nth-child(even) { background: #f2f2f2; }
        .btn-edit { background: #0077b6; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-edit:hover { background: #005f8d; }
    </style>
</head>
<body>

<h1>Select Reservation to Update</h1>

<table>
    <thead>
    <tr>
        <th>Res #</th>
        <th>Guest</th>
        <th>Check-in</th>
        <th>Check-out</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="res" items="${reservations}">
        <tr>
            <td>${res.reservationNumber}</td>
            <td>${res.guestName}</td>
            <td>${res.checkIn}</td>
            <td>${res.checkOut}</td>
            <td>
                <a href="update-reservation?id=${res.id}" class="btn-edit">Edit</a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty reservations}">
        <tr><td colspan="5">No reservations found.</td></tr>
    </c:if>
    </tbody>
</table>

<a href="dashboard">Back to Dashboard</a>

</body>
</html>