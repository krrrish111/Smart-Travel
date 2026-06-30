async function fetchJourneyData(endpoint) {
    try {
        const ctx = window.CONTEXT_PATH || '';
        const response = await fetch(ctx + '/api/journey/' + endpoint);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching ' + endpoint + ':', error);
        return null;
    }
}

async function loadMemories() {
    const container = document.getElementById('memories-grid-container');
    if (!container) return;
    container.innerHTML = '<div style="text-align: center; width: 100%; padding: 40px;"><i class="ri-loader-4-line" style="animation: spin 1s linear infinite; font-size: 2rem;"></i></div>';
    
    const trips = await fetchJourneyData('completed');
    if (!trips || trips.length === 0) {
        const ctx = window.CONTEXT_PATH || '';
        container.innerHTML = `
            <div style="text-align: center; padding: 40px; width: 100%;">
                <p style="color: var(--text-secondary); margin-bottom: 20px;">You don't have any completed trips to generate memories from yet.</p>
                <a href="${ctx}/pages/common/explore.jsp" class="btn" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none;">Explore Destinations</a>
            </div>`;
        return;
    }

    let html = '<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; width: 100%;">';
    trips.forEach(trip => {
        html += `
        <div class="trip-card" style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; overflow: hidden; transition: transform 0.3s ease; cursor: pointer;" onclick="openMemoryModal(${trip.id})">
            <div style="height: 160px; background: url('https://images.unsplash.com/photo-1506929562872-bb421503ef21?q=80&w=600&auto=format&fit=crop') center/cover;"></div>
            <div style="padding: 20px;">
                <h3 style="font-size: 1.4rem; font-family: 'Clash Display', sans-serif; margin-bottom: 5px;">${trip.planTitle ? trip.planTitle : trip.type}</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 15px;"><i class="ri-calendar-event-line"></i> ${trip.travelDate ? trip.travelDate : 'Archived'}</p>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="background: rgba(255,107,0,0.1); color: var(--primary); padding: 4px 10px; border-radius: 12px; font-size: 0.8rem;">View Album <i class="ri-arrow-right-line"></i></span>
                </div>
            </div>
        </div>`;
    });
    html += '</div>';
    container.innerHTML = html;
}

