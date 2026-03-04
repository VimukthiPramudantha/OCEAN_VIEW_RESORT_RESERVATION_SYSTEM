<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Reservation - Ocean View Resort</title>
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

        .form-container {
            background: white;
            max-width: 900px;
            margin: 0 auto;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 24px;
            color: var(--primary);
            font-weight: 600;
        }

        /* Progress Bar */
        .progress-stepper {
            display: flex;
            justify-content: space-between;
            margin-bottom: 40px;
            position: relative;
        }

        .progress-stepper::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            height: 2px;
            width: 100%;
            background: #eee;
            z-index: 1;
        }

        .progress-step {
            width: 40px;
            height: 40px;
            background: white;
            border: 2px solid #eee;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
            font-weight: 600;
            color: var(--text-muted);
            transition: all 0.3s ease;
            position: relative;
        }

        .progress-step.active {
            border-color: var(--primary);
            background: var(--primary);
            color: white;
            box-shadow: 0 0 15px rgba(0, 119, 182, 0.3);
        }

        .progress-step.completed {
            background: var(--success);
            border-color: var(--success);
            color: white;
        }

        .step-label {
            position: absolute;
            top: 50px;
            font-size: 11px;
            white-space: nowrap;
            color: var(--text-muted);
        }

        /* Form Steps */
        .form-step {
            display: none;
            animation: slideIn 0.4s ease-out;
        }

        .form-step.active {
            display: block;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(10px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-main);
        }

        .required-star {
            color: var(--error);
            margin-left: 3px;
        }

        .step-error {
            color: var(--error);
            font-size: 13px;
            margin-bottom: 15px;
            display: none;
            text-align: center;
            font-weight: 500;
        }

        .form-group input.invalid, 
        .form-group select.invalid, 
        .form-group textarea.invalid {
            border-color: var(--error);
        }

        .form-group input, 
        .form-group select, 
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 40px;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-prev { background: #eee; border: none; }
        .btn-next, .btn-submit { background: var(--primary); color: white; border: none; flex-grow: 0.5; }

        .error-msg {
            background: rgba(230, 57, 70, 0.1);
            color: var(--error);
            padding: 12px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 25px;
        }

        @media (max-width: 992px) {
            .sidebar { width: 80px; }
            .brand, .user-profile, .nav-link span { display: none; }
            .nav-link i { margin-right: 0; }
        }

        @media (max-width: 600px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; }
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
            <a href="manage-reservations" class="nav-link">
                <i class="fas fa-calendar-check"></i> <span>Manage Bookings</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="add-reservation" class="nav-link active">
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
    <div class="form-container">
        <div class="header">
            <h1>New Reservation</h1>
            <p>Register a guest and manage their booking stay</p>
        </div>

        <div class="progress-stepper">
            <div class="progress-step active" id="p1">1 <span class="step-label">Guest Info</span></div>
            <div class="progress-step" id="p2">2 <span class="step-label">Stay Info</span></div>
            <div class="progress-step" id="p3">3 <span class="step-label">Preferences</span></div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="error-msg">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form id="reservationForm" action="add-reservation" method="post">
            
            <!-- Step 1 -->
        <div id="step1" class="form-step active">
            <div id="error1" class="step-error">Please fill in all required fields marked with * before proceeding.</div>
            <div class="grid">
                <div class="form-group">
                    <label>NIC/Passport Number<span class="required-star">*</span></label>
                    <input type="text" name="nicPassport" required>
                </div>
                <div class="form-group">
                    <label>Full Name<span class="required-star">*</span></label>
                    <input type="text" name="fullName" required>
                </div>
                <div class="form-group">
                    <label>Nationality<span class="required-star">*</span></label>
                    <input type="text" name="nationality" required>
                </div>
                <div class="form-group">
                    <label>Contact Number<span class="required-star">*</span></label>
                    <input type="tel" name="contact" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email">
                </div>
            </div>
            <div class="grid" style="margin-top: 10px;">
                <div class="form-group">
                    <label>Adults<span class="required-star">*</span></label>
                    <input type="number" name="adults" min="1" value="1" required>
                </div>
                <div class="form-group">
                    <label>Children<span class="required-star">*</span></label>
                    <input type="number" name="children" min="0" value="0" required>
                </div>
            </div>
            <div class="btn-container">
                <div></div>
                <button type="button" class="btn btn-next" onclick="nextStep(2)">Next: Stay Details</button>
            </div>
        </div>

        <!-- Step 2 -->
        <div id="step2" class="form-step">
            <div id="error2" class="step-error">Please fill in all required fields marked with * before proceeding.</div>
            <div class="grid">
                <div class="form-group">
                    <label>Check-in Date<span class="required-star">*</span></label>
                    <input type="date" name="checkIn" required>
                </div>
                <div class="form-group">
                    <label>Check-out Date<span class="required-star">*</span></label>
                    <input type="date" name="checkOut" required>
                </div>
                <div class="form-group">
                    <label>Room Type<span class="required-star">*</span></label>
                    <select name="roomType" required>
                        <option value="Standard">Standard</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Suite">Suite</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Vehicle Number</label>
                    <input type="text" name="vehicleNumber">
                </div>
            </div>
                <div class="form-group">
                    <label>Special Requests</label>
                    <textarea name="specialRequests"></textarea>
                </div>
                <div class="btn-container">
                    <button type="button" class="btn btn-prev" onclick="prevStep(1)">Previous</button>
                    <button type="button" class="btn btn-next" onclick="nextStep(3)">Next: Preferences</button>
                </div>
            </div>

            <!-- Step 3 -->
            <div id="step3" class="form-step">
                <div class="form-group">
                    <label>Room Preference</label>
                    <textarea name="roomPreference"></textarea>
                </div>
                <div class="grid">
                    <div class="form-group">
                        <label>Wake-up Call Time</label>
                        <input type="time" name="wakeUpCall">
                    </div>
                    <div class="form-group">
                        <label>Loyalty Number</label>
                        <input type="text" name="loyaltyNumber">
                    </div>
                    <div class="checkbox-group">
                <input type="checkbox" id="luggage" name="luggageStorage">
                <label for="luggage" style="font-weight: 400; font-size: 14px;">Require luggage storage after checkout?</label>
            </div>
                </div>
                <div class="btn-container">
                    <button type="button" class="btn btn-prev" onclick="prevStep(2)">Previous</button>
                    <button type="submit" class="btn btn-submit">Confirm Reservation</button>
                </div>
            </div>
        </form>
    </div>
</main>

<script>
    function validateStep(stepId) {
        const step = document.getElementById(stepId);
        const requiredFields = step.querySelectorAll('[required]');
        let isValid = true;
        
        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('invalid');
            } else {
                field.classList.remove('invalid');
            }
        });
        
        const errorDiv = step.querySelector('.step-error');
        if (!isValid) {
            errorDiv.style.display = 'block';
        } else {
            errorDiv.style.display = 'none';
        }
        
        return isValid;
    }

    function nextStep(step) {
        const currentStepId = document.querySelector('.form-step.active').id;
        
        if (validateStep(currentStepId)) {
            document.querySelector('.form-step.active').classList.remove('active');
            document.getElementById('step' + step).classList.add('active');
            updateProgress(step);
            window.scrollTo(0, 0);
        }
    }

    function prevStep(step) {
        document.querySelector('.form-step.active').classList.remove('active');
        document.getElementById('step' + step).classList.add('active');
        updateProgress(step);
        window.scrollTo(0, 0);
    }

    function updateProgress(step) {
        document.querySelectorAll('.progress-step').forEach(el => el.classList.remove('active', 'completed'));
        for(let i=1; i<=3; i++) {
            const el = document.getElementById('p' + i);
            if(i < step) el.classList.add('completed');
            else if(i === step) el.classList.add('active');
        }
    }

    // Live validation feedback
    document.querySelectorAll('input, select, textarea').forEach(input => {
        input.addEventListener('input', function() {
            if (this.value.trim()) {
                this.classList.remove('invalid');
            }
        });
    });
</script>

</body>
</html>