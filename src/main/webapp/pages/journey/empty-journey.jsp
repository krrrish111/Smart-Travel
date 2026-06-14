<%@ page language="java" contentType="text/html; charset=UTF-8" pageContext="page" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Journey | Voyastra</title>
    <jsp:include page="/components/config.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .empty-state {
            text-align: center;
            padding: 100px 20px;
            min-height: 70vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .empty-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-15px); }
            100% { transform: translateY(0px); }
        }
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp" />

    <div class="empty-state">
        <div class="empty-icon">🎒</div>
        <h1 style="font-size: 2.5rem; margin-bottom: 10px;">No Active Journey</h1>
        <p style="font-size: 1.2rem; color: #666; max-width: 500px;">Ready for your next adventure? Head over to the Planner to craft a new itinerary, or browse our active community to get inspired.</p>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/planner" class="btn btn-primary">Open Planner</a>
            <a href="${pageContext.request.contextPath}/explore" class="btn btn-outline">Explore Destinations</a>
            <a href="${pageContext.request.contextPath}/community" class="btn btn-outline">View Community</a>
        </div>
    </div>

    <jsp:include page="/components/footer.jsp" />
</body>
</html>
