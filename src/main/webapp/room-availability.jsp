<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Availability - Ocean View Resort</title>
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
            --success-light: #e6fffb;
            --warning: #e9c46a;
            --warning-light: #fffbeb;
            --danger: #e63946;
            --danger-light: #fff5f5;
            --glass-bg: rgba(255, 255, 255, 0.9);
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

        /* Sidebar Styling */
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

        .brand h1 { color: var(--primary); font-size: 22px; text-align: center; margin-bottom: 40px; }

        .user-profile {
            background: rgba(0, 119, 182, 0.05);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .user-name { display: block; font-weight: 600; font-size: 14px; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }

        .nav-menu { list-style: none; flex-grow: 1; }
        .nav-link {
            display: flex; align-items: center; padding: 12px 15px; text-decoration: none;
            color: var(--text-muted); border-radius: 10px; font-size: 14px; transition: all 0.3s ease;
        }
        .nav-link i { margin-right: 12px; width: 20px; text-align: center; }
        .nav-link:hover { background: rgba(0, 119, 182, 0.1); color: var(--primary); }
        .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 10px rgba(0, 119, 182, 0.3); }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow-y: auto;
            padding: 40px;
            background: #f8fbff;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header-section h2 { font-size: 26px; color: var(--text-main); }

        .month-nav {
            display: flex;
            align-items: center;
            gap: 20px;
            background: white;
            padding: 10px 20px;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .month-nav a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 18px;
            transition: transform 0.2s;
        }

        .month-nav a:hover { transform: scale(1.2); }
        .month-nav span { font-weight: 600; color: var(--text-main); min-width: 160px; text-align: center; }

        /* Room Type Filter */
        .filter-section {
            margin-bottom: 30px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .type-chip {
            padding: 10px 20px;
            background: white;
            border: 1px solid #eee;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
        }

        .type-chip:hover { border-color: var(--primary); color: var(--primary); background: rgba(0, 119, 182, 0.02); }
        .type-chip.active { background: var(--primary); color: white; border-color: var(--primary); box-shadow: 0 4px 10px rgba(0,119,182,0.2); }

        /* Calendar Grid */
        .calendar-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.05);
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 15px;
        }

        .weekday-label {
            text-align: center;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            color: #aaa;
            padding-bottom: 15px;
        }

        .day-cell {
            aspect-ratio: 1 / 1;
            border-radius: 15px;
            padding: 12px;
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
            position: relative;
            border: 1px solid transparent;
        }

        .day-number {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .day-status {
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            margin-top: auto;
        }

        .other-month { opacity: 0.3; pointer-events: none; }

        /* Availability Classes */
        .status-available { background: var(--success-light); color: #1b635a; border-color: #d1f7f1; }
        .status-partial { background: var(--warning-light); color: #a67c00; border-color: #fef3c7; }
        .status-booked { background: var(--danger-light); color: #c53030; border-color: #fed7d7; }

        .day-cell:hover:not(.other-month) {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            z-index: 10;
        }

        /* Tooltip style popup on hover */
        .room-details {
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: white;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            width: 200px;
            display: none;
            z-index: 100;
            border: 1px solid #eee;
        }

        .day-cell:hover .room-details { display: block; }

        .room-details h5 { font-size: 12px; margin-bottom: 8px; color: var(--primary); border-bottom: 1px solid #eee; padding-bottom: 5px; }
        .room-item { font-size: 11px; display: flex; justify-content: space-between; margin-bottom: 3px; }
        .room-item .booked { color: var(--danger); font-weight: 600; }
        .room-item .available { color: var(--success); font-weight: 600; }

        @media (max-width: 1200px) { .sidebar { width: 80px; } .brand h1, .user-profile, .nav-link span { display: none; } .calendar-grid { gap: 8px; } }
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
            <a href="room-availability" class="nav-link active">
                <i class="fas fa-calendar-alt"></i> <span>Room Calendar</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="add-reservation" class="nav-link">
                <i class="fas fa-plus-circle"></i> <span>New Reservation</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="reservation-search" class="nav-link">
                <i class="fas fa-search"></i> <span>Search & Checkout</span>
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
    </ul>
    <a href="logout" class="nav-link logout-link">
        <i class="fas fa-sign-out-alt"></i> <span>Logout Session</span>
    </a>
</aside>

<main class="main-content">
    <div class="header-section">
        <div>
            <h2>Room Availability</h2>
            <p style="color: var(--text-muted); font-size: 14px;">Monitor occupancy levels and room statuses</p>
        </div>
        <div class="month-nav">
            <a href="?month=${yearMonth.minusMonths(1)}&type=${selectedType != null ? selectedType : ''}"><i class="fas fa-chevron-left"></i></a>
            <span><fmt:formatDate value="${firstDayOfMonth}" pattern="MMMM yyyy"/></span>
            <a href="?month=${yearMonth.plusMonths(1)}&type=${selectedType != null ? selectedType : ''}"><i class="fas fa-chevron-right"></i></a>
        </div>
    </div>

    <div class="filter-section">
        <a href="?month=${yearMonth}&type=" class="type-chip ${empty selectedType ? 'active' : ''}">All Room Types</a>
        <c:forEach var="type" items="${roomTypes}">
            <a href="?month=${yearMonth}&type=${type}" 
               class="type-chip ${selectedType eq type ? 'active' : ''}">${type}</a>
        </c:forEach>
    </div>

    <div class="calendar-card">
        <div class="calendar-grid">
            <div class="weekday-label">Sun</div>
            <div class="weekday-label">Mon</div>
            <div class="weekday-label">Tue</div>
            <div class="weekday-label">Wed</div>
            <div class="weekday-label">Thu</div>
            <div class="weekday-label">Fri</div>
            <div class="weekday-label">Sat</div>

            <c:forEach var="date" items="${calendarDays}">
                <c:set var="rooms" value="${availability[date]}" />
                <c:set var="isCurrentMonth" value="${date.month == yearMonth.month}" />

                <c:set var="statusClass" value="status-available" />
                <c:set var="statusLabel" value="Vacant" />
                <c:set var="totalRooms" value="0" />
                <c:set var="bookedRooms" value="0" />

                <c:if test="${not empty rooms}">
                    <c:forEach var="room" items="${rooms}">
                        <c:set var="totalRooms" value="${totalRooms + 1}" />
                        <c:if test="${room.status ne 'available'}">
                            <c:set var="bookedRooms" value="${bookedRooms + 1}" />
                        </c:if>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${bookedRooms == 0}">
                            <c:set var="statusClass" value="status-available" />
                            <c:set var="statusLabel" value="All Vacant" />
                        </c:when>
                        <c:when test="${bookedRooms < totalRooms}">
                            <c:set var="statusClass" value="status-partial" />
                            <c:set var="statusLabel" value="${totalRooms - bookedRooms} Left" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusClass" value="status-booked" />
                            <c:set var="statusLabel" value="Full" />
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <div class="day-cell ${statusClass} ${!isCurrentMonth ? 'other-month' : ''}">
                    <span class="day-number">${date.dayOfMonth}</span>
                    <c:if test="${isCurrentMonth}">
                        <span class="day-status">${statusLabel}</span>
                        
                        <div class="room-details">
                            <h5>Availability Details</h5>
                            <c:if test="${not empty rooms}">
                                <c:forEach var="room" items="${rooms}">
                                    <div class="room-item">
                                        <span>R#${room.roomId} (${room.roomType})</span>
                                        <span class="${room.status eq 'available' ? 'available' : 'booked'}">
                                            ${room.status eq 'available' ? 'VAC' : 'OCC'}
                                        </span>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

</body>
</html>
