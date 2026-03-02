<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search & Checkout - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #333;
            --text-muted: #666;
            --success: #2a9d8f;
            --danger: #e63946;
            --accent: #00b4db;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
        }

        body {
            height: 100vh;
            display: flex;
            background: #f0f4f8;
            overflow: hidden;
        }

        /* Sidebar Styling (Consistent) */
        .sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 30px 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            z-index: 100;
        }

        .brand {
            text-align: center;
            margin-bottom: 40px;
        }

        .brand h1 {
            color: var(--primary);
            font-size: 22px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .user-profile {
            background: rgba(0, 119, 182, 0.05);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .user-name {
            display: block;
            font-weight: 600;
            font-size: 14px;
            color: var(--text-main);
        }

        .user-role {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .nav-menu {
            list-style: none;
            flex-grow: 1;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            text-decoration: none;
            color: var(--text-muted);
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .nav-link i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .nav-link:hover {
            background: rgba(0, 119, 182, 0.1);
            color: var(--primary);
        }

        .nav-link.active {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 10px rgba(0, 119, 182, 0.3);
        }

        .logout-link {
            margin-top: auto;
            color: var(--danger);
        }

        .logout-link:hover {
            background: rgba(230, 57, 70, 0.1);
            color: var(--danger);
        }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow-y: auto;
            padding: 40px;
            background: #f8fbff;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 30px;
        }

        .content-header h2 {
            font-size: 24px;
            color: var(--primary);
            font-weight: 600;
        }

        .content-header p {
            color: var(--text-muted);
            font-size: 14px;
        }

        /* Filter Form */
        .filter-bar {
            background: white;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.05);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group label {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-main);
        }

        .filter-group input, .filter-group select {
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 13px;
            color: var(--text-main);
            transition: border-color 0.3s;
        }

        .filter-group input:focus, .filter-group select:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn-filter, .btn-clear {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-filter {
            background: var(--primary);
            color: white;
            border: none;
        }

        .btn-filter:hover {
            background: var(--primary-hover);
        }

        .btn-clear {
            background: #f0f0f0;
            color: var(--text-muted);
            border: 1px solid #e0e0e0;
        }

        .btn-clear:hover {
            background: #e5e5e5;
        }

        /* Table Styling */
        .table-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f4f8fb;
            color: var(--text-main);
            font-weight: 600;
            font-size: 13px;
            text-align: left;
            padding: 18px 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        td {
            padding: 15px 20px;
            font-size: 13.5px;
            color: var(--text-muted);
            border-bottom: 1px solid #f9f9f9;
        }

        tr:hover td {
            background-color: #fcfdfe;
        }

        .res-number {
            font-weight: 600;
            color: var(--primary);
        }

        .guest-name {
            font-weight: 500;
            color: var(--text-main);
        }

        /* Status Badge */
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-confirmed  { background: rgba(42, 157, 143, 0.1); color: var(--success); }
        .status-checked-in { background: rgba(0, 119, 182, 0.1);  color: var(--primary); }
        .status-checked-out { background: rgba(0, 0, 0, 0.05); color: #999; }

        .btn-checkout {
            background: var(--success);
            color: white;
            border: none;
            padding: 6px 15px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-checkout:hover {
            background: #21867a;
            transform: translateY(-1px);
        }

        .btn-disabled {
            background: #eee;
            color: #ccc;
            cursor: not-allowed;
        }

        @media (max-width: 992px) {
            .sidebar { width: 80px; }
            .brand, .user-profile, .nav-link span { display: none; }
            .nav-link i { margin-right: 0; }
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <h1>OCEAN VIEW</h1>
    </div>
    <div class="user-profile">
        <span class="user-name">${user.fullName}</span>
        <span class="user-role">${user.role.toUpperCase()}</span>
    </div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="dashboard" class="nav-link">
                <i class="fas fa-chart-line"></i> <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="manage-reservations" class="nav-link">
                <i class="fas fa-calendar-check"></i> <span>Manage Bookings</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="add-reservation" class="nav-link">
                <i class="fas fa-plus-circle"></i> <span>New Reservation</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="room-availability" class="nav-link">
                <i class="fas fa-calendar-alt"></i> <span>Room Calendar</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="reservation-search" class="nav-link active">
                <i class="fas fa-search-location"></i> <span>Search & Checkout</span>
            </a>
        </li>
        <c:if test="${user.role eq 'admin'}">
            <li class="nav-item">
                <a href="manage-rooms" class="nav-link">
                    <i class="fas fa-door-open"></i> <span>Room Management</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="add-user" class="nav-link">
                    <i class="fas fa-user-plus"></i> <span>Add User</span>
                </a>
            </li>
        </c:if>
        <li class="nav-item">
            <a href="help" class="nav-link">
                <i class="fas fa-question-circle"></i> <span>Portal Help</span>
            </a>
        </li>
    </ul>
    <a href="logout" class="nav-link logout-link">
        <i class="fas fa-sign-out-alt"></i> <span>Logout Session</span>
    </a>
</aside>

<main class="main-content">
    <div class="content-header">
        <div>
            <h2>Search & Checkout</h2>
            <p>Locate active reservations to process guest checkouts</p>
        </div>
    </div>

    <form class="filter-bar" method="get">
        <div class="filter-group">
            <label>Guest Name</label>
            <input type="text" name="guestName" placeholder="Search guests..." value="${guestName}">
        </div>
        <div class="filter-group">
            <label>Status</label>
            <select name="status">
                <option value="">All Active</option>
                <option value="checked_in" ${statusFilter == 'checked_in' ? 'selected' : ''}>Checked In</option>
                <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Confirmed</option>
            </select>
        </div>
        <button type="submit" class="btn-filter">Search</button>
        <a href="reservation-search" class="btn-clear">Reset</a>
    </form>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Booking #</th>
                <th>Guest Information</th>
                <th>Room</th>
                <th>Stay Period</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="res" items="${reservations}">
                <tr>
                    <td><span class="res-number">${res.reservationNumber}</span></td>
                    <td><span class="guest-name">${res.guestName}</span></td>
                    <td><i class="fas fa-bed" style="color:#ddd; margin-right:5px;"></i> ${res.roomId}</td>
                    <td>
                        <span style="font-size: 11px; display: block; color: #aaa;">IN: ${res.checkIn}</span>
                        <span style="font-size: 11px; display: block; color: #aaa;">OUT: ${res.checkOut}</span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${res.status == 'checked_in'}">
                                <span class="status-badge status-checked-in">Checked In</span>
                            </c:when>
                            <c:when test="${res.status == 'confirmed'}">
                                <span class="status-badge status-confirmed">Confirmed</span>
                            </c:when>
                            <c:when test="${res.status == 'checked_out'}">
                                <span class="status-badge status-checked-out">Checked Out</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${res.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${res.status == 'checked_in' || res.status == 'confirmed'}">
                                <a href="checkout?resNumber=${res.reservationNumber}" class="btn-checkout">
                                    <i class="fas fa-receipt"></i> Checkout
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="btn-checkout btn-disabled">Closed</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reservations}">
                <tr><td colspan="6" style="text-align:center;padding:60px;color:var(--text-muted);">
                    <i class="fas fa-search" style="font-size: 30px; display: block; margin-bottom: 10px; opacity: 0.2;"></i>
                    No matching active reservations found.
                </td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>

</body>
</html>