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
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-color: #131722;
            --accent-color: #d6a66b;
            --text-primary: #ffffff;
            --text-secondary: #b9b9b9;
            --glass-border: 1px solid rgba(214, 166, 107, 0.15);
        }
        body {
            background-color: var(--bg-color);
            color: var(--text-primary);
            font-family: 'Inter', 'Outfit', sans-serif;
        }
        .plan-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .header-section {
            text-align: center;
            margin-bottom: 40px;
        }
        .header-section h1 {
            font-size: 2.5rem;
            color: var(--accent-color);
            margin-bottom: 10px;
        }
        .card {
            background: var(--card-color);
            border: var(--glass-border);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .card h2 {
            color: var(--accent-color);
            border-bottom: 1px solid rgba(214, 166, 107, 0.2);
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .stat-item {
            background: rgba(11, 15, 25, 0.5);
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid rgba(214, 166, 107, 0.1);
        }
        .stat-value {
            font-size: 1.25rem;
            font-weight: bold;
            color: var(--text-primary);
        }
        .stat-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            margin-top: 5px;
        }
        .list-item {
            margin-bottom: 10px;
            display: flex;
            align-items: flex-start;
        }
        .list-item::before {
            content: "•";
            color: var(--accent-color);
            font-weight: bold;
            display: inline-block;
            width: 1em;
            margin-left: -1em;
        }
        .day-block {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px dashed rgba(214, 166, 107, 0.2);
        }
        .day-block:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        .day-title {
            font-size: 1.2rem;
            color: var(--text-primary);
            font-weight: bold;
            margin-bottom: 15px;
        }
        .time-slot {
            margin-bottom: 15px;
            padding-left: 15px;
            border-left: 2px solid var(--accent-color);
        }
        .time-label {
            font-size: 0.9rem;
            color: var(--accent-color);
            font-weight: bold;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        .error-message {
            background: #ff4c4c;
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
        }
        .hidden { display: none; }
    </style>
</head>
<body>

<div class="plan-container">
    
    <div id="loadingState" style="text-align: center; padding: 100px 0;">
        <h2 style="color: var(--accent-color);">Parsing AI Itinerary...</h2>
        <div class="spinner" style="margin: 20px auto;"></div>
    </div>

    <div id="errorState" class="error-message hidden">
        Unable to parse the trip plan. Please try again.
    </div>

    <div id="contentState" class="hidden">
        <div class="header-section">
            <h1 id="destTitle">Your Trip to [Destination]</h1>
            <p id="destOverview" style="color: var(--text-secondary); max-width: 800px; margin: 0 auto; line-height: 1.6;"></p>
        </div>

        <div class="card">
            <h2>Trip Overview</h2>
            <div class="overview-grid">
                <div class="stat-item">
                    <div class="stat-value" id="ovDuration">--</div>
                    <div class="stat-label">Duration</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value" id="ovBudget">--</div>
                    <div class="stat-label">Total Budget</div>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>Budget Breakdown</h2>
            <div class="overview-grid">
                <div class="stat-item">
                    <div class="stat-value">₹<span id="bgTransport">0</span></div>
                    <div class="stat-label">Transport</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">₹<span id="bgHotel">0</span></div>
                    <div class="stat-label">Accommodation</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">₹<span id="bgFood">0</span></div>
                    <div class="stat-label">Food</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">₹<span id="bgActivities">0</span></div>
                    <div class="stat-label">Activities</div>
                </div>
            </div>
        </div>

        <div class="card" id="hotelsCard">
            <h2>Recommended Hotels</h2>
            <div id="hotelsContainer"></div>
        </div>

        <div class="card" id="itineraryCard">
            <h2>Day-wise Itinerary</h2>
            <div id="itineraryContainer"></div>
        </div>

        <div class="card">
            <h2>Food Recommendations</h2>
            <div id="foodContainer" style="padding-left: 20px;"></div>
        </div>

        <div class="card">
            <h2>Transport Suggestions</h2>
            <div id="transportContainer" style="padding-left: 20px;"></div>
        </div>

        <div class="card">
            <h2>Travel Tips</h2>
            <div id="tipsContainer" style="padding-left: 20px;"></div>
        </div>
    </div>
</div>

<div id="hdnItineraryJson" style="display:none;"><c:out value="${itineraryJson}"/></div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const rawJson = document.getElementById('hdnItineraryJson').textContent;
    
    try {
        if (!rawJson || rawJson.trim() === 'null') {
            throw new Error("Empty JSON");
        }
        
        const data = JSON.parse(rawJson);
        
        // Hide loading, show content
        document.getElementById('loadingState').classList.add('hidden');
        document.getElementById('contentState').classList.remove('hidden');

        // Trip Summary
        if(data.tripSummary) {
            document.getElementById('destTitle').textContent = `Your Trip to ${data.tripSummary.destination}`;
            document.getElementById('destOverview').textContent = data.tripSummary.overview;
            document.getElementById('ovDuration').textContent = `${data.tripSummary.durationDays} Days`;
            document.getElementById('ovBudget').textContent = data.tripSummary.budget;
        }

        // Budget Breakdown
        if(data.estimatedBudget) {
            document.getElementById('bgTransport').textContent = data.estimatedBudget.transport;
            document.getElementById('bgHotel').textContent = data.estimatedBudget.hotel;
            document.getElementById('bgFood').textContent = data.estimatedBudget.food;
            document.getElementById('bgActivities').textContent = data.estimatedBudget.activities;
        }

        // Hotels
        if(data.recommendedHotels && data.recommendedHotels.length > 0) {
            let html = '';
            data.recommendedHotels.forEach(h => {
                html += `<div style="margin-bottom: 15px;">
                    <strong>${h.name}</strong> (${h.rating}⭐) <br>
                    <span style="color: var(--text-secondary); font-size: 0.9rem;">📍 ${h.location} | ₹${h.pricePerNight}/night</span>
                </div>`;
            });
            document.getElementById('hotelsContainer').innerHTML = html;
        }

        // Itinerary
        if(data.itinerary && data.itinerary.length > 0) {
            let html = '';
            data.itinerary.forEach(day => {
                html += `<div class="day-block">
                    <div class="day-title">Day ${day.day} <span style="font-size:0.9rem; color:var(--text-secondary); float:right;">Est. Cost: ₹${day.estimatedCost || 0}</span></div>`;
                
                if(day.morning && day.morning.length > 0) {
                    html += `<div class="time-slot"><div class="time-label">Morning</div>`;
                    day.morning.forEach(act => html += `<div class="list-item">${act}</div>`);
                    html += `</div>`;
                }
                if(day.afternoon && day.afternoon.length > 0) {
                    html += `<div class="time-slot"><div class="time-label">Afternoon</div>`;
                    day.afternoon.forEach(act => html += `<div class="list-item">${act}</div>`);
                    html += `</div>`;
                }
                if(day.evening && day.evening.length > 0) {
                    html += `<div class="time-slot"><div class="time-label">Evening</div>`;
                    day.evening.forEach(act => html += `<div class="list-item">${act}</div>`);
                    html += `</div>`;
                }
                html += `</div>`;
            });
            document.getElementById('itineraryContainer').innerHTML = html;
        }

        // Food
        if(data.foodRecommendations) {
            let html = '';
            data.foodRecommendations.forEach(f => html += `<div class="list-item">${f}</div>`);
            document.getElementById('foodContainer').innerHTML = html;
        }

        // Transport
        if(data.transportOptions) {
            let html = '';
            data.transportOptions.forEach(t => html += `<div class="list-item">${t}</div>`);
            document.getElementById('transportContainer').innerHTML = html;
        }

        // Tips
        if(data.travelTips) {
            let html = '';
            data.travelTips.forEach(t => html += `<div class="list-item">${t}</div>`);
            document.getElementById('tipsContainer').innerHTML = html;
        }

    } catch(e) {
        console.error("JSON Parsing Error: ", e);
        document.getElementById('loadingState').classList.add('hidden');
        document.getElementById('errorState').classList.remove('hidden');
    }
});
</script>

<%@ include file="/components/footer.jsp" %>
</body>
</html>
