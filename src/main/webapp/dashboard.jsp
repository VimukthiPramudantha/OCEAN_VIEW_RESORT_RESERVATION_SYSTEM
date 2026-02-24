<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotel.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login");
        return;
    }

    // These values should come from request attributes set by DashboardServlet
    Integer todayCheckins    = (Integer) request.getAttribute("todayCheckins");
    Integer todayCheckouts   = (Integer) request.getAttribute("todayCheckouts");
    Integer currentBooked    = (Integer) request.getAttribute("currentBooked");
    Integer totalRooms       = (Integer) request.getAttribute("totalRooms");
    Double  occupancyPercent = (Double)  request.getAttribute("occupancyPercent");
    String  todayRevenue     = (String)  request.getAttribute("todayRevenue"); // formatted string

    // Fallbacks if attributes are null (prevents NPE during early testing)
    todayCheckins    = (todayCheckins    != null) ? todayCheckins    : 0;
    todayCheckouts   = (todayCheckouts   != null) ? todayCheckouts   : 0;
    currentBooked    = (currentBooked    != null) ? currentBooked    : 0;
    totalRooms       = (totalRooms       != null) ? totalRooms       : 20; // example total
    occupancyPercent = (occupancyPercent != null) ? occupancyPercent : 0.0;
    todayRevenue     = (todayRevenue     != null) ? todayRevenue     : "0.00";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            background: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            margin: 0;
            font-size: 1.8em;
        }
        .user-info {
            font-size: 1.1em;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            padding: 24px;
            transition: transform 0.15s ease;
        }
        .card:hover {
            transform: translateY(-4px);
        }
        .card h3 {
            margin-top: 0;
            color: #2c3e50;
            font-size: 1.3em;
        }
        .card .number {
            font-size: 2.4em;
            font-weight: bold;
            margin: 10px 0;
            color: #3498db;
        }
        .card .label {
            color: #7f8c8d;
            font-size: 0.95em;
        }
        .btn {
            display: inline-block;
            background: #27ae60;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            margin-top: 12px;
        }
        .btn:hover {
            background: #219653;
        }
        .actions-grid {
            margin-top: 30px;
        }
        .logout {
            background: #e74c3c;
        }
        .logout:hover {
            background: #c0392b;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Ocean View Resort - Staff Dashboard</h1>
        <div class="user-info">
            Welcome, <strong><%= currentUser.getFullName() %></strong>
            (<%= currentUser.getRole().toUpperCase() %>)
        </div>
    </div>

    <div class="grid">

        <!-- Today's Summary Cards -->
        <div class="card">
            <h3>Today's Check-ins</h3>
            <div class="number"><%= todayCheckins %></div>
            <div class="label">Guests expected today</div>
            <a href="view-reservations?filter=today-checkin" class="btn">View List</a>
        </div>

        <div class="card">
            <h3>Today's Check-outs</h3>
            <div class="number"><%= todayCheckouts %></div>
            <div class="label">Rooms to be vacated</div>
            <a href="view-reservations?filter=today-checkout" class="btn">View List</a>
        </div>

        <div class="card">
            <h3>Current Occupancy</h3>
            <div class="number"><%= String.format("%.1f", occupancyPercent) %>%</div>
            <div class="label"><%= currentBooked %> / <%= totalRooms %> rooms occupied</div>
        </div>

        <div class="card">
            <h3>Today's Revenue</h3>
            <div class="number">LKR <%= todayRevenue %></div>
            <div class="label">From checked-out rooms</div>
        </div>

    </div>

    <!-- Quick Actions -->
    <div class="grid actions-grid">
        <div class="card">
            <h3>New Reservation</h3>
            <p>Register a new guest and book a room</p>
            <a href="add-reservation" class="btn">Create Booking</a>
        </div>

        <div class="card">
            <h3>Check Availability</h3>
            <p>See available rooms for specific dates</p>
            <a href="check-availability" class="btn">Check Now</a>
        </div>

        <div class="card">
            <h3>View Reservations</h3>
            <p>Search or list all bookings</p>
            <a href="view-reservations" class="btn">View All</a>
        </div>

        <div class="card">
            <h3>Help & Guidelines</h3>
            <p>System usage instructions for staff</p>
            <a href="help" class="btn">Open Help</a>
        </div>

        <div class="card">
            <h3>Logout</h3>
            <p>End your current session</p>
            <a href="logout" class="btn logout">Logout</a>
        </div>
    </div>
</div>

</body>
</html>