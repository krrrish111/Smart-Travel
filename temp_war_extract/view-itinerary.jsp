<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<style>
    .itinerary-view-header {
        background: linear-gradient(135deg, rgba(59, 130, 246, 0.1), rgba(147, 51, 234, 0.1));
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 24px;
        padding: 40px;
        margin-bottom: 40px;
        position: relative;
        overflow: hidden;
    }
    
    .day-card {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 20px;
        padding: 24px;
        margin-bottom: 24px;
        transition: all 0.3s ease;
    }
    
    .day-card:hover {
        background: rgba(255, 255, 255, 0.05);
        border-color: var(--color-primary);
        transform: translateX(5px);
    }
</style>

<main style="padding-top: 100px; padding-bottom: 80px; min-height: 100vh;">
    <div class="container relative z-10">
        
        <!-- Navigation Back -->
        <div class="mb-8 slide-up">
            <a href="dashboard.jsp" class="text-muted hover:text-white flex items-center gap-2 no-underline transition-all">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Back to Dashboard
            </a>
        </div>

        <c:if test="${not empty itinerary}">
            <div class="itinerary-view-header slide-up">
                <div class="flex justify-between items-start">
                    <div>
                        <span class="text-primary font-bold text-sm tracking-widest uppercase mb-2 block">Saved Itinerary</span>
                        <h1 class="text-white editorial mb-2" style="font-size: 3rem;">${itinerary.title}</h1>
                        <p class="text-muted font-body mb-0">Destination: <span class="text-white">${itinerary.destination}</span></p>
                    </div>
                    <div class="text-right">
                        <button onclick="window.print()" class="btn btn-outline" style="padding: 10px 20px; border-radius: 50px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 8px;"><path d="M6 9V2h12v7M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 14h12v8H6z"/></svg>
                            Print Trip
                        </button>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
                
                <!-- Main Plan -->
                <div class="lg:col-span-2 slide-up delay-1">
                    <h2 class="text-white editorial mb-6" style="font-size: 1.75rem;">Daily Schedule</h2>
                    <div id="itineraryContainer">
                        <!-- Rendered via JS -->
                    </div>
                </div>

                <!-- Summary Sidebar -->
                <div class="slide-up delay-2">
                    <div class="glass-panel" style="padding: 30px; border-radius: 24px; position: sticky; top: 120px;">
                        
                        <div class="mb-8">
                            <h3 class="text-white editorial text-lg mb-4">Budget Breakdown</h3>
                            <div id="budgetContainer" class="flex flex-col gap-3"></div>
                        </div>

                        <div class="mb-8">
                            <h3 class="text-white editorial text-lg mb-4">Must-Visit Spots</h3>
                            <ul id="visitContainer" class="flex flex-wrap gap-2 list-none p-0"></ul>
                        </div>

                        <div>
                            <h3 class="text-white editorial text-lg mb-4">Travel Tips</h3>
                            <ul id="tipsContainer" class="text-muted text-sm flex flex-col gap-2" style="padding-left: 20px;"></ul>
                        </div>

                    </div>
                </div>

            </div>
        </c:if>

    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const rawData = `${itinerary.itineraryData}`;
        if (!rawData) return;

        try {
            const data = JSON.parse(rawData);
            renderItinerary(data);
        } catch (e) {
            console.error("JSON parsing error:", e);
            document.getElementById('itineraryContainer').innerHTML = '<div class="text-red-400">Error rendering itinerary data.</div>';
        }
    });

    function renderItinerary(data) {
        // Render Days
        const container = document.getElementById('itineraryContainer');
        container.innerHTML = '';
        
        data.days.forEach(day => {
            const card = document.createElement('div');
            card.className = 'day-card';
            
            let activitiesHtml = '';
            day.activities.forEach(act => {
                activitiesHtml += `
                    <div class="flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all">
                        <div class="text-[0.65rem] text-muted font-bold uppercase w-16 pt-1">${act.time}</div>
                        <div class="flex-1 text-sm text-main">${act.description}</div>
                    </div>
                `;
            });

            card.innerHTML = `
                <h4 class="text-primary font-bold mb-4" style="font-size: 1.25rem;">Day ${day.day}: ${day.title}</h4>
                <div class="flex flex-col gap-1">${activitiesHtml}</div>
            `;
            container.appendChild(card);
        });

        // Render Budget
        const budgetContainer = document.getElementById('budgetContainer');
        data.budget_summary.forEach(item => {
            const div = document.createElement('div');
            div.className = 'flex justify-between items-center text-sm';
            div.innerHTML = `<span class="text-muted">${item.category}</span><span class="text-white font-bold">${item.amount}</span>`;
            budgetContainer.appendChild(div);
        });

        // Render Must-Visits
        const visitContainer = document.getElementById('visitContainer');
        data.must_visit.forEach(place => {
            const li = document.createElement('li');
            li.className = 'px-3 py-1 bg-white/10 rounded-full text-[0.7rem] text-muted border border-white/5';
            li.innerText = place;
            visitContainer.appendChild(li);
        });

        // Render Tips
        const tipsContainer = document.getElementById('tipsContainer');
        data.travel_tips.forEach(tip => {
            const li = document.createElement('li');
            li.innerText = tip;
            tipsContainer.appendChild(li);
        });
    }
</script>

<%@ include file="components/footer.jsp" %>
