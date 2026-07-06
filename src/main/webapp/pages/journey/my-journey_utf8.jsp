<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    :root {
        --profile-sidebar-width: 280px;
    }

    body {
        background: radial-gradient(circle at top right, rgba(255, 107, 0, 0.05), transparent),
                    radial-gradient(circle at bottom left, rgba(0, 122, 255, 0.05), transparent),
                    #0a0a0a;
        color: white;
    }

    .dashboard-container {
        max-width: 1400px;
        margin: 40px auto;
        padding: 0 20px;
        display: grid;
        grid-template-columns: var(--profile-sidebar-width) 1fr;
        gap: 30px;
        position: relative;
        z-index: 1;
    }

    /* Disable the fixed scroll-line on dashboard to prevent click blocking */
    .scroll-line-container { display: none !important; }

    /* Sidebar Navigation */
    .profile-sidebar {
        z-index: 10; position: relative;
        background: var(--surface-glass);
        backdrop-filter: blur(12px);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 24px;
        height: fit-content;
        position: sticky;
        top: 100px;
    }

    .nav-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 18px;
        border-radius: 12px;
        color: var(--text-secondary);
        text-decoration: none;
        transition: all 0.3s ease;
        margin-bottom: 8px;
        font-weight: 500;
        cursor: pointer;
    }

    .nav-item:hover {
        background: rgba(255, 255, 255, 0.05);
        color: white;
    }

    .nav-item.active {
        background: var(--primary);
        color: white;
        box-shadow: 0 4px 15px rgba(255, 107, 0, 0.3);
    }

    /* Tab Contents */
    .tab-content {
        display: none;
        animation: fadeIn 0.4s ease forwards;
    }
    .tab-content.active {
        display: block;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Generic Panels */
    .panel {
        background: var(--surface-glass);
        backdrop-filter: blur(12px);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    }
    .panel h2 {
        font-size: 1.8rem;
        margin-bottom: 20px;
        font-family: 'Clash Display', sans-serif;
        color: white;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* Metrics Grid */
    .metrics-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
    }
    .metric-card {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid var(--color-border);
        padding: 20px;
        border-radius: 16px;
        text-align: center;
        transition: transform 0.3s ease;
    }
    .metric-card:hover { transform: translateY(-5px); }
    .metric-card h3 { font-size: 2.2rem; color: var(--primary); margin-bottom: 5px; font-family: 'Clash Display', sans-serif; }
    .metric-card span { font-size: 0.9rem; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 1px; }

    /* Active Journey Specific */
    .trip-hero {
        background: linear-gradient(135deg, var(--primary), #8E2DE2);
        padding: 40px;
        border-radius: 24px;
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 15px 35px rgba(255, 107, 0, 0.2);
    }
    .trip-hero h1 { font-size: 3.5rem; margin-bottom: 10px; font-family: 'Clash Display', sans-serif; }
    .progress-circle {
        width: 120px; height: 120px;
        border-radius: 50%;
        border: 8px solid rgba(255,255,255,0.2);
        display: flex; align-items: center; justify-content: center;
        font-size: 2.5rem; font-weight: bold;
    }

    /* Plan Timeline */
    .plan-timeline { border-left: 2px solid var(--color-border); margin-left: 20px; padding-left: 30px; }
    .plan-item { position: relative; margin-bottom: 30px; }
    .plan-item::before {
        content: ''; position: absolute; left: -37px; top: 0;
        width: 12px; height: 12px; border-radius: 50%;
        background: var(--primary);
        box-shadow: 0 0 0 4px rgba(255, 107, 0, 0.2);
    }
    .plan-time { font-weight: bold; color: var(--primary); margin-bottom: 5px; display: block; font-size: 1.1rem;}

    /* Memories Masonry */
    .memories-grid {
        display: column;
        column-count: 3;
        column-gap: 20px;
    }
    .memory-item {
        break-inside: avoid;
        margin-bottom: 20px;
        border-radius: 16px;
        overflow: hidden;
        position: relative;
        background: rgba(255,255,255,0.05);
        border: 1px solid var(--color-border);
    }
    .memory-item img { width: 100%; display: block; border-radius: 16px 16px 0 0; }
    .memory-caption { padding: 15px; font-size: 0.95rem; color: var(--text-secondary); }

    /* Custom CSS Calendar */
    .calendar {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 10px;
        text-align: center;
    }
    .cal-header { font-weight: bold; color: var(--text-secondary); padding: 10px; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; }
    .cal-day {
        background: rgba(255,255,255,0.03);
        border: 1px solid var(--color-border);
        border-radius: 12px;
        padding: 20px 10px;
        font-size: 1.2rem;
        cursor: pointer;
        transition: all 0.2s ease;
        position: relative;
    }
    .cal-day:hover { background: rgba(255,255,255,0.1); }
    .cal-day.has-trip { border-color: var(--primary); color: var(--primary); }
    .cal-day.has-trip::after {
        content: ''; position: absolute; bottom: 8px; left: 50%; transform: translateX(-50%);
        width: 6px; height: 6px; border-radius: 50%; background: var(--primary);
    }

    /* DNA Bars */
    .dna-bar-container { margin-bottom: 20px; }
    .dna-bar-header { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 1rem; color: white; }
    .dna-track { background: rgba(255,255,255,0.1); height: 8px; border-radius: 4px; overflow: hidden; }
    .dna-fill { height: 100%; border-radius: 4px; }

    @media (max-width: 900px) {
        .dashboard-container { grid-template-columns: 1fr; }
        .profile-sidebar { position: static; display: flex; overflow-x: auto; padding: 15px; border-radius: 16px; white-space: nowrap; }
        .nav-item { padding: 10px 15px; margin-bottom: 0; }
        .memories-grid { column-count: 2; }
        .trip-hero { flex-direction: column; text-align: center; gap: 20px; }
    }
    @media (max-width: 600px) {
        .memories-grid { column-count: 1; }
        .calendar { gap: 5px; }
        .cal-day { padding: 10px 5px; font-size: 1rem; }
    }
</style>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="profile-sidebar">
        <a class="nav-item ${activeTab == 'overview' ? 'active' : ''}" onclick="switchTab('overview', this)">
            <i class="ri-dashboard-line" style="font-size: 1.2rem;"></i> Overview
        </a>
        <a class="nav-item ${activeTab == 'active' ? 'active' : ''}" onclick="switchTab('active', this)">
            <i class="ri-compass-3-line" style="font-size: 1.2rem;"></i> Active Journey
        </a>
        <a class="nav-item ${activeTab == 'upcoming' ? 'active' : ''}" onclick="switchTab('upcoming', this)">
            <i class="ri-flight-takeoff-line" style="font-size: 1.2rem;"></i> Upcoming Trips
        </a>
        <a class="nav-item ${activeTab == 'memories' ? 'active' : ''}" onclick="switchTab('memories', this)">
            <i class="ri-gallery-line" style="font-size: 1.2rem;"></i> Travel Memories
        </a>
        <a class="nav-item ${activeTab == 'calendar' ? 'active' : ''}" onclick="switchTab('calendar', this)">
            <i class="ri-calendar-event-line" style="font-size: 1.2rem;"></i> Travel Calendar
        </a>
        <a class="nav-item ${activeTab == 'dna' ? 'active' : ''}" onclick="switchTab('dna', this)">
            <i class="ri-dna-line" style="font-size: 1.2rem;"></i> Travel DNA
        </a>
        <a class="nav-item ${activeTab == 'family' ? 'active' : ''}" onclick="switchTab('family', this)">
            <i class="ri-group-line" style="font-size: 1.2rem;"></i> Family Hub
        </a>
        <a class="nav-item ${activeTab == 'completed' ? 'active' : ''}" onclick="switchTab('completed', this)">
            <i class="ri-history-line" style="font-size: 1.2rem;"></i> Completed Trips
        </a>
        <a class="nav-item ${activeTab == 'reports' ? 'active' : ''}" onclick="switchTab('reports', this)">
            <i class="ri-bar-chart-box-line" style="font-size: 1.2rem;"></i> Trip Reports
        </a>
    </aside>

    <!-- Main Content Area -->
    <main>
        
        <!-- TAB: OVERVIEW -->
        <div id="tab-overview" class="tab-content ${activeTab == 'overview' ? 'active' : ''}">
            
            <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px; margin-bottom: 30px;">
                <div class="metric-card" style="padding: 15px; border-radius: 12px; background: linear-gradient(135deg, rgba(255,255,255,0.05), rgba(0,0,0,0));">
                    <h3 style="font-size: 1.8rem; margin:0;">12</h3>
                    <span style="font-size: 0.75rem;">Total Trips</span>
                </div>
                <div class="metric-card" style="padding: 15px; border-radius: 12px; background: linear-gradient(135deg, rgba(255,255,255,0.05), rgba(0,0,0,0));">
                    <h3 style="font-size: 1.8rem; margin:0;">14</h3>
                    <span style="font-size: 0.75rem;">Countries Visited</span>
                </div>
                <div class="metric-card" style="padding: 15px; border-radius: 12px; background: linear-gradient(135deg, rgba(255,255,255,0.05), rgba(0,0,0,0));">
                    <h3 style="font-size: 1.8rem; margin:0;">35</h3>
                    <span style="font-size: 0.75rem;">Cities Visited</span>
                </div>
                <div class="metric-card" style="padding: 15px; border-radius: 12px; background: linear-gradient(135deg, rgba(255,255,255,0.05), rgba(0,0,0,0));">
                    <h3 style="font-size: 1.8rem; margin:0;">8</h3>
                    <span style="font-size: 0.75rem;">Experiences Completed</span>
                </div>
                <div class="metric-card" style="padding: 15px; border-radius: 12px; background: linear-gradient(135deg, rgba(255,255,255,0.05), rgba(0,0,0,0));">
                    <h3 style="font-size: 1.8rem; margin:0;">42</h3>
                    <span style="font-size: 0.75rem;">Community Contributions</span>
                </div>
            </div>

            <!-- Dashboard Grid -->
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px;">
                
                <!-- Main Content Column -->
                <div style="display: flex; flex-direction: column; gap: 30px;">
                    
                    <!-- Current Trip Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0;">
                        <h2 style="font-size: 1.4rem; margin-bottom: 15px;"><i class="ri-map-pin-user-line" style="color: var(--primary);"></i> Current Trip</h2>
                        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 12px; padding: 15px; display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h3 style="font-size: 1.4rem; margin-bottom: 5px;">${not empty journey ? journey.destination : 'No Active Trip'}</h3>
                                <p style="color: var(--text-secondary); font-size: 0.9rem;">
                                    ${not empty journey ? 'Day '.concat(journey.currentDay).concat(' of ').concat(journey.totalDays) : 'Plan your next adventure!'}
                                </p>
                            </div>
                            <c:if test="${not empty journey}">
                                <div style="text-align: right;">
                                    <div style="font-size: 1.5rem; font-weight: bold; color: var(--primary);">${journey.progressPercentage}%</div>
                                    <span style="font-size: 0.75rem; color: var(--text-secondary);">Progress</span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Upcoming Trips Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0;">
                        <h2 style="font-size: 1.4rem; margin-bottom: 15px;"><i class="ri-flight-takeoff-line" style="color: var(--primary);"></i> Upcoming Trips</h2>
                        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 12px; padding: 15px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                            <div>
                                <strong style="font-size: 1.1rem;">Kyoto, Japan</strong>
                                <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 5px;"><i class="ri-calendar-line"></i> Oct 12 - Oct 20, 2026</div>
                            </div>
                            <div style="background: rgba(0, 184, 148, 0.2); color: #00b894; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem;">Confirmed</div>
                        </div>
                        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 12px; padding: 15px; display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <strong style="font-size: 1.1rem;">Paris, France</strong>
                                <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 5px;"><i class="ri-calendar-line"></i> Dec 24 - Jan 2, 2027</div>
                            </div>
                            <div style="background: rgba(255, 107, 0, 0.2); color: var(--primary); padding: 4px 10px; border-radius: 20px; font-size: 0.75rem;">Planning</div>
                        </div>
                    </div>

                    <!-- Quick Actions Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0; background: linear-gradient(135deg, rgba(255,107,0,0.1), rgba(0,0,0,0));">
                        <h2 style="font-size: 1.4rem; margin-bottom: 15px;"><i class="ri-flashlight-line" style="color: #f1c40f;"></i> Quick Actions</h2>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <button class="btn btn-outline" style="flex: 1; padding: 8px; font-size: 0.85rem;" onclick="switchTab('active', document.querySelector('.nav-item:nth-child(2)'))">Continue Journey</button>
                            <button class="btn btn-outline" style="flex: 1; padding: 8px; font-size: 0.85rem;" onclick="switchTab('memories', document.querySelector('.nav-item:nth-child(4)'))">View Memories</button>
                            <button class="btn btn-outline" style="flex: 1; padding: 8px; font-size: 0.85rem;" onclick="switchTab('calendar', document.querySelector('.nav-item:nth-child(5)'))">Open Calendar</button>
                            <button class="btn btn-outline" style="flex: 1; padding: 8px; font-size: 0.85rem;" onclick="switchTab('family', document.querySelector('.nav-item:nth-child(7)'))">Family Hub</button>
                            <a href="${pageContext.request.contextPath}/travel-center" class="btn btn-primary" style="flex: 1; text-align: center; padding: 8px; font-size: 0.85rem;">Travel Center</a>
                        </div>
                    </div>

                    <!-- Recent Memories Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0;">
                        <h2 style="font-size: 1.4rem; margin-bottom: 15px;"><i class="ri-camera-lens-line" style="color: var(--primary);"></i> Recent Memories</h2>
                        <div style="display: flex; gap: 10px;">
                            <div style="flex:1; height: 120px; border-radius: 12px; background: url('https://images.unsplash.com/photo-1499856871958-5b9627545d1a?q=80&w=400&auto=format&fit=crop') center/cover;"></div>
                            <div style="flex:1; height: 120px; border-radius: 12px; background: url('https://images.unsplash.com/photo-1542051841857-5f90071e7989?q=80&w=400&auto=format&fit=crop') center/cover;"></div>
                            <div style="flex:1; height: 120px; border-radius: 12px; background: url('https://images.unsplash.com/photo-1506929562872-bb421503ef21?q=80&w=400&auto=format&fit=crop') center/cover;"></div>
                        </div>
                    </div>

                </div>

                <!-- Sidebar Column (Widgets) -->
                <div style="display: flex; flex-direction: column; gap: 30px;">
                    
                    <!-- Weather Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0; background: linear-gradient(135deg, rgba(0, 184, 148, 0.1), rgba(0,0,0,0)); text-align: center;">
                        <h2 style="font-size: 1.2rem; margin-bottom: 10px; justify-content: center;"><i class="ri-sun-cloudy-line"></i> Weather</h2>
                        <div style="font-size: 2.5rem; font-family: 'Clash Display', sans-serif; font-weight: bold; color: white;">
                            ${not empty journey ? journey.temperature : '24'}Â°C
                        </div>
                        <p style="color: var(--text-secondary); font-size: 0.9rem;">${not empty journey ? journey.weatherCondition : 'Sunny'}</p>
                    </div>

                    <!-- Travel Readiness Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0; background: rgba(30, 41, 59, 0.5);">
                        <h2 style="font-size: 1.2rem; margin-bottom: 15px;"><i class="ri-shield-check-fill" style="color: #60a5fa;"></i> Travel Readiness</h2>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <span style="font-size: 1.8rem; font-family: 'Clash Display', sans-serif; font-weight: bold;">92%</span>
                            <span style="background: rgba(74, 222, 128, 0.2); color: #4ade80; padding: 4px 8px; border-radius: 12px; font-size: 0.7rem;">Ready</span>
                        </div>
                        <div style="font-size: 0.8rem;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
                                <span style="color: var(--text-secondary);">Visa</span><span style="color: #4ade80;"><i class="ri-check-line"></i></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
                                <span style="color: var(--text-secondary);">Insurance</span><span style="color: #4ade80;"><i class="ri-check-line"></i></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
                                <span style="color: var(--text-secondary);">eSIM</span><span style="color: #fbbf24;">Pending</span>
                            </div>
                            <div style="display: flex; justify-content: space-between;">
                                <span style="color: var(--text-secondary);">Forex</span><span style="color: #fbbf24;">Pending</span>
                            </div>
                        </div>
                    </div>

                    <!-- Travel Budget Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0;">
                        <h2 style="font-size: 1.2rem; margin-bottom: 15px;"><i class="ri-wallet-3-line" style="color: var(--primary);"></i> Trip Budget</h2>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                            <span style="color: var(--text-secondary); font-size: 0.9rem;">Remaining</span>
                            <strong style="color: #00b894;">â‚¹${not empty journey ? journey.totalBudget - journey.spent : '0'}</strong>
                        </div>
                        <div class="dna-track" style="height: 6px;"><div class="dna-fill" style="width: 60%; background: #00b894;"></div></div>
                        <div style="display: flex; justify-content: space-between; margin-top: 10px;">
                            <span style="color: var(--text-secondary); font-size: 0.9rem;">Spent: â‚¹${not empty journey ? journey.spent : '0'}</span>
                            <span style="color: var(--text-secondary); font-size: 0.9rem;">Total: â‚¹${not empty journey ? journey.totalBudget : '0'}</span>
                        </div>
                    </div>

                    <!-- Travel DNA Widget -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0;">
                        <h2 style="font-size: 1.2rem; margin-bottom: 15px;"><i class="ri-dna-line" style="color: #8E2DE2;"></i> Travel DNA</h2>
                        <div class="dna-bar-container" style="margin-bottom: 10px;">
                            <div class="dna-bar-header" style="font-size: 0.85rem;"><span style="color: var(--text-secondary);">Explorer</span> <strong style="color: var(--primary);">92%</strong></div>
                            <div class="dna-track" style="height: 4px;"><div class="dna-fill" style="width: 92%; background: var(--primary);"></div></div>
                        </div>
                        <div class="dna-bar-container" style="margin-bottom: 10px;">
                            <div class="dna-bar-header" style="font-size: 0.85rem;"><span style="color: var(--text-secondary);">Foodie</span> <strong style="color: #e17055;">85%</strong></div>
                            <div class="dna-track" style="height: 4px;"><div class="dna-fill" style="width: 85%; background: #e17055;"></div></div>
                        </div>
                        <div class="dna-bar-container" style="margin-bottom: 0;">
                            <div class="dna-bar-header" style="font-size: 0.85rem;"><span style="color: var(--text-secondary);">Adventure</span> <strong style="color: #00b894;">65%</strong></div>
                            <div class="dna-track" style="height: 4px;"><div class="dna-fill" style="width: 65%; background: #00b894;"></div></div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- TAB: ACTIVE JOURNEY -->
        <div id="tab-active" class="tab-content ${activeTab == 'active' ? 'active' : ''}">
            <c:choose>
                <c:when test="${not empty journey}">
                    <div class="trip-hero">
                        <div>
                            <span style="background: rgba(255,255,255,0.2); padding: 6px 16px; border-radius: 20px; font-weight: 600; letter-spacing: 1px; font-size: 0.85rem; text-transform: uppercase;">STATUS: ${journey.status}</span>
                            <h1 style="margin-top: 15px;">${journey.destination}</h1>
                            <p style="font-size: 1.2rem; opacity: 0.9; margin-bottom: 5px;"><i class="ri-calendar-line"></i> ${journey.startDate} - ${journey.endDate}</p>
                            <p style="font-size: 1.2rem;"><strong>Day ${journey.currentDay} of ${journey.totalDays}</strong></p>
                        </div>
                        <div class="progress-circle">
                            ${journey.progressPercentage}%
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px;">
                        <div class="panel">
                            <h2><i class="ri-map-pin-time-line"></i> Today's Itinerary</h2>
                            <div class="plan-timeline" style="margin-top: 25px;">
                                <div class="plan-item">
                                    <span class="plan-time">Morning</span>
                                    <c:forEach var="item" items="${journey.morningPlan}">
                                        <div style="color: var(--text-secondary); margin-bottom: 5px;">â€¢ ${item}</div>
                                    </c:forEach>
                                </div>
                                <div class="plan-item">
                                    <span class="plan-time">Afternoon</span>
                                    <c:forEach var="item" items="${journey.afternoonPlan}">
                                        <div style="color: var(--text-secondary); margin-bottom: 5px;">â€¢ ${item}</div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="panel" style="background: linear-gradient(135deg, rgba(0, 184, 148, 0.1), rgba(0,0,0,0));">
                            <h2><i class="ri-sun-cloudy-line"></i> Weather</h2>
                            <div style="font-size: 3rem; font-weight: bold; font-family: 'Clash Display', sans-serif;">${journey.temperature}Â°C</div>
                            <p style="color: var(--text-secondary); font-size: 1.1rem; margin-bottom: 20px;">${journey.weatherCondition}</p>
                            <c:if test="${not empty journey.weatherAlert}">
                                <div style="background: rgba(255, 107, 0, 0.2); border: 1px solid var(--primary); padding: 12px; border-radius: 12px; font-size: 0.9rem; color: #fff;">
                                    <i class="ri-error-warning-line"></i> ${journey.weatherAlert}
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Additional Active Journey Widgets -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 30px;">
                        
                        <div class="panel" style="margin-bottom: 0;">
                            <h2><i class="ri-folder-open-line" style="color: var(--primary);"></i> Documents</h2>
                            <div style="display: flex; flex-direction: column; gap: 10px;">
                                <div style="background: rgba(255,255,255,0.05); padding: 15px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center;">
                                    <div><i class="ri-file-pdf-2-line" style="color: #e74c3c;"></i> E-Ticket.pdf</div>
                                    <c:choose>
                                        <c:when test="${not empty activeFlightId}">
                                            <button class="btn btn-outline" style="padding: 5px 10px; font-size: 0.8rem;" onclick="window.open('${pageContext.request.contextPath}/flight/ticket?id=${activeFlightId}&preview=true', '_blank')">View</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-outline" style="padding: 5px 10px; font-size: 0.8rem;" onclick="alert('Document not available yet.')">View</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="background: rgba(255,255,255,0.05); padding: 15px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center;">
                                    <div><i class="ri-file-pdf-2-line" style="color: #e74c3c;"></i> Hotel_Voucher.pdf</div>
                                    <c:choose>
                                        <c:when test="${not empty activeHotelId}">
                                            <button class="btn btn-outline" style="padding: 5px 10px; font-size: 0.8rem;" onclick="window.open('${pageContext.request.contextPath}/hotel-voucher?id=${activeHotelId}', '_blank')">View</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-outline" style="padding: 5px 10px; font-size: 0.8rem;" onclick="alert('Document not available yet.')">View</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="panel" style="margin-bottom: 0; background: linear-gradient(135deg, rgba(142, 45, 226, 0.1), rgba(0,0,0,0));">
                            <h2><i class="ri-robot-2-line" style="color: #8E2DE2;"></i> AI Companion</h2>
                            <p style="color: var(--text-secondary); margin-bottom: 20px;">Your travel buddy is ready to assist you.</p>
                            <a href="${pageContext.request.contextPath}/planner" class="btn btn-primary" style="width: 100%; text-align: center;"><i class="ri-chat-1-line"></i> Open Chat</a>
                        </div>
                    </div>

                    <div class="panel" style="margin-top: 30px;">
                        <h2><i class="ri-map-pin-line" style="color: var(--primary);"></i> Nearby Attractions & Food</h2>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 12px; padding: 15px;">
                                <h3 style="font-size: 1.1rem; margin-bottom: 10px;"><i class="ri-camera-lens-line"></i> Attractions</h3>
                                <ul style="color: var(--text-secondary); padding-left: 20px; margin: 0;">
                                    <li>City Center Plaza</li>
                                    <li>National Museum</li>
                                </ul>
                            </div>
                            <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 12px; padding: 15px;">
                                <h3 style="font-size: 1.1rem; margin-bottom: 10px;"><i class="ri-restaurant-line"></i> Local Food</h3>
                                <ul style="color: var(--text-secondary); padding-left: 20px; margin: 0;">
                                    <li>Street Food Alley</li>
                                    <li>Oceanview Cafe</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="panel" style="text-align: center; padding: 80px 20px;">
                        <i class="ri-luggage-cart-line" style="font-size: 5rem; color: var(--text-secondary); opacity: 0.5;"></i>
                        <h2 style="justify-content: center; margin-top: 20px;">No Active Journey</h2>
                        <p style="color: var(--text-secondary); margin-bottom: 30px;">You are currently not on any trip. Go to the Planner to start your next adventure!</p>
                        <a href="${pageContext.request.contextPath}/planner" class="btn btn-primary">Start Planning</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- TAB: UPCOMING TRIPS -->
        <div id="tab-upcoming" class="tab-content ${activeTab == 'upcoming' ? 'active' : ''}">
            <div class="panel">
                <h2><i class="ri-flight-takeoff-line" style="color: var(--primary);"></i> Upcoming Trips</h2>
                
                <c:choose>
                    <c:when test="${not empty upcomingTripBookings}">
                        <c:forEach var="trip" items="${upcomingTripBookings}">
                            <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 25px; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s ease; margin-bottom: 20px;" onmouseover="this.style.background='rgba(255,255,255,0.08)'" onmouseout="this.style.background='rgba(255,255,255,0.03)'">
                                <div>
                                    <h3 style="font-size: 1.6rem; font-family: 'Clash Display', sans-serif; margin-bottom: 8px;">
                                        ${not empty trip.destination.title ? trip.destination.title : 'Trip'}
                                    </h3>
                                    <p style="color: var(--text-secondary); font-size: 1rem;"><i class="ri-calendar-event-line"></i> ${trip.bookingDate != null ? trip.bookingDate : 'Open Date'}</p>
                                </div>
                                <div style="text-align: right;">
                                    <div style="background: rgba(0, 184, 148, 0.2); color: #00b894; padding: 6px 15px; border-radius: 20px; font-weight: 600; font-size: 0.85rem; margin-bottom: 10px; display: inline-block;">${trip.status}</div>
                                    <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 10px;">ID: ${trip.id}</p>
                                    <button class="btn btn-outline" style="padding: 5px 15px; font-size: 0.85rem;" onclick="editTrip(${trip.id}, '${trip.travelDate}', ${trip.guests})">Edit</button>
                                    <button class="btn btn-outline" style="padding: 5px 15px; font-size: 0.85rem; color: #e74c3c; border-color: #e74c3c;" onclick="cancelTrip(${trip.id})">Cancel</button>
                                    <button class="btn btn-primary" style="padding: 5px 15px; font-size: 0.85rem;" onclick="setActiveTrip(${trip.id})">Set Active</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 40px;">
                            <p style="color: var(--text-secondary);">No upcoming trips found. Time to plan a new adventure!</p>
                            <a href="${pageContext.request.contextPath}/planner" class="btn btn-outline" style="margin-top: 15px;">Start Planning</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <script>
                function setActiveTrip(bookingId) {
                    fetch('${pageContext.request.contextPath}/api/trip/set-active', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'bookingId=' + bookingId
                    })
                    .then(r => r.json())
                    .then(data => {
                        if(data.success) {
                            window.location.reload();
                        } else {
                            alert(data.message);
                        }
                    });
                }

                function cancelTrip(bookingId) {
                    if (confirm("Are you sure you want to cancel this trip?")) {
                        fetch('${pageContext.request.contextPath}/api/destination/booking/cancel', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'booking_id=' + bookingId
                        })
                        .then(r => r.json())
                        .then(data => {
                            if(data.status === 'success') {
                                window.location.reload();
                            } else {
                                alert(data.message);
                            }
                        });
                    }
                }

                function editTrip(bookingId, currentDate, currentGuests) {
                    let newDate = prompt("Enter new travel date (YYYY-MM-DD):", currentDate || '');
                    if (!newDate) return;
                    let newGuests = prompt("Enter new number of guests:", currentGuests || '1');
                    if (!newGuests) return;

                    fetch('${pageContext.request.contextPath}/api/destination/booking/edit', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'booking_id=' + bookingId + '&travel_date=' + newDate + '&guests=' + newGuests
                    })
                    .then(r => r.json())
                    .then(data => {
                        if(data.status === 'success') {
                            window.location.reload();
                        } else {
                            alert(data.message);
                        }
                    });
                }
            </script>
        </div>

        <!-- TAB: TRAVEL MEMORIES -->
        <div id="tab-memories" class="tab-content ${activeTab == 'memories' ? 'active' : ''}">
            <div class="panel">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <h2 style="margin: 0;"><i class="ri-gallery-fill" style="color: var(--primary);"></i> Travel Memories</h2>
                </div>
                <div id="memories-grid-container"></div>
            </div>
        </div>

        <!-- Memory Modal Framework (Hidden by default) -->
        <div id="memoryModalOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); backdrop-filter: blur(10px); z-index: 1000; overflow-y: auto;">
            <div style="max-width: 1000px; margin: 40px auto; background: var(--surface-glass); border: 1px solid var(--color-border); border-radius: 24px; overflow: hidden; position: relative;">
                
                <button onclick="closeMemoryModal()" style="position: absolute; top: 20px; right: 20px; background: rgba(0,0,0,0.5); border: none; color: white; width: 40px; height: 40px; border-radius: 50%; font-size: 1.5rem; cursor: pointer; z-index: 10;"><i class="ri-close-line"></i></button>

                <div id="memoryModalHero" style="height: 300px; background: url('https://images.unsplash.com/photo-1506929562872-bb421503ef21?q=80&w=1200&auto=format&fit=crop') center/cover; position: relative; display: flex; align-items: flex-end; padding: 40px;">
                    <div style="position: absolute; inset: 0; background: linear-gradient(to top, rgba(0,0,0,0.9), transparent);"></div>
                    <div style="position: relative; z-index: 1;">
                        <h1 id="modalTripTitle" style="font-size: 3rem; font-family: 'Clash Display', sans-serif; margin-bottom: 10px;">Trip Name</h1>
                        <p id="modalTripDate" style="font-size: 1.2rem; opacity: 0.8;"><i class="ri-calendar-line"></i> Date</p>
                    </div>
                </div>

                <div style="padding: 40px;">
                    <!-- Actions -->
                    <div style="display: flex; gap: 15px; margin-bottom: 40px; flex-wrap: wrap;">
                        <button class="btn btn-primary"><i class="ri-share-forward-line"></i> Share to Community</button>
                        <button class="btn btn-outline"><i class="ri-download-cloud-2-line"></i> Download Album</button>
                        <button class="btn btn-outline" style="color: #8E2DE2; border-color: #8E2DE2;"><i class="ri-video-add-line"></i> Generate Reel</button>
                        <button class="btn btn-outline" style="color: #00b894; border-color: #00b894;"><i class="ri-book-open-line"></i> Generate Journal</button>
                    </div>

                    <!-- Layout Grid -->
                    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px; margin-bottom: 40px;">
                        <div>
                            <h3 style="font-size: 1.5rem; margin-bottom: 15px; font-family: 'Clash Display', sans-serif;"><i class="ri-file-text-line" style="color: var(--primary);"></i> Trip Summary</h3>
                            <p style="color: #ccc; line-height: 1.8;">An unforgettable journey filled with beautiful sights and amazing local experiences. The weather was perfect for exploring, and all planned activities went smoothly.</p>
                            
                            <h3 style="font-size: 1.5rem; margin-top: 30px; margin-bottom: 15px; font-family: 'Clash Display', sans-serif;"><i class="ri-map-pin-time-line" style="color: var(--primary);"></i> Visited Places</h3>
                            <ul style="color: #ccc; line-height: 1.8; padding-left: 20px;">
                                <li>City Center Square</li>
                                <li>National Museum</li>
                                <li>Sunset Viewpoint</li>
                            </ul>
                        </div>
                        <div>
                            <div style="background: rgba(255,255,255,0.03); padding: 20px; border-radius: 16px; border: 1px solid var(--color-border);">
                                <h3 style="font-size: 1.2rem; margin-bottom: 15px;"><i class="ri-wallet-3-line" style="color: #e17055;"></i> Expenses</h3>
                                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: var(--text-secondary);"><span>Flights</span> <span>â‚¹12,000</span></div>
                                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: var(--text-secondary);"><span>Hotel</span> <span>â‚¹18,000</span></div>
                                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: var(--text-secondary);"><span>Food</span> <span>â‚¹5,500</span></div>
                                <hr style="border-color: rgba(255,255,255,0.1); margin: 15px 0;">
                                <div style="display: flex; justify-content: space-between; font-weight: bold; font-size: 1.2rem;"><span>Total</span> <span style="color: var(--primary);">â‚¹35,500</span></div>
                            </div>
                        </div>
                    </div>

                    <!-- Album Grid -->
                    <h3 style="font-size: 1.8rem; margin-bottom: 20px; font-family: 'Clash Display', sans-serif;"><i class="ri-image-line" style="color: var(--primary);"></i> Trip Album</h3>
                    <div id="modalMemoriesGrid" class="memories-grid">
                        <!-- Rendered via JS -->
                    </div>

                </div>
            </div>
        </div>

        <script>
            // Store memories map from JSP to JS variable for dynamic rendering
            const memoriesData = {
                <c:forEach var="entry" items="${tripMemoriesMap}">
                    ${entry.key}: [
                        <c:forEach var="mem" items="${entry.value}">
                            {
                                type: '${mem.type}',
                                url: '${mem.mediaUrl}',
                                caption: '${mem.caption.replace("'", "\\'")}',
                                location: '${mem.location.replace("'", "\\'")}'
                            },
                        </c:forEach>
                    ],
                </c:forEach>
            };

            function openMemoryModal(tripId) {
                // Populate title/date from the clicked card (simple DOM traversal or data attributes. Here we just hardcode mock text for demo if we don't have it)
                document.getElementById('modalTripTitle').innerText = "Trip " + tripId; // In a real app, pass the title or use data-attributes
                document.getElementById('modalTripDate').innerText = "Archived";
                
                const grid = document.getElementById('modalMemoriesGrid');
                grid.innerHTML = '';

                const mems = memoriesData[tripId] || [];
                mems.forEach(m => {
                    let icon = 'ri-image-line';
                    if(m.type === 'FOOD') icon = 'ri-restaurant-line';
                    if(m.type === 'EXPERIENCE') icon = 'ri-compass-3-line';
                    if(m.type === 'VIDEO') icon = 'ri-video-line';

                    grid.innerHTML += `
                        <div class="memory-item">
                            <img src="\${m.url}" alt="\${m.type}">
                            <div class="memory-caption">
                                <strong><i class="\${icon}"></i> \${m.caption}</strong><br>
                                <span style="font-size: 0.85rem; opacity: 0.7;"><i class="ri-map-pin-line"></i> \${m.location}</span>
                            </div>
                        </div>
                    `;
                });

                document.getElementById('memoryModalOverlay').style.display = 'block';
                document.body.style.overflow = 'hidden';
            }

            function closeMemoryModal() {
                document.getElementById('memoryModalOverlay').style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        </script>

        <!-- TAB: TRAVEL CALENDAR -->
        <div id="tab-calendar" class="tab-content ${activeTab == 'calendar' ? 'active' : ''}">
            <div style="display: grid; grid-template-columns: 3fr 1fr; gap: 30px;">
                <!-- Main Calendar Section -->
                <div class="panel" style="margin-bottom: 0;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                        <h2 style="margin: 0;"><i class="ri-calendar-2-line" style="color: var(--primary);"></i> Travel Calendar</h2>
                        <div style="display: flex; gap: 10px; background: rgba(255,255,255,0.05); padding: 5px; border-radius: 12px;">
                            <button class="btn btn-outline" style="border: none; background: var(--primary); color: white;" onclick="setCalendarView('month')">Month</button>
                            <button class="btn btn-outline" style="border: none; color: var(--text-secondary);" onclick="setCalendarView('year')">Year</button>
                            <button class="btn btn-outline" style="border: none; color: var(--text-secondary);" onclick="setCalendarView('timeline')">Timeline</button>
                        </div>
                    </div>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                        <button class="btn btn-outline" style="padding: 8px 15px;" onclick="changeMonth(-1)"><i class="ri-arrow-left-s-line"></i></button>
                        <h3 id="calendarMonthYearDisplay" style="font-family: 'Clash Display', sans-serif; font-size: 1.5rem;">October 2026</h3>
                        <button class="btn btn-outline" style="padding: 8px 15px;" onclick="changeMonth(1)"><i class="ri-arrow-right-s-line"></i></button>
                    </div>

                    <div id="calendarViewContainer">
                        <div class="calendar" id="dynamicCalendarGrid">
                            <div class="cal-header">Sun</div><div class="cal-header">Mon</div><div class="cal-header">Tue</div>
                            <div class="cal-header">Wed</div><div class="cal-header">Thu</div><div class="cal-header">Fri</div><div class="cal-header">Sat</div>
                            <!-- Days rendered via JS -->
                        </div>
                    </div>
                </div>

                <!-- Sidebar Section -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <!-- Legend -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0;">
                        <h3 style="font-size: 1.1rem; margin-bottom: 15px;">Legend</h3>
                        <div style="display: flex; flex-direction: column; gap: 10px; font-size: 0.9rem;">
                            <div style="display: flex; align-items: center; gap: 10px;"><div style="width: 12px; height: 12px; border-radius: 50%; background: #00b894;"></div> Upcoming Trips</div>
                            <div style="display: flex; align-items: center; gap: 10px;"><div style="width: 12px; height: 12px; border-radius: 50%; background: rgba(255,255,255,0.2);"></div> Past Trips</div>
                            <div style="display: flex; align-items: center; gap: 10px;"><div style="width: 12px; height: 12px; border-radius: 50%; background: var(--primary);"></div> Saved Plans</div>
                            <div style="display: flex; align-items: center; gap: 10px;"><div style="width: 12px; height: 12px; border-radius: 50%; background: #0984e3;"></div> Holidays / Long Weekends</div>
                        </div>
                    </div>

                    <!-- AI Suggestions -->
                    <div class="panel" style="padding: 20px; margin-bottom: 0; background: linear-gradient(135deg, rgba(142, 45, 226, 0.1), rgba(0,0,0,0)); border-color: rgba(142, 45, 226, 0.3);">
                        <h3 style="font-size: 1.1rem; margin-bottom: 15px;"><i class="ri-sparkling-line" style="color: #8E2DE2;"></i> AI Suggestions</h3>
                        <div id="aiSuggestionContent">
                            <!-- Rendered via JS -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Prepare trips data for calendar (dynamically updated via JS)
            window.allTripsForCalendar = [];

            // Mocked Holidays / Long Weekends
            const holidays = [
                { date: "2026-10-02", title: "Gandhi Jayanti (Holiday)", type: "HOLIDAY" },
                { date: "2026-10-23", title: "Dussehra (Long Weekend)", type: "HOLIDAY" },
                { date: "2026-11-09", title: "Diwali (Long Weekend)", type: "HOLIDAY" }
            ];

            // Mocked AI Suggestions per month (0-indexed)
            const aiSuggestions = {
                9: { // October
                    weekend: "Oct 23 - Oct 25",
                    destination: "Goa, India",
                    reason: "Perfect weather for the Dussehra long weekend.",
                    budget: "â‚¹18,000"
                },
                10: { // November
                    weekend: "Nov 7 - Nov 9",
                    destination: "Udaipur, India",
                    reason: "Experience the royal Diwali festival.",
                    budget: "â‚¹22,000"
                }
            };

            let currentCalDate = new Date(); // Start at current date

            function setCalendarView(viewType) {
                // In a full implementation, this toggles between Month/Year/Timeline grids.
                // For now, we only render the 'month' view natively, others show placeholders.
                const container = document.getElementById('calendarViewContainer');
                const controls = event.target.parentElement.querySelectorAll('.btn');
                controls.forEach(c => { c.style.background = 'transparent'; c.style.color = 'var(--text-secondary)'; });
                event.target.style.background = 'var(--primary)';
                event.target.style.color = 'white';

                if (viewType === 'month') {
                    container.innerHTML = `
                        <div class="calendar" id="dynamicCalendarGrid">
                            <div class="cal-header">Sun</div><div class="cal-header">Mon</div><div class="cal-header">Tue</div>
                            <div class="cal-header">Wed</div><div class="cal-header">Thu</div><div class="cal-header">Fri</div><div class="cal-header">Sat</div>
                        </div>
                    `;
                    renderCalendar();
                } else if (viewType === 'year') {
                    container.innerHTML = `<div style="text-align:center; padding: 100px; color: var(--text-secondary);"><i class="ri-calendar-event-line" style="font-size: 3rem;"></i><p>Year View Coming Soon</p></div>`;
                } else if (viewType === 'timeline') {
                    container.innerHTML = `<div style="text-align:center; padding: 100px; color: var(--text-secondary);"><i class="ri-git-commit-line" style="font-size: 3rem;"></i><p>Timeline View Coming Soon</p></div>`;
                }
            }

            function changeMonth(offset) {
                currentCalDate.setMonth(currentCalDate.getMonth() + offset);
                renderCalendar();
            }

            function renderCalendar() {
                const grid = document.getElementById('dynamicCalendarGrid');
                if(!grid) return; // Not in month view

                const year = currentCalDate.getFullYear();
                const month = currentCalDate.getMonth();
                
                // Update header
                const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                document.getElementById('calendarMonthYearDisplay').innerText = `\${monthNames[month]} \${year}`;

                // Update AI Suggestion
                const suggestionBox = document.getElementById('aiSuggestionContent');
                const aiData = aiSuggestions[month];
                if (aiData) {
                    suggestionBox.innerHTML = `
                        <div style="background: rgba(0,0,0,0.2); padding: 15px; border-radius: 12px; border: 1px solid rgba(142,45,226,0.3);">
                            <div style="color: var(--primary); font-size: 0.8rem; font-weight: bold; margin-bottom: 5px;">3-DAY WEEKEND</div>
                            <strong style="display:block; margin-bottom: 5px;">\${aiData.weekend}</strong>
                            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;"><i class="ri-map-pin-line" style="color: #00b894;"></i> \${aiData.destination}</div>
                            <p style="font-size: 0.85rem; color: #ccc; margin-bottom: 10px;">\${aiData.reason}</p>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.9rem; color: var(--text-secondary);">Est. Budget: \${aiData.budget}</span>
                                <button class="btn btn-primary" style="padding: 4px 10px; font-size: 0.8rem;">Plan Now</button>
                            </div>
                        </div>
                    `;
                } else {
                    suggestionBox.innerHTML = `<p style="color: var(--text-secondary); font-size: 0.9rem;">No specific AI recommendations for this month yet. Explore the planner to generate ideas!</p>`;
                }

                // Clear old days (keep headers)
                const headers = grid.querySelectorAll('.cal-header');
                grid.innerHTML = '';
                headers.forEach(h => grid.appendChild(h));

                const firstDay = new Date(year, month, 1).getDay();
                const daysInMonth = new Date(year, month + 1, 0).getDate();

                // Pad empty days
                for (let i = 0; i < firstDay; i++) {
                    grid.innerHTML += `<div class="cal-day" style="opacity: 0.1;"></div>`;
                }

                // Render days
                for (let d = 1; d <= daysInMonth; d++) {
                    // Format current day string 'YYYY-MM-DD'
                    const dateStr = `\${year}-\${String(month+1).padStart(2, '0')}-\${String(d).padStart(2, '0')}`;
                    
                    let dayHtml = `<div class="cal-day" style="display: flex; flex-direction: column; justify-content: space-between;">`;
                    dayHtml += `<span style="font-weight: bold;">\${d}</span>`;
                    
                    let eventsHtml = '';
                    
                    // Check holidays
                    const h = holidays.find(x => x.date === dateStr);
                    if (h) {
                        eventsHtml += `<div style="background: rgba(9, 132, 227, 0.2); color: #0984e3; font-size: 0.65rem; padding: 2px 4px; border-radius: 4px; margin-top: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="\${h.title}">\${h.title}</div>`;
                    }

                    // Check trips
                    const trips = allTripsForCalendar.filter(x => x.date && x.date.startsWith(dateStr));
                    trips.forEach(t => {
                        let color = t.status === 'UPCOMING' ? '#00b894' : 'rgba(255,255,255,0.4)';
                        let bg = t.status === 'UPCOMING' ? 'rgba(0, 184, 148, 0.2)' : 'rgba(255,255,255,0.05)';
                        eventsHtml += `<div style="background: \${bg}; color: \${color}; font-size: 0.65rem; padding: 2px 4px; border-radius: 4px; margin-top: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="\${t.title}">\${t.title}</div>`;
                    });

                    dayHtml += `<div style="margin-top: auto;">\${eventsHtml}</div>`;
                    dayHtml += `</div>`;
                    grid.innerHTML += dayHtml;
                }
            }

            // Init calendar on load
            document.addEventListener('DOMContentLoaded', () => {
                // wait for a bit to ensure it doesn't break other DOM loads
                setTimeout(renderCalendar, 100);
            });
        </script>

        <!-- TAB: TRAVEL DNA -->
        <div id="tab-dna" class="tab-content ${activeTab == 'dna' ? 'active' : ''}">
            <div class="panel">
                <h2><i class="ri-dna-line" style="color: var(--primary);"></i> Travel DNA</h2>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">Deep analytics based on your past travels and preferences.</p>
                <div id="dna-container-main"></div>
            </div>
        </div>

        <!-- TAB: FAMILY HUB -->
        <div id="tab-family" class="tab-content ${activeTab == 'family' ? 'active' : ''}">
            <div class="panel">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <h2 style="margin: 0;"><i class="ri-group-line" style="color: var(--primary);"></i> Family Hub</h2>
                    <button class="btn" style="background: rgba(255,255,255,0.05); color: white; border: 1px solid rgba(255,255,255,0.1); padding: 8px 15px;"><i class="ri-user-add-line"></i> Invite Member</button>
                </div>
                <div id="family-grid-container" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;"></div>
            </div>
        </div>

        <!-- TAB: COMPLETED TRIPS -->
        <div id="tab-completed" class="tab-content ${activeTab == 'completed' ? 'active' : ''}">
            <div class="panel">
                <h2><i class="ri-history-line" style="color: var(--primary);"></i> Completed Trips</h2>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">Archive of your past journeys. Ready for Memories.</p>
                <div id="completed-trips-container"></div>
            </div>
        </div>

        <!-- TAB: TRIP REPORTS (WRAPPED) -->
        <div id="tab-reports" class="tab-content ${activeTab == 'reports' ? 'active' : ''}">
            <div class="panel">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <div>
                        <h2 style="margin: 0;"><i class="ri-bar-chart-2-line" style="color: var(--primary);"></i> Trip Reports</h2>
                        <p style="color: var(--text-secondary); margin-top: 5px;">Financials, invoices, and analytics.</p>
                    </div>
                    <button class="btn" style="background: rgba(255,255,255,0.05); color: white; border: 1px solid rgba(255,255,255,0.1); padding: 8px 15px;"><i class="ri-file-download-line"></i> Export All</button>
                </div>

                <div id="report-cards-container" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px;">
                </div>

                <h3 style="font-size: 1.2rem; margin-bottom: 20px;">Recent Reports</h3>
                <div id="recent-reports-container" style="display: flex; flex-direction: column; gap: 15px;"></div>
            </div>
        </div>

    </main>
</div>

<jsp:include page="/components/footer.jsp" />

<script>window.CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/my-journey.js"></script>
</body>
</html>
