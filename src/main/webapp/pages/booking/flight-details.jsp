<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Flight Details - Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        .layout-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            margin-top: 24px;
        }
        .card {
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--color-border);
            border-radius: 16px;
            padding: 32px;
        }
        .flight-info-grid {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 20px;
            align-items: center;
            text-align: center;
            margin: 24px 0;
            padding: 24px 0;
            border-top: 1px solid rgba(255,255,255,0.1);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            color: var(--color-muted);
        }
        .summary-row.total {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 16px;
            margin-top: 16px;
            color: var(--text-main);
            font-size: 1.2rem;
            font-weight: 800;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            font-size: 0.8rem;
            color: var(--text-main);
        }
        .badge.green {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
        }
        @media (max-width: 768px) {
            .layout-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body style="padding-top: 80px; padding-bottom: 60px; overflow-x: hidden;">

    <jsp:include page="/components/header.jsp" />
    <jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="1"/></jsp:include>

    <div class="container" style="max-width: 1100px; margin: 40px auto; padding: 0 20px;">
        <div style="display: flex; gap: 16px; align-items: center; margin-bottom: 8px;">
            <a href="javascript:history.back()" style="color: var(--color-primary); text-decoration: none;">&larr; Back to Results</a>
        </div>
        <h1 class="text-white font-bold" style="font-size: 2rem;">Review Your Flight</h1>
        <p style="color: var(--color-muted);">Please confirm the details of your flight before proceeding.</p>

        <div class="layout-grid">
            <!-- Left Side: Flight Details -->
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div style="display: flex; align-items: center; gap: 16px;">
                        <div style="background: var(--color-primary); color: #000; width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: bold;">
                            ${flightLogo}
                        </div>
                        <div>
                            <div style="font-size: 1.2rem; font-weight: 800; color: var(--color-main);">${flightName}</div>
                            <div style="font-size: 0.9rem; color: var(--color-muted);">${flightId}</div>
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <div class="badge green">Partially Refundable</div>
                        <div style="margin-top: 8px; font-size: 0.9rem; color: var(--color-muted); text-transform: capitalize;">Class: ${flightClass}</div>
                    </div>
                </div>

                <div class="flight-info-grid">
                    <div style="text-align: left;">
                        <div style="font-size: 1.8rem; font-weight: 800; color: var(--color-main);">${flightDeptTime}</div>
                        <div style="font-size: 1.1rem; font-weight: 600; color: var(--text-main); margin-top: 4px;">${flightFrom}</div>
                        <div style="font-size: 0.85rem; color: var(--color-muted);">${flightDate}</div>
                    </div>
                    <div style="display: flex; flex-direction: column; align-items: center; gap: 8px; padding: 0 20px;">
                        <div style="font-size: 0.85rem; color: var(--color-muted); font-weight: 600;">${flightDuration}</div>
                        <div style="width: 120px; height: 2px; background: rgba(255,255,255,0.2); position: relative;">
                            <div style="position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); background: var(--bg-base); padding: 0 8px; font-size: 1.2rem; color: var(--color-primary);">✈️</div>
                        </div>
                        <div style="font-size: 0.8rem; color: var(--color-primary); font-weight: 600;">
                            <c:choose>
                                <c:when test="${flightStops == 0}">Non-stop</c:when>
                                <c:when test="${flightStops == 1}">1 Stop</c:when>
                                <c:otherwise>${flightStops} Stops</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 1.8rem; font-weight: 800; color: var(--color-main);">${flightArrTime}</div>
                        <div style="font-size: 1.1rem; font-weight: 600; color: var(--text-main); margin-top: 4px;">${flightTo}</div>
                        <div style="font-size: 0.85rem; color: var(--color-muted);">${flightDate}</div>
                    </div>
                </div>

                <div style="display: flex; gap: 24px; padding-top: 8px;">
                    <div style="display: flex; gap: 12px; align-items: center; color: var(--text-main); font-size: 0.9rem;">
                        <span style="font-size: 1.2rem;">🧳</span>
                        <div>
                            <div style="font-weight: 600;">Cabin Baggage</div>
                            <div style="color: var(--color-muted); font-size: 0.85rem;">7 kg (1 piece)</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 12px; align-items: center; color: var(--text-main); font-size: 0.9rem;">
                        <span style="font-size: 1.2rem;">🛄</span>
                        <div>
                            <div style="font-weight: 600;">Check-in Baggage</div>
                            <div style="color: var(--color-muted); font-size: 0.85rem;">15 kg (1 piece)</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Booking Summary -->
            <div class="card" style="align-self: start; position: sticky; top: 100px;">
                <h3 style="font-size: 1.3rem; font-weight: 800; margin-bottom: 24px; color: var(--text-main);">Fare Summary</h3>
                
                <div class="summary-row">
                    <span>Base Fare (${flightPassengers} Adult)</span>
                    <span style="color: var(--text-main); font-weight: 600;">₹${baseFare}</span>
                </div>
                <div class="summary-row">
                    <span>Taxes & Surcharges</span>
                    <span style="color: var(--text-main); font-weight: 600;">₹${taxes}</span>
                </div>
                <div class="summary-row">
                    <span>Convenience Fee</span>
                    <span style="color: var(--text-main); font-weight: 600;">₹${convenienceFee}</span>
                </div>

                <div class="summary-row total">
                    <span>Total Amount</span>
                    <span>₹${totalPrice}</span>
                </div>

                <button class="btn-select" style="margin-top: 16px; width: 100%; padding: 14px; font-weight: 700; font-size: 1.1rem; border-radius: 8px; background: var(--color-primary); color: #000; border: none; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;"
                        onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(212,165,116,0.3)';"
                        onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';"
                        onclick="location.href='${pageContext.request.contextPath}/travellers'">
                    Continue Booking &rarr;
                </button>
            </div>
        </div>
    </div>

    <jsp:include page="/components/footer.jsp" />

    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
