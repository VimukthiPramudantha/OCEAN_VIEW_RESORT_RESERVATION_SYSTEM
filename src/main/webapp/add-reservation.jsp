<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>New Reservation - Ocean View Resort</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .step { display: none; }
        .step.active { display: block; }
        input { margin: 5px 0; display: block; }
        button { margin: 10px 5px; }
        .error { color: red; }
    </style>
</head>
<body>
<h1>New Reservation</h1>
<form id="reservationForm" action="add-reservation" method="post">
    <div id="step1" class="step active">
        <h2>Step 1: Mandatory Guest Details</h2>
        <label>NIC/Passport Number: <input type="text" name="nicPassport" required></label>
        <label>Full Name: <input type="text" name="fullName" required></label>
        <label>Number of Adults: <input type="number" name="adults" min="1" required></label>
        <label>Number of Children: <input type="number" name="children" min="0" required></label>
        <label>Number of Infants: <input type="number" name="infants" min="0" required></label>
        <label>Nationality / Country: <input type="text" name="nationality" required></label>
        <label>Contact Number: <input type="tel" name="contact" required></label>
        <label>Email (optional): <input type="email" name="email"></label>
        <button type="button" onclick="nextStep(2)">Next</button>
    </div>

    <div id="step2" class="step">
        <h2>Step 2: Common Details</h2>
        <label>Vehicle Number (if parking needed): <input type="text" name="vehicleNumber"></label>
        <label>Check-in Date: <input type="date" name="checkIn" required></label>
        <label>Check-out Date: <input type="date" name="checkOut" required></label>
        <label>Room Type: <select name="roomType" required>
            <option value="Standard">Standard</option>
            <option value="Deluxe">Deluxe</option>
            <option value="Suite">Suite</option>
        </select></label>
        <label>Special Requests / Remarks: <textarea name="specialRequests"></textarea></label>
        <button type="button" onclick="prevStep(1)">Previous</button>
        <button type="button" onclick="nextStep(3)">Next</button>
    </div>

    <div id="step3" class="step">
        <h2>Step 3: Optional Preferences</h2>
        <label>Room Preference (floor, view, smoking): <textarea name="roomPreference"></textarea></label>
        <label>Wake-up Call Time: <input type="time" name="wakeUpCall"></label>
        <label>Luggage Storage After Checkout? <input type="checkbox" name="luggageStorage"></label>
        <label>Loyalty / Membership Number: <input type="text" name="loyaltyNumber"></label>
        <button type="button" onclick="prevStep(2)">Previous</button>
        <button type="submit">Save Reservation</button>
    </div>
</form>

<script>
    function nextStep(step) {
        document.querySelector('.step.active').classList.remove('active');
        document.getElementById('step' + step).classList.add('active');
    }
    function prevStep(step) {
        document.querySelector('.step.active').classList.remove('active');
        document.getElementById('step' + step).classList.add('active');
    }
</script>

<% if (request.getAttribute("error") != null) { %>
<p class="error"><%= request.getAttribute("error") %></p>
<% } %>
</body>
</html>