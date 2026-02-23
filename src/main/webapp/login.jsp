<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Ocean View Resort</title>
    <style>
        body {
            font-family: Arial, serif; background: #f0f8ff; margin: 0; padding: 50px; }
        .container { max-width: 400px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 15px rgba(0,0,0,0.2); }
        h2 { text-align: center; color: #333; }
        input[type=text], input[type=password] { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background: #4CAF50; color: white; padding: 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #45a049; }
        .error { color: red; text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Staff Login</h2>
    <form action="login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required autofocus>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>

        <button type="submit">Login</button>
    </form>

    <% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
</div>
</body>
</html>