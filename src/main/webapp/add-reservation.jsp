<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Reservation - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --glass-bg: rgba(255, 255, 255, 0.95);
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-gradient);
            background-attachment: fixed;
            padding: 40px 20px;
        }

        .container {
            background: var(--glass-bg);
            max-width: 800px;
            width: 100%;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            font-size: 28px;
            color: var(--primary);
            font-weight: 600;
        }

        .header p {
            font-size: 14px;
            color: var(--text-muted);
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
            font-weight: 400;
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

        .step-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--text-main);
            border-bottom: 2px solid #f0f4f8;
            padding-bottom: 10px;
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

        .form-group input, 
        .form-group select, 
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .form-group input:focus, 
        .form-group select:focus, 
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(0, 119, 182, 0.1);
        }

        .form-group textarea {
            height: 80px;
            resize: vertical;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .checkbox-group input {
            width: auto;
        }

        /* Navigation Buttons */
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-prev {
            background: #eee;
            color: var(--text-main);
            border: none;
        }

        .btn-prev:hover {
            background: #e0e0e0;
        }

        .btn-next, .btn-submit {
            background: var(--primary);
            color: white;
            border: none;
            flex-grow: 0.5;
        }

        .btn-next:hover, .btn-submit:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 119, 182, 0.2);
        }

        .error-msg {
            background: rgba(230, 57, 70, 0.1);
            color: var(--error);
            padding: 12px;
            border-radius: 10px;
            text-align: center;
            font-size: 14px;
            margin-bottom: 25px;
            border: 1px solid rgba(230, 57, 70, 0.2);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--text-muted);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: var(--primary);
        }

        @media (max-width: 600px) {
            .grid { grid-template-columns: 1fr; }
            .container { padding: 25px; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>New Reservation</h1>
        <p>Register a new guest and book their stay</p>
    </div>

    <!-- Progress Indicator -->
    <div class="progress-stepper">
        <div class="progress-step active" id="p1">1 <span class="step-label">Guest Details</span></div>
        <div class="progress-step" id="p2">2 <span class="step-label">Stay Details</span></div>
        <div class="progress-step" id="p3">3 <span class="step-label">Preferences</span></div>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-msg">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form id="reservationForm" action="add-reservation" method="post">
        
        <!-- Step 1: Guest Details -->
        <div id="step1" class="form-step active">
            <h2 class="step-title">Guest Information</h2>
            <div class="grid">
                <div class="form-group">
                    <label>NIC/Passport Number</label>
                    <input type="text" name="nicPassport" placeholder="ID or Passport" required>
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="As per ID" required>
                </div>
                <div class="form-group">
                    <label>Nationality / Country</label>
                    <input type="text" name="nationality" placeholder="e.g. Sri Lankan" required>
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="tel" name="contact" placeholder="+94 XXXXXXXXX" required>
                </div>
                <div class="form-group">
                    <label>Email Address (Optional)</label>
                    <input type="email" name="email" placeholder="example@mail.com">
                </div>
            </div>
            <div class="grid" style="margin-top: 10px;">
                <div class="form-group">
                    <label>Adults</label>
                    <input type="number" name="adults" min="1" value="1" required>
                </div>
                <div class="form-group">
                    <label>Children</label>
                    <input type="number" name="children" min="0" value="0" required>
                </div>
                <div class="form-group">
                    <label>Infants</label>
                    <input type="number" name="infants" min="0" value="0" required>
                </div>
            </div>
            <div class="btn-container">
                <div></div> <!-- Spacer -->
                <button type="button" class="btn btn-next" onclick="nextStep(2)">Next: Stay Details</button>
            </div>
        </div>

        <!-- Step 2: Stay Details -->
        <div id="step2" class="form-step">
            <h2 class="step-title">Stay & Room Details</h2>
            <div class="grid">
                <div class="form-group">
                    <label>Check-in Date</label>
                    <input type="date" name="checkIn" required>
                </div>
                <div class="form-group">
                    <label>Check-out Date</label>
                    <input type="date" name="checkOut" required>
                </div>
                <div class="form-group">
                    <label>Room Type</label>
                    <select name="roomType" required>
                        <option value="Standard">Standard</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Suite">Suite</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Vehicle Number</label>
                    <input type="text" name="vehicleNumber" placeholder="For parking allocation">
                </div>
            </div>
            <div class="form-group">
                <label>Special Requests / Remarks</label>
                <textarea name="specialRequests" placeholder="Any specific needs or notes..."></textarea>
            </div>
            <div class="btn-container">
                <button type="button" class="btn btn-prev" onclick="prevStep(1)">Previous</button>
                <button type="button" class="btn btn-next" onclick="nextStep(3)">Next: Preferences</button>
            </div>
        </div>

        <!-- Step 3: Preferences -->
        <div id="step3" class="form-step">
            <h2 class="step-title">Optional Preferences</h2>
            <div class="form-group">
                <label>Room Preference</label>
                <textarea name="roomPreference" placeholder="Floor, view (ocean/garden), smoking/non-smoking..."></textarea>
            </div>
            <div class="grid">
                <div class="form-group">
                    <label>Wake-up Call Time</label>
                    <input type="time" name="wakeUpCall">
                </div>
                <div class="form-group">
                    <label>Loyalty / Membership No.</label>
                    <input type="text" name="loyaltyNumber" placeholder="If applicable">
                </div>
            </div>
            <div class="checkbox-group">
                <input type="checkbox" id="luggage" name="luggageStorage">
                <label for="luggage" style="font-weight: 400; font-size: 14px;">Require luggage storage after checkout?</label>
            </div>
            <div class="btn-container">
                <button type="button" class="btn btn-prev" onclick="prevStep(2)">Previous</button>
                <button type="submit" class="btn btn-submit">Confirm & Save Reservation</button>
            </div>
        </div>
    </form>

    <a href="dashboard" class="back-link">Cancel and return to Dashboard</a>
</div>

<script>
    function nextStep(step) {
        // Hide current step
        document.querySelector('.form-step.active').classList.remove('active');
        // Show next step
        document.getElementById('step' + step).classList.add('active');
        
        // Update progress bar
        updateProgress(step);
    }

    function prevStep(step) {
        // Hide current step
        document.querySelector('.form-step.active').classList.remove('active');
        // Show prev step
        document.getElementById('step' + step).classList.add('active');
        
        // Update progress bar
        updateProgress(step);
    }

    function updateProgress(step) {
        // Reset all steps
        document.querySelectorAll('.progress-step').forEach(el => {
            el.classList.remove('active', 'completed');
        });

        // Set active and completed states
        for(let i=1; i<=3; i++) {
            const el = document.getElementById('p' + i);
            if(i < step) {
                el.classList.add('completed');
            } else if(i === step) {
                el.classList.add('active');
            }
        }
    }
</script>

</body>
</html>