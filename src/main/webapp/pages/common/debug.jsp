<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voyastra Diagnostic Dashboard</title>
    <style>
        body { font-family: monospace; background: #111; color: #0f0; padding: 20px; }
        h1 { color: #fff; }
        .success { color: #0f0; }
        .fail { color: #f00; }
        .card { border: 1px solid #333; padding: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <h1>Voyastra Diagnostic Dashboard</h1>
    
    <div class="card">
        <h2>System Status</h2>
        <p>Tomcat Server: <span class="success">RUNNING</span></p>
        <p>Database Connected: <span class="${dbConnected ? 'success' : 'fail'}">${dbConnected ? 'SUCCESS' : 'FAILED'}</span></p>
        <p>Servlets Registered: <span class="${servletsRegistered ? 'success' : 'fail'}">${servletsRegistered ? 'SUCCESS' : 'FAILED'}</span></p>
        <p>YouTube Config: <span class="${youtubeConfigured ? 'success' : 'fail'}">${youtubeConfigured ? 'SUCCESS' : 'FAILED'}</span></p>
        <p>Unsplash Config: <span class="${unsplashConfigured ? 'success' : 'fail'}">${unsplashConfigured ? 'SUCCESS' : 'FAILED'}</span></p>
    </div>

    <div class="card">
        <h2>Planner Status By Session</h2>
        <c:choose>
            <c:when test="${not empty allStatuses}">
                <ul>
                    <c:forEach var="entry" items="${allStatuses}">
                        <li>Session [${entry.key}]: <strong>${entry.value}</strong></li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>No planner requests recorded yet.</p>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>
