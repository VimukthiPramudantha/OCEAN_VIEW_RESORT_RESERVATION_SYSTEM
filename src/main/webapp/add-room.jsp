<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Room - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #333;
            --text-muted: #666;
            --error: #e63946;
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
        }

        .main-content {
            flex-grow: 1;
            padding: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            width: 100%;
            max-width: 500px;
        }

        .form-card h2 {
            margin-bottom: 30px;
            color: var(--primary);
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-main);
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-submit:hover {
            background: var(--primary-hover);
        }

        .error-msg {
            color: var(--error);
            font-size: 13px;
            margin-bottom: 20px;
            text-align: center;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--text-muted);
            text-decoration: none;
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand" style="text-align: center; margin-bottom: 40px;">
        <h1 style="color: var(--primary); font-size: 22px;">OCEAN VIEW</h1>
    </div>
    <ul style="list-style: none;">
        <li style="margin-bottom: 10px;"><a href="dashboard" style="text-decoration: none; color: var(--text-muted);"><i class="fas fa-chart-line"></i> Dashboard</a></li>
        <li><a href="manage-rooms" style="text-decoration: none; color: var(--text-muted);"><i class="fas fa-door-open"></i> Manage Rooms</a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="form-card">
        <h2>Add New Room</h2>
        
        <c:if test="${not empty error}">
            <p class="error-msg">${error}</p>
        </c:if>

        <form action="add-room" method="post">
            <div class="form-group">
                <label>Room Type</label>
                <select name="type">
                    <option value="Single">Single</option>
                    <option value="Double">Double</option>
                    <option value="Deluxe">Deluxe</option>
                    <option value="Suite">Suite</option>
                    <option value="Penthouse">Penthouse</option>
                </select>
            </div>
            <div class="form-group">
                <label>Rate Per Night (LKR)</label>
                <input type="number" name="rate" step="0.01" placeholder="e.g. 15000" required>
            </div>
            <button type="submit" class="btn-submit">Register Room</button>
        </form>
        
        <a href="manage-rooms" class="back-link">Cancel and Go Back</a>
    </div>
</main>

</body>
</html>
