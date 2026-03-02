<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Management - Ocean View Resort</title>
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
            --warning: #f4a261;
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

        .nav-menu { list-style: none; flex-grow: 1; }
        .nav-link {
            display: flex; align-items: center; padding: 12px 15px; text-decoration: none;
            color: var(--text-muted); border-radius: 10px; font-size: 14px; margin-bottom: 5px; transition: all 0.3s ease;
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

        .btn-add {
            padding: 12px 25px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0, 119, 182, 0.2);
            border: none;
            cursor: pointer;
        }

        .btn-add:hover { background: var(--primary-hover); transform: translateY(-2px); }

        /* Table Design */
        .table-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 20px;
            border-bottom: 2px solid #f8fbff;
            color: var(--text-muted);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        td {
            padding: 20px;
            border-bottom: 1px solid #f8fbff;
            font-size: 14px;
            color: var(--text-main);
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-available { background: rgba(42, 157, 143, 0.1); color: var(--success); }
        .status-booked { background: rgba(0, 119, 182, 0.1); color: var(--primary); }
        .status-cleaning { background: rgba(244, 162, 97, 0.1); color: var(--warning); }
        .status-maintenance { background: rgba(230, 57, 70, 0.1); color: var(--danger); }

        .btn-status {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-available { background: var(--success); color: white; }
        .btn-available:hover { background: #21867a; }
        .btn-cleaning { background: var(--warning); color: white; }
        .btn-cleaning:hover { background: #e76f51; }

        .msg-container { margin-bottom: 25px; }
        .msg {
            padding: 15px 20px;
            border-radius: 12px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .success { background: #e6fffb; color: #1b635a; border: 1px solid #d1f7f1; }
        .error { background: #fff5f5; color: #c53030; border: 1px solid #fed7d7; }

        @media (max-width: 992px) {
            .sidebar { width: 80px; }
            .brand h1, .nav-link span { display: none; }
            .nav-link i { margin-right: 0; }
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand"><h1>OCEAN VIEW</h1></div>
    <ul class="nav-menu">
        <li><a href="dashboard" class="nav-link"><i class="fas fa-chart-line"></i> <span>Dashboard</span></a></li>
        <c:if test="${user.role eq 'admin'}">
            <li><a href="manage-rooms" class="nav-link active"><i class="fas fa-door-open"></i> <span>Manage Rooms</span></a></li>
            <li><a href="add-user" class="nav-link"><i class="fas fa-user-plus"></i> <span>Add User</span></a></li>
        </c:if>
        <li><a href="manage-reservations" class="nav-link"><i class="fas fa-calendar-check"></i> <span>Manage Bookings</span></a></li>
        <li><a href="room-availability" class="nav-link"><i class="fas fa-calendar-alt"></i> <span>Availability</span></a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="header-section">
        <div>
            <h2>Room Management</h2>
            <p style="color: var(--text-muted); font-size: 14px;">Inventory overview and room service control</p>
        </div>
        <a href="add-room" class="btn-add"><i class="fas fa-plus"></i> Add New Room</a>
    </div>

    <div class="msg-container">
        <c:if test="${not empty successMsg}">
            <div class="msg success">
                <i class="fas fa-check-circle"></i>
                <span>${successMsg}</span>
                <% session.removeAttribute("successMsg"); %>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="msg error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>
    </div>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Room ID</th>
                    <th>Room Type</th>
                    <th>Current Status</th>
                    <th style="text-align: right;">Management Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="room" items="${rooms}">
                    <tr>
                        <td><strong style="color: var(--primary);">#${room.roomId}</strong></td>
                        <td>${room.roomType}</td>
                        <td>
                            <span class="status-badge status-${room.status}">${room.status}</span>
                        </td>
                        <td style="text-align: right;">
                            <c:choose>
                                <c:when test="${room.status == 'cleaning'}">
                                    <form action="manage-rooms" method="post" style="display: inline;">
                                        <input type="hidden" name="roomId" value="${room.roomId}">
                                        <input type="hidden" name="status" value="available">
                                        <button type="submit" class="btn-status btn-available">
                                            <i class="fas fa-sparkles"></i> Mark Available
                                        </button>
                                    </form>
                                </c:when>
                                <c:when test="${room.status == 'available'}">
                                    <form action="manage-rooms" method="post" style="display: inline;">
                                        <input type="hidden" name="roomId" value="${room.roomId}">
                                        <input type="hidden" name="status" value="cleaning">
                                        <button type="submit" class="btn-status btn-cleaning">
                                            <i class="fas fa-broom"></i> Start Cleaning
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-size: 12px; color: #aaa; font-style: italic;">No actions available</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

</body>
</html>
