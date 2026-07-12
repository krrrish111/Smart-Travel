<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Itinerary Details | Voyastra</title>
    <%@ include file="/components/global_ui.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .itin-hero {
            position: relative;
            height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
        }
        .itin-hero img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }
        .itin-hero::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, var(--bg-dark) 0%, rgba(13, 13, 17, 0.4) 100%);
            z-index: 2;
        }
        .itin-hero-content {
            position: relative;
            z-index: 3;
            text-align: center;
            max-width: 800px;
            padding: 0 20px;
        }
        .timeline-container {
            max-width: 800px;
            margin: -60px auto 100px;
            position: relative;
            z-index: 10;
        }
        .timeline-day {
            display: flex;
            margin-bottom: 40px;
            position: relative;
        }
        .timeline-day::before {
            content: '';
            position: absolute;
            left: 24px;
            top: 50px;
            bottom: -40px;
            width: 2px;
            background: rgba(255, 255, 255, 0.1);
        }
        .timeline-day:last-child::before {
            display: none;
        }
        .timeline-marker {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--surface-glass);
            border: 2px solid var(--color-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: var(--color-primary);
            flex-shrink: 0;
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 2;
        }
        .timeline-content {
            margin-left: 30px;
            background: var(--surface-glass);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 30px;
            flex-grow: 1;
            backdrop-filter: blur(20px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        .timeline-content:hover {
            transform: translateY(-5px);
            border-color: rgba(255, 255, 255, 0.15);
        }
    </style>
</head>
<body class="bg-dark text-white font-sans antialiased">
    
    <%@ include file="/components/header.jsp" %>

    <%
        // Fallback data mapping for demo purposes
        String city = request.getParameter("city");
        if (city == null) city = "Destination";
        
        String bgImage = "https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=1920&q=80";
        if (city.equalsIgnoreCase("Agra")) bgImage = "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=1920&q=80";
        if (city.equalsIgnoreCase("Kerala")) bgImage = "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=1920&q=80";
        if (city.equalsIgnoreCase("Jaisalmer")) bgImage = "https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=1920&q=80";
        if (city.equalsIgnoreCase("Varanasi")) bgImage = "https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format&fit=crop&w=1920&q=80";
    %>

    <main>
        <!-- Hero Section -->
        <section class="itin-hero">
            <img src="<%= bgImage % loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">" alt="<%= city %>">
            <div class="itin-hero-content">
                <span class="inline-block py-1 px-3 rounded-full bg-primary/20 text-primary border border-primary/30 text-sm font-semibold mb-4 backdrop-blur-md">
                    Curated Itinerary
                </span>
                <h1 class="text-5xl md:text-7xl font-bold mb-4 editorial">The Complete <%= city %> Experience</h1>
                <p class="text-xl text-gray-300">Discover the hidden gems, iconic landmarks, and authentic flavors of <%= city %> over a perfectly paced 3-day journey.</p>
            </div>
        </section>

        <!-- Timeline Section -->
        <section class="timeline-container px-4">
            
            <div class="timeline-day">
                <div class="timeline-marker">1</div>
                <div class="timeline-content">
                    <h3 class="text-2xl font-bold text-main mb-2">Arrival & Immersion</h3>
                    <p class="text-gray-400 mb-4">Settle in and begin your exploration of the local culture and vibrant streets.</p>
                    <ul class="space-y-3 text-gray-300">
                        <li class="flex items-center gap-3"><i class="fas fa-plane-arrival text-primary w-5 text-center"></i> Morning arrival and hotel check-in</li>
                        <li class="flex items-center gap-3"><i class="fas fa-utensils text-primary w-5 text-center"></i> Authentic local lunch experience</li>
                        <li class="flex items-center gap-3"><i class="fas fa-walking text-primary w-5 text-center"></i> Guided heritage walk through old town</li>
                    </ul>
                </div>
            </div>

            <div class="timeline-day">
                <div class="timeline-marker">2</div>
                <div class="timeline-content">
                    <h3 class="text-2xl font-bold text-main mb-2">Iconic Landmarks & Wonders</h3>
                    <p class="text-gray-400 mb-4">A full day dedicated to the most spectacular and renowned sights of <%= city %>.</p>
                    <ul class="space-y-3 text-gray-300">
                        <li class="flex items-center gap-3"><i class="fas fa-sun text-primary w-5 text-center"></i> Early morning sunrise viewing</li>
                        <li class="flex items-center gap-3"><i class="fas fa-camera text-primary w-5 text-center"></i> Monument exploration and photography</li>
                        <li class="flex items-center gap-3"><i class="fas fa-moon text-primary w-5 text-center"></i> Evening cultural performance</li>
                    </ul>
                </div>
            </div>

            <div class="timeline-day">
                <div class="timeline-marker">3</div>
                <div class="timeline-content">
                    <h3 class="text-2xl font-bold text-main mb-2">Nature & Leisure</h3>
                    <p class="text-gray-400 mb-4">Unwind with nature trails, local shopping, and a farewell dinner.</p>
                    <ul class="space-y-3 text-gray-300">
                        <li class="flex items-center gap-3"><i class="fas fa-leaf text-primary w-5 text-center"></i> Nature retreat or boat ride</li>
                        <li class="flex items-center gap-3"><i class="fas fa-shopping-bag text-primary w-5 text-center"></i> Souvenir shopping at the artisan market</li>
                        <li class="flex items-center gap-3"><i class="fas fa-plane-departure text-primary w-5 text-center"></i> Departure</li>
                    </ul>
                </div>
            </div>

            <!-- Booking CTA -->
            <div class="text-center mt-12">
                <a href="${pageContext.request.contextPath}/trip-booking?id=custom_<%= city.toLowerCase() %>" class="inline-flex items-center gap-2 bg-gradient-to-r from-primary to-accent text-white px-8 py-4 rounded-full font-bold text-lg hover:shadow-[0_0_20px_rgba(79,70,229,0.4)] transition-all transform hover:-translate-y-1">
                    Customize & Book This Itinerary
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>

        </section>

    </main>

    <%@ include file="/components/footer.jsp" %>
</body>
</html>
