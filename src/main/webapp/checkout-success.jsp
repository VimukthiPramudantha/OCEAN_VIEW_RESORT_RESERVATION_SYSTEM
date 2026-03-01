<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Successful - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- PDF Generation Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --success: #2a9d8f;
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --text-main: #333;
            --text-muted: #666;
            --accent: #00b4db;
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

        .brand h1 { color: var(--primary); font-size: 22px; text-align: center; margin-bottom: 40px; }

        .main-content {
            flex-grow: 1;
            height: 100vh;
            overflow-y: auto;
            padding: 40px;
            background: #f8fbff;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .success-banner {
            text-align: center;
            margin-bottom: 30px;
            animation: fadeIn 0.8s ease-out;
        }

        .success-banner i {
            font-size: 60px;
            color: var(--success);
            margin-bottom: 15px;
        }

        .success-banner h2 { color: var(--primary); margin-bottom: 5px; }
        .success-banner p { color: var(--text-muted); font-size: 14px; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

        /* Invoice Container */
        .invoice-box {
            background: white;
            width: 100%;
            max-width: 700px;
            padding: 50px;
            border-radius: 5px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.05);
            border: 1px solid #eee;
            position: relative;
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 50px;
            border-bottom: 2px solid var(--primary);
            padding-bottom: 20px;
        }

        .hotel-info h3 { color: var(--primary); margin-bottom: 5px; }
        .hotel-info p { font-size: 11px; color: var(--text-muted); line-height: 1.4; }

        .invoice-meta { text-align: right; }
        .invoice-meta h4 { color: #999; font-size: 20px; text-transform: uppercase; letter-spacing: 2px; }
        .invoice-meta p { font-size: 13px; font-weight: 600; margin-top: 5px; }

        .bill-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }

        .bill-to h5, .stay-info h5 {
            font-size: 11px;
            text-transform: uppercase;
            color: #aaa;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .bill-to p, .stay-info p { font-size: 14px; color: var(--text-main); font-weight: 500; margin-bottom: 3px; }

        .invoice-table { width: 100%; border-collapse: collapse; margin-bottom: 40px; }
        .invoice-table th { text-align: left; padding: 12px; font-size: 12px; border-bottom: 1px solid #eee; color: #aaa; }
        .invoice-table td { padding: 15px 12px; font-size: 14px; border-bottom: 1px solid #f9f9f9; }

        .total-section {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            padding-top: 20px;
        }

        .total-section .line { display: flex; justify-content: space-between; width: 250px; padding: 5px 0; }
        .total-section .line span { font-size: 14px; color: var(--text-muted); }
        .total-section .line .val { font-weight: 600; color: var(--text-main); }
        .total-section .grand-total { 
            margin-top: 15px;
            background: var(--primary);
            color: white;
            padding: 15px;
            width: 250px;
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 18px;
        }

        .invoice-footer { margin-top: 50px; text-align: center; border-top: 1px dashed #eee; padding-top: 20px; }
        .invoice-footer p { font-size: 12px; color: #aaa; font-style: italic; }

        /* Print Controls */
        .controls {
            margin-top: 40px;
            display: flex;
            gap: 20px;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 50px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            border: none;
        }

        .btn-download { background: var(--primary); color: white; box-shadow: 0 4px 15px rgba(0, 119, 182, 0.3); }
        .btn-download:hover { background: var(--primary-hover); transform: translateY(-2px); }
        .btn-dash { background: #f0f0f0; color: var(--text-muted); }
        .btn-dash:hover { background: #e5e5e5; }

        @media screen {
            #invoice-print-area { margin: 0 auto; }
        }

        @media print {
            .sidebar, .success-banner, .controls { display: none !important; }
            body { background: white; }
            .main-content { padding: 0; }
            .invoice-box { box-shadow: none; border: none; width: 100%; max-width: 100%; }
        }
    </style>
</head>
<body>

<main class="main-content" style="width: 100%; height: 100vh; overflow-y: auto;">
    <div class="success-banner">
        <i class="fas fa-check-circle"></i>
        <h2>Checkout Completed</h2>
        <p>Guest Departure Processed Successfully</p>
    </div>

    <!-- This div will be converted to PDF -->
    <div id="invoice-print-area" class="invoice-box">
        <div class="invoice-header">
            <div class="hotel-info">
                <h3>OCEAN VIEW RESORT</h3>
                <p>123 Coastal Road, Galle, Sri Lanka<br>+94 11 234 5678 | hello@oceanviewresort.com</p>
            </div>
            <div class="invoice-meta">
                <h4>Invoice</h4>
                <p>RES# ${reservation.reservationNumber}</p>
                <p style="font-weight: 400; font-size: 11px; color:#999;">DATE: ${LocalDate.now()}</p>
            </div>
        </div>

        <div class="bill-grid">
            <div class="bill-to">
                <h5>Guest Details</h5>
                <p>${reservation.guestName}</p>
                <p style="color: #888; font-size: 12px;">Loyalty: ${reservation.loyaltyNumber != null ? reservation.loyaltyNumber : 'N/A'}</p>
            </div>
            <div class="stay-info">
                <h5>Stay Information</h5>
                <p>Room: ${reservation.roomId}</p>
                <p>Check-in: ${reservation.checkIn}</p>
                <p>Check-out: ${reservation.checkOut}</p>
            </div>
        </div>

        <table class="invoice-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th style="text-align: center;">Qty (Nights)</th>
                    <th style="text-align: right;">Unit Price</th>
                    <th style="text-align: right;">Total</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Accommodation - Deluxe Ocean View Room</td>
                    <td style="text-align: center;">${nights}</td>
                    <td style="text-align: right;">LKR ${reservation.ratePerNight}</td>
                    <td style="text-align: right;">LKR ${totalBill}</td>
                </tr>
            </tbody>
        </table>

        <div class="total-section">
            <div class="line">
                <span>Subtotal</span>
                <span class="val">LKR ${totalBill}</span>
            </div>
            <div class="line">
                <span>Service Charge (0%)</span>
                <span class="val">LKR 0.00</span>
            </div>
            <div class="line">
                <span>Tax (0%)</span>
                <span class="val">LKR 0.00</span>
            </div>
            <div class="grand-total">
                <span>Total Amount</span>
                <span>LKR ${totalBill}</span>
            </div>
        </div>

        <div class="invoice-footer">
            <p>Thank you for choosing Ocean View Resort. We hope to see you again soon!</p>
        </div>
    </div>

    <div class="controls">
        <button onclick="downloadPDF()" class="btn btn-download">
            <i class="fas fa-file-pdf"></i> Download PDF Bill
        </button>
        <a href="dashboard" class="btn btn-dash">
            <i class="fas fa-th-large"></i> Go to Dashboard
        </a>
    </div>
</main>

<script>
    function downloadPDF() {
        const element = document.getElementById('invoice-print-area');
        const opt = {
            margin:       0.5,
            filename:     'Invoice_${reservation.reservationNumber}.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
        };

        // New Promise-based usage:
        html2pdf().set(opt).from(element).save();
    }
</script>

</body>
</html>
