<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/google-places-autocomplete.css">
<script src="${pageContext.request.contextPath}/js/google-places-autocomplete.js"></script>
<%
    // Capture URL parameters for pre-filling
    String preDestination = request.getParameter("location");
    if (preDestination == null) preDestination = request.getParameter("destination");
    if (preDestination == null) preDestination = "";
    preDestination = preDestination.trim();

    String preDays = request.getParameter("days");
    if (preDays == null) preDays = "";

    request.setAttribute("preDestination", preDestination);
    request.setAttribute("preDays", preDays);
%>

<style>
    /* Planner entrance highlight when pre-filled */
    .prefill-banner {
        display: flex;
        align-items: center;
        gap: 12px;
        background: linear-gradient(135deg, rgba(212,165,116,0.12), rgba(96,165,250,0.08));
        border: 1px solid rgba(212,165,116,0.3);
        border-radius: 14px;
        padding: 14px 18px;
        margin-bottom: 24px;
        animation: prefillFadeIn 0.6s ease both;
    }
    @keyframes prefillFadeIn {
        from { opacity: 0; transform: translateY(-8px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    .prefill-banner-icon { font-size: 20px; flex-shrink: 0; }
    .prefill-banner-text { font-size: 12px; color: rgba(255,255,255,0.75); line-height: 1.4; }
    .prefill-banner-text strong { color: var(--color-primary); font-family: 'Outfit', sans-serif; }
    .prefill-dest-chip {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        background: rgba(212,165,116,0.15);
        color: var(--color-primary);
        font-size: 10px;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        padding: 3px 10px;
        border-radius: 20px;
        border: 1px solid rgba(212,165,116,0.25);
        margin-top: 4px;
        display: inline-block;
    }
    /* Highlight the destination input when pre-filled */
    #routeEnd.prefilled {
        border-color: rgba(212,165,116,0.5) !important;
        box-shadow: 0 0 0 3px rgba(212,165,116,0.12);
        animation: fieldGlow 0.8s ease both;
    }
    @keyframes fieldGlow {
        0%   { box-shadow: 0 0 0 0 rgba(212,165,116,0.4); }
        50%  { box-shadow: 0 0 0 8px rgba(212,165,116,0.1); }
        100% { box-shadow: 0 0 0 3px rgba(212,165,116,0.12); }
    }
</style>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center;">

    <!-- Loading Overlay -->
    <div id="aiLoadingOverlay" class="ai-loading-overlay">
        <div class="ai-orb"></div>
        <h2 class="ai-loading-text">Generating your trip...</h2>
        <p class="ai-loading-subtext">Optimizing travel routes and fetching details...</p>
    </div>

    <div class="text-center mb-8 slide-up" style="max-width: 600px;">
        <h1 class="text-primary mb-2 editorial" style="font-size: 3rem; background: linear-gradient(90deg, #fff 60%, var(--color-primary-light) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Interactive Trip Planner</h1>
        <p class="text-muted text-sm" style="font-family: 'Poppins', 'Inter', sans-serif; font-size: 1rem;">Let AI craft your personalized adventure. Fill in your details below to get started.</p>
    </div>

    <!-- Glassmorphic Input Form -->
    <div class="glass-panel w-full max-w-xl slide-up delay-1" style="padding: 40px; border-radius: 24px; border: 1px solid rgba(214,166,107,0.15); box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
        <form id="plannerForm" action="${pageContext.request.contextPath}/planner" method="POST" onsubmit="return showLoading(event)">
            <input type="hidden" name="action" value="generate">

            <c:if test="${not empty error}">
                <div class="bg-red-500/20 border border-red-500/50 rounded-lg p-4 mb-6">
                    <div class="flex items-center gap-3">
                        <i class="ri-error-warning-fill text-red-400 text-2xl"></i>
                        <p class="text-white text-sm font-bold">${error}</p>
                    </div>
                </div>
            </c:if>

            <%-- Pre-fill banner: shown only when arriving from Explorer --%>
            <c:if test="${not empty preDestination}">
            <div class="prefill-banner">
                <span class="prefill-banner-icon">🗺️</span>
                <div class="prefill-banner-text">
                    Destination pre-filled from your Explorer session.<br>
                    <span class="prefill-dest-chip">📍 ${preDestination}</span>
                </div>
            </div>
            </c:if>

            <!-- Origin & Destination -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Origin</label>
                    <input type="text" id="routeStart" name="startLocation" class="form-control" placeholder="e.g. Delhi" style="border-radius: 12px; padding: 12px;" required>
                </div>
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Destination</label>
                    <input type="text" id="routeEnd" name="destination" class="form-control" placeholder="e.g. Goa" style="border-radius: 12px; padding: 12px;" required
                           value="${preDestination}">
                </div>
            </div>

            <!-- Dates -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Departure Date</label>
                    <input type="date" id="depDate" name="departureDate" class="form-control" style="border-radius: 12px; padding: 12px;" required>
                </div>
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Return Date</label>
                    <input type="date" id="retDate" name="returnDate" class="form-control" style="border-radius: 12px; padding: 12px;" required>
                </div>
            </div>

            <!-- Budget & Travel Style -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Est. Budget</label>
                    <input type="number" id="budgetInput" name="budget" class="form-control" min="1000" placeholder="₹" value="50000" style="border-radius: 12px; padding: 12px;" required>
                </div>
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Travel Style</label>
                    <select name="type" class="form-control" style="appearance: auto; border-radius: 12px; padding: 12px; background: var(--color-surface);">
                        <option value="Relaxation">Relaxation</option>
                        <option value="Adventure">Adventure</option>
                        <option value="Spiritual">Spiritual</option>
                        <option value="Luxury">Luxury</option>
                    </select>
                </div>
            </div>

            <!-- Travelers -->
            <div class="form-group mb-8">
                <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-3 block">Travelers</label>
                <div class="grid grid-cols-3 gap-4">
                    <div class="glass-panel p-3 text-center" style="border-radius: 12px; background: rgba(255,255,255,0.02);">
                        <label class="text-[0.65rem] text-muted uppercase font-bold block mb-1">Adults</label>
                        <input type="number" name="adults" class="form-control text-center p-2" min="1" value="1" style="border-radius: 8px;" required>
                    </div>
                    <div class="glass-panel p-3 text-center" style="border-radius: 12px; background: rgba(255,255,255,0.02);">
                        <label class="text-[0.65rem] text-muted uppercase font-bold block mb-1">Children</label>
                        <input type="number" name="children" class="form-control text-center p-2" min="0" value="0" style="border-radius: 8px;">
                    </div>
                    <div class="glass-panel p-3 text-center" style="border-radius: 12px; background: rgba(255,255,255,0.02);">
                        <label class="text-[0.65rem] text-muted uppercase font-bold block mb-1">Seniors</label>
                        <input type="number" name="seniors" class="form-control text-center p-2" min="0" value="0" style="border-radius: 8px;">
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" id="btnGenerateAI" class="btn btn-primary w-full" style="padding: 16px; font-size: 1.1rem; border-radius: 50px; font-weight: 700; transition: all 0.3s; box-shadow: 0 4px 15px rgba(214,166,107,0.3);">
                🚀 Generate AI Itinerary
            </button>
        </form>
    </div>

</main>

<script>
document.addEventListener('DOMContentLoaded', () => {
    console.log("Planner Loaded");

    // ── Pre-fill destination and dates from URL params ──────────────────────
    const urlParams   = new URLSearchParams(window.location.search);
    const destParam   = urlParams.get('location') || urlParams.get('destination') || '';
    const daysParam   = parseInt(urlParams.get('days') || '0', 10);

    const destField = document.getElementById('routeEnd');
    const depField  = document.getElementById('depDate');
    const retField  = document.getElementById('retDate');

    // Pre-fill destination field
    if (destParam && destField) {
        destField.value = destParam;
        destField.classList.add('prefilled');
        // pulse the field briefly to draw attention
        setTimeout(() => destField.focus(), 400);
    }

    // Auto-set departure date to tomorrow
    const today    = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const fmt = (d) => d.toISOString().split('T')[0];
    if (depField) depField.value = fmt(tomorrow);

    // Auto-set return date based on days param or default 5 days
    const tripDays = daysParam > 0 ? daysParam : 5;
    const returnDate = new Date(tomorrow);
    returnDate.setDate(returnDate.getDate() + tripDays - 1);
    if (retField) retField.value = fmt(returnDate);

    if (typeof initGooglePlacesAutocomplete === 'function') {
        initGooglePlacesAutocomplete('routeStart');
        initGooglePlacesAutocomplete('routeEnd');
    }
});

function showLoading(event) {
    console.log("Generate Clicked");
    const depDate = document.getElementById('depDate').value;
    const retDate = document.getElementById('retDate').value;
    if (new Date(depDate) < new Date(new Date().toDateString())) {
        event.preventDefault();
        const err = "Departure date cannot be in the past.";
        console.error(err);
        if (typeof VoyastraToast !== 'undefined') {
            VoyastraToast.show(err, "error");
        } else {
            alert(err);
        }
        return false;
    }
    if (new Date(retDate) < new Date(depDate)) {
        event.preventDefault();
        const err = "Return date must be after departure date.";
        console.error(err);
        if (typeof VoyastraToast !== 'undefined') {
            VoyastraToast.show(err, "error");
        } else {
            alert(err);
        }
        return false;
    }

    console.log("Sending Request");
    const overlay = document.getElementById('aiLoadingOverlay');
    if (overlay) {
        overlay.classList.add('active');
    }
    return true;
}
</script>

<%@ include file="/components/footer.jsp" %>