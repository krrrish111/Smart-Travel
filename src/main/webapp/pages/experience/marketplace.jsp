<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Experiences & Local Guides | Voyastra</title>
    <jsp:include page="/components/config.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .hero-experiences {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1522199710521-72d69614c71c?auto=format&fit=crop&w=1600') center/cover;
            padding: 100px 20px;
            text-align: center;
            color: white;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
        }
        .hero-experiences h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            animation: fadeInDown 1s ease;
        }
        .category-scroll {
            display: flex;
            gap: 15px;
            overflow-x: auto;
            padding: 20px 0;
            margin-top: -30px;
            padding-left: 5%;
        }
        .category-scroll::-webkit-scrollbar { display: none; }
        .category-chip {
            background: white;
            color: #333;
            padding: 12px 25px;
            border-radius: 30px;
            font-weight: 600;
            white-space: nowrap;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .category-chip:hover, .category-chip.active {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
        }
        .experience-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            padding: 50px 5%;
        }
        .exp-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .exp-card:hover {
            transform: translateY(-10px);
        }
        .exp-img {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }
        .exp-content {
            padding: 20px;
        }
        .exp-tag {
            background: rgba(108, 92, 231, 0.1);
            color: var(--primary);
            padding: 4px 10px;
            border-radius: 10px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 10px;
        }
        .exp-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .exp-meta {
            display: flex;
            justify-content: space-between;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        .exp-price {
            font-size: 1.4rem;
            font-weight: 700;
            color: #2D3436;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .score-pill {
            background: #FFD700;
            color: #333;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp" />

    <section class="hero-experiences">
        <h1>Discover Unforgettable Experiences</h1>
        <p style="font-size: 1.2rem; max-width: 600px; margin: 0 auto;">Book local tours, extreme adventures, and authentic workshops led by verified local guides.</p>
    </section>

    <!-- Categories -->
    <div class="category-scroll">
        <a href="?category=All" class="category-chip ${selectedCategory == 'All' ? 'active' : ''}">All</a>
        <a href="?category=Adventure" class="category-chip ${selectedCategory == 'Adventure' ? 'active' : ''}">🧗 Adventure</a>
        <a href="?category=Food" class="category-chip ${selectedCategory == 'Food' ? 'active' : ''}">🍜 Food Trails</a>
        <a href="?category=Culture" class="category-chip ${selectedCategory == 'Culture' ? 'active' : ''}">🏛️ Culture</a>
        <a href="?category=Spiritual" class="category-chip ${selectedCategory == 'Spiritual' ? 'active' : ''}">🧘 Spiritual</a>
        <a href="?category=Nature" class="category-chip ${selectedCategory == 'Nature' ? 'active' : ''}">🌿 Nature</a>
    </div>

    <!-- AI Recommendation Banner -->
    <div style="margin: 40px 5%; padding: 25px; background: linear-gradient(135deg, var(--primary), #8E2DE2); border-radius: 20px; color: white; display: flex; align-items: center; gap: 20px;">
        <div style="font-size: 40px;">🤖</div>
        <div>
            <h3 style="margin-bottom: 5px;">AI Match for You</h3>
            <p style="opacity: 0.9;">Based on your Backpacking travel style and past Goa trips, we highly recommend the <strong>Deep Sea Scuba Diving</strong> experience.</p>
        </div>
    </div>

    <!-- Experiences Grid -->
    <div class="experience-grid">
        <c:forEach var="exp" items="${experiences}">
            <a href="${pageContext.request.contextPath}/experience-details?id=${exp.id}" class="exp-card">
                <img src="${exp.coverImage}" alt="${exp.title}" class="exp-img">
                <div class="exp-content">
                    <span class="exp-tag">${exp.category} • ${exp.difficulty}</span>
                    <h3 class="exp-title">${exp.title}</h3>
                    <div class="exp-meta">
                        <span><i class="fas fa-clock"></i> ${exp.durationMinutes} mins</span>
                        <span><i class="fas fa-star" style="color: #F1C40F;"></i> ${exp.rating} (${exp.reviewCount})</span>
                    </div>
                    <div class="exp-price">
                        <span>₹${exp.price} <small style="font-size: 0.8rem; color: #666; font-weight: normal;">/ person</small></span>
                        <span class="score-pill">Fun: ${exp.funScore}</span>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>

    <jsp:include page="/components/footer.jsp" />
</body>
</html>
