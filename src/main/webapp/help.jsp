<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Guidelines - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --glass-bg: rgba(255, 255, 255, 0.9);
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #333;
            --text-muted: #666;
            --accent: #caf0f8;
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

        .brand { text-align: center; margin-bottom: 40px; }
        .brand h1 { color: var(--primary); font-size: 22px; font-weight: 600; letter-spacing: 1px; }

        .user-profile {
            background: rgba(0, 119, 182, 0.05);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 30px;
        }
        .user-name { display: block; font-weight: 600; font-size: 14px; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }

        .nav-menu { list-style: none; flex-grow: 1; }
        .nav-item { margin-bottom: 5px; }
        .nav-link {
            display: flex; align-items: center; padding: 12px 15px; text-decoration: none;
            color: var(--text-muted); border-radius: 10px; font-size: 14px; transition: all 0.3s ease;
        }
        .nav-link i { margin-right: 12px; width: 20px; text-align: center; }
        .nav-link:hover { background: rgba(0, 119, 182, 0.1); color: var(--primary); }
        .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 10px rgba(0, 119, 182, 0.3); }

        .logout-link { margin-top: auto; color: #e63946; }
        .logout-link:hover { background: rgba(230, 57, 70, 0.1); }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow-y: auto;
            padding: 40px;
            background: #f8fbff;
        }

        .help-header { margin-bottom: 40px; }
        .help-header h2 { font-size: 28px; color: var(--text-main); margin-bottom: 10px; }
        .help-header p { color: var(--text-muted); }

        .guide-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
        }

        .guide-section h3 {
            font-size: 20px;
            color: var(--primary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .guide-section h3 i {
            background: var(--accent);
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 18px;
        }

        .instruction-list {
            list-style: none;
        }

        .instruction-item {
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .instruction-item:last-child { border-bottom: none; }

        .instruction-item strong {
            display: block;
            font-size: 15px;
            color: var(--text-main);
            margin-bottom: 5px;
        }

        .instruction-item p {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.6;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .badge-admin { background: #fee2e2; color: #991b1b; }
        .badge-staff { background: #dcfce7; color: #166534; }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; }
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
            <a href="help" class="nav-link active">
                <i class="fas fa-question-circle"></i> <span>Portal Help</span>
            </a>
        </li>
    </ul>
    <a href="logout" class="nav-link logout-link">
        <i class="fas fa-sign-out-alt"></i> <span>Logout Session</span>
    </a>
</aside>

<main class="main-content">
    <div class="help-header">
        <h2>System Operations Guide</h2>
        <p>Comprehensive instructions for resort staff and administration.</p>
    </div>

    <!-- Dashboard section -->
    <section class="guide-section">
        <h3><i class="fas fa-tachometer-alt"></i> Dashboard & Analytics</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>Real-time Occupancy</strong>
                <p>The dashboard displays the current percentage of occupied rooms. This is calculated live based on "Checked In" status.</p>
            </li>
            <li class="instruction-item">
                <strong>Revenue Tracking</strong>
                <p>The system calculates today's expected revenue from checkouts and total billing processed within the current 24-hour cycle.</p>
            </li>
        </ul>
    </section>

    <!-- Reservation section -->
    <section class="guide-section">
        <h3><i class="fas fa-calendar-alt"></i> Reservation Lifecycle</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>Creating a Booking</strong>
                <p>Navigate to "New Reservation". Enter guest details, select room type, and pick dates. The system will automatically check for room availability before confirming.</p>
            </li>
            <li class="instruction-item">
                <strong>Guest Check-In</strong>
                <p>Find the guest in "Search & Checkout" or "View All Bookings". Update their status to "Checked In" upon arrival to update room status.</p>
            </li>
            <li class="instruction-item">
                <strong>Handling Check-Out</strong>
                <p>Use "Search & Checkout" to find the guest. Review the bill, add any additional service charges or taxes, and proceed to complete checkout. This marks the reservation as "Checked Out" and the room for cleaning.</p>
            </li>
        </ul>
    </section>

    <!-- Room Management -->
    <section class="guide-section">
        <h3><i class="fas fa-door-open"></i> Inventory & Housekeeping</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>Room Statuses</strong>
                <p>Rooms can be set to "Available", "Occupied", "Cleaning", or "Maintenance". "Cleaning" status is set automatically after guest checkout.</p>
            </li>
            <c:if test="${user.role eq 'admin'}">
                <li class="instruction-item">
                    <span class="role-badge badge-admin">Admin Only</span>
                    <strong>Registering New Rooms</strong>
                    <p>Administrators can add new room inventory via the "Room Management" page by specifying room numbers and types (Standard, Deluxe, Suite).</p>
                </li>
            </c:if>
        </ul>
    </section>

    <!-- User Management -->
    <c:if test="${user.role eq 'admin'}">
        <section class="guide-section">
            <h3><i class="fas fa-users-cog"></i> System Administration</h3>
            <ul class="instruction-list">
                <li class="instruction-item">
                    <span class="role-badge badge-admin">Admin Only</span>
                    <strong>Managing Staff Accounts</strong>
                    <p>Use the "Add User" tool to create new system accounts. Ensure you assign the correct role (Staff or Admin) to enforce proper system security.</p>
                </li>
                <li class="instruction-item">
                    <span class="role-badge badge-admin">Admin Only</span>
                    <strong>Restricted Actions</strong>
                    <p>Only administrators can perform destructive actions like "Purge Record" (Delete) or "Cancel Stay" for finalized reservations.</p>
                </li>
            </ul>
        </section>
    </c:if>

    <!-- Support section -->
    <section class="guide-section">
        <h3><i class="fas fa-info-circle"></i> Support & Troubleshooting</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>Empty Message Bars</strong>
                <p>If you see a successful or error message bar with no text, it indicates a background process was completed without a specific feedback string. This is normal and doesn't affect system stability.</p>
            </li>
            <li class="instruction-item">
                <strong>Technical Support</strong>
                <p>For critical system failures or database connectivity issues, please contact the IT department immediately at support@oceanview.resort</p>
            </li>
        </ul>
    </section>
</main>

</body>
</html>
