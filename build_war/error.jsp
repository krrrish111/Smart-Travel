<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error Encountered | Voyastra</title>
    <!-- Add Google Fonts and a polished stylesheet for premium quality -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: #333;
        }

        .error-container {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            max-width: 600px;
            width: 90%;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: linear-gradient(90deg, #ff416c 0%, #ff4b2b 100%);
        }

        h1 {
            font-size: 80px;
            margin: 0;
            font-weight: 700;
            background: linear-gradient(90deg, #ff416c 0%, #ff4b2b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .error-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #2b2d42;
        }

        .error-message {
            font-size: 16px;
            color: #6c757d;
            line-height: 1.6;
            margin-bottom: 30px;
            padding: 15px;
            background: #fff5f5;
            border-radius: 8px;
            border: 1px solid #ffccd5;
            text-align: left;
            word-break: break-word;
        }

        .error-illustration {
            font-size: 60px;
            margin-bottom: 20px;
        }

        .back-btn {
            display: inline-block;
            background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            color: #fff;
            padding: 12px 28px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 500;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(13, 110, 253, 0.3);
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(13, 110, 253, 0.4);
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="error-illustration">⚠️</div>
        
        <c:choose>
            <c:when test="${not empty errorType}">
                <h1>OOPS!</h1>
                <div class="error-title">We hit a roadblock.</div>
            </c:when>
            <c:otherwise>
                <h1>500</h1>
                <div class="error-title">Internal Server Error</div>
            </c:otherwise>
        </c:choose>

        <div class="error-message">
            <strong>What happened?</strong><br>
            <c:choose>
                <c:when test="${not empty errorMsg}">
                    <c:out value="${errorMsg}" escapeXml="true" />
                </c:when>
                <c:when test="${not empty errorMessage}">
                    <c:out value="${errorMessage}" escapeXml="true" />
                </c:when>
                <c:otherwise>
                    Looks like something broke on our end. Please try again or navigate back.
                </c:otherwise>
            </c:choose>
        </div>

        <a href="${pageContext.request.contextPath}/index.jsp" class="back-btn">Return to Safety</a>
    </div>

</body>
</html>
