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

        .brand h1 {
            color: var(--primary);
            font-size: 22px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 40px;
        }

        .nav-menu {
            list-style: none;
            flex-grow: 1;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            text-decoration: none;
            color: var(--text-muted);
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 5px;
            transition: all 0.3s ease;
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(0, 119, 182, 0.1);
            color: var(--primary);
        }

        .nav-link.active {
            background: var(--primary);
            color: white;
        }

        .nav-link i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .main-content {
            flex-grow: 1;
            padding: 40px;
            background: #f8fbff;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .btn-add {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
        }

        .table-container {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #f0f0f0;
            color: var(--text-muted);
            font-size: 13px;
            text-transform: uppercase;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-available { background: rgba(42, 157, 143, 0.1); color: var(--success); }
        .status-booked { background: rgba(0, 119, 182, 0.1); color: var(--primary); }
        .status-cleaning { background: rgba(244, 162, 97, 0.1); color: var(--warning); }

        .btn-status {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            font-size: 12px;
            cursor: pointer;
            background: var(--primary);
            color: white;
        }

        .msg {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .success { background: rgba(42, 157, 143, 0.1); color: var(--success); }
        .error { background: rgba(230, 57, 70, 0.1); color: var(--danger); }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand"><h1>OCEAN VIEW</h1></div>
    <ul class="nav-menu">
        <li><a href="dashboard" class="nav-link"><i class="fas fa-chart-line"></i> Dashboard</a></li>
        <li><a href="manage-rooms" class="nav-link active"><i class="fas fa-door-open"></i> Manage Rooms</a></li>
        <li><a href="manage-reservations" class="nav-link"><i class="fas fa-calendar-check"></i> Manage Bookings</a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="header">
        <h2>Room Management</h2>
        <a href="add-room" class="btn-add"><i class="fas fa-plus"></i> Add New Room</a>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="msg success">${successMsg}</div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>
    <c:if test="${not empty error}">
        <div class="msg error">${error}</div>
    </c:if>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Room ID</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="room" items="${rooms}">
                    <tr>
                        <td><strong>#${room.roomId}</strong></td>
                        <td>${room.roomType}</td>
                        <td>
                            <span class="status-badge status-${room.status}">${room.status}</span>
                        </td>
                        <td>
                            <c:if test="${room.status == 'cleaning'}">
                                <form action="manage-rooms" method="post" style="display: inline;">
                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                    <input type="hidden" name="status" value="available">
                                    <button type="submit" class="btn-status">Mark Available</button>
                                </form>
                            </c:if>
                            <c:if test="${room.status == 'available'}">
                                <form action="manage-rooms" method="post" style="display: inline;">
                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                    <input type="hidden" name="status" value="cleaning">
                                    <button type="submit" class="btn-status" style="background: var(--warning);">Mark Cleaning</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

</body>
</html>
