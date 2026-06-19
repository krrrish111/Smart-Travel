<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

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

            <!-- Origin & Destination -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Origin</label>
                    <input type="text" id="routeStart" name="startLocation" class="form-control" placeholder="e.g. Delhi" style="border-radius: 12px; padding: 12px;" required>
                </div>
                <div class="form-group">
                    <label class="form-label text-xs uppercase tracking-wider text-muted font-semibold mb-2 block">Destination</label>
                    <input type="text" id="routeEnd" name="destination" class="form-control" placeholder="e.g. Goa" style="border-radius: 12px; padding: 12px;" required>
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
                Generate AI Itinerary
            </button>
        </form>
    </div>

</main>

<script>
document.addEventListener('DOMContentLoaded', () => {
    console.log("Planner Loaded");
});

function showLoading(event) {
    console.log("Generate Clicked");
    const depDate = document.getElementById('depDate').value;
    const retDate = document.getElementById('retDate').value;
    if (new Date(depDate) < new Date(new Date().toDateString())) {
        event.preventDefault();
        const err = "Departure date cannot be in the past.";
        console.error(err);
        VoyastraToast.show(err, "error");
        return false;
    }
    if (new Date(retDate) < new Date(depDate)) {
        event.preventDefault();
        const err = "Return date must be after departure date.";
        console.error(err);
        VoyastraToast.show(err, "error");
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