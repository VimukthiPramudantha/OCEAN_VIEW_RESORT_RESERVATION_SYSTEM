<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0077b6;
            --primary-hover: #023e8a;
            --bg-gradient: linear-gradient(135deg, #00b4db, #0083b0);
            --glass-bg: rgba(255, 255, 255, 0.9);
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
            align-items: center;
            justify-content: center;
            background: var(--bg-gradient);
            background-attachment: fixed;
            color: var(--text-main);
        }

        .login-card {
            background: var(--glass-bg);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 5px;
        }

        .header p {
            font-size: 14px;
            color: var(--text-muted);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 400;
            font-size: 14px;
            color: var(--text-main);
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(0, 119, 182, 0.2);
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .btn-login:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .error-msg {
            background: rgba(230, 57, 70, 0.1);
            color: var(--error);
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            font-size: 13px;
            margin-top: 20px;
            border: 1px solid rgba(230, 57, 70, 0.2);
        }

        .footer-note {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="header">
        <h1>Ocean View</h1>
        <p>Staff Portal Access</p>
    </div>

    <form action="login" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required autofocus>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="••••••••" required>
        </div>

        <button type="submit" class="btn-login">Sign In</button>
    </form>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-msg">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="footer-note">
        &copy; 2026 Ocean View Resort. All rights reserved.
    </div>
</div>

</body>
</html>