async function loadTravelDNA() {
    const dnaContainer = document.getElementById('dna-container-main');
    if (!dnaContainer) return;
    dnaContainer.innerHTML = '<div style="text-align: center; width: 100%; padding: 40px;"><i class="ri-loader-4-line" style="animation: spin 1s linear infinite; font-size: 2rem;"></i></div>';

    const dna = await fetchJourneyData('dna');
    if (!dna || dna.explorerScore === undefined) {
        const ctx = window.CONTEXT_PATH || '';
        dnaContainer.innerHTML = `
            <div style="text-align: center; padding: 40px; width: 100%;">
                <p style="color: var(--text-secondary); margin-bottom: 20px;">Complete your first trip to unlock Travel DNA.</p>
                <a href="${ctx}/pages/common/explore.jsp" class="btn" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none;">Book a Trip</a>
            </div>`;
        return;
    }

    let insightsHtml = '';
    if (dna.aiInsights) {
        dna.aiInsights.forEach(insight => {
            insightsHtml += `<li>${insight}</li>`;
        });
    }

    dnaContainer.innerHTML = `
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px; width: 100%;">
            <div>
                <div class="dna-bar-container">
                    <div class="dna-bar-header"><span>Explorer Profile</span> <span style="font-weight:bold; color: var(--primary);">${dna.explorerScore}%</span></div>
                    <div class="dna-track"><div class="dna-fill" style="width: ${dna.explorerScore}%; background: var(--primary); box-shadow: 0 0 10px var(--primary);"></div></div>
                </div>
                <div class="dna-bar-container">
                    <div class="dna-bar-header"><span>Foodie Profile</span> <span style="font-weight:bold; color: #e17055;">${dna.foodieScore}%</span></div>
                    <div class="dna-track"><div class="dna-fill" style="width: ${dna.foodieScore}%; background: #e17055; box-shadow: 0 0 10px #e17055;"></div></div>
                </div>
                <div class="dna-bar-container">
                    <div class="dna-bar-header"><span>Adventure Profile</span> <span style="font-weight:bold; color: #00b894;">${dna.adventureScore}%</span></div>
                    <div class="dna-track"><div class="dna-fill" style="width: ${dna.adventureScore}%; background: #00b894; box-shadow: 0 0 10px #00b894;"></div></div>
                </div>
                <div class="dna-bar-container">
                    <div class="dna-bar-header"><span>Photography Profile</span> <span style="font-weight:bold; color: #fdcb6e;">${dna.photographyScore}%</span></div>
                    <div class="dna-track"><div class="dna-fill" style="width: ${dna.photographyScore}%; background: #fdcb6e; box-shadow: 0 0 10px #fdcb6e;"></div></div>
                </div>
                <div class="dna-bar-container">
                    <div class="dna-bar-header"><span>Luxury Profile</span> <span style="font-weight:bold; color: #0984e3;">${dna.luxuryScore}%</span></div>
                    <div class="dna-track"><div class="dna-fill" style="width: ${dna.luxuryScore}%; background: #0984e3; box-shadow: 0 0 10px #0984e3;"></div></div>
                </div>
                <div class="dna-bar-container">
                    <div class="dna-bar-header"><span>Budget Profile</span> <span style="font-weight:bold; color: #d63031;">${dna.budgetScore}%</span></div>
                    <div class="dna-track"><div class="dna-fill" style="width: ${dna.budgetScore}%; background: #d63031; box-shadow: 0 0 10px #d63031;"></div></div>
                </div>
            </div>
            
            <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 25px;">
                <h4 style="margin-bottom: 15px; color: white; font-size: 1.2rem;">AI Insights</h4>
                <ul style="color: var(--text-secondary); padding-left: 20px; line-height: 1.8;">
                    ${insightsHtml}
                </ul>
            </div>
        </div>
    `;
}

async function loadFamilyHub() {
    const container = document.getElementById('family-grid-container');
    if (!container) return;
    container.innerHTML = '<div style="text-align: center; width: 100%; padding: 40px;"><i class="ri-loader-4-line" style="animation: spin 1s linear infinite; font-size: 2rem;"></i></div>';

    const members = await fetchJourneyData('family');
    if (!members || members.length === 0) {
        container.innerHTML = `
            <div style="text-align: center; padding: 40px; width: 100%;">
                <p style="color: var(--text-secondary); margin-bottom: 20px;">No family members added yet.</p>
                <button class="btn" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; border: none;">Add Family Member</button>
            </div>`;
        return;
    }

    let html = '';
    members.forEach(member => {
        let readinessColor = member.passportReadiness === 100 ? '#00b894' : 'var(--primary)';
        html += `
        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 20px; text-align: center; position: relative;">
            <div style="width: 80px; height: 80px; border-radius: 50%; background: rgba(255,255,255,0.1); margin: 0 auto 15px; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: var(--text-secondary);">
                <i class="ri-user-line"></i>
            </div>
            <h3 style="color: white; font-size: 1.2rem; margin-bottom: 5px;">${member.name}</h3>
            <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 15px;">${member.relation}</p>
            
            <div style="text-align: left; background: rgba(0,0,0,0.3); padding: 15px; border-radius: 12px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.8rem;">
                    <span style="color: var(--text-secondary);">Travel Readiness</span>
                    <span style="color: ${readinessColor}; font-weight: bold;">${member.passportReadiness}%</span>
                </div>
                <div style="height: 6px; background: rgba(255,255,255,0.1); border-radius: 3px; overflow: hidden;">
                    <div style="height: 100%; width: ${member.passportReadiness}%; background: ${readinessColor};"></div>
                </div>
            </div>
            <button class="btn btn-outline" style="width: 100%; margin-top: 15px; padding: 8px; font-size: 0.85rem;">Manage Profile</button>
        </div>`;
    });
    container.innerHTML = html;
}

