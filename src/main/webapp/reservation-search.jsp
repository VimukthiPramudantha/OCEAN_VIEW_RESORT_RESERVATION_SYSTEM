<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reservation Search & Checkout</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Poppins', sans-serif; background: #f8fbff; padding: 40px; }
    h1 { color: #0077b6; text-align: center; }
    .filters { text-align: center; margin-bottom: 30px; }
    .filters input, .filters select { padding: 10px; margin: 0 10px; font-size: 16px; }
    .filters button { padding: 10px 20px; background: #0077b6; color: white; border: none; cursor: pointer; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    th, td { padding: 14px; text-align: left; border-bottom: 1px solid #eee; }
    th { background: #0077b6; color: white; }
    tr:hover { background: #f0f8ff; }
    .btn-checkout {
      background: #2a9d8f;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
    }
    .btn-checkout:hover { background: #21867a; }
    .btn-checkout:disabled { background: #ccc; cursor: not-allowed; }
  </style>
</head>
<body>

<h1>Search & Checkout Reservations</h1>

<div class="filters">
  <form method="get">
    <input type="text" name="guestName" placeholder="Guest Name" value="${guestName}">
    <select name="status">
      <option value="">All Statuses</option>
      <option value="checked_in" ${statusFilter == 'checked_in' ? 'selected' : ''}>Checked In</option>
      <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Confirmed</option>
    </select>
    <button type="submit">Filter</button>
    <a href="reservation-search">Clear</a>
  </form>
</div>

<table>
  <thead>
  <tr>
    <th>Res #</th>
    <th>Guest</th>
    <th>Room</th>
    <th>Check-in</th>
    <th>Check-out</th>
    <th>Status</th>
    <th>Action</th>
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
        <c:if test="${res.status == 'checked_in'}">
          <a href="checkout?resNumber=${res.reservationNumber}">
            <button class="btn-checkout">Checkout</button>
          </a>
        </c:if>
        <c:if test="${res.status != 'checked_in'}">
          <button class="btn-checkout" disabled>Not Available</button>
        </c:if>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty reservations}">
    <tr><td colspan="7" style="text-align:center;padding:40px;">No reservations found.</td></tr>
  </c:if>
  </tbody>
</table>

<div style="margin-top:30px;text-align:center;">
  <a href="dashboard">Back to Dashboard</a>
</div>

</body>
</html>