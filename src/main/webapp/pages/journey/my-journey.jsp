<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Journey Command Center | Voyastra</title>
    <jsp:include page="/components/config.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f4f6f9; }
        .journey-dashboard {
            display: grid;
            grid-template-columns: 3fr 1fr;
            gap: 30px;
            padding: 40px 5%;
            max-width: 1600px;
            margin: 0 auto;
        }
        .panel {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 30px;
        }
        /* Top Hero Card */
        .trip-hero {
            background: linear-gradient(135deg, var(--primary), #8E2DE2);
            color: white;
            padding: 40px;
            border-radius: 24px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.3);
        }
        .trip-hero h1 { font-size: 3rem; margin-bottom: 10px; }
        .progress-circle {
            width: 120px; height: 120px;
            border-radius: 50%;
            border: 8px solid rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; font-weight: bold;
            position: relative;
        }
        /* Plan Timeline */
        .plan-timeline {
            border-left: 3px solid #eee;
            margin-left: 20px;
            padding-left: 30px;
        }
        .plan-item { position: relative; margin-bottom: 30px; }
        .plan-item::before {
            content: ''; position: absolute; left: -39px; top: 0;
            width: 15px; height: 15px; border-radius: 50%;
            background: var(--primary);
            border: 4px solid white;
            box-shadow: 0 0 0 2px var(--primary);
        }
        .plan-time { font-weight: bold; color: var(--primary); margin-bottom: 5px; display: block; }
        
        /* Grid Layouts for smaller panels */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .metric-card {
            background: #f8f9fa; padding: 15px; border-radius: 12px; text-align: center;
        }
        .metric-card h3 { font-size: 1.8rem; color: #2d3436; margin-bottom: 5px; }
        .metric-card span { font-size: 0.9rem; color: #636e72; }

        /* Document Vault */
        .doc-item {
            display: flex; align-items: center; justify-content: space-between;
            padding: 12px 15px; background: #f8f9fa; border-radius: 10px; margin-bottom: 10px;
        }
        .doc-item i { font-size: 1.5rem; color: var(--primary); }

        /* Checklist */
        .checklist-item {
            display: flex; align-items: center; gap: 15px; padding: 10px 0; border-bottom: 1px solid #eee;
        }
        .checklist-item input[type="checkbox"] { width: 20px; height: 20px; accent-color: var(--primary); }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp" />

    <div class="journey-dashboard">
        <!-- Main Column -->
        <div class="main-col">
            <!-- SECTION 1: Current Trip Card -->
            <div class="trip-hero">
                <div>
                    <span style="background: rgba(255,255,255,0.2); padding: 5px 15px; border-radius: 20px; font-weight: bold; letter-spacing: 1px; font-size: 0.8rem;">STATUS: ${journey.status}</span>
                    <h1>${journey.destination}</h1>
                    <p style="font-size: 1.2rem; opacity: 0.9;"><i class="far fa-calendar-alt"></i> ${journey.startDate} - ${journey.endDate}</p>
                    <p style="font-size: 1.2rem; margin-top: 10px;"><strong>Day ${journey.currentDay} of ${journey.totalDays}</strong></p>
                </div>
                <div class="progress-circle">
                    ${journey.progressPercentage}%
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                <!-- SECTION 2: Today's Plan -->
                <div class="panel">
                    <h2><i class="fas fa-map-marked-alt"></i> Today's Plan</h2>
                    <p style="color: #666; margin-bottom: 25px;">Follow your scheduled itinerary.</p>
                    <div class="plan-timeline">
                        <div class="plan-item">
                            <span class="plan-time">Morning</span>
                            <c:forEach var="item" items="${journey.morningPlan}">
                                <div>• ${item}</div>
                            </c:forEach>
                        </div>
                        <div class="plan-item">
                            <span class="plan-time">Afternoon</span>
                            <c:forEach var="item" items="${journey.afternoonPlan}">
                                <div>• ${item}</div>
                            </c:forEach>
                        </div>
                        <div class="plan-item">
                            <span class="plan-time">Evening</span>
                            <c:forEach var="item" items="${journey.eveningPlan}">
                                <div>• ${item}</div>
                            </c:forEach>
                        </div>
                        <div class="plan-item">
                            <span class="plan-time">Night</span>
                            <c:forEach var="item" items="${journey.nightPlan}">
                                <div>• ${item}</div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- SECTION 4: Live Budget Tracker -->
                <div class="panel">
                    <h2><i class="fas fa-wallet"></i> Live Budget Tracker</h2>
                    <div class="metrics-grid" style="margin-top: 20px;">
                        <div class="metric-card" style="grid-column: span 2; background: rgba(108, 92, 231, 0.1);">
                            <h3 style="color: var(--primary);">₹${journey.totalBudget}</h3>
                            <span>Total Approved Budget</span>
                        </div>
                        <div class="metric-card">
                            <h3 style="color: #e17055;">₹${journey.spent}</h3>
                            <span>Total Spent</span>
                        </div>
                        <div class="metric-card">
                            <h3 style="color: #00b894;">₹${journey.totalBudget - journey.spent}</h3>
                            <span>Remaining</span>
                        </div>
                    </div>
                    
                    <button class="btn btn-outline" style="width: 100%; margin-top: 20px;"><i class="fas fa-receipt"></i> Add Expense</button>
                </div>
            </div>

            <!-- SECTION 6 & 7: Nearby Discovery & Food -->
            <div class="panel" style="margin-top: 30px;">
                <h2><i class="fas fa-compass"></i> Discover Nearby</h2>
                <div style="display: flex; gap: 15px; margin-top: 20px; overflow-x: auto; padding-bottom: 10px;">
                    <div class="metric-card" style="min-width: 200px; text-align: left;">
                        <h4><i class="fas fa-utensils"></i> Must Try Food</h4>
                        <p style="font-size: 0.9rem; color: #666; margin-top: 5px;">Seafood thali at Fisherman's Wharf (2km away)</p>
                    </div>
                    <div class="metric-card" style="min-width: 200px; text-align: left;">
                        <h4><i class="fas fa-camera-retro"></i> Photography Spot</h4>
                        <p style="font-size: 0.9rem; color: #666; margin-top: 5px;">Chapora Fort sunset view (5km away)</p>
                    </div>
                    <div class="metric-card" style="min-width: 200px; text-align: left;">
                        <h4><i class="fas fa-gem"></i> Hidden Gem</h4>
                        <p style="font-size: 0.9rem; color: #666; margin-top: 5px;">Butterfly Beach kayaking</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar Column -->
        <div class="sidebar-col">
            
            <!-- SECTION 3 & 8: Weather & Alerts -->
            <div class="panel" style="background: linear-gradient(135deg, #74b9ff, #0984e3); color: white; border: none;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <h2><i class="fas fa-cloud-sun"></i> Weather</h2>
                    <span style="font-size: 2.5rem;">${journey.temperature}°C</span>
                </div>
                <p style="font-size: 1.2rem; margin: 10px 0;">${journey.weatherCondition}</p>
                
                <div style="background: rgba(255,255,255,0.2); padding: 10px; border-radius: 8px; font-size: 0.9rem; margin-top: 15px;">
                    <i class="fas fa-exclamation-triangle"></i> Alert: ${journey.weatherAlert}
                </div>
            </div>

            <!-- SECTION 5: Document Vault -->
            <div class="panel">
                <h2><i class="fas fa-folder-open"></i> Document Vault</h2>
                <div style="margin-top: 15px;">
                    <div class="doc-item">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <i class="fas fa-plane-ticket"></i>
                            <div><strong>Flight Vistara</strong><br><span style="font-size: 0.8rem; color: #666;">PDF • 1.2MB</span></div>
                        </div>
                        <i class="fas fa-download" style="font-size: 1rem; color: #aaa; cursor: pointer;"></i>
                    </div>
                    <div class="doc-item">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <i class="fas fa-hotel"></i>
                            <div><strong>Taj Hotel Voucher</strong><br><span style="font-size: 0.8rem; color: #666;">PDF • 2.4MB</span></div>
                        </div>
                        <i class="fas fa-download" style="font-size: 1rem; color: #aaa; cursor: pointer;"></i>
                    </div>
                </div>
            </div>

            <!-- SECTION 9: Packing Checklist -->
            <div class="panel">
                <h2><i class="fas fa-check-square"></i> Packing Checklist</h2>
                <div style="margin-top: 15px;">
                    <label class="checklist-item"><input type="checkbox" checked> Sunscreen & Sunglasses</label>
                    <label class="checklist-item"><input type="checkbox" checked> Swimwear</label>
                    <label class="checklist-item"><input type="checkbox"> Camera & Drone</label>
                    <label class="checklist-item"><input type="checkbox"> Powerbank</label>
                </div>
            </div>

            <!-- SECTION 11: Travel DNA -->
            <div class="panel">
                <h2><i class="fas fa-dna"></i> Travel DNA</h2>
                <div style="margin-top: 15px;">
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 5px;"><span>Explorer</span> <span>${journey.explorerScore}%</span></div>
                        <div style="background: #eee; height: 6px; border-radius: 3px;"><div style="background: var(--primary); height: 100%; width: ${journey.explorerScore}%; border-radius: 3px;"></div></div>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 5px;"><span>Foodie</span> <span>${journey.foodieScore}%</span></div>
                        <div style="background: #eee; height: 6px; border-radius: 3px;"><div style="background: #e17055; height: 100%; width: ${journey.foodieScore}%; border-radius: 3px;"></div></div>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 5px;"><span>Adventure</span> <span>${journey.adventureScore}%</span></div>
                        <div style="background: #eee; height: 6px; border-radius: 3px;"><div style="background: #00b894; height: 100%; width: ${journey.adventureScore}%; border-radius: 3px;"></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/components/footer.jsp" />
</body>
</html>
