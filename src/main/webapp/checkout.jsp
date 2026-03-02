<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Checkout - Ocean View Resort</title>
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
            --accent: #00b4db;
            --glass-bg: rgba(255, 255, 255, 0.8);
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
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Checkout Card */
        .checkout-card {
            background: white;
            width: 100%;
            max-width: 800px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
        }

        .checkout-header {
            margin-bottom: 30px;
            border-bottom: 2px solid #f9f9f9;
            padding-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .checkout-header h2 {
            font-size: 24px;
            color: var(--primary);
        }

        .checkout-header p {
            color: var(--text-muted);
            font-size: 14px;
        }

        .bill-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .detail-item {
            font-size: 14px;
        }

        .detail-item label {
            display: block;
            color: var(--text-muted);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .detail-item span {
            font-weight: 600;
            color: var(--text-main);
        }

        /* Bill Table */
        .bill-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .bill-table th {
            text-align: left;
            padding: 15px;
            font-size: 12px;
            text-transform: uppercase;
            color: var(--text-muted);
            border-bottom: 2px solid #f9f9f9;
        }

        .bill-table td {
            padding: 15px;
            font-size: 14px;
            border-bottom: 1px solid #f9f9f9;
        }

        .bill-table .total-row {
            background: #fcfdfe;
            font-weight: 700;
            font-size: 18px;
            color: var(--primary);
        }

        /* Error message */
        .error-msg {
            background: rgba(230, 57, 70, 0.1);
            color: var(--danger);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Buttons */
        .action-btns {
            display: flex;
            gap: 20px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            border: none;
        }

        .btn-confirm {
            background: var(--success);
            color: white;
            box-shadow: 0 4px 15px rgba(42, 157, 143, 0.3);
        }

        .btn-confirm:hover {
            background: #21867a;
            transform: translateY(-2px);
        }

        .btn-back {
            background: #f0f0f0;
            color: var(--text-muted);
        }

        .btn-back:hover {
            background: #e5e5e5;
        }

        @media (max-width: 992px) {
            .sidebar { width: 80px; }
            .brand, .user-profile, .nav-link span { display: none; }
            .nav-link i { margin-right: 0; }
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
            <a href="reservation-search" class="nav-link active">
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
    <div class="checkout-card">
        <div class="checkout-header">
            <div>
                <h2>Checkout Preview</h2>
                <p>Finalize guest departure and verify bill details</p>
            </div>
            <div style="text-align: right;">
                <span style="font-size: 11px; color: var(--text-muted);">REF#</span>
                <div style="font-weight: 600; color: var(--text-main);">${reservation.reservationNumber}</div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-msg">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <div class="bill-details">
            <div class="detail-item">
                <label>Guest Name</label>
                <span>${reservation.guestName}</span>
            </div>
            <div class="detail-item">
                <label>Room Number</label>
                <span>${reservation.roomId}</span>
            </div>
            <div class="detail-item">
                <label>Check-in Date</label>
                <span>${reservation.checkIn}</span>
            </div>
            <div class="detail-item">
                <label>Check-out Date</label>
                <span>${reservation.checkOut}</span>
            </div>
        </div>

        <form method="post" action="checkout">
            <input type="hidden" name="reservationId" value="${reservation.id}">
            <input type="hidden" id="finalTotalInput" name="totalAmount" value="${totalBill}">
            
            <table class="bill-table">
                <thead>
                    <tr>
                        <th>Description</th>
                        <th>Rate/Duration</th>
                        <th style="text-align: right;">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Ocean View Resort Accommodation</td>
                        <td>LKR ${reservation.ratePerNight} x ${nights} Nights</td>
                        <td style="text-align: right;">LKR ${totalBill}</td>
                    </tr>
                    <tr>
                        <td>Service Charge</td>
                        <td><input type="number" id="serviceCharge" name="serviceCharge" step="0.01" value="0.00" oninput="calculateTotal()" style="padding: 5px; border-radius: 4px; border: 1px solid #ddd; width: 100px;"></td>
                        <td style="text-align: right;">-</td>
                    </tr>
                    <tr>
                        <td>Tax Information</td>
                        <td><input type="number" id="tax" name="tax" step="0.01" value="0.00" oninput="calculateTotal()" style="padding: 5px; border-radius: 4px; border: 1px solid #ddd; width: 100px;"></td>
                        <td style="text-align: right;">-</td>
                    </tr>
                    <tr>
                        <td>Additional Charges</td>
                        <td><input type="number" id="additionalCharges" name="additionalCharges" step="0.01" value="0.00" oninput="calculateTotal()" style="padding: 5px; border-radius: 4px; border: 1px solid #ddd; width: 100px;"></td>
                        <td style="text-align: right;">-</td>
                    </tr>
                    <tr class="total-row">
                        <td colspan="2" style="text-align: right;">Grand Total (LKR):</td>
                        <td style="text-align: right;" id="grandTotalDisplay">LKR ${totalBill}</td>
                    </tr>
                </tbody>
            </table>

            <div class="action-btns">
                <a href="reservation-search" class="btn btn-back">Return to Search</a>
                <button type="submit" class="btn btn-confirm">
                    <i class="fas fa-check-circle"></i> Complete Checkout
                </button>
            </div>
        </form>
    </div>
</main>

<script>
    function calculateTotal() {
        const baseTotal = parseFloat('${totalBill}');
        const serviceCharge = parseFloat(document.getElementById('serviceCharge').value) || 0;
        const tax = parseFloat(document.getElementById('tax').value) || 0;
        const additional = parseFloat(document.getElementById('additionalCharges').value) || 0;
        
        const grandTotal = baseTotal + serviceCharge + tax + additional;
        
        document.getElementById('grandTotalDisplay').innerText = 'LKR ' + grandTotal.toFixed(2);
        document.getElementById('finalTotalInput').value = grandTotal;
    }
</script>

</body>
</html>