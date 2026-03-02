<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Luxury Coastal Escape</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0077b6;
            --accent: #00b4db;
            --white: #ffffff;
            --glass: rgba(255, 255, 255, 0.1);
            --glass-strong: rgba(255, 255, 255, 0.2);
            --glass-border: rgba(255, 255, 255, 0.2);
            --text-light: #f8fbff;
            --text-dark: #333;
            --gold: #d4af37;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: #000;
            color: var(--text-light);
            overflow-x: hidden;
            line-height: 1.6;
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            width: 100%;
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.3)), 
                        url('images/upgraded-points-ROWs7kzqpGQ-unsplash.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        /* Navigation */
        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 80px;
            position: absolute;
            top: 0;
            width: 100%;
            z-index: 1000;
            backdrop-filter: blur(8px);
            background: rgba(0,0,0,0.2);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
            letter-spacing: 2px;
            color: var(--white);
            text-transform: uppercase;
        }

        .nav-links {
            display: flex;
            gap: 40px;
            list-style: none;
            align-items: center;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--white);
            font-size: 14px;
            font-weight: 500;
            letter-spacing: 1px;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: var(--accent);
        }

        .btn-portal {
            background: var(--accent);
            color: white !important;
            padding: 10px 25px;
            border-radius: 50px;
            font-weight: 600 !important;
            box-shadow: 0 4px 15px rgba(0, 180, 219, 0.3);
            transition: all 0.3s !important;
        }

        .btn-portal:hover {
            background: var(--primary);
            transform: translateY(-2px);
        }

        /* Hero Content */
        .hero-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 120px 20px 60px;
            animation: fadeIn 1.2s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-content h2 {
            font-size: 5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 10px 30px rgba(0,0,0,0.5);
            line-height: 1.1;
        }

        .hero-content p.subtitle {
            font-size: 1.2rem;
            max-width: 700px;
            margin-bottom: 40px;
            font-weight: 300;
            letter-spacing: 1px;
            opacity: 0.9;
        }

        /* Staff Intelligence Section (Glassmorphism) */
        .staff-intelligence {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto 0;
            padding: 30px;
            background: var(--glass);
            backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            animation: slideUp 1s ease-out 0.5s both;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .staff-welcome {
            grid-column: 1 / -1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 20px;
            margin-bottom: 10px;
        }

        .staff-welcome h3 {
            font-size: 20px;
            font-weight: 600;
        }

        .staff-welcome span {
            font-size: 13px;
            color: var(--accent);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .resort-pulse {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .pulse-card {
            background: rgba(255,255,255,0.05);
            padding: 20px;
            border-radius: 15px;
            border: 1px solid rgba(255,255,255,0.05);
            text-align: left;
        }

        .pulse-card i {
            font-size: 24px;
            color: var(--accent);
            margin-bottom: 15px;
        }

        .pulse-card .val {
            display: block;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .pulse-card .label {
            font-size: 12px;
            color: rgba(255,255,255,0.6);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .notice-board {
            background: rgba(255,255,255,0.05);
            padding: 25px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .notice-board h4 {
            font-size: 16px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--gold);
        }

        .notice-item {
            padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        .notice-item:last-child { border: none; }

        .notice-item p {
            font-size: 13px;
            color: rgba(255,255,255,0.8);
            margin-bottom: 5px;
        }

        .notice-item span {
            font-size: 11px;
            color: rgba(255,255,255,0.4);
        }

        .cta-buttons {
            display: flex;
            gap: 20px;
            margin-top: 40px;
        }

        .btn-main {
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: var(--white);
            color: var(--primary);
        }

        .btn-primary:hover {
            background: var(--accent);
            color: var(--white);
            transform: scale(1.05);
        }

        .btn-outline {
            border: 2px solid var(--white);
            color: var(--white);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: scale(1.05);
        }

        /* Section Styling */
        section {
            padding: 100px 80px;
            background: #fff;
            color: var(--text-dark);
        }

        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-header h3 {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 15px;
        }

        .section-header p {
            color: #777;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Features/Rooms Grid */
        .rooms-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
        }

        .room-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid #f0f0f0;
        }

        .room-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
        }

        .room-img {
            height: 280px;
            background-size: cover;
            background-position: center;
        }

        .room-info {
            padding: 30px;
        }

        .room-info h4 {
            font-size: 22px;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .room-info p {
            font-size: 15px;
            color: #666;
            margin-bottom: 25px;
        }

        .room-price {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .price {
            font-size: 26px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .price span {
            font-size: 14px;
            font-weight: 400;
            color: #999;
        }

        /* Footer */
        footer {
            background: #001219;
            color: #fff;
            padding: 100px 80px 40px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
        }

        .footer-col h5 {
            font-size: 18px;
            margin-bottom: 25px;
            color: var(--accent);
        }

        .footer-col ul {
            list-style: none;
        }

        .footer-col ul li {
            margin-bottom: 12px;
        }

        .footer-col ul a {
            color: #aaa;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }

        .footer-col ul a:hover {
            color: #fff;
        }

        .footer-bottom {
            grid-column: 1 / -1;
            text-align: center;
            padding-top: 40px;
            margin-top: 40px;
            border-top: 1px solid rgba(255,255,255,0.05);
            color: #555;
            font-size: 13px;
        }

        @media (max-width: 992px) {
            .staff-intelligence { grid-template-columns: 1fr; }
            .hero-content h2 { font-size: 4rem; }
            nav { padding: 20px 40px; }
        }

        @media (max-width: 768px) {
            .nav-links { display: none; }
            .hero-content h2 { font-size: 3rem; }
            section { padding: 60px 40px; }
            footer { padding: 60px 40px 30px; }
            .resort-pulse { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <div class="hero">
        <nav>
            <div class="logo">
                <h1>Ocean View</h1>
            </div>
            <ul class="nav-links">
                <li><a href="#">Home</a></li>
                <li><a href="#rooms">Accommodations</a></li>
                <li><a href="#">Dining</a></li>
                <c:choose>
                    <c:when test="${not empty user}">
                        <li><a href="dashboard" class="btn-portal"><i class="fas fa-th-large"></i> Dashboard</a></li>
                        <li><a href="logout"><i class="fas fa-sign-out-alt"></i></a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="login" class="btn-portal"><i class="fas fa-key"></i> Staff Portal</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>

        <div class="hero-content">
            <c:choose>
                <c:when test="${not empty user}">
                    <div class="staff-intelligence">
                        <div class="staff-welcome">
                            <h3><i class="fas fa-user-circle"></i> Welcome Back, ${user.fullName.split(' ')[0]}</h3>
                            <span>${user.role} | Operational Oversight</span>
                        </div>
                        
                        <div class="resort-pulse">
                            <div class="pulse-card">
                                <i class="fas fa-door-open"></i>
                                <span class="val">${todayCheckins != null ? todayCheckins : '12'}</span>
                                <span class="label">Today's Check-ins</span>
                            </div>
                            <div class="pulse-card">
                                <i class="fas fa-bed"></i>
                                <span class="val">${occupancyPercent != null ? occupancyPercent : '85'}%</span>
                                <span class="label">Real-time Occupancy</span>
                            </div>
                            <div class="pulse-card">
                                <i class="fas fa-star" style="color:var(--gold)"></i>
                                <span class="val">4</span>
                                <span class="label">VIP Groups Today</span>
                            </div>
                        </div>

                        <div class="notice-board">
                            <h4><i class="fas fa-bullhorn"></i> Internal Notices</h4>
                            <div class="notice-item">
                                <p>Elevator Maintenance scheduled for Block B (2 PM - 4 PM).</p>
                                <span>Today, 09:12 AM</span>
                            </div>
                            <div class="notice-item">
                                <p>VIP Arrival: Ambassador delegation (Suite 405) - Prep priority.</p>
                                <span>Today, 07:45 AM</span>
                            </div>
                            <div class="notice-item">
                                <p>Staff briefing in the Shoreline Lounge at 6 PM.</p>
                                <span>Yesterday, 04:30 PM</span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="subtitle">EXPERIENCE TRANQUILITY BY THE SHORE</p>
                    <h2>Your Coastal Sanctuary<br>Awaits</h2>
                    <div class="cta-buttons">
                        <a href="#rooms" class="btn-main btn-primary">Book Your Stay</a>
                        <a href="#" class="btn-main btn-outline">Explore Gallery</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <section id="rooms">
        <div class="section-header">
            <h3>Refined Luxury</h3>
            <p>Discover our curated collection of suites and rooms, each designed to provide the ultimate coastal living experience.</p>
        </div>

        <div class="rooms-grid">
            <div class="room-card">
                <div class="room-img" style="background-image: url('https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')"></div>
                <div class="room-info">
                    <h4>Standard Room</h4>
                    <p>Comfortable and elegant, our standard rooms offer all the essential amenities for a relaxing stay.</p>
                    <div class="room-price">
                        <div class="price">$250 <span>/ night</span></div>
                        <a href="#"><i class="fas fa-arrow-right" style="color:var(--primary)"></i></a>
                    </div>
                </div>
            </div>

            <div class="room-card">
                <div class="room-img" style="background-image: url('https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')"></div>
                <div class="room-info">
                    <h4>Deluxe Ocean View</h4>
                    <p>Breath-taking ocean views with a private balcony and contemporary minimalist design.</p>
                    <div class="room-price">
                        <div class="price">$450 <span>/ night</span></div>
                        <a href="#"><i class="fas fa-arrow-right" style="color:var(--primary)"></i></a>
                    </div>
                </div>
            </div>

            <div class="room-card">
                <div class="room-img" style="background-image: url('https://images.unsplash.com/photo-1595576508898-0ad5c879a061?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')"></div>
                <div class="room-info">
                    <h4>Executive Suite</h4>
                    <p>Spacious floor-to-ceiling windows overlooking the horizon with a separate lounge area.</p>
                    <div class="room-price">
                        <div class="price">$950 <span>/ night</span></div>
                        <a href="#"><i class="fas fa-arrow-right" style="color:var(--primary)"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer>
        <div class="footer-col">
            <h5>The Resort</h5>
            <ul>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Our Philosophy</a></li>
                <li><a href="#">Awards</a></li>
                <li><a href="#">Careers</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h5>Guest Services</h5>
            <ul>
                <li><a href="#">Reservations</a></li>
                <li><a href="#">Airport Transfers</a></li>
                <li><a href="#">Spa & Wellness</a></li>
                <li><a href="#">Guest Portal</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h5>Discover</h5>
            <ul>
                <li><a href="#">Fine Dining</a></li>
                <li><a href="#">Excursions</a></li>
                <li><a href="#">Events</a></li>
                <li><a href="#">Sustainability</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h5>Contact</h5>
            <ul style="color: #666; font-size: 14px;">
                <li><i class="fas fa-map-marker-alt" style="margin-right: 10px;"></i> 123 Coastal Road, Galle, SL</li>
                <li><i class="fas fa-phone" style="margin-right: 10px;"></i> +94 11 234 5678</li>
                <li><i class="fas fa-envelope" style="margin-right: 10px;"></i> hello@oceanviewresort.com</li>
            </ul>
        </div>
        <div class="footer-bottom">
            &copy; 2026 Ocean View Resort. Crafted for unparalleled luxury.
        </div>
    </footer>

</body>
</html>