async function loadCompletedTrips() {
    const container = document.getElementById('completed-trips-container');
    if (!container) return;
    container.innerHTML = '<div style="text-align: center; width: 100%; padding: 40px;"><i class="ri-loader-4-line" style="animation: spin 1s linear infinite; font-size: 2rem;"></i></div>';

    const trips = await fetchJourneyData('completed');
    if (!trips || trips.length === 0) {
        const ctx = window.CONTEXT_PATH || '';
        container.innerHTML = `
            <div style="text-align: center; padding: 40px; width: 100%;">
                <p style="color: var(--text-secondary); margin-bottom: 20px;">No completed trips yet.</p>
                <a href="${ctx}/pages/common/explore.jsp" class="btn" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none;">Explore Destinations</a>
            </div>`;
        return;
    }

    let html = '';
    trips.forEach(trip => {
        html += `
        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 25px; margin-bottom: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                <div>
                    <h3 style="color: white; font-size: 1.5rem; font-family: 'Clash Display', sans-serif;">
                        ${trip.planTitle ? trip.planTitle : trip.type}
                    </h3>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;"><i class="ri-calendar-check-line"></i> ${trip.travelDate ? trip.travelDate : 'Archived'}</p>
                </div>
                <div style="text-align: right;">
                    <h3 style="color: var(--primary); font-size: 1.5rem;">₹${trip.totalPrice}</h3>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Total Cost</p>
                </div>
            </div>
            <div style="margin-top: 15px;">
                <button class="btn btn-outline" style="padding: 5px 10px; font-size: 0.8rem;" onclick="switchTab('memories', document.querySelector('.nav-item:nth-child(4)'))"><i class="ri-camera-lens-line"></i> Add Memories</button>
            </div>
        </div>`;
    });
    container.innerHTML = html;
}

async function loadReports() {
    const reportCardsContainer = document.getElementById('report-cards-container');
    const recentReportsContainer = document.getElementById('recent-reports-container');
    if (!reportCardsContainer || !recentReportsContainer) return;
    
    reportCardsContainer.innerHTML = '<div style="text-align: center; width: 100%; padding: 40px; grid-column: 1 / -1;"><i class="ri-loader-4-line" style="animation: spin 1s linear infinite; font-size: 2rem;"></i></div>';

    const annual = await fetchJourneyData('annual-report');
    if (!annual || annual.citiesVisited === undefined) {
        const ctx = window.CONTEXT_PATH || '';
        reportCardsContainer.innerHTML = `
            <div style="text-align: center; padding: 40px; width: 100%; grid-column: 1 / -1;">
                <p style="color: var(--text-secondary); margin-bottom: 20px;">No trips completed yet to generate reports.</p>
                <a href="${ctx}/pages/common/explore.jsp" class="btn" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none;">Book a Trip</a>
            </div>`;
        recentReportsContainer.innerHTML = '';
        return;
    }

    reportCardsContainer.innerHTML = `
        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 25px;">
            <div style="width: 50px; height: 50px; border-radius: 12px; background: rgba(255,107,0,0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px;">
                <i class="ri-wallet-3-line"></i>
            </div>
            <h4 style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 5px;">Total Spent</h4>
            <h2 style="font-size: 2rem; font-family: 'Clash Display', sans-serif;">₹${annual.totalMoneySpent}</h2>
        </div>
        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 25px;">
            <div style="width: 50px; height: 50px; border-radius: 12px; background: rgba(0,184,148,0.1); color: #00b894; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px;">
                <i class="ri-map-pin-line"></i>
            </div>
            <h4 style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 5px;">Cities Visited</h4>
            <h2 style="font-size: 2rem; font-family: 'Clash Display', sans-serif;">${annual.citiesVisited}</h2>
        </div>
        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 25px;">
            <div style="width: 50px; height: 50px; border-radius: 12px; background: rgba(9,132,227,0.1); color: #0984e3; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px;">
                <i class="ri-route-line"></i>
            </div>
            <h4 style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 5px;">KMs Traveled</h4>
            <h2 style="font-size: 2rem; font-family: 'Clash Display', sans-serif;">${annual.distanceTraveled}</h2>
        </div>
    `;

    const reports = await fetchJourneyData('reports');
    if (reports && reports.length > 0) {
        let html = '';
        reports.forEach(r => {
            html += `
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px; border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; margin-bottom: 10px;">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <div style="width: 40px; height: 40px; border-radius: 8px; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                        <i class="ri-file-text-line"></i>
                    </div>
                    <div>
                        <h4 style="margin: 0; font-size: 1rem;">${r.destination} Report</h4>
                        <p style="margin: 0; color: var(--text-secondary); font-size: 0.8rem;">${r.summary}</p>
                    </div>
                </div>
                <button class="btn btn-outline" style="padding: 5px 15px; font-size: 0.85rem;"><i class="ri-download-2-line"></i> PDF</button>
            </div>`;
        });
        recentReportsContainer.innerHTML = html;
    } else {
        recentReportsContainer.innerHTML = '<p style="color: var(--text-secondary);">No trip reports generated yet.</p>';
    }
}

