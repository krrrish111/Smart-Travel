<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

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

        /* ── Loading / Error ── */
        #loadingState {
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; min-height: 60vh; gap: 20px;
        }
        .spinner {
            width: 50px; height: 50px; border: 3px solid rgba(214,166,107,0.2);
            border-top-color: var(--accent); border-radius: 50%;
            animation: spin 0.9s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        #loadingState h2 { color: var(--accent); font-size: 1.5rem; }
        #loadingState p  { color: var(--muted); font-size: 0.9rem; }

        #errorState {
            display: none; text-align: center; padding: 60px 20px;
            background: rgba(248,113,113,0.08); border: 1px solid rgba(248,113,113,0.3);
            border-radius: 16px; margin-top: 40px;
        }
        #errorState h2 { color: var(--red); margin-bottom: 10px; }
        #errorState p  { color: var(--muted); }

        #contentState { display: none; }

        /* ── Hero banner ── */
        .hero {
            background: linear-gradient(135deg, #1a2033 0%, #0d1526 100%);
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

        /* ── Score breakdown ── */
        .score-bars { display: flex; flex-direction: column; gap: 10px; }
        .score-row { display: flex; align-items: center; gap: 12px; }
        .score-row .s-name { width: 110px; font-size: 0.85rem; color: var(--muted); text-transform: capitalize; }
        .bar-track { flex: 1; background: rgba(255,255,255,0.06); border-radius: 4px; height: 8px; overflow: hidden; }
        .bar-fill { height: 100%; border-radius: 4px; background: linear-gradient(90deg, var(--accent), var(--accent2)); transition: width 0.6s ease; }
        .s-num { width: 28px; font-size: 0.85rem; font-weight: 600; color: var(--text); text-align: right; }

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

        .day-body { padding: 0 20px 20px; }
        .day-story { color: var(--muted); font-size: 0.88rem; margin: 12px 0 16px; line-height: 1.6; }
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
        .cat-pill.food   { background: rgba(251,146,60,0.12); color: #fb923c; }
        .cat-pill.hidden { background: rgba(167,139,250,0.12); color: var(--purple); }

        /* ── Lists ── */
        .tag-list { display: flex; flex-wrap: wrap; gap: 10px; }
        .tag {
            background: var(--surface2); border: 1px solid rgba(255,255,255,0.07);
            border-radius: 20px; padding: 6px 14px; font-size: 0.85rem; color: var(--text);
            transition: border-color 0.2s;
        }
        .tag:hover { border-color: rgba(214,166,107,0.35); }
        .tag.gem    { border-color: rgba(167,139,250,0.25); color: var(--purple); }
        .tag.insta  { border-color: rgba(251,191,36,0.25); color: #fbbf24; }
        .tag.food   { border-color: rgba(251,146,60,0.25); color: #fb923c; }
        .tag.event  { border-color: rgba(96,165,250,0.25); color: var(--blue); }

        /* ── Hidden gems detailed ── */
        .gem-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap: 16px; }
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

        /* ── Warning ── */
        .warn-item {
            display: flex; gap: 12px; align-items: flex-start;
            background: rgba(248,113,113,0.06); padding: 12px 16px; border-radius: 10px;
            border-left: 3px solid var(--red); margin-bottom: 10px;
        }
        .warn-text { font-size: 0.88rem; color: #fca5a5; line-height: 1.5; }

        /* ── Gamification ── */
        .badge-list { display: flex; flex-direction: column; gap: 10px; }
        .badge-item {
            display: flex; gap: 12px; align-items: center;
            background: rgba(96,165,250,0.06); padding: 12px 16px; border-radius: 10px;
            border: 1px solid rgba(96,165,250,0.15);
        }
        .badge-icon { font-size: 1.3rem; }
        .badge-text { font-size: 0.88rem; color: var(--blue); }

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

<%-- Hidden container: server writes raw JSON here, JS reads it --%>
<div id="hdnItineraryJson" style="display:none;"><c:out value="${itineraryJson}"/></div>

<div class="container">

    <!-- Loading State -->
    <div id="loadingState">
        <div class="spinner"></div>
        <h2>Parsing AI Itinerary…</h2>
        <p>Building your personalised trip plan</p>
    </div>

    <!-- Error State -->
    <div id="errorState">
        <h2>⚠️ Unable to parse trip plan</h2>
        <p id="errorMsg">The AI response could not be processed. Please try again.</p>
        <br>
        <a href="/voyastra/planner" class="btn btn-primary">← Try Again</a>
    </div>

    <!-- Content State -->
    <div id="contentState">

        <!-- Hero -->
        <div class="hero">
            <div class="hero-badge" id="heroBadge">AI Trip Plan</div>
            <h1 id="heroTitle">Your Perfect Itinerary</h1>
            <p class="hero-story" id="heroStory"></p>
            <div style="display:flex;align-items:center;gap:20px;flex-wrap:wrap;">
                <div class="score-ring">
                    <span class="num" id="tripScore">--</span>
                    <div>
                        <div style="font-weight:600;font-size:0.9rem;">Trip Score</div>
                        <div class="label">out of 100</div>
                    </div>
                </div>
                <div id="heroInsight" class="insight-box" style="flex:1;min-width:200px;margin-top:0;"></div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="card">
            <div class="card-title"><span class="icon">📊</span> Trip Overview</div>
            <div class="stats-grid" id="statsGrid"></div>
        </div>

        <!-- Score Breakdown -->
        <div class="card" id="scoreCard">
            <div class="card-title"><span class="icon">🎯</span> Score Breakdown</div>
            <div class="score-bars" id="scoreBars"></div>
        </div>

        <!-- Budget Breakdown -->
        <div class="card" id="budgetCard">
            <div class="card-title"><span class="icon">💰</span> Budget Breakdown</div>
            <div class="budget-grid" id="budgetGrid"></div>
        </div>

        <!-- Day-by-Day -->
        <div class="card" id="daysCard">
            <div class="card-title"><span class="icon">📅</span> Day-by-Day Itinerary</div>
            <div id="daysContainer"></div>
        </div>

        <!-- Must Visit -->
        <div class="card" id="mustCard">
            <div class="card-title"><span class="icon">🏛️</span> Must Visit</div>
            <div class="tag-list" id="mustList"></div>
        </div>

        <!-- Hidden Gems -->
        <div class="card" id="gemsCard">
            <div class="card-title"><span class="icon">💎</span> Hidden Gems</div>
            <div class="gem-grid" id="gemGrid"></div>
        </div>

        <!-- Food & Cuisine -->
        <div class="card" id="foodCard">
            <div class="card-title"><span class="icon">🍽️</span> Food Discovery</div>
            <div class="tag-list" id="foodList" style="margin-bottom:16px;"></div>
            <div id="foodDetailed"></div>
        </div>

        <!-- Food Trails -->
        <div class="card" id="trailsCard" style="display:none;">
            <div class="card-title"><span class="icon">🗺️</span> Food Trails</div>
            <div id="trailsContainer"></div>
        </div>

        <!-- Instagram Spots -->
        <div class="card" id="instaCard">
            <div class="card-title"><span class="icon">📸</span> Instagram Spots</div>
            <div class="tag-list" id="instaList"></div>
        </div>

        <!-- Events -->
        <div class="card" id="eventsCard" style="display:none;">
            <div class="card-title"><span class="icon">🎉</span> Events & Festivals</div>
            <div class="tag-list" id="eventList"></div>
        </div>

        <!-- Travel Warnings -->
        <div class="card" id="warnCard" style="display:none;">
            <div class="card-title"><span class="icon">⚠️</span> Travel Warnings</div>
            <div id="warnList"></div>
        </div>

        <!-- Travel Tips -->
        <div class="card" id="tipsCard">
            <div class="card-title"><span class="icon">💡</span> Travel Tips</div>
            <div class="tip-list" id="tipList"></div>
        </div>

        <!-- Gamification -->
        <div class="card" id="gamCard" style="display:none;">
            <div class="card-title"><span class="icon">🏆</span> Badges to Earn</div>
            <div class="badge-list" id="gamList"></div>
        </div>

        <!-- Actions -->
        <div class="actions">
            <a href="/voyastra/planner" class="btn btn-ghost">← Plan Another Trip</a>
            <button class="btn btn-primary" onclick="window.print()">🖨️ Print / Save PDF</button>
        </div>
    </div><!-- /contentState -->

</div><!-- /container -->

<script>
document.addEventListener('DOMContentLoaded', function() {
    const raw = document.getElementById('hdnItineraryJson').textContent.trim();
    console.log('[PlannerResult] raw length:', raw.length);

    function hide(id) { var el = document.getElementById(id); if(el) el.style.display='none'; }
    function show(id, disp) { var el = document.getElementById(id); if(el) el.style.display = disp||'block'; }
    function el(id) { return document.getElementById(id); }
    function esc(s) { return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    function showError(msg) {
        hide('loadingState');
        show('errorState');
        var em = el('errorMsg'); if(em) em.textContent = msg || 'Unknown error';
    }

    if (!raw || raw === 'null' || raw === '') {
        showError('No itinerary data was returned. Please try generating your trip again.');
        return;
    }

    var data;
    try {
        data = JSON.parse(raw);
    } catch(e) {
        console.error('[PlannerResult] JSON parse error:', e, 'raw preview:', raw.substring(0, 300));
        showError('Could not parse the AI response: ' + e.message);
        return;
    }

    console.log('[PlannerResult] Parsed OK. Keys:', Object.keys(data));

    // ── Show content ──────────────────────────────────────────────
    hide('loadingState');
    show('contentState');

    // ── Hero ──────────────────────────────────────────────────────
    var title = data.title || data.trip_summary || 'Your Trip Plan';
    el('heroTitle').textContent = title;
    el('heroBadge').textContent = 'AI Trip Plan';
    el('heroStory').textContent = data.destination_story || data.trip_summary || '';
    el('tripScore').textContent = data.trip_score || '--';
    el('heroInsight').innerHTML = data.ai_recommendation_insight
        ? '<strong>AI Insight:</strong> ' + esc(data.ai_recommendation_insight)
        : '';

    // ── Quick Stats ───────────────────────────────────────────────
    var stats = [
        { val: data.best_season || '--',            lbl: 'Best Season'    },
        { val: data.recommended_duration || '--',   lbl: 'Duration'       },
        { val: data.best_travel_mode || '--',       lbl: 'Travel Mode'    },
        { val: data.weather || '--',                lbl: 'Weather'        }
    ];
    var sg = el('statsGrid'); sg.innerHTML = '';
    stats.forEach(function(s) {
        sg.innerHTML += '<div class="stat-box"><div class="stat-val">' + esc(s.val) + '</div><div class="stat-lbl">' + s.lbl + '</div></div>';
    });

    // ── Score Breakdown ───────────────────────────────────────────
    var sb = data.trip_score_breakdown;
    if (sb && typeof sb === 'object' && Object.keys(sb).length > 0) {
        var sbEl = el('scoreBars'); sbEl.innerHTML = '';
        Object.entries(sb).forEach(function(pair) {
            var name = pair[0].replace(/_/g,' '), val = Number(pair[1]) || 0;
            var pct = Math.min(100, val * 10);
            sbEl.innerHTML += '<div class="score-row">' +
                '<span class="s-name">' + esc(name) + '</span>' +
                '<div class="bar-track"><div class="bar-fill" style="width:' + pct + '%"></div></div>' +
                '<span class="s-num">' + val + '</span></div>';
        });
    } else { hide('scoreCard'); }

    // ── Budget ────────────────────────────────────────────────────
    var bb = data.budget_breakdown;
    if (bb && typeof bb === 'object') {
        var bgEl = el('budgetGrid'); bgEl.innerHTML = '';
        var labels = { flights:'✈️ Flights', hotel:'🏨 Hotel', food:'🍽️ Food',
                       activities:'🎭 Activities', transportation:'🚕 Transport', emergency_fund:'🛡️ Emergency' };
        Object.entries(bb).forEach(function(pair) {
            var key = pair[0], val = pair[1];
            bgEl.innerHTML += '<div class="budget-box"><div class="b-label">' +
                (labels[key]||key) + '</div><div class="b-val">' + esc(val) + '</div></div>';
        });
    } else { hide('budgetCard'); }

    // ── Days ──────────────────────────────────────────────────────
    var days = data.days;
    if (days && Array.isArray(days) && days.length > 0) {
        var dc = el('daysContainer'); dc.innerHTML = '';
        days.forEach(function(day) {
            var diff = (day.difficulty_level||'').toLowerCase();
            var badgeClass = diff.indexOf('easy') >= 0 ? 'badge-easy'
                           : diff.indexOf('hard') >= 0 ? 'badge-hard' : 'badge-moderate';
            var actsHtml = '';
            if (day.activities && Array.isArray(day.activities)) {
                day.activities.forEach(function(act) {
                    var cat = (act.category||'').toLowerCase();
                    var catClass = cat.indexOf('food') >= 0 ? 'food'
                                 : (cat.indexOf('hidden') >= 0 || cat.indexOf('gem') >= 0) ? 'hidden' : '';
                    actsHtml += '<div class="activity-row">' +
                        '<div class="act-time">' + esc(act.time_slot||'') + '</div>' +
                        '<div class="act-body">' +
                        '  <div class="act-title">' + esc(act.title||'') +
                        '    <span class="cat-pill ' + catClass + '">' + esc(act.category||'') + '</span>' +
                        '  </div>' +
                        '  <div class="act-desc">' + esc(act.description||'') + '</div>' +
                        '  <div style="font-size:0.78rem;color:var(--muted);margin-top:3px;">⏱ ' + esc(act.recommended_duration||'') + '</div>' +
                        '</div></div>';
                });
            }
            dc.innerHTML += '<div class="day-card">' +
                '<div class="day-header">' +
                '  <div class="day-num">' + (day.day||'') + '</div>' +
                '  <div class="day-info">' +
                '    <div class="day-title-text">' + esc(day.title||('Day '+day.day)) + '</div>' +
                '    <div class="day-meta">🌤 ' + esc(day.weather_forecast||'') + ' &nbsp;·&nbsp; 🚶 ' + esc(day.walking_km||'') + '</div>' +
                '  </div>' +
                '  <span class="day-badge ' + badgeClass + '">' + esc(day.difficulty_level||'') + '</span>' +
                '</div>' +
                '<div class="day-body">' +
                '  <div class="day-story">' + esc(day.daily_story||'') + '</div>' +
                actsHtml +
                '</div></div>';
        });
    } else { hide('daysCard'); }

    // ── Must Visit ────────────────────────────────────────────────
    var mv = data.must_visit;
    if (mv && Array.isArray(mv) && mv.length > 0) {
        var ml = el('mustList'); ml.innerHTML = '';
        mv.forEach(function(p) { ml.innerHTML += '<span class="tag">🏛 ' + esc(p) + '</span>'; });
    } else { hide('mustCard'); }

    // ── Hidden Gems Detailed ──────────────────────────────────────
    var hgd = data.hidden_gems_detailed;
    if (hgd && Array.isArray(hgd) && hgd.length > 0) {
        var gg = el('gemGrid'); gg.innerHTML = '';
        hgd.forEach(function(gem) {
            gg.innerHTML += '<div class="gem-card">' +
                '<div class="gem-name">💎 ' + esc(gem.name||'') + '</div>' +
                '<div class="gem-desc">' + esc(gem.description||'') + '</div>' +
                '<div class="gem-scores">' +
                '  <span class="gem-score">Beauty ' + (gem.beauty_score||'?') + '</span>' +
                '  <span class="gem-score">Peace ' + (gem.peace_score||'?') + '</span>' +
                '  <span class="gem-score">Photo ' + (gem.photo_score||'?') + '</span>' +
                '  <span class="gem-score">Score ' + (gem.overall_score||'?') + '</span>' +
                '</div></div>';
        });
    } else { hide('gemsCard'); }

    // ── Food Discovery ────────────────────────────────────────────
    var fd = data.food_discovery;
    var fdHasItems = fd && Array.isArray(fd) && fd.length > 0;
    var fdd = data.food_discovery_detailed;
    var fddHasItems = fdd && Array.isArray(fdd) && fdd.length > 0;
    if (fdHasItems || fddHasItems) {
        if (fdHasItems) {
            var fl = el('foodList'); fl.innerHTML = '';
            fd.forEach(function(f) { fl.innerHTML += '<span class="tag food">🍴 ' + esc(f) + '</span>'; });
        }
        if (fddHasItems) {
            var fde = el('foodDetailed'); fde.innerHTML = '';
            fdd.forEach(function(r) {
                fde.innerHTML += '<div class="trail-card">' +
                    '<div class="trail-title">' + esc(r.name||'') + ' <span style="font-weight:400;color:var(--muted);">' + esc(r.category||'') + '</span></div>' +
                    '<div class="meal-row"><span class="meal-label">⭐ Rating</span><span class="meal-val">' + esc(String(r.rating||'')) + ' / 5 &nbsp;·&nbsp; ' + esc(r.price_range||'') + ' &nbsp;·&nbsp; ' + esc(r.crowd_level||'') + '</span></div>' +
                    '<div class="meal-row"><span class="meal-label">About</span><span class="meal-val">' + esc(r.description||'') + '</span></div>' +
                    '</div>';
            });
        }
    } else { hide('foodCard'); }

    // ── Food Trails ───────────────────────────────────────────────
    var ft = data.food_trails;
    if (ft && Array.isArray(ft) && ft.length > 0) {
        show('trailsCard');
        var tc = el('trailsContainer'); tc.innerHTML = '';
        ft.forEach(function(trail) {
            tc.innerHTML += '<div class="trail-card">' +
                '<div class="trail-title">🗺 ' + esc(trail.title||'') + '</div>' +
                '<div class="meal-row"><span class="meal-label">Breakfast</span><span class="meal-val">' + esc(trail.breakfast||'') + '</span></div>' +
                '<div class="meal-row"><span class="meal-label">Lunch</span><span class="meal-val">'    + esc(trail.lunch||'') + '</span></div>' +
                '<div class="meal-row"><span class="meal-label">Evening</span><span class="meal-val">'  + esc(trail.evening||'') + '</span></div>' +
                '<div class="meal-row"><span class="meal-label">Dinner</span><span class="meal-val">'   + esc(trail.dinner||'') + '</span></div>' +
                '</div>';
        });
    }

    // ── Instagram Spots ───────────────────────────────────────────
    var is_ = data.instagram_spots;
    if (is_ && Array.isArray(is_) && is_.length > 0) {
        var il = el('instaList'); il.innerHTML = '';
        is_.forEach(function(s) { il.innerHTML += '<span class="tag insta">📸 ' + esc(s) + '</span>'; });
    } else { hide('instaCard'); }

    // ── Events ────────────────────────────────────────────────────
    var ev = data.events_detected;
    if (ev && Array.isArray(ev) && ev.length > 0) {
        show('eventsCard');
        var evl = el('eventList'); evl.innerHTML = '';
        ev.forEach(function(e) { evl.innerHTML += '<span class="tag event">🎉 ' + esc(e) + '</span>'; });
    }

    // ── Travel Warnings ───────────────────────────────────────────
    var tw = data.travel_warnings;
    if (tw && Array.isArray(tw) && tw.length > 0) {
        show('warnCard');
        var wl = el('warnList'); wl.innerHTML = '';
        tw.forEach(function(w) {
            wl.innerHTML += '<div class="warn-item"><span style="font-size:1rem;">⚠️</span><span class="warn-text">' + esc(w) + '</span></div>';
        });
    }

    // ── Travel Tips ───────────────────────────────────────────────
    var tips = data.travel_tips;
    if (tips && Array.isArray(tips) && tips.length > 0) {
        var tl = el('tipList'); tl.innerHTML = '';
        tips.forEach(function(t) {
            tl.innerHTML += '<div class="tip-item"><span class="tip-icon">💡</span><span class="tip-text">' + esc(t) + '</span></div>';
        });
    } else { hide('tipsCard'); }

    // ── Gamification ──────────────────────────────────────────────
    var gam = data.gamification;
    if (gam && Array.isArray(gam) && gam.length > 0) {
        show('gamCard');
        var gl = el('gamList'); gl.innerHTML = '';
        gam.forEach(function(g) {
            gl.innerHTML += '<div class="badge-item"><span class="badge-icon">🏅</span><span class="badge-text">' + esc(g) + '</span></div>';
        });
    }

    console.log('[PlannerResult] Render complete.');
});
</script>

<%@ include file="/components/footer.jsp" %>
</body>
</html>
