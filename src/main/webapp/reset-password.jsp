<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | Voyastra</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3b82f6;
            --bg: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
        }
        body {
            font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
            background: radial-gradient(circle at bottom left, #1e293b, #0f172a);
            color: #f8fafc;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            overflow: hidden;
        }
        .card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            padding: 2.5rem;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.1);
            width: 100%;
            max-width: 400px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }
        h2 { font-weight: 600; margin-bottom: 0.5rem; text-align: center; }
        p { color: #94a3b8; font-size: 0.9rem; text-align: center; margin-bottom: 2rem; }
        .form-group { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; font-size: 0.85rem; color: #cbd5e1; }
        input {
            width: 100%;
            background: rgba(15, 23, 42, 0.5);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 0.8rem;
            border-radius: 10px;
            color: white;
            box-sizing: border-box;
            transition: 0.3s;
        }
        input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2); }
        .btn {
            width: 100%;
            background: var(--primary);
            color: white;
            padding: 1rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn:hover { background: #2563eb; transform: translateY(-1px); }
        .alert { background: rgba(239, 68, 68, 0.1); border: 1px solid #ef4444; color: #f87171; padding: 1rem; border-radius: 10px; font-size: 0.85rem; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Security Reset</h2>
        <p>Enter your new password below.</p>

        <% if (request.getAttribute("errorMsg") != null) { %>
            <div class="alert"><%= request.getAttribute("errorMsg") %></div>
        <% } %>

        <form action="reset-password" method="POST">
            <input type="hidden" name="token" value="<%= request.getAttribute("token") %>">
            
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="password" placeholder="Min 6 characters" required>
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" name="confirm_password" placeholder="Repeat password" required>
            </div>

            <button type="submit" class="btn">Update Password</button>
        </form>
    </div>
</body>
</html>
