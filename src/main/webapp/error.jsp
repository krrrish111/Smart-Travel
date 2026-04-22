<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Error | Voyastra</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4f46e5;
            --bg: #0d0d11;
            --text: #f9fafb;
            --text-muted: rgba(249, 250, 251, 0.5);
        }
        body {
            background-color: var(--bg);
            color: var(--text);
            font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            overflow: hidden;
            text-align: center;
        }
        .container {
            max-width: 500px;
            padding: 40px;
            position: relative;
            z-index: 10;
        }
        .error-code {
            font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
            font-size: 10rem;
            font-weight: 800;
            margin: 0;
            background: linear-gradient(135deg, #4f46e5, #06b6d4);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            opacity: 0.8;
            line-height: 1;
        }
        h1 {
            font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
            font-size: 1.8rem;
            margin: 20px 0 10px;
        }
        p {
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .error-id {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 10px 15px;
            border-radius: 8px;
            font-family: monospace;
            display: inline-block;
            margin-bottom: 30px;
            font-size: 0.9rem;
        }
        .btn {
            display: inline-block;
            background: white;
            color: #0d0d11;
            padding: 14px 28px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.4);
        }
        /* Background decor */
        .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(100px);
            z-index: 1;
        }
        .orb-1 { width: 400px; height: 400px; background: rgba(79, 70, 229, 0.15); top: -100px; left: -100px; }
        .orb-2 { width: 300px; height: 300px; background: rgba(6, 182, 212, 0.1); bottom: -50px; right: -50px; }
    </style>
</head>
<body>
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <div class="container">
        <div class="error-code">
            <% 
                Object code = request.getAttribute("javax.servlet.error.status_code");
                out.print(code != null ? code : "!!!");
            %>
        </div>
        <h1>Oops! Systems offline.</h1>
        <p>
            It seems we've encountered a slight distortion in the space-time continuum. 
            Our engineers have been notified and are on it.
        </p>
        
        <div class="error-id">
            Event ID: <%= request.getAttribute("errorId") != null ? request.getAttribute("errorId") : "SYSTEM_FAILURE" %>
        </div>

        <div>
            <a href="index.jsp" class="btn">Take Me Home</a>
        </div>
    </div>
</body>
</html>
