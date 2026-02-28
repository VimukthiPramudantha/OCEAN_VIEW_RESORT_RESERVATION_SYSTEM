<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Reservation #${reservation.reservationNumber}</title>
    <style>
        body { font-family: Arial; padding: 40px; max-width: 600px; margin: auto; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; }
        input, textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { padding: 12px 24px; background: #0077b6; color: white; border: none; border-radius: 6px; cursor: pointer; }
        button:hover { background: #005f8d; }
        .error { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>

<h1>Update Reservation #${reservation.reservationNumber}</h1>

<c:if test="${not empty requestScope.error}">
    <div class="error">${requestScope.error}</div>
</c:if>

<form method="post">
    <input type="hidden" name="reservationId" value="${reservation.id}">

    <div class="form-group">
        <label for="checkIn">Check-in Date:</label>
        <input type="date" id="checkIn" name="checkIn" value="${reservation.checkIn}" required>
    </div>

    <div class="form-group">
        <label for="checkOut">Check-out Date:</label>
        <input type="date" id="checkOut" name="checkOut" value="${reservation.checkOut}" required>
    </div>

    <div class="form-group">
        <label for="adults">Adults:</label>
        <input type="number" id="adults" name="adults" min="1" value="${reservation.adults}" required>
    </div>

    <div class="form-group">
        <label for="children">Children:</label>
        <input type="number" id="children" name="children" min="0" value="${reservation.children}">
    </div>

<%--    <div class="form-group">--%>
<%--        <label for="infants">Infants:</label>--%>
<%--        <input type="number" id="infants" name="infants" min="0" value="${reservation.infants}">--%>
<%--    </div>--%>

    <div class="form-group">
        <label for="specialRequests">Special Requests:</label>
        <textarea id="specialRequests" name="specialRequests" rows="4">${reservation.specialRequests}</textarea>
    </div>

    <button type="submit">Save Changes</button>
</form>

<a href="view-reservations">Back to List</a>

</body>
</html>