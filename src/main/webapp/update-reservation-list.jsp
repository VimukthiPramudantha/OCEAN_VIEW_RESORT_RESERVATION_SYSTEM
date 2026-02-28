<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Reservation - Ocean View Resort</title>
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
            --danger: #e63946;
            --success: #2a9d8f;
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
            font-size: 14px;
            text-align: left;
            padding: 20px 25px;
            border-bottom: 2px solid #f0f0f0;
        }

        td {
            padding: 18px 25px;
            font-size: 14px;
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

        .btn-edit {
            background: var(--primary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
        }

        .btn-edit i { margin-right: 6px; }

        .btn-edit:hover {
            background: var(--primary-hover);
            box-shadow: 0 4px 10px rgba(0, 119, 182, 0.2);
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
            <a href="check-availability" class="nav-link">
                <i class="fas fa-search"></i> <span>Availability</span>
            </a>
        </li>
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
        <h2>Update Reservation</h2>
        <p>Select a booking to modify stay details or guest counts</p>
    </div>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Reservation #</th>
                <th>Guest Name</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="res" items="${reservations}">
                <tr>
                    <td><span class="res-number">${res.reservationNumber}</span></td>
                    <td><span class="guest-name">${res.guestName}</span></td>
                    <td>${res.checkIn}</td>
                    <td>${res.checkOut}</td>
                    <td>
                        <a href="update-reservation?id=${res.id}" class="btn-edit">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reservations}">
                <tr><td colspan="5" style="text-align:center;padding:50px;color:var(--text-muted);">
                    <i class="fas fa-search" style="font-size: 30px; display: block; margin-bottom: 10px; opacity: 0.3;"></i>
                    No reservations found to update.
                </td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>

</body>
</html>