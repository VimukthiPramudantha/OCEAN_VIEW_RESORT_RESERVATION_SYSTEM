<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Room - Ocean View Resort</title>
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
            --error: #e63946;
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

        .nav-link {
            display: flex; align-items: center; padding: 12px 15px; text-decoration: none;
            color: var(--text-muted); border-radius: 10px; font-size: 14px; margin-bottom: 5px; transition: all 0.3s ease;
        }
        .nav-link i { margin-right: 12px; width: 20px; text-align: center; }
        .nav-link:hover { background: rgba(0, 119, 182, 0.1); color: var(--primary); }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow: hidden;
            padding: 40px;
            background: #f8fbff;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-card {
            background: white;
            width: 100%;
            max-width: 550px;
            padding: 50px;
            border-radius: 25px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
        }

        .form-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 8px;
            background: var(--bg-gradient);
            border-radius: 25px 25px 0 0;
        }

        .form-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .form-header h2 {
            font-size: 28px;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .form-header p {
            color: var(--text-muted);
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-main);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: 0.3s;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 1px solid #eef2f7;
            background: #fcfdfe;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            color: var(--text-main);
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 5px 15px rgba(0,119,182,0.05);
        }

        .form-group input:focus + i { color: var(--primary); }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 6px 20px rgba(0,119,182,0.25);
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,119,182,0.3);
        }

        .error-container {
            background: rgba(230, 57, 70, 0.05);
            border-left: 4px solid var(--error);
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .error-msg {
            color: var(--error);
            font-size: 14px;
            font-weight: 500;
        }

        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 25px;
            font-size: 14px;
            color: var(--text-muted);
            text-decoration: none;
            transition: 0.3s;
        }

        .back-link:hover { color: var(--primary); }

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
    <ul style="list-style: none; flex-grow: 1;">
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
    <div class="form-card">
        <div class="form-header">
            <h2>Register New Room</h2>
            <p>Expand resort inventory with a new unit</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="error-container">
                <i class="fas fa-exclamation-circle" style="color: var(--error);"></i>
                <span class="error-msg">${error}</span>
            </div>
        </c:if>

        <form action="add-room" method="post">
            <div class="form-group">
                <label>Room Number / ID</label>
                <div class="input-wrapper">
                    <i class="fas fa-hashtag"></i>
                    <input type="number" name="roomNumber" placeholder="e.g. 101" required>
                </div>
            </div>
            
            <div class="form-group">
                <label>Accommodation Category</label>
                <div class="input-wrapper">
                    <i class="fas fa-bed"></i>
                    <select name="type">
                        <option value="Standard">Standard Room</option>
                        <option value="Deluxe">Deluxe Room</option>
                        <option value="Suite">Executive Suite</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label>Standard Rate (LKR)</label>
                <div class="input-wrapper">
                    <i class="fas fa-money-bill-wave"></i>
                    <input type="number" name="rate" step="0.01" placeholder="e.g. 15000.00" required>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">
                <i class="fas fa-plus-circle"></i> Complete Registration
            </button>
        </form>
        
        <a href="manage-rooms" class="back-link">
            <i class="fas fa-arrow-left"></i> Discard and Go Back
        </a>
    </div>
</main>

</body>
</html>
