<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --glass-bg: rgba(255, 255, 255, 0.7);
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #1a1a1a;
            --text-muted: #555;
            --success: #2a9d8f;
            --danger: #e63946;
            --accent: #caf0f8;
            --card-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
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
            background-image: 
                radial-gradient(at 0% 0%, rgba(0, 180, 219, 0.05) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(0, 131, 176, 0.05) 0px, transparent 50%);
            overflow: hidden;
        }
        /* Sidebar Styling (UNCHANGED per user request) */
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
            font-size: 12px;
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
        /* Dashboard Content Area Styles */
        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow-y: auto;
            padding: 50px;
            background: transparent;
            scroll-behavior: smooth;
        }
        .dashboard-header {
            margin-bottom: 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .welcome-text h2 {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        .welcome-text p {
            color: var(--text-muted);
            font-size: 16px;
        }
        .date-badge {
            background: white;
            padding: 10px 20px;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            font-size: 13px;
            font-weight: 600;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        /* Stats Grid - Premium Glassmorphism */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }
        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            padding: 30px;
            border-radius: 24px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(255, 255, 255, 0.4);
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 45px rgba(31, 38, 135, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.6);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            background: rgba(0, 119, 182, 0.1);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        .stat-info .stat-title {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }
        .stat-info .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 5px;
        }
        .stat-info .stat-label {
            font-size: 12px;
            color: var(--text-muted);
        }
        /* Action Tiles */
        .section-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .section-title::after {
            content: '';
            flex-grow: 1;
            height: 1px;
            background: rgba(0,0,0,0.05);
        }
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }
        .action-tile {
            background: white;
            padding: 35px;
            border-radius: 20px;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            gap: 15px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.03);
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }
        .action-tile:hover {
            transform: scale(1.02);
            box-shadow: 0 10px 30px rgba(0, 119, 182, 0.08);
            border-color: rgba(0, 119, 182, 0.1);
        }
        .action-icon {
            font-size: 28px;
            color: var(--primary);
            margin-bottom: 5px;
        }
        .action-tile h3 {
            font-size: 18px;
            color: var(--text-main);
            font-weight: 600;
        }
        .action-tile p {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.5;
        }
        .tile-arrow {
            margin-top: auto;
            align-self: flex-end;
            width: 35px;
            height: 35px;
            background: #f8fbff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            transition: all 0.3s;
        }
        .action-tile:hover .tile-arrow {
            background: var(--primary);
            color: white;
            transform: translateX(5px);
        }
        /* Occupancy Progress */
        .occupancy-container {
            margin-top: 15px;
            width: 100%;
        }
        .progress-track {
            height: 10px;
            background: rgba(0, 119, 182, 0.05);
            border-radius: 500px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: var(--bg-gradient);
            border-radius: 500px;
            transition: width 1s ease-out;
        }
        @media (max-width: 992px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; }
            .main-content { padding: 30px; }
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
            <a href="dashboard" class="nav-link active">
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
            <a href="reservation-search" class="nav-link">
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
    <div class="dashboard-header">
        <div class="welcome-text">
            <h2>Welcome Back, ${user.fullName.split(' ')[0]}</h2>
            <p>Here is what's happening at the resort today.</p>
        </div>
        <div class="date-badge">
            <i class="far fa-calendar-alt"></i>
            <%= new java.text.SimpleDateFormat("EEEE, dd MMMM").format(new java.util.Date()) %>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div style="padding: 20px; background: rgba(230, 57, 70, 0.05); color: #e63946; border-radius: 16px; margin-bottom: 40px; border-left: 5px solid #e63946; display: flex; align-items: center; gap: 15px; font-weight: 500;">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>
    <c:if test="${not empty successMsg}">
         <div style="padding: 20px; background: rgba(42, 157, 143, 0.05); color: #2a9d8f; border-radius: 16px; margin-bottom: 40px; border-left: 5px solid #2a9d8f; display: flex; align-items: center; gap: 15px; font-weight: 500;">
            <i class="fas fa-check-circle"></i> ${successMsg}
        </div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-user-check"></i></div>
            <div class="stat-info">
                <div class="stat-title">Arrivals</div>
                <div class="stat-value">${todayCheckins}</div>
                <div class="stat-label">Scheduled check-ins</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="color:#e67e22; background:rgba(230,126,34,0.1);"><i class="fas fa-user-clock"></i></div>
            <div class="stat-info">
                <div class="stat-title">Departures</div>
                <div class="stat-value">${todayCheckouts}</div>
                <div class="stat-label">Scheduled check-outs</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="color:#9b59b6; background:rgba(155,89,182,0.1);"><i class="fas fa-chart-pie"></i></div>
            <div class="stat-info">
                <div class="stat-title">Occupancy</div>
                <div class="stat-value">${occupancyPercent}%</div>
                <div class="stat-label">${currentBooked} / ${totalRooms} Rooms Occupied</div>
                <div class="occupancy-container">
                    <div class="progress-track"><div class="progress-fill" style="width: ${occupancyPercent}%"></div></div>
                </div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="color:#2ecc71; background:rgba(46,204,113,0.1);"><i class="fas fa-money-bill-wave"></i></div>
            <div class="stat-info">
                <div class="stat-title">Revenue</div>
                <div class="stat-value" style="font-size: 24px;">LKR ${todayRevenue}</div>
                <div class="stat-label">Expected for today</div>
            </div>
        </div>
    </div>

    <h3 class="section-title">Operations Portal</h3>
    <div class="actions-grid">
        <a href="add-reservation" class="action-tile">
            <div class="action-icon"><i class="fas fa-plus-circle"></i></div>
            <h3>New Reservation</h3>
            <p>Register a new booking and secure guest records instantly.</p>
            <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
        </a>
        <a href="room-availability" class="action-tile">
            <div class="action-icon" style="color:#9b59b6;"><i class="fas fa-calendar-alt"></i></div>
            <h3>Room Calendar</h3>
            <p>Check interactive monthly availability and plan occupancy.</p>
            <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
        </a>
        <a href="manage-reservations" class="action-tile">
            <div class="action-icon" style="color:#e67e22;"><i class="fas fa-tasks"></i></div>
            <h3>Master Registry</h3>
            <p>Complete control over active, cancelled, and history records.</p>
            <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
        </a>
        <a href="reservation-search" class="action-tile">
            <div class="action-icon" style="color:#34495e;"><i class="fas fa-receipt"></i></div>
            <h3>Express Checkout</h3>
            <p>Quick search and automated bill generation for departing guests.</p>
            <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
        </a>
        <c:if test="${user.role eq 'admin'}">
            <a href="manage-rooms" class="action-tile">
                <div class="action-icon" style="color:#e74c3c;"><i class="fas fa-hotel"></i></div>
                <h3>Inventory Management</h3>
                <p>Register new wing units and monitor housekeeping cycles.</p>
                <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>
            <a href="add-user" class="action-tile">
                <div class="action-icon" style="color:#16a085;"><i class="fas fa-users-cog"></i></div>
                <h3>User Governance</h3>
                <p>Provision security clearances for resort staff and managers.</p>
                <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>
        </c:if>
        <a href="help" class="action-tile">
            <div class="action-icon" style="color:#7f8c8d;"><i class="fas fa-book-reader"></i></div>
            <h3>Operational Help</h3>
            <p>Access guidelines and protocols for all system modules.</p>
            <div class="tile-arrow"><i class="fas fa-chevron-right"></i></div>
        </a>
    </div>
</main>
</body>
</html>