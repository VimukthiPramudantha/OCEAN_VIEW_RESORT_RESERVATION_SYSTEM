<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reservations - Ocean View Resort</title>
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
            --warning: #f4a261;
            --danger: #e63946;
            --white: #ffffff;
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

        /* Sidebar Styling (Consistent with Dashboard) */
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

        .view-header {
            margin-bottom: 40px;
        }

        .view-header h2 {
            font-size: 28px;
            color: var(--text-main);
            margin-bottom: 10px;
        }

        .view-header p {
            color: var(--text-muted);
        }

        /* Flash Messages */
        .flash {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 12px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideDown 0.4s ease-out;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .flash.success { background: rgba(42,157,143,0.1); color: var(--success); border: 1px solid rgba(42,157,143,0.2); }
        .flash.error   { background: rgba(230,57,70,0.1); color: var(--danger);  border: 1px solid rgba(230,57,70,0.2);  }

        /* Management Grid */
        .management-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }

        .management-card {
            background: var(--white);
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .management-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.08);
            border-color: var(--primary);
        }

        .card-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 20px;
            background: rgba(0, 119, 182, 0.05);
            width: 80px;
            height: 80px;
            line-height: 80px;
            border-radius: 50%;
            margin-left: auto;
            margin-right: auto;
            transition: all 0.3s ease;
        }

        .management-card:hover .card-icon {
            background: var(--primary);
            color: white;
            transform: rotateY(360deg);
        }

        .management-card h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--text-main);
        }

        .management-card p {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .btn-manage {
            display: inline-block;
            padding: 12px 25px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn-manage:hover {
            background: var(--primary-hover);
            box-shadow: 0 4px 10px rgba(0, 119, 182, 0.2);
        }

        /* Color variations for buttons */
        .btn-cancel { background: var(--danger); }
        .btn-cancel:hover { background: #d62828; }
        
        .btn-delete { background: #6c757d; }
        .btn-delete:hover { background: #495057; }
        
        .btn-history { background: var(--warning); }
        .btn-history:hover { background: #e67e22; }

        @media (max-width: 992px) {
            .sidebar { width: 80px; padding: 20px 10px; }
            .brand h1, .user-profile, .nav-link span { display: none; }
            .nav-link i { margin-right: 0; font-size: 20px; }
        }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; padding: 15px; }
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
            <a href="dashboard" class="nav-link">
                <i class="fas fa-chart-line"></i> <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="manage-reservations" class="nav-link active">
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
    <section class="view-header">
        <h2>Reservation Management</h2>
        <p>Control and monitor all guest bookings from a centralized hub.</p>
    </section>

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="flash success">
            <i class="fas fa-check-circle"></i> ${sessionScope.successMsg}
        </div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="flash error">
            <i class="fas fa-exclamation-triangle"></i> ${requestScope.error}
        </div>
    </c:if>

    <div class="management-grid">

        <!-- View Reservations -->
        <div class="management-card">
            <div class="card-icon"><i class="fas fa-list-ul"></i></div>
            <h3>View All Bookings</h3>
            <p>Access the complete master list of all current, upcoming, and past reservations with powerful search.</p>
            <a href="view-reservations" class="btn-manage">Explore List</a>
        </div>

        <!-- Update Reservation -->
        <div class="management-card">
            <div class="card-icon"><i class="fas fa-user-edit"></i></div>
            <h3>Update Details</h3>
            <p>Modify guest information, change stay dates, or reassign room types for existing bookings.</p>
            <a href="update-reservation" class="btn-manage">Edit Booking</a>
        </div>

        <c:if test="${user.role eq 'admin'}">
            <!-- Cancel Reservation -->
            <div class="management-card">
                <div class="card-icon"><i class="fas fa-calendar-times"></i></div>
                <h3>Cancel Stay</h3>
                <p>Properly handle cancellation requests and instantly free up room inventory for new guests.</p>
                <a href="cancel-reservation" class="btn-manage btn-cancel">Cancel Booking</a>
            </div>

            <!-- Reservation History -->
            <div class="management-card">
                <div class="card-icon"><i class="fas fa-history"></i></div>
                <h3>Guest History</h3>
                <p>Review comprehensive historical data for returning guests using their NIC or Passport records.</p>
                <a href="reservation-history" class="btn-manage btn-history">View History</a>
            </div>

            <!-- Delete Reservation (Admin only context) -->
            <div class="management-card">
                <div class="card-icon"><i class="fas fa-trash-alt"></i></div>
                <h3>Purge Record</h3>
                <p>Permanently remove reservation entries from the system database. Intended for administrative cleanup.</p>
                <a href="delete-reservation" class="btn-manage btn-delete">Delete Record</a>
            </div>
        </c:if>

    </div>
</main>

</body>
</html>