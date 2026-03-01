<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout - Search Reservation</title>
    <style>
        body { font-family: Arial; padding: 40px; max-width: 600px; margin: auto; }
        input[type=text] { padding: 12px; width: 100%; font-size: 16px; }
        button { padding: 12px 24px; background: #0077b6; color: white; border: none; cursor: pointer; }
        .error { color: red; margin: 10px 0; }
    </style>
</head>
<body>

<h1>Checkout Guest</h1>

<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form method="get">
    <label>Reservation Number or Guest Name:</label><br>
    <input type="text" name="resNumber" placeholder="e.g. RES-2025-123 or John Doe" required>
    <button type="submit">Find Reservation</button>
</form>

<a href="dashboard">Back to Dashboard</a>

</body>
</html>