<%@ page language="java" contentType="text/html; charset=UTF-8" pageContext="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Local Guides | Voyastra</title>
    <jsp:include page="/components/config.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .hero { padding: 80px 20px; text-align: center; background: #f8f9fa; }
        .guide-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 30px; padding: 50px 5%; }
        .guide-card { background: white; border-radius: 15px; padding: 25px; text-align: center; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .guide-avatar { width: 100px; height: 100px; border-radius: 50%; background: #eee; margin: 0 auto 15px auto; display: flex; align-items: center; justify-content: center; font-size: 40px; }
        .hire-btn { display: inline-block; background: var(--primary); color: white; padding: 10px 20px; border-radius: 20px; text-decoration: none; margin-top: 15px; font-weight: bold; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp" />

    <section class="hero">
        <h1 style="font-size: 3rem; margin-bottom: 10px;">Voyastra Local Guides</h1>
        <p>Hire verified experts for private tours, photography sessions, and food trails.</p>
    </section>

    <div class="guide-grid">
        <c:forEach var="guide" items="${guides}">
            <div class="guide-card">
                <div class="guide-avatar">👤</div>
                <h3>${guide.userId} <c:if test="${guide.verified}"><i class="fas fa-check-circle" style="color: #2ecc71;"></i></c:if></h3>
                <p style="color: var(--primary); font-weight: bold; margin: 5px 0;">${guide.specialization}</p>
                <p style="font-size: 0.9rem; color: #666;"><i class="fas fa-map-marker-alt"></i> ${guide.location}</p>
                <p style="font-size: 0.9rem; margin: 15px 0;">${guide.bio}</p>
                <div style="font-size: 0.9rem; color: #555; margin-bottom: 15px;">
                    <i class="fas fa-language"></i> ${guide.languages}
                </div>
                <div><i class="fas fa-star" style="color: #f1c40f;"></i> ${guide.rating} (${guide.reviewCount})</div>
                <a href="#" class="hire-btn">Hire Guide</a>
            </div>
        </c:forEach>
    </div>

    <jsp:include page="/components/footer.jsp" />
</body>
</html>
