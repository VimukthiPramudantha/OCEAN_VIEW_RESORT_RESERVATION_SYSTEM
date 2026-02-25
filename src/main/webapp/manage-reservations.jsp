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
            --success: #2a9d8f;
            --warning: #f4a261;
            --danger: #e63946;
            --bg: #f8fbff;
            --card-bg: white;
            --text: #333;
            --muted: #666;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            padding: 40px;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
        }

        h1 {
            text-align: center;
            color: var(--primary);
            margin-bottom: 40px;
            font-size: 2.2rem;
        }

        .flash {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 8px;
            font-weight: 500;
            text-align: center;
        }
        .success { background: rgba(42,157,143,0.15); color: var(--success); border: 1px solid var(--success); }
        .error   { background: rgba(230,57,70,0.15); color: var(--danger);   border: 1px solid var(--danger);   }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            text-align: center;
        }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 30px rgba(0,119,182,0.15);
        }

        .icon {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--primary);
        }

        h3 {
            font-size: 1.4rem;
            margin-bottom: 12px;
            color: var(--text);
        }

        p {
            color: var(--muted);
            font-size: 0.95rem;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .btn {
            display: inline-block;
            background: var(--primary);
            color: white;
            padding: 12px 28px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn:hover {
            background: var(--primary-hover);
            transform: scale(1.05);
        }

        .btn.cancel { background: var(--danger); }
        .btn.cancel:hover { background: #c0392b; }
        .btn.delete { background: #7f8c8d; }
        .btn.delete:hover { background: #636e72; }
        .btn.history { background: var(--warning); }
        .btn.history:hover { background: #e67e22; }

        @media (max-width: 768px) {
            body { padding: 20px; }
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Manage Reservations</h1>

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

    <div class="grid">

        <!-- View Reservations -->
        <div class="card">
            <div class="icon"><i class="fas fa-list-ul"></i></div>
            <h3>View All Reservations</h3>
            <p>See the full list of current and upcoming bookings with filters and search.</p>
            <a href="view-reservations" class="btn">View Reservations</a>
        </div>

        <!-- Update Reservation -->
        <div class="card">
            <div class="icon"><i class="fas fa-edit"></i></div>
            <h3>Update Reservation</h3>
            <p>Modify dates, guest count, room assignment, special requests, or status.</p>
            <a href="update-reservation" class="btn">Update Booking</a>
        </div>

        <!-- Cancel Reservation -->
        <div class="card">
            <div class="icon"><i class="fas fa-ban"></i></div>
            <h3>Cancel Reservation</h3>
            <p>Cancel a booking, free up the room, and log cancellation details.</p>
            <a href="cancel-reservation" class="btn cancel">Cancel Booking</a>
        </div>

        <!-- Delete Reservation -->
        <div class="card">
            <div class="icon"><i class="fas fa-trash-alt"></i></div>
            <h3>Delete Reservation</h3>
            <p>Permanently remove a reservation record (admin only).</p>
            <a href="delete-reservation" class="btn delete">Delete Booking</a>
        </div>

        <!-- Reservation History -->
        <div class="card">
            <div class="icon"><i class="fas fa-history"></i></div>
            <h3>Reservation History</h3>
            <p>View past, completed, and cancelled bookings per guest (by NIC/Passport).</p>
            <a href="reservation-history" class="btn history">View History</a>
        </div>

    </div>

    <div style="text-align: center; margin-top: 40px;">
        <a href="dashboard" style="color: var(--primary); text-decoration: none;">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>