async function loadCalendar() {
    // Fetch data from MySQL via our API Servlet
    const bookings = await fetchJourneyData('calendar');
    if (!bookings) return;

    window.allTripsForCalendar = [];

    bookings.forEach(booking => {
        // Skip bookings with no start date
        if (!booking.travelDate) return;

        let startDate = booking.travelDate;
        let endDate = booking.travelDate;
        
        // Try parsing JSON details for multi-day trips
        try {
            if (booking.details) {
                const details = JSON.parse(booking.details);
                if (details.returnDate) endDate = details.returnDate;
                if (details.endDate) endDate = details.endDate;
            }
        } catch (e) {}

        // Add an event for each day of the trip
        let current = new Date(startDate);
        let end = new Date(endDate);
        
        // Safety bounds
        if (isNaN(current.getTime()) || isNaN(end.getTime())) return;
        
        // Normalize time to prevent infinite loops due to timezone shifts
        current.setHours(12, 0, 0, 0);
        end.setHours(12, 0, 0, 0);

        while (current <= end) {
            // Format to YYYY-MM-DD
            const yyyy = current.getFullYear();
            const mm = String(current.getMonth() + 1).padStart(2, '0');
            const dd = String(current.getDate()).padStart(2, '0');
            const formattedDate = `${yyyy}-${mm}-${dd}`;

            window.allTripsForCalendar.push({
                title: booking.planTitle || booking.pickupCity || booking.type,
                date: formattedDate,
                status: booking.status === 'CONFIRMED' || booking.status === 'ACTIVE' ? 'UPCOMING' : booking.status
            });

            // Increment by 1 day
            current.setDate(current.getDate() + 1);
        }
    });

    // Re-render the calendar UI natively
    if (typeof renderCalendar === 'function') {
        renderCalendar();
    }
}

// Attach our dynamic loader to the window object to override standard JSTL behaviors
window.switchTab = async function(tabId, element) {
    // Update URL dynamically without reload
    const url = new URL(window.location);
    url.searchParams.set('tab', tabId);
    window.history.pushState({}, '', url);

    // Update active class on nav items
    document.querySelectorAll('.profile-sidebar .nav-item').forEach(el => el.classList.remove('active'));
    if (element) element.classList.add('active');

    // Show appropriate content tab
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
    const targetTab = document.getElementById('tab-' + tabId);
    if (targetTab) targetTab.classList.add('active');
    
    // Fetch dynamic data
    if (tabId === 'completed') await loadCompletedTrips();
    if (tabId === 'memories') await loadMemories();
    if (tabId === 'dna') await loadTravelDNA();
    if (tabId === 'family') await loadFamilyHub();
    if (tabId === 'reports') await loadReports();
    if (tabId === 'calendar') await loadCalendar();
};

document.addEventListener('DOMContentLoaded', () => {
    // Initial load for active tab
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab') || 'overview';
    const tabBtn = document.querySelector(".profile-sidebar .nav-item[onclick*=\"'" + tab + "'\"]");
    
    if (tab === 'completed') loadCompletedTrips();
    if (tab === 'memories') loadMemories();
    if (tab === 'dna') loadTravelDNA();
    if (tab === 'family') loadFamilyHub();
    if (tab === 'reports') loadReports();
    if (tab === 'calendar') loadCalendar();
});
