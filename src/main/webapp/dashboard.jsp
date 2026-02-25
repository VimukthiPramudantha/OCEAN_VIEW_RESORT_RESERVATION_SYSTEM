<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --glass-bg: rgba(255, 255, 255, 0.9);
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #333;
            --text-muted: #666;
            --success: #2a9d8f;
            --danger: #e63946;
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

        .welcome-section {
            margin-bottom: 40px;
        }

        .welcome-section h2 {
            font-size: 28px;
            color: var(--text-main);
            margin-bottom: 10px;
        }

        .welcome-section p {
            color: var(--text-muted);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-title {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary);
        }

        .stat-label {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 5px;
        }

        /* Actions Grid */
        .actions-header {
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .action-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .action-card h3 {
            font-size: 16px;
            margin-bottom: 10px;
            color: var(--text-main);
        }

        .action-card p {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 20px;
        }

        .btn-action {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-action:hover {
            background: var(--primary-hover);
            transform: scale(1.05);
        }

        .occupancy-bar {
            width: 100%;
            height: 8px;
            background: #eee;
            border-radius: 4px;
            margin-top: 15px;
            overflow: hidden;
        }

        .occupancy-fill {
            height: 100%;
            background: var(--primary);
            border-radius: 4px;
        }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; padding: 20px; }
            .main-content { padding: 20px; }
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
            <a href="dashboard" class="nav-link active">Dashboard</a>
        </li>
        <li class="nav-item">
            <a href="manage-reservations" class="nav-link"><i class="fas fa-list-check"></i> Manage Reservations</a>
        </li>
        <li class="nav-item">
            <a href="view-reservations" class="nav-link">Reservations</a>
        </li>
        <li class="nav-item">
            <a href="check-availability" class="nav-link">Availability</a>
        </li>
        <li class="nav-item">
            <a href="help" class="nav-link">Help & Portal Info</a>
        </li>
    </ul>

    <a href="logout" class="nav-link logout-link">Logout Session</a>
</aside>

<main class="main-content">
    <section class="welcome-section">
        <h2>Welcome Back, ${user.fullName.split(' ')[0]}</h2>
        <p>Overview of resort operations for today.</p>
    </section>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-title">Today's Check-ins</div>
            <div class="stat-value">${todayCheckins}</div>
            <div class="stat-label">Guests expected today</div>
        </div>

        <div class="stat-card">
            <div class="stat-title">Today's Check-outs</div>
            <div class="stat-value">${todayCheckouts}</div>
            <div class="stat-label">Rooms to be vacated</div>
        </div>

        <div class="stat-card">
            <div class="stat-title">Current Occupancy</div>
            <div class="stat-value">${occupancyPercent}%</div>
            <div class="stat-label">${currentBooked} / ${totalRooms} rooms booked</div>
            <div class="occupancy-bar">
                <div class="occupancy-fill" style="width: ${occupancyPercent}%"></div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-title">Today's Revenue</div>
            <div class="stat-value">LKR ${todayRevenue}</div>
            <div class="stat-label">Real-time revenue tracking</div>
        </div>
    </div>

    <h3 class="actions-header">Quick Resort Actions</h3>
    <div class="actions-grid">
        <div class="action-card">
            <h3>New Reservation</h3>
            <p>Register a guest and manage room booking effortlessly.</p>
            <a href="add-reservation" class="btn-action">Create Booking</a>
        </div>

        <div class="action-card">
            <h3>Check Availability</h3>
            <p>Quickly view available rooms for any date range.</p>
            <a href="check-availability" class="btn-action">Check Now</a>
        </div>

        <div class="action-card">
            <h3>Manage Reservations</h3>
            <p>View, update, cancel or delete existing bookings.</p>
            <a href="manage-reservations" class="btn-action">Manage Now</a>
        </div>

        <div class="action-card">
            <h3>Staff Guidelines</h3>
            <p>Access system manuals and operation protocols.</p>
            <a href="help" class="btn-action">View Help</a>
        </div>
    </div>
</main>

</body>
</html>