<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Checkout</title>
    <style>
        body { font-family: Arial; padding: 40px; max-width: 700px; margin: auto; }
        .bill-box { border: 1px solid #ddd; padding: 25px; background: #fff; margin: 20px 0; }
        table { width: 100%; margin: 20px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f8f8; }
        .total { font-size: 1.3em; font-weight: bold; text-align: right; padding-right: 20px; }
        button { padding: 14px 30px; background: #2a9d8f; color: white; border: none; font-size: 16px; cursor: pointer; }
        button:hover { background: #1f7a6e; }
        .error { color: red; }
    </style>
</head>
<body>

<h1>Checkout Confirmation</h1>

<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<div class="bill-box">
    <h3>Reservation #${reservation.reservationNumber}</h3>
    <p><strong>Guest:</strong> ${reservation.guestName}</p>
    <p><strong>Room:</strong> ${reservation.roomId}</p>
    <p><strong>Check-in:</strong> ${reservation.checkIn}</p>
    <p><strong>Check-out:</strong> ${reservation.checkOut}</p>

    <table>
        <tr>
            <th>Description</th>
            <th>Details</th>
            <th>Amount</th>
        </tr>
        <tr>
            <td>Room rate per night</td>
            <td>LKR ${reservation.ratePerNight}</td>
            <td></td>
        </tr>
        <tr>
            <td>Number of nights</td>
            <td>${nights}</td>
            <td></td>
        </tr>
        <tr>
            <td colspan="2" class="total">Total Bill:</td>
            <td class="total">LKR ${totalBill}</td>
        </tr>
    </table>
</div>

<form method="post">
    <input type="hidden" name="reservationId" value="${reservation.id}">
    <input type="hidden" name="action" value="confirm_checkout">
    <button type="submit">Confirm Checkout & Free Room</button>
</form>

<a href="checkout">Back to Search</a>

</body>
</html>