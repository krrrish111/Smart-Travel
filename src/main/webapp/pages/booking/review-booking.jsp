<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Review Booking - Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        .layout-grid { display:grid; grid-template-columns:2fr 1fr; gap:24px; margin-top:24px; }
        .card { background:rgba(255,255,255,0.03); border:1px solid var(--color-border); border-radius:16px; padding:28px; margin-bottom:20px; }
        .section-title { font-size:1rem; font-weight:800; color:var(--color-primary); margin-bottom:16px; text-transform:uppercase; letter-spacing:0.05em; }
        .info-row { display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid rgba(255,255,255,0.04); }
        .info-row:last-child { border-bottom:none; }
        .info-label { color:var(--color-muted); font-size:0.9rem; }
        .info-val { color:var(--text-main); font-weight:600; font-size:0.9rem; }
        .summary-row { display:flex; justify-content:space-between; margin-bottom:10px; color:var(--color-muted); font-size:0.9rem; }
        .summary-row.total { border-top:1px solid rgba(255,255,255,0.12); padding-top:14px; margin-top:14px; color:var(--text-main); font-size:1.3rem; font-weight:800; }
        .traveller-block { background:rgba(0,0,0,0.15); border-radius:10px; padding:16px 20px; margin-bottom:12px; border:1px solid rgba(255,255,255,0.05); }
        .checkbox-container { display:flex; align-items:flex-start; gap:10px; margin:20px 0; font-size:0.85rem; color:var(--color-muted); line-height:1.4; }
        .checkbox-container input { margin-top:4px; accent-color:var(--color-primary); width:16px; height:16px; cursor:pointer; }
        .checkbox-container a { color:var(--color-primary); text-decoration:underline; }
        @media(max-width:768px){ .layout-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body style="padding-top:80px; padding-bottom:60px; overflow-x:hidden;">
<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="5"/></jsp:include>

<div class="container" style="max-width:1100px; margin:40px auto; padding:0 20px;">
    <a href="javascript:history.back()" style="color:var(--color-primary); text-decoration:none;">&larr; Back to Extras</a>
    <h1 class="text-white font-bold" style="font-size:2rem; margin-top:12px;">Review Your Booking</h1>
    <p style="color:var(--color-muted);">Please verify all details before proceeding to payment.</p>

    <div class="layout-grid">
        <!-- Left: Details -->
        <div>
            <!-- Flight Info -->
            <div class="card">
                <div class="section-title">✈️ Flight Details</div>
                <div class="info-row"><span class="info-label">Flight</span><span class="info-val">${sessionScope.currentFlight.name} (${sessionScope.currentFlight.id})</span></div>
                <div class="info-row"><span class="info-label">Route</span><span class="info-val">${sessionScope.currentFlight.from} → ${sessionScope.currentFlight.to}</span></div>
                <div class="info-row"><span class="info-label">Date</span><span class="info-val">${sessionScope.currentFlight.date}</span></div>
                <div class="info-row"><span class="info-label">Class</span><span class="info-val" style="text-transform:capitalize;">${sessionScope.currentFlight['class']}</span></div>
                <div class="info-row"><span class="info-label">Passengers</span><span class="info-val">${sessionScope.currentFlight.passengers} Adult(s)</span></div>
                <div class="info-row"><span class="info-label">Seats</span><span class="info-val">${sessionScope.selectedSeats}</span></div>
            </div>

            <!-- Travellers -->
            <div class="card">
                <div class="section-title">👤 Traveller Details</div>
                <c:forEach items="${travellers}" var="t" varStatus="st">
                    <div class="traveller-block">
                        <div style="font-weight:700; color:var(--text-main); margin-bottom:8px;">Passenger ${st.index + 1} — ${t.title} ${t.firstName} ${t.lastName}</div>
                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:6px;">
                            <div class="info-row"><span class="info-label">Gender</span><span class="info-val">${t.gender}</span></div>
                            <div class="info-row"><span class="info-label">DOB</span><span class="info-val">${t.dob}</span></div>
                            <div class="info-row"><span class="info-label">Nationality</span><span class="info-val">${t.nationality}</span></div>
                            <div class="info-row"><span class="info-label">Seat</span><span class="info-val">${t.seatNumber}</span></div>
                            <c:if test="${not empty t.passport}">
                                <div class="info-row"><span class="info-label">Passport</span><span class="info-val">${t.passport}</span></div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Add-ons -->
            <div class="card">
                <div class="section-title">🎁 Selected Extras</div>
                <div class="info-row">
                    <span class="info-label">Meal</span>
                    <span class="info-val" style="text-transform:capitalize;">${not empty sessionScope.extras_meal && sessionScope.extras_meal != 'none' ? sessionScope.extras_meal : 'Not Added'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Extra Baggage</span>
                    <span class="info-val">${not empty sessionScope.extras_baggage && sessionScope.extras_baggage != 'none' ? sessionScope.extras_baggage : 'Not Added'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Priority Boarding</span>
                    <span class="info-val">${sessionScope.extrasPriority == 'true' ? '✅ Included' : 'Not Added'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Travel Insurance</span>
                    <span class="info-val">${sessionScope.extrasInsurance == 'true' ? '✅ Included' : 'Not Added'}</span>
                </div>
            </div>
        </div>

        <!-- Right: Fare Breakdown -->
        <div class="card" style="align-self:start; position:sticky; top:100px;">
            <h3 style="font-size:1.2rem; font-weight:800; margin-bottom:20px;">Fare Breakdown</h3>

            <div class="summary-row"><span>Base Fare</span><span style="color:var(--text-main); font-weight:600;">₹${baseFare}</span></div>
            <div class="summary-row"><span>Taxes &amp; Surcharges (18%)</span><span style="color:var(--text-main); font-weight:600;">₹${taxes}</span></div>
            <div class="summary-row"><span>Convenience Fee</span><span style="color:var(--text-main); font-weight:600;">₹${convFee}</span></div>
            <div class="summary-row"><span>Seat Charges</span><span style="color:var(--text-main); font-weight:600;">₹${seatCharges}</span></div>
            <div class="summary-row"><span>Extras</span><span style="color:var(--text-main); font-weight:600;">₹${extrasTotal}</span></div>
            <div class="summary-row total"><span>Total Amount</span><span style="color:var(--color-primary);">₹${grandTotal}</span></div>

            <!-- Terms Checkbox -->
            <div class="checkbox-container">
                <input type="checkbox" id="termsCheckbox" onchange="togglePayButton()">
                <label for="termsCheckbox">I have reviewed my booking and agree to Voyastra's <a href="#">Terms &amp; Conditions</a>, <a href="#">Privacy Policy</a>, and the airline's cancellation policy.</label>
            </div>

            <!-- Proceed to payment -->
            <form action="${pageContext.request.contextPath}/api/process-payment" method="get">
                <button type="submit" id="btnProceed" disabled class="btn-select" style="margin-top:10px; width:100%; padding:14px; font-weight:800; font-size:1.1rem; border-radius:8px; background:var(--color-primary); color:#000; border:none; cursor:not-allowed; opacity:0.5; transition:transform 0.2s, box-shadow 0.2s;">
                    Proceed to Payment &rarr;
                </button>
            </form>

            <p style="font-size:0.75rem; color:var(--color-muted); text-align:center; margin-top:12px;">
                🔒 Secured by 256-bit SSL encryption
            </p>
        </div>
    </div>
</div>

<script>
    function togglePayButton() {
        const checkbox = document.getElementById('termsCheckbox');
        const btn = document.getElementById('btnProceed');
        
        if (checkbox.checked) {
            btn.disabled = false;
            btn.style.opacity = '1';
            btn.style.cursor = 'pointer';
        } else {
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.style.cursor = 'not-allowed';
        }
    }
</script>

<jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
