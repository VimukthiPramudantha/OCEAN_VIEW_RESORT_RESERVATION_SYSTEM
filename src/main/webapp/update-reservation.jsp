<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Booking - Ocean View Resort</title>
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

        /* Flash Messages */
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

        /* Form Styling */
        .form-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            max-width: 800px;
        }

        .res-preview {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: rgba(0, 119, 182, 0.05);
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .res-preview-title {
            font-size: 14px;
            color: var(--text-muted);
        }

        .res-preview-value {
            font-size: 18px;
            font-weight: 600;
            color: var(--primary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }

        .form-group {
            margin-bottom: 5px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-main);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }

        .form-textarea {
            grid-column: span 2;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .form-actions {
            margin-top: 35px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-hover);
            box-shadow: 0 4px 15px rgba(0, 119, 182, 0.3);
        }

        .btn-secondary {
            background: #f0f0f0;
            color: var(--text-muted);
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }

        .btn-secondary:hover {
            background: #e5e5e5;
        }

        @media (max-width: 992px) {
            .sidebar { width: 80px; }
            .brand, .user-profile, .nav-link span { display: none; }
            .nav-link i { margin-right: 0; }
            .form-grid { grid-template-columns: 1fr; }
            .form-textarea { grid-column: span 1; }
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
        <h2>Modify Stay Details</h2>
        <p>Update guest count, dates, or special requests for this booking</p>
    </div>

    <c:if test="${not empty requestScope.error}">
        <div class="flash error">
            <i class="fas fa-exclamation-circle"></i>
            ${requestScope.error}
        </div>
    </c:if>

    <div class="form-container">
        <div class="res-preview">
            <div>
                <span class="res-preview-title">Booking Reference</span>
                <div class="res-preview-value">#${reservation.reservationNumber}</div>
            </div>
            <div style="text-align: right;">
                <span class="res-preview-title">Room Assigned</span>
                <div class="res-preview-value">Room ${reservation.roomId}</div>
            </div>
        </div>

        <form method="post">
            <input type="hidden" name="reservationId" value="${reservation.id}">

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="checkIn">Check-in Date</label>
                    <input type="date" id="checkIn" name="checkIn" class="form-control" value="${reservation.checkIn}" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="checkOut">Check-out Date</label>
                    <input type="date" id="checkOut" name="checkOut" class="form-control" value="${reservation.checkOut}" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="adults">Adult Count</label>
                    <input type="number" id="adults" name="adults" class="form-control" min="1" value="${reservation.adults}" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="children">Children Count</label>
                    <input type="number" id="children" name="children" class="form-control" min="0" value="${reservation.children}">
                </div>

                <div class="form-group form-textarea">
                    <label class="form-label" for="specialRequests">Special Requests & Preferences</label>
                    <textarea id="specialRequests" name="specialRequests" class="form-control" rows="4">${reservation.specialRequests}</textarea>
                </div>
            </div>

            <div class="form-actions">
                <a href="update-reservation" class="btn btn-secondary">Discard Changes</a>
                <button type="submit" class="btn btn-primary">Sync All Changes</button>
            </div>
        </form>
    </div>
</main>

</body>
</html>