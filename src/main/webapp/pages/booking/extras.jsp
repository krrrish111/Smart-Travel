<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Add Extras – Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        /* ── Layout ───────────────────────────────────────────────── */
        .layout-grid { display:grid; grid-template-columns:2fr 1fr; gap:24px; margin-top:24px; }
        .card { background:rgba(255,255,255,0.03); border:1px solid var(--color-border); border-radius:16px; padding:28px; margin-bottom:20px; }
        .section-title { font-size:1.05rem; font-weight:800; color:var(--text-main); margin-bottom:18px; display:flex; align-items:center; gap:10px; }
        .section-title .icon { font-size:1.4rem; }

        /* ── Option Cards (radio/checkbox style) ──────────────────── */
        .options-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(170px, 1fr)); gap:12px; }
        .option-card {
            border:2px solid rgba(255,255,255,0.08); border-radius:12px;
            padding:18px 14px; cursor:pointer; position:relative;
            transition:border-color .2s, background .2s, transform .15s;
            user-select:none;
        }
        .option-card:hover  { border-color:rgba(212,165,116,0.5); transform:translateY(-2px); }
        .option-card.active { border-color:var(--color-primary); background:rgba(212,165,116,0.08); }
        .option-card input  { position:absolute; opacity:0; pointer-events:none; }
        .opt-icon  { font-size:2rem; margin-bottom:10px; display:block; }
        .opt-name  { font-weight:700; color:var(--text-main); font-size:0.9rem; }
        .opt-price { color:var(--color-primary); font-weight:800; font-size:1rem; margin-top:4px; }
        .opt-desc  { font-size:0.75rem; color:var(--color-muted); margin-top:4px; line-height:1.4; }
        .check-badge {
            position:absolute; top:10px; right:10px;
            width:20px; height:20px; border-radius:50%;
            background:var(--color-primary); color:#000;
            display:none; align-items:center; justify-content:center;
            font-size:0.7rem; font-weight:800;
        }
        .option-card.active .check-badge { display:flex; }

        /* ── Toggle Switch ────────────────────────────────────────── */
        .toggle-row {
            display:flex; align-items:center; justify-content:space-between;
            padding:18px 0; border-bottom:1px solid rgba(255,255,255,0.06);
        }
        .toggle-row:last-child { border-bottom:none; }
        .toggle-info { display:flex; align-items:center; gap:14px; }
        .toggle-icon { font-size:1.6rem; width:44px; text-align:center; }
        .toggle-label { font-weight:700; color:var(--text-main); font-size:0.95rem; }
        .toggle-sublabel { font-size:0.8rem; color:var(--color-muted); margin-top:2px; }
        .toggle-price-badge {
            background:rgba(212,165,116,0.12); color:var(--color-primary);
            font-weight:800; padding:4px 12px; border-radius:20px; font-size:0.85rem;
        }
        /* iOS-style toggle switch */
        .switch { position:relative; display:inline-block; width:46px; height:26px; }
        .switch input { opacity:0; width:0; height:0; }
        .slider {
            position:absolute; inset:0; background:rgba(255,255,255,0.12);
            border-radius:26px; cursor:pointer; transition:.3s;
        }
        .slider::before {
            content:''; position:absolute;
            width:20px; height:20px; left:3px; bottom:3px;
            background:#fff; border-radius:50%; transition:.3s;
        }
        input:checked + .slider { background:var(--color-primary); }
        input:checked + .slider::before { transform:translateX(20px); background:#000; }

        /* ── Summary sidebar ──────────────────────────────────────── */
        .fare-row { display:flex; justify-content:space-between; padding:7px 0; font-size:0.88rem; color:var(--color-muted); border-bottom:1px solid rgba(255,255,255,0.04); }
        .fare-row:last-of-type { border-bottom:none; }
        .fare-val { color:var(--text-main); font-weight:600; }
        .fare-val.highlight { color:var(--color-primary); }
        .total-row { display:flex; justify-content:space-between; margin-top:16px; padding-top:16px; border-top:1px solid rgba(255,255,255,0.12); font-size:1.2rem; font-weight:800; color:var(--text-main); }

        @media(max-width:768px) { .layout-grid { grid-template-columns:1fr; } }
    </style>
</head>
<body style="padding-top:80px; padding-bottom:60px; overflow-x:hidden;">
<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="4"/></jsp:include>

<%-- JS-accessible session values --%>
<c:set var="flightPrice" value="${sessionScope.currentFlight.price}" />
<c:set var="passengers"  value="${sessionScope.currentFlight.passengers}" />

<div class="container" style="max-width:1100px; margin:40px auto; padding:0 20px;">
    <a href="${pageContext.request.contextPath}/seat-selection" style="color:var(--color-primary); text-decoration:none;">&larr; Back to Seat Selection</a>
    <h1 class="text-white font-bold" style="font-size:2rem; margin-top:12px;">Enhance Your Journey</h1>
    <p style="color:var(--color-muted);">Optional add-ons to make your flight more comfortable.</p>

    <form action="${pageContext.request.contextPath}/booking-extras" method="post" id="extrasForm">
        <!-- hidden fields updated by JS -->
        <input type="hidden" name="meal"             id="hidMeal"      value="none">
        <input type="hidden" name="baggage"           id="hidBaggage"   value="none">
        <input type="hidden" name="priorityBoarding"  id="hidPriority"  value="false">
        <input type="hidden" name="travelInsurance"   id="hidInsurance" value="false">

        <div class="layout-grid">
            <!-- ══════════════ LEFT ══════════════ -->
            <div>
                <!-- 1. Meal Selection -->
                <div class="card">
                    <div class="section-title"><span class="icon">🍽️</span> Meal Selection</div>
                    <div class="options-grid" id="mealGroup">
                        <div class="option-card active" data-group="meal" data-value="none" onclick="pickMeal(this)">
                            <input type="radio" name="_meal" value="none" checked>
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">⛔</span>
                            <div class="opt-name">No Meal</div>
                            <div class="opt-price">Free</div>
                        </div>
                        <div class="option-card" data-group="meal" data-value="veg" onclick="pickMeal(this)">
                            <input type="radio" name="_meal" value="veg">
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">🥦</span>
                            <div class="opt-name">Vegetarian</div>
                            <div class="opt-price">+₹350</div>
                            <div class="opt-desc">Fresh salad, grains &amp; seasonal veggies</div>
                        </div>
                        <div class="option-card" data-group="meal" data-value="non-veg" onclick="pickMeal(this)">
                            <input type="radio" name="_meal" value="non-veg">
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">🍗</span>
                            <div class="opt-name">Non-Veg</div>
                            <div class="opt-price">+₹350</div>
                            <div class="opt-desc">Chicken or fish entrée with sides</div>
                        </div>
                        <div class="option-card" data-group="meal" data-value="jain" onclick="pickMeal(this)">
                            <input type="radio" name="_meal" value="jain">
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">🫙</span>
                            <div class="opt-name">Jain Meal</div>
                            <div class="opt-price">+₹400</div>
                            <div class="opt-desc">No onion, garlic or root vegetables</div>
                        </div>
                    </div>
                </div>

                <!-- 2. Extra Baggage -->
                <div class="card">
                    <div class="section-title"><span class="icon">🧳</span> Extra Baggage Allowance</div>
                    <div class="options-grid" id="baggageGroup">
                        <div class="option-card active" data-group="baggage" data-value="none" onclick="pickBaggage(this)">
                            <input type="radio" name="_bag" value="none" checked>
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">✅</span>
                            <div class="opt-name">Standard</div>
                            <div class="opt-price">Free</div>
                            <div class="opt-desc">7 kg cabin + 15 kg check-in</div>
                        </div>
                        <div class="option-card" data-group="baggage" data-value="15kg" onclick="pickBaggage(this)">
                            <input type="radio" name="_bag" value="15kg">
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">🧳</span>
                            <div class="opt-name">+15 kg</div>
                            <div class="opt-price">+₹750</div>
                            <div class="opt-desc">Good for a week-long trip</div>
                        </div>
                        <div class="option-card" data-group="baggage" data-value="30kg" onclick="pickBaggage(this)">
                            <input type="radio" name="_bag" value="30kg">
                            <div class="check-badge">✓</div>
                            <span class="opt-icon">🏋️</span>
                            <div class="opt-name">+30 kg</div>
                            <div class="opt-price">+₹1,400</div>
                            <div class="opt-desc">Best for long-haul or family travel</div>
                        </div>
                    </div>
                </div>

                <!-- 3. Toggle add-ons -->
                <div class="card">
                    <div class="section-title"><span class="icon">⭐</span> Premium Services</div>

                    <!-- Priority Boarding -->
                    <div class="toggle-row">
                        <div class="toggle-info">
                            <div class="toggle-icon">🚀</div>
                            <div>
                                <div class="toggle-label">Priority Boarding</div>
                                <div class="toggle-sublabel">Board first — pick your overhead bin space</div>
                            </div>
                        </div>
                        <div style="display:flex; align-items:center; gap:14px;">
                            <span class="toggle-price-badge">+₹499</span>
                            <label class="switch">
                                <input type="checkbox" id="togglePriority" onchange="updateToggle('priority', this.checked, 499)">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <!-- Travel Insurance -->
                    <div class="toggle-row">
                        <div class="toggle-info">
                            <div class="toggle-icon">🛡️</div>
                            <div>
                                <div class="toggle-label">Travel Insurance</div>
                                <div class="toggle-sublabel">Covers delays, cancellations &amp; medical emergencies up to ₹1 lakh</div>
                            </div>
                        </div>
                        <div style="display:flex; align-items:center; gap:14px;">
                            <span class="toggle-price-badge">+₹599</span>
                            <label class="switch">
                                <input type="checkbox" id="toggleInsurance" onchange="updateToggle('insurance', this.checked, 599)">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ══════════════ RIGHT — Live Summary ══════════════ -->
            <div class="card" style="align-self:start; position:sticky; top:100px;">
                <h3 style="font-size:1.1rem; font-weight:800; margin-bottom:20px; color:var(--text-main);">Fare Summary</h3>

                <div class="fare-row"><span>Flight (${passengers} pax)</span><span class="fare-val" id="sBase">₹<c:out value="${flightPrice * passengers}" /></span></div>
                <div class="fare-row"><span>Taxes (18%)</span>            <span class="fare-val" id="sTax">₹<c:out value="${Math.round(flightPrice * passengers * 0.18)}" /></span></div>
                <div class="fare-row"><span>Convenience Fee</span>        <span class="fare-val" id="sConv">₹<c:out value="${350 * passengers}" /></span></div>
                <div class="fare-row"><span>Seat Charges</span>           <span class="fare-val" id="sSeat">₹<c:out value="${sessionScope.seatCharges != null ? sessionScope.seatCharges : 0}" /></span></div>

                <div style="height:10px;"></div>

                <div class="fare-row"><span>🍽️ Meal</span>               <span class="fare-val highlight" id="sMeal">Free</span></div>
                <div class="fare-row"><span>🧳 Extra Baggage</span>       <span class="fare-val highlight" id="sBag">Free</span></div>
                <div class="fare-row"><span>🚀 Priority Boarding</span>   <span class="fare-val highlight" id="sPri">Free</span></div>
                <div class="fare-row"><span>🛡️ Travel Insurance</span>    <span class="fare-val highlight" id="sIns">Free</span></div>

                <div class="total-row">
                    <span>Total</span>
                    <span style="color:var(--color-primary);" id="sTotal">₹—</span>
                </div>

                <button type="submit" class="btn-select"
                        style="margin-top:22px; width:100%; padding:14px; font-weight:800; font-size:1.05rem; border-radius:8px; background:var(--color-primary); color:#000; border:none; cursor:pointer; transition:transform .2s,box-shadow .2s;"
                        onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 6px 18px rgba(212,165,116,.35)';"
                        onmouseout="this.style.transform='';this.style.boxShadow='';">
                    Review Booking &rarr;
                </button>
                <p style="text-align:center; font-size:0.75rem; color:var(--color-muted); margin-top:10px;">You can skip all extras for free.</p>
            </div>
        </div>
    </form>
</div>

<script>
/* ── State ─────────────────────────────────────────────────────────── */
const pax = parseInt('${passengers}') || 1;
const base = parseFloat('${flightPrice}') * pax;
const taxes = Math.round(base * 0.18);
const conv = 350 * pax;
const seat = parseFloat('${sessionScope.seatCharges}') || 0;

const prices = { meal:0, baggage:0, priority:0, insurance:0 };
const mealMap    = { none:0, veg:350, 'non-veg':350, jain:400 };
const baggageMap = { none:0, '15kg':750, '30kg':1400 };

/* ── Meal ──────────────────────────────────────────────────────────── */
function pickMeal(card) {
    document.querySelectorAll('#mealGroup .option-card').forEach(c => c.classList.remove('active'));
    card.classList.add('active');
    const val = card.dataset.value;
    document.getElementById('hidMeal').value = val;
    prices.meal = (mealMap[val] || 0) * pax;
    document.getElementById('sMeal').textContent = prices.meal ? '₹'+prices.meal : 'Free';
    recalc();
}

/* ── Baggage ───────────────────────────────────────────────────────── */
function pickBaggage(card) {
    document.querySelectorAll('#baggageGroup .option-card').forEach(c => c.classList.remove('active'));
    card.classList.add('active');
    const val = card.dataset.value;
    document.getElementById('hidBaggage').value = val;
    prices.baggage = (baggageMap[val] || 0) * pax;
    document.getElementById('sBag').textContent = prices.baggage ? '₹'+prices.baggage : 'Free';
    recalc();
}

/* ── Toggle ────────────────────────────────────────────────────────── */
function updateToggle(type, checked, perPaxPrice) {
    if (type === 'priority') {
        document.getElementById('hidPriority').value = checked ? 'true' : 'false';
        prices.priority = checked ? perPaxPrice * pax : 0;
        document.getElementById('sPri').textContent = prices.priority ? '₹'+prices.priority : 'Free';
    } else {
        document.getElementById('hidInsurance').value = checked ? 'true' : 'false';
        prices.insurance = checked ? perPaxPrice * pax : 0;
        document.getElementById('sIns').textContent = prices.insurance ? '₹'+prices.insurance : 'Free';
    }
    recalc();
}

/* ── Recalculate Grand Total ───────────────────────────────────────── */
function recalc() {
    const extras = prices.meal + prices.baggage + prices.priority + prices.insurance;
    const grand  = Math.round(base + taxes + conv + seat + extras);
    document.getElementById('sTotal').textContent = '₹'+grand.toLocaleString('en-IN');
}

/* ── Init ──────────────────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', recalc);
</script>

<jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
