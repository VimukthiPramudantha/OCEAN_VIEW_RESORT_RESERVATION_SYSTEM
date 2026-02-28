<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest History - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f8fbff; padding: 40px; color: #333; }
        .search-box { text-align: center; margin-bottom: 40px; }
        .search-box input { padding: 14px 20px; width: 500px; font-size: 16px; border: 2px solid #ddd; border-radius: 50px; }
        .search-box button { padding: 14px 32px; background: #0077b6; color: white; border: none; border-radius: 50px; cursor: pointer; font-size: 16px; }

        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.08); border-radius: 12px; overflow: hidden; margin-top: 20px; }
        th, td { padding: 14px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #0077b6; color: white; }
        tr:hover { background: #f0f8ff; }

        .details-card {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-top: 30px;
        }

        .section-title { margin: 35px 0 15px; color: #0077b6; font-size: 1.4rem; border-bottom: 2px solid #eee; padding-bottom: 8px; }

        .no-data { text-align: center; color: #888; font-style: italic; padding: 40px; }

        .status-cancelled { color: #e63946; font-weight: bold; }
        .status-completed { color: #2a9d8f; }
    </style>
</head>
<body>

<h1>Guest Reservation History</h1>

<div class="search-box">
    <form method="post">
        <input type="text" name="searchTerm" placeholder="Search by NIC, Passport, Name or Contact Number" value="${searchTerm}" required>
        <button type="submit"><i class="fas fa-search"></i> Search</button>
    </form>
</div>

<c:if test="${not empty error}">
    <p style="color:red; text-align:center;">${error}</p>
</c:if>

<!-- Guest List View -->
<c:if test="${not empty guests && empty guest}">
    <h2>Search Results (${guests.size()} guests found)</h2>
    <table>
        <thead>
        <tr>
            <th>Name</th>
            <th>NIC / Passport</th>
            <th>Contact</th>
            <th>Nationality</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="g" items="${guests}">
            <tr>
                <td>${g.name}</td>
                <td>${g.nicPassport}</td>
                <td>${g.contact}</td>
                <td>${g.nationality}</td>
                <td>
                    <a href="reservation-history?guestId=${g.id}" style="color:#0077b6; font-weight:500;">View Full History →</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</c:if>

<!-- Detailed Guest History View -->
<c:if test="${not empty guest}">
    <div class="details-card">
        <h2>Guest Profile</h2>
        <p><strong>Name:</strong> ${guest.name}</p>
        <p><strong>NIC / Passport:</strong> ${guest.nicPassport}</p>
        <p><strong>Contact:</strong> ${guest.contact}</p>
        <p><strong>Email:</strong> ${guest.email}</p>
        <p><strong>Nationality:</strong> ${guest.nationality}</p>

        <h3 class="section-title">Current / Upcoming Reservations</h3>
        <c:if test="${empty currentReservations}">
            <p class="no-data">No current or upcoming reservations</p>
        </c:if>
        <c:if test="${not empty currentReservations}">
            <table>
                <thead><tr><th>Res #</th><th>Check-in</th><th>Check-out</th><th>Room</th><th>Status</th></tr></thead>
                <tbody>
                <c:forEach var="res" items="${currentReservations}">
                    <tr>
                        <td>${res.reservationNumber}</td>
                        <td>${res.checkIn}</td>
                        <td>${res.checkOut}</td>
                        <td>${res.roomId}</td>
                        <td>${res.status}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <h3 class="section-title">Previous / Completed Reservations</h3>
        <c:if test="${empty previousReservations}">
            <p class="no-data">No previous reservations</p>
        </c:if>
        <c:if test="${not empty previousReservations}">
            <table>
                <thead><tr><th>Res #</th><th>Check-in</th><th>Check-out</th><th>Room</th><th>Status</th></tr></thead>
                <tbody>
                <c:forEach var="res" items="${previousReservations}">
                    <tr>
                        <td>${res.reservationNumber}</td>
                        <td>${res.checkIn}</td>
                        <td>${res.checkOut}</td>
                        <td>${res.roomId}</td>
                        <td class="status-completed">${res.status}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <h3 class="section-title">Cancelled Reservations</h3>
        <c:if test="${empty cancelledReservations}">
            <p class="no-data">No cancelled reservations</p>
        </c:if>
        <c:if test="${not empty cancelledReservations}">
            <table>
                <thead><tr><th>Res #</th><th>Check-in</th><th>Check-out</th><th>Room</th><th>Status</th></tr></thead>
                <tbody>
                <c:forEach var="res" items="${cancelledReservations}">
                    <tr>
                        <td>${res.reservationNumber}</td>
                        <td>${res.checkIn}</td>
                        <td>${res.checkOut}</td>
                        <td>${res.roomId}</td>
                        <td class="status-cancelled">${res.status}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <div style="text-align:center; margin-top:40px;">
        <a href="reservation-history">Search Another Guest</a>
    </div>
</c:if>

</body>
</html>