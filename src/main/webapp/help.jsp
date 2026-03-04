<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Guidelines - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --glass-bg: rgba(255, 255, 255, 0.75);
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #333;
            --text-muted: #666;
            --accent: #caf0f8;
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

        /* Sidebar Styling */
        .sidebar {
            min-width: 280px !important;
            background: var(--sidebar-bg);
            height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 30px 20px;
            box-shadow: 2px 0 15px rgba(0,0,0,0.05);
            z-index: 100;
        }

        .brand { text-align: center; margin-bottom: 40px; }
        .brand h1 { color: var(--primary); font-size: 22px; font-weight: 700; letter-spacing: 1px; }

        .user-profile {
            background: rgba(0, 119, 182, 0.05);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 30px;
        }
        .user-name { display: block; font-weight: 600; font-size: 14px; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }

        .nav-menu { list-style: none; flex-grow: 1; }
        .nav-item { margin-bottom: 5px; }
        .nav-link {
            display: flex; align-items: center; padding: 12px 15px; text-decoration: none;
            color: var(--text-muted); border-radius: 10px; font-size: 14px; transition: all 0.3s ease;
        }
        .nav-link i { margin-right: 12px; width: 20px; text-align: center; }
        .nav-link:hover { background: rgba(0, 119, 182, 0.1); color: var(--primary); }
        .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(0, 119, 182, 0.3); }

        .logout-link { margin-top: auto; color: var(--danger); }
        .logout-link:hover { background: rgba(230, 57, 70, 0.1); }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow-y: auto;
            padding: 40px;
            background: #f8fbff;
            scroll-behavior: smooth;
        }

        .help-header { 
            margin-bottom: 40px; 
            background: var(--bg-gradient);
            padding: 40px;
            border-radius: 20px;
            color: white;
            box-shadow: 0 10px 30px rgba(0, 180, 219, 0.2);
        }
        .help-header h2 { font-size: 32px; font-weight: 700; margin-bottom: 10px; }
        .help-header p { opacity: 0.9; font-size: 16px; }

        .guide-section {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            border-radius: 24px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .guide-section:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.08);
        }

        .guide-section h3 {
            font-size: 24px;
            color: var(--text-main);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 700;
        }

        .guide-section h3 i {
            background: var(--primary);
            color: white;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            font-size: 20px;
            box-shadow: 0 4px 10px rgba(0, 119, 182, 0.3);
        }

        /* Flow Indicators */
        .flow-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 30px 0;
            padding: 20px;
            background: rgba(255,255,255,0.5);
            border-radius: 15px;
            position: relative;
        }
        .flow-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 25%;
            position: relative;
            z-index: 2;
        }
        .step-icon {
            width: 50px;
            height: 50px;
            background: white;
            border: 3px solid var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }
        .flow-step:hover .step-icon {
            background: var(--primary);
            color: white;
            transform: scale(1.1);
        }
        .step-text { font-size: 13px; font-weight: 600; color: var(--text-main); }
        .flow-line {
            position: absolute;
            top: 45px;
            left: 10%;
            right: 10%;
            height: 2px;
            background: #ddd;
            z-index: 1;
        }

        /* Matrix Table */
        .matrix-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 15px;
            overflow: hidden;
            border: 1px solid #eee;
        }
        .matrix-table th {
            background: #f8fbff;
            padding: 15px;
            text-align: left;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-main);
            border-bottom: 1px solid #eee;
        }
        .matrix-table td {
            padding: 15px;
            font-size: 14px;
            color: var(--text-muted);
            border-bottom: 1px solid #eee;
        }
        .matrix-table tr:last-child td { border-bottom: none; }
        .check { color: var(--success); font-weight: 700; }
        .cross { color: var(--danger); font-weight: 700; }

        .instruction-item {
            padding: 20px;
            margin-bottom: 15px;
            border: .5px solid #e7e7e7;
            background: rgba(255,255,255,0.5);
            border-radius: 15px;
            border-left: 4px solid var(--primary);
        }
        .instruction-item strong { display: block; margin-bottom: 8px; font-size: 16px; color: var(--text-main); }
        .instruction-item p { font-size: 14px; color: var(--text-muted); line-height: 1.6; }

        .role-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 12px;
        }
        .badge-admin { background: #fee2e2; color: #991b1b; }
        .badge-staff { background: #dcfce7; color: #166534; }

        /* FAQ Style Support */
        .faq-item {
            margin-bottom: 15px;
            border: 1px solid #b1abab;
            border-radius: 12px;
            padding: 15px;
            background: white;
        }
        .faq-q { font-weight: 600; color: var(--primary); margin-bottom: 10px; display: flex; align-items: center; gap: 10px; }
        .faq-a { font-size: 13px; color: var(--text-muted); border-top: 1px solid #f9f9f9; padding-top: 10px; }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; }
            .flow-container { flex-wrap: wrap; }
            .flow-step { width: 50%; margin-bottom: 20px; }
            .flow-line { display: none; }
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
        <li class="nav-item"><a href="dashboard" class="nav-link"><i class="fas fa-chart-line"></i> <span>Dashboard</span></a></li>
        <li class="nav-item"><a href="manage-reservations" class="nav-link"><i class="fas fa-calendar-check"></i> <span>Manage Bookings</span></a></li>
        <li class="nav-item"><a href="add-reservation" class="nav-link"><i class="fas fa-plus-circle"></i> <span>New Reservation</span></a></li>
        <li class="nav-item"><a href="room-availability" class="nav-link"><i class="fas fa-calendar-alt"></i> <span>Room Calendar</span></a></li>
        <li class="nav-item"><a href="reservation-search" class="nav-link"><i class="fas fa-search-location"></i> <span>Search & Checkout</span></a></li>
        <c:if test="${user.role eq 'admin'}">
            <li class="nav-item"><a href="manage-rooms" class="nav-link"><i class="fas fa-door-open"></i> <span>Room Management</span></a></li>
            <li class="nav-item"><a href="add-user" class="nav-link"><i class="fas fa-user-plus"></i> <span>Add User</span></a></li>
        </c:if>
        <li class="nav-item"><a href="help" class="nav-link active"><i class="fas fa-question-circle"></i> <span>Portal Help</span></a></li>
    </ul>
    <a href="logout" class="nav-link logout-link"><i class="fas fa-sign-out-alt"></i> <span>Logout Session</span></a>
</aside>

<main class="main-content">
    <div class="help-header">
        <h2>Operations Center</h2>
        <p>Your comprehensive resource for executing resort operations with precision.</p>
    </div>

    <!-- Operating Matrix -->
    <section class="guide-section">
        <h3><i class="fas fa-shield-halved"></i> Role Permissions Matrix</h3>
        <p style="font-size: 14px; color: var(--text-muted); margin-bottom: 20px;">Understand the boundaries of system responsibility based on your security clearance.</p>
        <table class="matrix-table">
            <thead>
                <tr>
                    <th>System Capability</th>
                    <th style="text-align: center;">Staff Role</th>
                    <th style="text-align: center;">Admin Role</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Check-in & Checkout Processing</td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                </tr>
                <tr>
                    <td>Inventory Status Management</td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                </tr>
                <tr>
                    <td>Reservation Modifications</td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                </tr>
                <tr>
                    <td>Purge Records (Hard Delete)</td>
                    <td style="text-align: center;" class="cross"><i class="fas fa-times"></i></td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                </tr>
                <tr>
                    <td>Account & User Creation</td>
                    <td style="text-align: center;" class="cross"><i class="fas fa-times"></i></td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                </tr>
                <tr>
                    <td>Add New Room Inventory</td>
                    <td style="text-align: center;" class="cross"><i class="fas fa-times"></i></td>
                    <td style="text-align: center;" class="check"><i class="fas fa-check"></i></td>
                </tr>
            </tbody>
        </table>
    </section>

    <!-- Dashboard section -->
    <section class="guide-section">
        <h3><i class="fas fa-tachometer-alt"></i> Dashboard & Analytics</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>Real-time Occupancy Metrics</strong>
                <p>The dashboard displays the current percentage of occupied rooms. This is calculated live: (Count of 'Checked In' Reservations / Total Available Rooms) * 100. This data refreshes every time the dashboard is loaded to ensure frontline staff have the most accurate availability data.</p>
            </li>
            <li class="instruction-item">
                <strong>Revenue Performance Indicators</strong>
                <p>Calculates today's expected revenue based on scheduled checkouts and total billing processed within the current 24-hour cycle (starting 12:00 AM). Note: This includes room rates, service charges, and taxes for all finalized transactions today.</p>
            </li>
        </ul>
    </section>

    <!-- Reservation section -->
    <section class="guide-section">
        <h3><i class="fas fa-calendar-alt"></i> Reservation Lifecycle</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>New Booking Requirements</strong>
                <p>When creating a booking, ensure the 'Guest NIC / Passport' field is filled accurately. This is the primary key used to link returning guests to their historical data. The system enforces a check for existing active reservations for the same NIC to prevent duplicate bookings.</p>
            </li>
            <li class="instruction-item">
                <strong>Formal Check-In Protocol</strong>
                <p>A guest must be marked as 'Checked In' to appear in the analytics. This action automatically locks the assigned room in the 'Room Calendar', preventing any overlapping bookings or room changes during the stay period.</p>
            </li>
            <li class="instruction-item">
                <strong>Finalized Check-Out & Billing</strong>
                <p>Navigate to 'Search & Checkout' to retrieve the guest's record. You must verify the number of nights calculated by the system. If there are additional consumption charges (minibar, laundry), enter them manually in the 'Additional Charges' field before clicking 'Add to Bill'. Once 'Finish Checkout' is clicked, the invoice is generated and the room status is set to 'Cleaning'.</p>
            </li>
            <li class="instruction-item">
                <strong>No-Show & Modification Policy</strong>
                <p>For guests who fail to arrive by the scheduled check-in time, reservations should be marked as 'Cancelled' by an administrator to release the room inventory back into the available pool for walk-in guests.</p>
            </li>
        </ul>
    </section>

    <!-- Room Management -->
    <section class="guide-section">
        <h3><i class="fas fa-door-open"></i> Inventory & Housekeeping</h3>
        <ul class="instruction-list">
            <li class="instruction-item">
                <strong>Room Status Definitions</strong>
                <p><strong>Available:</strong> Ready for immediate check-in.<br>
                <strong>Occupied:</strong> Guest is currently in-house.<br>
                <strong>Cleaning:</strong> Set automatically after checkout; denotes room is being serviced.<br>
                <strong>Maintenance:</strong> Set manually for repairs; room is completely removed from booking availability.</p>
            </li>
            <li class="instruction-item">
                <strong>Housekeeping Cycle</strong>
                <p>Standard room cleaning takes approximately 30-45 minutes. Once housekeeping confirms a room is ready, staff must manually update the status from 'Cleaning' to 'Available' in the 'Room Management' module or the 'Room Calendar'.</p>
            </li>
            <c:if test="${user.role eq 'admin'}">
                <li class="instruction-item">
                    <span class="role-badge badge-admin">Admin Only</span>
                    <strong>Inventory Management</strong>
                    <p>When adding new rooms, ensure the room number matches the physical floor numbering. Each room must be assigned a fixed 'Room Type' (Standard, Deluxe, or Suite) which determines its base nightly rate in the billing engine.</p>
                </li>
            </c:if>
        </ul>
    </section>

    <!-- Guest Lifecycle -->
    <section class="guide-section">
        <h3><i class="fas fa-sync"></i> Guest Journey Workflow</h3>
        <div class="flow-container">
            <div class="flow-line"></div>
            <div class="flow-step">
                <div class="step-icon">1</div>
                <span class="step-text">Booking</span>
            </div>
            <div class="flow-step">
                <div class="step-icon">2</div>
                <span class="step-text">Check-In</span>
            </div>
            <div class="flow-step">
                <div class="step-icon">3</div>
                <span class="step-text">Stay</span>
            </div>
            <div class="flow-step">
                <div class="step-icon">4</div>
                <span class="step-text">Check-Out</span>
            </div>
        </div>
        
        <div class="instruction-list">
            <div class="instruction-item">
                <strong>Phase 1: Secure Booking</strong>
                <p>Verify availability in the Room Calendar before confirming a reservation. Collect accurate NIC/Passport data to maintain guest history integrity.</p>
            </div>
            <div class="instruction-item">
                <strong>Phase 2: Formal Check-In</strong>
                <p>Updating reservation status to 'Checked In' triggers the automated inventory lock, preventing double-bookings.</p>
            </div>
            <div class="instruction-item">
                <strong>Phase 3: The Departure Flow</strong>
                <p>In 'Search & Checkout', audit all charges. Adding 'Service Charge' or 'Tax' updates the final invoice dynamically before success processing.</p>
            </div>
        </div>
    </section>

    <!-- Advanced Troubleshooting -->
    <section class="guide-section">
        <h3><i class="fas fa-tools"></i> Advanced Troubleshooting</h3>
        <div class="faq-item">
            <div class="faq-q"><i class="fas fa-search-minus"></i> Guest cannot be found in Search?</div>
            <div class="faq-a">Verify the search parameters match the NIC/Passport exactly. If the guest is marked as 'Checked Out', they will move to the Guest History hub rather than the active Search module.</div>
        </div>
        <div class="faq-item">
            <div class="faq-q"><i class="fas fa-calendar-times"></i> Room appears unavailable erroneously?</div>
            <div class="faq-a">Check Room Management. If a room status is 'Cleaning', it will not show as available for new bookings even if physically empty. Manually reset status to 'Available' once housekeeping confirms completion.</div>
        </div>
        <div class="faq-item">
            <div class="faq-q"><i class="fas fa-calculator"></i> Invoice totals don't match?</div>
            <div class="faq-a">Total amounts in checkout are generated columns. Any manual additions like service charges are calculated on-the-fly. Ensure all input fields are properly filled before clicking 'Finish Checkout'.</div>
        </div>
    </section>

    <!-- Admin Control Center -->
    <c:if test="${user.role eq 'admin'}">
        <section class="guide-section" style="border-left: 6px solid var(--danger);">
            <div class="role-badge badge-admin">Master Administrator Oversight</div>
            <h3><i class="fas fa-user-shield"></i> Security & Integrity</h3>
            <div class="instruction-list">
                <div class="instruction-item">
                    <strong>Critical Record Purging</strong>
                    <p>Deleting a reservation is permanent. Only use this for test data or erroneous entries that cannot be neutralized via 'Cancellation'.</p>
                </div>
                <div class="instruction-item">
                    <strong>New Inventory Entry</strong>
                    <p>When adding rooms, ensure the Room Number is unique. Duplicate room numbers will cause logic failures in the availability engine.</p>
                </div>
                <div class="instruction-item">
                    <strong>Audit Logs</strong>
                    <p>Maintain oversight of Staff activity by reviewing the Global History periodically to ensure operational compliance.</p>
                </div>
            </div>
        </section>
    </c:if>

</main>

</body>
</html>
