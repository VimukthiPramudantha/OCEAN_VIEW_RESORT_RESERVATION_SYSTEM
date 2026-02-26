<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancel Reservations - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --danger: #e63946;
            --success: #2a9d8f;
            --bg: #f8fbff;
            --text: #333;
            --muted: #666;
        }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); padding: 40px; color: var(--text); }
        .container { max-width: 1200px; margin: auto; }
        h1 { text-align: center; color: var(--primary); margin-bottom: 30px; }
        .flash { padding: 15px; margin-bottom: 25px; border-radius: 8px; text-align: center; }
        .success { background: rgba(42,157,143,0.15); color: var(--success); border: 1px solid var(--success); }
        .error { background: rgba(230,57,70,0.15); color: var(--danger); border: 1px solid var(--danger); }

        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.08); border-radius: 12px; overflow: hidden; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: var(--primary); color: white; font-weight: 600; }
        tr:hover { background: rgba(0,119,182,0.05); }
        .btn-cancel { background: var(--danger); color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; }
        .btn-cancel:hover { background: #c0392b; }

        .modal {
            display: none;
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            justify-content: center; align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background: white; padding: 30px; border-radius: 12px;
            width: 90%; max-width: 500px; text-align: center;
        }
        .modal textarea {
            width: 100%; padding: 12px; margin: 15px 0;
            border: 1px solid #ccc; border-radius: 6px; font-size: 1rem; resize: vertical;
        }
        .modal-buttons { margin-top: 20px; }
        .modal-btn { padding: 10px 25px; border: none; border-radius: 6px; cursor: pointer; margin: 0 10px; }
        .modal-btn.confirm { background: var(--danger); color: white; }
        .modal-btn.cancel { background: #95a5a6; color: white; }
    </style>
</head>
<body>

<div class="container">
    <h1>Cancel Reservations</h1>

    <c:if test="${not empty requestScope.error}">
        <div class="flash error">${requestScope.error}</div>
    </c:if>
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="flash success">${sessionScope.successMsg}</div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>

    <table>
        <thead>
        <tr>
            <th>Res #</th>
            <th>Guest</th>
            <th>Room</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="res" items="${reservations}">
            <tr>
                <td>${res.reservationNumber}</td>
                <td>${res.guestName}</td>
                <td>${res.roomId}</td>
                <td>${res.checkIn}</td>
                <td>${res.checkOut}</td>
                <td>${res.status}</td>
                <td>
                    <c:if test="${res.status != 'cancelled' && res.status != 'checked_out'}">
                        <button class="btn-cancel" onclick="showCancelModal('${res.id}', '${res.guestName}')">
                            Cancel
                        </button>
                    </c:if>
                    <c:if test="${res.status == 'cancelled' || res.status == 'checked_out'}">
                        <span style="color: gray;">Cannot Cancel</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty reservations}">
            <tr><td colspan="7" style="text-align:center;padding:40px;">No active reservations to cancel.</td></tr>
        </c:if>
        </tbody>
    </table>

    <a href="dashboard" style="display:block; text-align:center; margin-top:30px; color:var(--primary);">
        Back to Dashboard
    </a>
</div>

<!-- Cancel Confirmation Modal -->
<div id="cancelModal" class="modal">
    <div class="modal-content">
        <h2>Cancel Reservation #<span id="modalResId"></span></h2>
        <p>Guest: <strong id="modalGuestName"></strong></p>
        <p>Are you sure? This will free the room and log the cancellation.</p>

        <form id="cancelForm" method="post" action="cancel-reservation">
            <input type="hidden" name="reservationId" id="modalReservationId">
            <div class="form-group">
                <label for="cancelReason">Cancellation Reason (required):</label>
                <textarea id="cancelReason" name="cancelReason" rows="4" required
                          placeholder="e.g. Guest cancelled, no-show, weather issue..."></textarea>
            </div>
            <div class="modal-buttons">
                <button type="button" class="modal-btn cancel" onclick="closeModal()">Cancel</button>
                <button type="submit" class="modal-btn confirm">Confirm Cancellation</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showCancelModal(resId, guestName) {
        document.getElementById('modalResId').textContent = resId;
        document.getElementById('modalGuestName').textContent = guestName;
        document.getElementById('modalReservationId').value = resId;
        document.getElementById('cancelReason').value = '';
        document.getElementById('cancelModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('cancelModal').style.display = 'none';
    }

    window.onclick = function(event) {
        const modal = document.getElementById('cancelModal');
        if (event.target === modal) closeModal();
    }
</script>

</body>
</html>