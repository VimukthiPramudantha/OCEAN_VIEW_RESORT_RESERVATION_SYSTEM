<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Registry - Ocean View Resort</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
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

        /* Search Bar */
        .search-container {
            margin-bottom: 35px;
            position: relative;
            max-width: 600px;
        }

        .search-container input {
            width: 100%;
            padding: 15px 120px 15px 50px;
            border: 2px solid #eee;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s;
            background: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
        }

        .search-container i.fa-search {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }

        .search-container button {
            position: absolute;
            right: 8px;
            top: 8px;
            bottom: 8px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0 20px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-container button:hover {
            background: var(--primary-hover);
        }

        .search-container input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 4px 15px rgba(0, 119, 182, 0.1);
        }

        /* Table Styling */
        .card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            margin-bottom: 30px;
            overflow: hidden;
        }

        .card-header {
            padding: 20px 25px;
            background: #fcfdfe;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-weight: 600;
            font-size: 16px;
            color: var(--text-main);
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
            padding: 15px 25px;
        }

        td {
            padding: 15px 25px;
            font-size: 13px;
            color: var(--text-muted);
            border-bottom: 1px solid #f9f9f9;
        }

        tr:hover td {
            background-color: #fcfdfe;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-confirmed { background: rgba(42, 157, 143, 0.1); color: var(--success); }
        .status-cancelled { background: rgba(230, 57, 70, 0.1); color: var(--danger); }
        .status-checked-in { background: rgba(0, 119, 182, 0.1); color: var(--primary); }
        .status-checked-out { background: rgba(102, 102, 102, 0.1); color: var(--text-muted); }

        /* Profile Section */
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 25px;
            padding: 25px;
        }

        .profile-item label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .profile-item span {
            font-weight: 500;
            color: var(--text-main);
            font-size: 14px;
        }

        .section-separator {
            margin: 40px 0 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .section-separator h3 {
            font-size: 16px;
            color: var(--text-main);
            white-space: nowrap;
        }

        .section-separator .line {
            height: 1px;
            background: #eee;
            flex-grow: 1;
        }

        .btn-view-profile {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 12px;
            transition: opacity 0.3s;
        }

        .btn-view-profile:hover {
            opacity: 0.7;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: var(--text-muted);
            font-size: 14px;
        }

        /* Error/Flash Messages */
        .flash {
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            animation: fadeIn 0.4s ease;
        }

        .flash i { margin-right: 10px; }
        .flash.error { background: rgba(230, 57, 70, 0.1); color: var(--danger); border: 1px solid rgba(230, 57, 70, 0.2); }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }

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
        <!-- <li class="nav-item">
            <a href="reservation-history" class="nav-link active">
                <i class="fas fa-history"></i> <span>Guest Registry</span>
            </a>
        </li> -->
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
            <h2>Guest History & Insights</h2>
            <p>Access guest loyalty records and previous stay history</p>
        </div>
        <c:if test="${not empty guest}">
            <a href="reservation-history" class="btn-view-profile">
                <i class="fas fa-arrow-left"></i> Search Another Guest
            </a>
        </c:if>
    </div>

    <c:if test="${not empty error}">
        <div class="flash error">
            <i class="fas fa-exclamation-circle"></i>
            ${error}
        </div>
    </c:if>

    <!-- Search Section -->
    <c:if test="${empty guest}">
        <div class="search-container">
            <form method="post">
                <i class="fas fa-search"></i>
                <input type="text" name="searchTerm" placeholder="Search by NIC, Passport, Name or Contact..." value="${searchTerm}" required>
                <button type="submit">Search</button>
            </form>
        </div>
    </c:if>

    <!-- Guest Search Results Table -->
    <c:if test="${not empty guests && empty guest}">
        <div class="card">
            <div class="card-header">
                <span class="card-title">Found ${guests.size()} Guest Matches</span>
            </div>
            <table>
                <thead>
                <tr>
                    <th>Full Name</th>
                    <th>NIC / Passport</th>
                    <th>Contact Info</th>
                    <th>Nationality</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="g" items="${guests}">
                    <tr>
                        <td style="font-weight: 600; color: var(--text-main);">${g.name}</td>
                        <td>${g.nicPassport}</td>
                        <td>${g.contact}</td>
                        <td>${g.nationality}</td>
                        <td>
                            <a href="reservation-history?guestId=${g.id}" class="btn-view-profile">
                                View Profile <i class="fas fa-chevron-right" style="margin-left: 5px;"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Detailed Guest History View -->
    <c:if test="${not empty guest}">
        <div class="card">
            <div class="card-header">
                <span class="card-title">Guest Profile: ${guest.name}</span>
                <span class="status-badge status-checked-in">Verified Identity</span>
            </div>
            <div class="profile-grid">
                <div class="profile-item">
                    <label>Identity Document</label>
                    <span>${guest.nicPassport}</span>
                </div>
                <div class="profile-item">
                    <label>Contact Number</label>
                    <span>${guest.contact}</span>
                </div>
                <div class="profile-item">
                    <label>Email Address</label>
                    <span style="text-transform: lowercase;">${guest.email}</span>
                </div>
                <div class="profile-item">
                    <label>Country / Origin</label>
                    <span>${guest.nationality}</span>
                </div>
            </div>
        </div>

        <div class="section-separator">
            <h3>Current & Future Stays</h3>
            <div class="line"></div>
        </div>

        <div class="card">
            <c:if test="${empty currentReservations}">
                <div class="no-data">No current or upcoming reservations found for this guest.</div>
            </c:if>
            <c:if test="${not empty currentReservations}">
                <table>
                    <thead>
                    <tr>
                        <th>Booking #</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Room</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="res" items="${currentReservations}">
                        <tr>
                            <td style="font-weight: 600; color: var(--primary);">#${res.reservationNumber}</td>
                            <td>${res.checkIn}</td>
                            <td>${res.checkOut}</td>
                            <td><i class="fas fa-bed" style="color:#ddd; margin-right:5px;"></i> ${res.roomId}</td>
                            <td><span class="status-badge status-confirmed">${res.status}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <div class="section-separator">
            <h3>Completed History</h3>
            <div class="line"></div>
        </div>

        <div class="card">
            <c:if test="${empty previousReservations}">
                <div class="no-data">Guest has no previous stay history.</div>
            </c:if>
            <c:if test="${not empty previousReservations}">
                <table>
                    <thead>
                    <tr>
                        <th>Booking #</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Room</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="res" items="${previousReservations}">
                        <tr>
                            <td style="font-weight: 600; color: var(--text-main);">#${res.reservationNumber}</td>
                            <td>${res.checkIn}</td>
                            <td>${res.checkOut}</td>
                            <td>${res.roomId}</td>
                            <td><span class="status-badge status-checked-out">${res.status}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <c:if test="${not empty cancelledReservations}">
            <div class="section-separator">
                <h3>Cancellation Records</h3>
                <div class="line"></div>
            </div>
            <div class="card">
                <table>
                    <thead>
                    <tr>
                        <th>Booking #</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Room</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="res" items="${cancelledReservations}">
                        <tr>
                            <td>#${res.reservationNumber}</td>
                            <td>${res.checkIn}</td>
                            <td>${res.checkOut}</td>
                            <td>${res.roomId}</td>
                            <td><span class="status-badge status-cancelled">${res.status}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </c:if>
</main>

</body>
</html>