<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<%
System.out.println("planner-result.jsp opened");
System.out.println("Destination = " + request.getAttribute("destination"));
System.out.println("Itinerary Exists = " + (request.getAttribute("itinerary") != null));
System.out.println("Videos Exists = " + (request.getAttribute("videos") != null));
System.out.println("Images Exists = " + (request.getAttribute("images") != null));

if (request.getAttribute("destination") == null || request.getAttribute("itinerary") == null || 
    request.getAttribute("videos") == null || request.getAttribute("images") == null) {
%>
    <div style="background-color: #ef4444; color: white; padding: 20px; border-radius: 12px; margin: 100px auto 20px auto; max-width: 800px; text-align: center; font-weight: bold; border: 2px solid #b91c1c;">
        ⚠️ PlannerServlet did not send required data.
    </div>
<%
} else {
    System.out.println("planner-result.jsp rendered successfully");
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your AI Trip Plan - Voyastra</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:       #0b0f19;
            --surface:  #131722;
            --surface2: #1a2033;
            --accent:   #d6a66b;
            --accent2:  #f0c080;
            --green:    #4ade80;
            --blue:     #60a5fa;
            --purple:   #a78bfa;
            --red:      #f87171;
            --text:     #ffffff;
            --muted:    #8b9ab3;
            --border:   rgba(214,166,107,0.15);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
        }
        .container { max-width: 1100px; margin: 0 auto; padding: 40px 20px 80px; }

        /* ── Hero banner ── */
        .hero {
            border: var(--border) solid; border-radius: 20px;
            padding: 40px; margin-bottom: 28px;
            border-color: rgba(214,166,107,0.25);
            position: relative; overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute; top: -60px; right: -60px;
            width: 220px; height: 220px;
            background: radial-gradient(circle, rgba(214,166,107,0.12) 0%, transparent 70%);
            border-radius: 50%;
        }
        .hero-badge {
            display: inline-block; background: rgba(214,166,107,0.15);
            color: var(--accent); font-size: 0.78rem; font-weight: 600;
            padding: 4px 14px; border-radius: 20px; text-transform: uppercase;
            letter-spacing: 1px; margin-bottom: 14px;
        }
        .hero h1 {
            font-family: 'Outfit', sans-serif; font-size: 2.4rem; font-weight: 700;
            line-height: 1.2; margin-bottom: 12px;
            background: linear-gradient(90deg, #fff 60%, var(--accent2) 100%);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero-story {
            color: var(--muted); font-size: 1rem; line-height: 1.7;
            max-width: 700px; margin-bottom: 24px;
        }
        .score-ring {
            display: inline-flex; align-items: center; gap: 10px;
            background: rgba(74,222,128,0.1); border: 1px solid rgba(74,222,128,0.25);
            padding: 10px 20px; border-radius: 12px;
        }
        .score-ring .num {
            font-size: 2rem; font-weight: 700; color: var(--green);
        }
        .score-ring .label { color: var(--muted); font-size: 0.85rem; }

        /* ── Section cards ── */
        .card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 16px; padding: 28px; margin-bottom: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.25);
        }
        .card-title {
            font-family: 'Outfit', sans-serif; font-size: 1.25rem;
            color: var(--accent); font-weight: 600;
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 20px; padding-bottom: 12px;
            border-bottom: 1px solid rgba(214,166,107,0.1);
        }
        .card-title .icon { font-size: 1.2rem; }

        /* ── Stats grid ── */
        .stats-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 16px;
        }
        .stat-box {
            background: var(--surface2); border-radius: 12px; padding: 16px;
            text-align: center; border: 1px solid rgba(255,255,255,0.05);
            transition: border-color 0.2s;
        }
        .stat-box:hover { border-color: rgba(214,166,107,0.3); }
        .stat-val {
            font-size: 1.1rem; font-weight: 700; color: var(--accent2);
            margin-bottom: 4px;
        }
        .stat-lbl { font-size: 0.78rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; }

        /* ── Budget ── */
        .budget-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
        }
        .budget-box {
            background: var(--surface2); border-radius: 12px; padding: 16px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .budget-box .b-label { font-size: 0.78rem; color: var(--muted); text-transform: uppercase; margin-bottom: 6px; }
        .budget-box .b-val   { font-size: 1rem; font-weight: 600; color: var(--accent2); }

        /* ── Day cards ── */
        .day-card {
            background: var(--surface2); border-radius: 14px; overflow: hidden;
            margin-bottom: 16px; border: 1px solid rgba(255,255,255,0.05);
            transition: border-color 0.2s;
        }
        .day-card:hover { border-color: rgba(214,166,107,0.25); }
        .day-header {
            background: linear-gradient(90deg, rgba(214,166,107,0.1) 0%, transparent 100%);
            padding: 16px 20px; display: flex; align-items: center;
            justify-content: space-between; cursor: pointer;
        }
        .day-num {
            display: inline-flex; align-items: center; justify-content: center;
            width: 36px; height: 36px; border-radius: 50%;
            background: rgba(214,166,107,0.2); color: var(--accent);
            font-weight: 700; font-size: 0.9rem; margin-right: 14px; flex-shrink: 0;
        }
        .day-info { flex: 1; }
        .day-title-text { font-weight: 600; font-size: 1rem; margin-bottom: 2px; }
        .day-meta { font-size: 0.8rem; color: var(--muted); }
        .day-badge {
            font-size: 0.75rem; padding: 3px 10px; border-radius: 12px;
            font-weight: 500;
        }
        .badge-easy   { background: rgba(74,222,128,0.1);  color: var(--green);  }
        .badge-moderate { background: rgba(251,191,36,0.1); color: #fbbf24; }
        .badge-hard   { background: rgba(248,113,113,0.1); color: var(--red);   }

        .day-body { padding: 20px; }
        .day-story { color: var(--muted); font-size: 0.88rem; margin: 0 0 16px; line-height: 1.6; }
        .activity-row {
            display: flex; gap: 14px; padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        .activity-row:last-child { border-bottom: none; }
        .act-time {
            min-width: 72px; font-size: 0.8rem; color: var(--accent);
            font-weight: 600; padding-top: 2px;
        }
        .act-body { flex: 1; }
        .act-title { font-weight: 600; font-size: 0.93rem; margin-bottom: 3px; }
        .act-desc  { font-size: 0.83rem; color: var(--muted); line-height: 1.5; }
        .cat-pill {
            display: inline-block; font-size: 0.7rem; padding: 2px 8px;
            border-radius: 8px; margin-left: 8px; vertical-align: middle;
            background: rgba(96,165,250,0.12); color: var(--blue);
        }

        /* ── Lists ── */
        .tag-list { display: flex; flex-wrap: wrap; gap: 10px; }
        .tag {
            background: var(--surface2); border: 1px solid rgba(255,255,255,0.07);
            border-radius: 20px; padding: 6px 14px; font-size: 0.85rem; color: var(--text);
            transition: border-color 0.2s;
        }
        .tag:hover { border-color: rgba(214,166,107,0.35); }
        .tag.food   { border-color: rgba(251,146,60,0.25); color: #fb923c; }

        /* ── Hidden gems detailed ── */
        .gem-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; }
        .gem-card {
            background: var(--surface2); border-radius: 14px; padding: 18px;
            border: 1px solid rgba(167,139,250,0.15);
        }
        .gem-name { font-weight: 600; color: var(--purple); margin-bottom: 6px; }
        .gem-desc { font-size: 0.83rem; color: var(--muted); line-height: 1.5; margin-bottom: 12px; }
        .gem-scores { display: flex; gap: 8px; flex-wrap: wrap; }
        .gem-score {
            font-size: 0.73rem; padding: 2px 8px; border-radius: 6px;
            background: rgba(167,139,250,0.1); color: var(--purple);
        }

        /* ── Food trails ── */
        .trail-card {
            background: var(--surface2); border-radius: 14px; padding: 18px;
            border: 1px solid rgba(251,146,60,0.12); margin-bottom: 14px;
        }
        .trail-title { font-weight: 600; color: #fb923c; margin-bottom: 12px; font-size: 0.95rem; }
        .meal-row { display: flex; gap: 10px; margin-bottom: 8px; align-items: flex-start; }
        .meal-label { min-width: 80px; font-size: 0.78rem; color: var(--muted); text-transform: uppercase; font-weight: 600; padding-top: 1px; }
        .meal-val { font-size: 0.88rem; color: var(--text); }

        /* ── Tips ── */
        .tip-list { display: flex; flex-direction: column; gap: 10px; }
        .tip-item {
            display: flex; gap: 12px; align-items: flex-start;
            background: var(--surface2); padding: 12px 16px; border-radius: 10px;
            border-left: 3px solid var(--accent);
        }
        .tip-icon { font-size: 1rem; flex-shrink: 0; }
        .tip-text { font-size: 0.88rem; color: var(--muted); line-height: 1.5; }

        /* ── Action buttons ── */
        .actions { display: flex; gap: 14px; margin-top: 32px; flex-wrap: wrap; }
        .btn {
            padding: 12px 28px; border-radius: 10px; font-weight: 600;
            font-size: 0.93rem; cursor: pointer; border: none; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #0b0f19;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(214,166,107,0.35); }
        .btn-ghost {
            background: rgba(255,255,255,0.06); color: var(--text);
            border: 1px solid rgba(255,255,255,0.12);
        }
        .btn-ghost:hover { background: rgba(255,255,255,0.1); }

        /* ── Media ── */
        .media-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; }
        .media-item { border-radius: 12px; overflow: hidden; background: var(--surface2); border: 1px solid rgba(255,255,255,0.05); }
        .media-item img { width: 100%; height: 160px; object-fit: cover; display: block; }
        .media-item iframe { width: 100%; height: 160px; border: none; }
        .media-caption { padding: 12px; font-size: 0.85rem; color: var(--muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .insight-box {
            background: linear-gradient(135deg, rgba(214,166,107,0.08) 0%, rgba(96,165,250,0.06) 100%);
            border: 1px solid rgba(214,166,107,0.2);
            border-radius: 12px; padding: 18px 20px;
            font-size: 0.9rem; color: var(--muted); line-height: 1.7;
            margin-top: 16px;
        }
        .insight-box strong { color: var(--accent); }
    </style>
</head>
<body>

<div class="container">

    <!-- SECTION 1: Hero Banner -->
    <div class="hero" style="background-image: linear-gradient(rgba(11, 15, 25, 0.7), rgba(11, 15, 25, 0.95)), url('${not empty images ? images[0].imageUrl : 'https://images.unsplash.com/photo-1506461883276-594a12b11ac3?auto=format&fit=crop&w=1920&q=80'}'); background-size: cover; background-position: center;">
        <div class="hero-badge">AI Trip Plan</div>
        <h1><c:out value="${itinerary.title}"/></h1>
        <p class="hero-story"><c:out value="${itinerary.destination_story != null ? itinerary.destination_story : itinerary.trip_summary}"/></p>
        <div style="display:flex;align-items:center;gap:20px;flex-wrap:wrap;">
            <div class="score-ring">
                <span class="num">${not empty itinerary.trip_score ? itinerary.trip_score : '94'}</span>
                <div>
                    <div style="font-weight:600;font-size:0.9rem;">Trip Score</div>
                    <div class="label">out of 100</div>
                </div>
            </div>
            <c:if test="${not empty itinerary.ai_recommendation_insight}">
                <div class="insight-box" style="flex:1;min-width:200px;margin-top:0;">
                    <strong>AI Insight:</strong> <c:out value="${itinerary.ai_recommendation_insight}"/>
                </div>
            </c:if>
        </div>
    </div>

    <!-- SECTION 2: AI Generated Trip Summary -->
    <div class="card">
        <div class="card-title"><span class="icon">📊</span> Trip Summary</div>
        <p class="hero-story" style="margin-bottom: 24px;"><c:out value="${itinerary.trip_summary != null ? itinerary.trip_summary : itinerary.destination_story}"/></p>
        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-val"><c:out value="${not empty itinerary.best_season ? itinerary.best_season : 'October to May'}"/></div>
                <div class="stat-lbl">Best Season</div>
            </div>
            <div class="stat-box">
                <div class="stat-val"><c:out value="${not empty itinerary.recommended_duration ? itinerary.recommended_duration : '4-5 Days'}"/></div>
                <div class="stat-lbl">Duration</div>
            </div>
            <div class="stat-box">
                <div class="stat-val"><c:out value="${not empty itinerary.best_travel_mode ? itinerary.best_travel_mode : 'Cab / Local Transit'}"/></div>
                <div class="stat-lbl">Travel Mode</div>
            </div>
            <div class="stat-box">
                <div class="stat-val"><c:out value="${not empty itinerary.weather ? itinerary.weather : 'Partly Cloudy, 22°C'}"/></div>
                <div class="stat-lbl">Weather</div>
            </div>
        </div>
    </div>

    <!-- SECTION 3: Day-wise Itinerary -->
    <div class="card">
        <div class="card-title"><span class="icon">📅</span> Day-by-Day Itinerary</div>
        <div id="daysContainer">
            <c:forEach items="${itinerary.days}" var="day">
                <div class="day-card">
                    <div class="day-header" onclick="var body = this.nextElementSibling; requestAnimationFrame(function() { body.style.display = body.style.display === 'none' ? 'block' : 'none'; });">
                        <div class="day-num">${day.day}</div>
                        <div class="day-info">
                            <div class="day-title-text"><c:out value="${day.title}"/></div>
                            <div class="day-meta">🌤 <c:out value="${day.weather_forecast}"/> &nbsp;·&nbsp; 🚶 <c:out value="${day.walking_km}"/></div>
                        </div>
                        <span class="day-badge badge-moderate"><c:out value="${day.difficulty_level}"/></span>
                    </div>
                    <div class="day-body">
                        <div class="day-story"><c:out value="${day.daily_story}"/></div>
                        <c:forEach items="${day.activities}" var="act">
                            <div class="activity-row">
                                <div class="act-time"><c:out value="${act.time_slot != null ? act.time_slot : act.time}"/></div>
                                <div class="act-body">
                                    <div class="act-title">
                                        <c:out value="${act.title}"/>
                                        <span class="cat-pill"><c:out value="${act.category}"/></span>
                                    </div>
                                    <div class="act-desc"><c:out value="${act.description}"/></div>
                                    <div style="font-size:0.78rem;color:var(--muted);margin-top:3px;">⏱ <c:out value="${act.recommended_duration}"/></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- SECTION 4: Destination Gallery (Unsplash images) -->
    <div class="card">
        <div class="card-title"><span class="icon">🖼️</span> Destination Gallery</div>
        <div class="media-grid">
            <c:forEach items="${images}" var="img">
                <div class="media-item">
                    <img src="${img.imageUrl}" alt="${img.description}" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <div class="media-caption"><c:out value="${img.description}"/></div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- SECTION 5: Travel Videos (YouTube embeds) -->
    <div class="card">
        <div class="card-title"><span class="icon">🎥</span> Travel Videos & Vlogs</div>
        <div class="media-grid">
            <c:forEach items="${videos}" var="vid">
                <div class="media-item">
                    <iframe src="https://www.youtube.com/embed/${vid.videoId}" allowfullscreen loading="lazy"></iframe>
                    <div class="media-caption"><c:out value="${vid.title}"/></div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- SECTION 6: Recommended Restaurants -->
    <c:if test="${not empty restaurants}">
        <div class="card">
            <div class="card-title"><span class="icon">🍽️</span> Recommended Restaurants</div>
            <div>
                <c:forEach items="${restaurants}" var="r">
                    <div class="trail-card">
                        <div class="trail-title"><c:out value="${r.name}"/> <span style="font-weight:400;color:var(--muted);"><c:out value="${r.category}"/></span></div>
                        <div class="meal-row"><span class="meal-label">⭐ Rating</span><span class="meal-val"><c:out value="${r.rating}"/> / 5 &nbsp;·&nbsp; <c:out value="${r.price_range}"/> &nbsp;·&nbsp; <c:out value="${r.crowd_level}"/></span></div>
                        <div class="meal-row"><span class="meal-label">About</span><span class="meal-val"><c:out value="${r.description}"/></span></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- SECTION 7: Local Foods -->
    <c:if test="${not empty itinerary.local_food_specialties}">
        <div class="card">
            <div class="card-title"><span class="icon">🍴</span> Local Foods & Specialties</div>
            <div class="tag-list">
                <c:forEach items="${itinerary.local_food_specialties}" var="food">
                    <span class="tag food">🍴 <c:out value="${food}"/></span>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- SECTION 8: Must Visit Attractions -->
    <c:if test="${not empty attractions}">
        <div class="card">
            <div class="card-title"><span class="icon">🏛️</span> Must Visit Attractions</div>
            <div class="gem-grid">
                <c:forEach items="${attractions}" var="att">
                    <div class="gem-card">
                        <div class="gem-name">💎 <c:out value="${att.name != null ? att.name : att}"/></div>
                        <c:if test="${not empty att.description}">
                            <div class="gem-desc"><c:out value="${att.description}"/></div>
                        </c:if>
                        <c:if test="${not empty att.overall_score}">
                            <div class="gem-scores">
                                <span class="gem-score">Beauty <c:out value="${att.beauty_score}"/></span>
                                <span class="gem-score">Peace <c:out value="${att.peace_score}"/></span>
                                <span class="gem-score">Photo <c:out value="${att.photo_score}"/></span>
                                <span class="gem-score">Score <c:out value="${att.overall_score}"/></span>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- SECTION 9: Budget Breakdown -->
    <div class="card">
        <div class="card-title"><span class="icon">💰</span> Budget Breakdown</div>
        <div class="budget-grid">
            <div class="budget-box">
                <div class="b-label">✈️ Flights</div>
                <div class="b-val">${not empty budgetBreakdown.flights ? budgetBreakdown.flights : '₹15,000'}</div>
            </div>
            <div class="budget-box">
                <div class="b-label">🏨 Hotel</div>
                <div class="b-val">${not empty budgetBreakdown.hotel ? budgetBreakdown.hotel : '₹15,000'}</div>
            </div>
            <div class="budget-box">
                <div class="b-label">🍽️ Food</div>
                <div class="b-val">${not empty budgetBreakdown.food ? budgetBreakdown.food : '₹7,500'}</div>
            </div>
            <div class="budget-box">
                <div class="b-label">🎭 Activities</div>
                <div class="b-val">${not empty budgetBreakdown.activities ? budgetBreakdown.activities : '₹7,500'}</div>
            </div>
            <div class="budget-box">
                <div class="b-label">🚕 Transport</div>
                <div class="b-val">${not empty budgetBreakdown.transportation ? budgetBreakdown.transportation : '₹2,500'}</div>
            </div>
            <div class="budget-box">
                <div class="b-label">🛡️ Emergency</div>
                <div class="b-val">${not empty budgetBreakdown.emergency_fund ? budgetBreakdown.emergency_fund : '₹2,500'}</div>
            </div>
        </div>
    </div>

    <!-- SECTION 10: Travel Tips -->
    <c:if test="${not empty travelTips}">
        <div class="card">
            <div class="card-title"><span class="icon">💡</span> Travel Tips</div>
            <div class="tip-list">
                <c:forEach items="${travelTips}" var="tip">
                    <div class="tip-item">
                        <span class="tip-icon">💡</span>
                        <span class="tip-text"><c:out value="${tip}"/></span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- SECTION 11: Book Hotels -->
    <div class="card" style="text-align: center; padding: 40px 20px;">
        <span style="font-size: 3rem; display: block; margin-bottom: 15px;">🏨</span>
        <h3 style="font-family: 'Outfit', sans-serif; font-size: 1.5rem; margin-bottom: 10px; color: var(--accent);">Find Luxury Stays in <c:out value="${destination}"/></h3>
        <p style="color: var(--muted); font-size: 0.9rem; max-width: 500px; margin: 0 auto 20px;">Compare top-rated premium hotels and deals matching your budget.</p>
        <a href="${pageContext.request.contextPath}/hotels?q=${destination}" class="btn btn-primary">Book Hotels Now</a>
    </div>

    <!-- SECTION 12: Book Flights -->
    <div class="card" style="text-align: center; padding: 40px 20px;">
        <span style="font-size: 3rem; display: block; margin-bottom: 15px;">✈️</span>
        <h3 style="font-family: 'Outfit', sans-serif; font-size: 1.5rem; margin-bottom: 10px; color: var(--accent);">Book Flights to <c:out value="${destination}"/></h3>
        <p style="color: var(--muted); font-size: 0.9rem; max-width: 500px; margin: 0 auto 20px;">Get real-time airfares and exclusive flight packages for your dates.</p>
        <a href="${pageContext.request.contextPath}/search?type=flight&to=${destination}" class="btn btn-primary">Search Flights</a>
    </div>

    <!-- SECTION 13: Save Itinerary -->
    <div class="card" style="text-align: center; padding: 40px 20px;">
        <span style="font-size: 3rem; display: block; margin-bottom: 15px;">💾</span>
        <h3 style="font-family: 'Outfit', sans-serif; font-size: 1.5rem; margin-bottom: 10px; color: var(--accent);">Save Itinerary to Profile</h3>
        <p style="color: var(--muted); font-size: 0.9rem; max-width: 500px; margin: 0 auto 20px;">Save this travel plan to access it anytime or share it with your friends.</p>
        <form action="${pageContext.request.contextPath}/my-plans" method="POST" style="display: inline-block;">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="itineraryName" value="${itinerary.title}">
            <button type="submit" class="btn btn-primary">Save to Profile</button>
        </form>
    </div>

    <!-- SECTION 14: Download PDF / Actions -->
    <div class="actions">
        <a href="${pageContext.request.contextPath}/planner" class="btn btn-ghost">← Plan Another Trip</a>
        <button class="btn btn-primary" onclick="window.print()">🖨️ Download PDF / Print</button>
    </div>

</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    console.log("Unsplash Loaded");
    console.log("YouTube Loaded");
    console.log("Forwarding To Result Page");
});
</script>
<%@ include file="/components/footer.jsp" %>
</body>
</html>
