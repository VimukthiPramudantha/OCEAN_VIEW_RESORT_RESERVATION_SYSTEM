<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Reservation - Ocean View Resort</title>
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
        .flash.success { background: rgba(42, 157, 143, 0.1); color: var(--success); border: 1px solid rgba(42, 157, 143, 0.2); }
        .flash.error { background: rgba(230, 57, 70, 0.1); color: var(--danger); border: 1px solid rgba(230, 57, 70, 0.2); }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }

        /* Table Styling */
        .table-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f4f8fb;
            color: var(--text-main);
            font-weight: 600;
            font-size: 14px;
            text-align: left;
            padding: 20px 25px;
            border-bottom: 2px solid #f0f0f0;
        }

        td {
            padding: 18px 25px;
            font-size: 14px;
            color: var(--text-muted);
            border-bottom: 1px solid #f9f9f9;
        }

        tr:hover td {
            background-color: #fcfdfe;
        }

        .res-number {
            font-weight: 600;
            color: var(--primary);
        }

        .guest-name {
            font-weight: 500;
            color: var(--text-main);
        }

        .btn-delete {
            background: rgba(230, 57, 70, 0.1);
            color: var(--danger);
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
        }

        .btn-delete i { margin-right: 6px; }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
            box-shadow: 0 4px 10px rgba(230, 57, 70, 0.2);
        }

        /* Modal Styling */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
            backdrop-filter: blur(4px);
            justify-content: center; align-items: center;
            z-index: 1000;
            animation: fadeIn 0.3s ease;
        }

        .modal-content {
            background: white;
            padding: 40px;
            border-radius: 20px;
            width: 90%; max-width: 450px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }

        .modal h2 {
            color: var(--danger);
            font-size: 20px;
            margin-bottom: 15px;
        }

        .modal p {
            color: var(--text-muted);
            font-size: 14px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .confirm-box {
            background: #fdf5f5;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px dashed var(--danger);
        }

        .modal input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 20px;
            transition: border-color 0.3s;
        }

        .modal input:focus {
            outline: none;
            border-color: var(--danger);
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
        }

        .modal-btn { 
            flex: 1;
            padding: 12px; 
            border: none; 
            border-radius: 10px; 
            cursor: pointer; 
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .modal-btn.confirm { 
            background: var(--danger); 
            color: white; 
        }

        .modal-btn.confirm:hover {
            background: #c0303c;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .modal-btn.cancel { 
            background: #f0f0f0; 
            color: var(--text-muted); 
        }

        .modal-btn.cancel:hover {
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
        <h2>Delete Reservation</h2>
        <p>Permanently remove confirmed reservations from the system</p>
    </div>

    <c:if test="${not empty requestScope.error}">
        <div class="flash error">
            <i class="fas fa-exclamation-circle"></i>
            ${requestScope.error}
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.successMsg}">
        <div class="flash success">
            <i class="fas fa-check-circle"></i>
            ${sessionScope.successMsg}
        </div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Reservation #</th>
                <th>Guest Name</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="res" items="${reservations}">
                <tr>
                    <td><span class="res-number">${res.reservationNumber}</span></td>
                    <td><span class="guest-name">${res.guestName}</span></td>
                    <td>${res.checkIn}</td>
                    <td>${res.checkOut}</td>
                    <td>
                        <button class="btn-delete"
                                onclick="showConfirmModal('${res.id}', '${res.guestName}')">
                            <i class="fas fa-trash-alt"></i> Delete
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reservations}">
                <tr><td colspan="5" style="text-align:center;padding:50px;color:var(--text-muted);">
                    <i class="fas fa-folder-open" style="font-size: 30px; display: block; margin-bottom: 10px; opacity: 0.3;"></i>
                    No reservations found to delete.
                </td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <i class="fas fa-exclamation-triangle" style="font-size: 40px; color: var(--danger); margin-bottom: 20px;"></i>
            <h2>Confirm Deletion</h2>
            <p>This action cannot be undone. To proceed, please type the guest name exactly as shown below:</p>
            
            <div class="confirm-box">
                <strong id="guestNameToMatch" style="color: var(--danger);"></strong>
            </div>

            <form id="deleteForm" action="delete-reservation" method="post">
                <input type="hidden" name="action" value="confirm_delete">
                <input type="hidden" name="reservationId" id="reservationId">
                <input type="text" name="confirmGuestName" id="confirmGuestName" placeholder="Type guest name here" required autocomplete="off">
                <div class="modal-buttons">
                    <button type="button" class="modal-btn cancel" onclick="closeModal()">Keep Stay</button>
                    <button type="submit" class="modal-btn confirm">Delete Permanently</button>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
    function showConfirmModal(resId, guestName) {
        document.getElementById('reservationId').value = resId;
        document.getElementById('guestNameToMatch').textContent = guestName;
        document.getElementById('confirmGuestName').value = '';
        document.getElementById('confirmModal').style.display = 'flex';
        setTimeout(() => document.getElementById('confirmGuestName').focus(), 100);
    }

    function closeModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('confirmModal');
        if (event.target === modal) {
            closeModal();
        }
    }
</script>

</body>
</html>