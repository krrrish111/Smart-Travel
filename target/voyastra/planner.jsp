<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh; display: flex; flex-direction: column;">
    
    <!-- AI Loading Overlay -->
    <div id="aiLoadingOverlay" class="ai-loading-overlay">
        <div class="ai-orb"></div>
        <h2 class="ai-loading-text">Generating your trip...</h2>
        <p id="aiLoadingSubtext" class="ai-loading-subtext">Optimizing travel routes...</p>
    </div>
    
    <div class="text-center mb-6 slide-up">
        <h1 class="text-primary mb-1 editorial" style="font-size: 2.5rem;">Interactive Trip Planner</h1>
        <p class="text-muted text-sm" style="font-family: 'Poppins', sans-serif;">Map your route and let AI optimize your Indian adventure.</p>
    </div>

    <div class="flex flex-col lg:flex-row gap-6 w-full slide-up delay-1" style="flex: 1; overflow: visible; padding-bottom:20px;">
        
        <!-- LEFT PANEL: AI Chat Interface -->
        <div class="glass-panel flex flex-col w-full lg:max-w-[420px] relative" style="padding: 20px; overflow: visible; border-radius: 16px; height: auto;">
            
            <form id="plannerChatForm" action="${pageContext.request.contextPath}/generatePlan" method="post" class="ai-chat-container">
                <input type="hidden" name="action" value="generate">
                
                <!-- AI Greeting -->
                <div class="chat-bubble ai mt-2">
                    <p class="text-main font-bold mb-1" style="font-size: 0.95rem;">Voyastra AI</p>
                    <p class="text-muted text-sm">Hi Traveller! I'm here to curate your perfect itinerary. Where are we heading today?</p>
                </div>

                <!-- User Input: Route -->
                <div class="chat-bubble user-widget slide-up delay-1">
                    <div class="form-group mb-3 relative">
                        <label class="form-label text-xs">Origin</label>
                        <input type="text" id="routeStart" name="startLocation" class="form-control" placeholder="e.g. Delhi" required>
                    </div>
                    <div class="form-group relative mb-2">
                        <label class="form-label text-xs">Destination</label>
                        <input type="text" id="routeEnd" name="destination" class="form-control" placeholder="e.g. Goa" required>
                    </div>
                    <button type="button" id="btnCalcRoute" class="btn btn-outline w-full" style="padding: 8px; font-size: 0.8rem;">Update Map</button>
                </div>

                <!-- AI Next Question -->
                <div class="chat-bubble ai slide-up delay-2">
                    <p class="text-muted text-sm">Great choice. What's your estimated budget and ideal schedule?</p>
                </div>

                <!-- User Input: Budget & Time -->
                <div class="chat-bubble user-widget slide-up delay-3">
                    <div class="form-group mb-3">
                        <div class="flex justify-between items-end mb-1">
                            <label class="form-label text-xs mb-0">Est. Budget</label>
                            <div id="budgetDisplay" class="font-bold text-primary text-sm">₹50,000</div>
                        </div>
                        <input type="range" name="budget" id="budgetSlider" class="range-slider w-full" min="5000" max="200000" step="500" value="50000">
                    </div>
                    <div class="grid grid-cols-2 gap-3">
                        <div class="form-group">
                            <label class="form-label text-xs">Duration (Days)</label>
                            <input type="number" name="days" class="form-control" min="1" max="30" value="5" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label text-xs">Travel Type</label>
                            <select name="type" class="form-control" style="appearance: auto;">
                                <option value="Relaxation">Relaxation</option>
                                <option value="Adventure">Adventure</option>
                                <option value="Spiritual">Spiritual</option>
                                <option value="Luxury">Luxury</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Submit Action (Chat Send) -->
                <div class="mt-auto pt-4 text-center slide-up delay-3">
                    <button type="submit" id="btnGenerateAI" class="btn btn-primary w-full" style="padding: 14px; font-size: 1rem; border-radius: 50px;">
                        ✨ Generate AI Itinerary
                    </button>
                </div>
            </form>
        </div>

        <!-- RIGHT PANEL: Google Map -->
        <div class="glass-panel relative flex-1 hidden lg:flex" style="overflow: hidden; padding: 0; border-radius: 16px; border: 1px solid var(--color-border); min-height: 600px;">
            <div id="plannerMap" class="w-full h-full" style="min-height: 100%; background: #e5e3df;">
                <!-- Map will render here -->
                <div class="flex items-center justify-center w-full h-full text-muted">
                    Loading Interactive Map...
                </div>
            </div>
            
            <!-- Map Overlay Info (Distance, Time) -->
            <div id="routeInfoOverlay" class="absolute top-4 left-4 glass-panel" style="padding: 16px 24px; z-index: 10; display: none; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
                <h4 class="text-main mb-2" style="font-family: 'Poppins', sans-serif; font-weight:700; font-size:0.95rem;">Route Summary</h4>
                <div class="flex gap-6">
                    <div>
                        <span class="text-[0.65rem] text-muted uppercase font-bold tracking-wider">Distance</span>
                        <div id="routeDist" class="font-bold font-body" style="color: var(--color-primary); font-size:1.15rem;">--</div>
                    </div>
                    <div>
                        <span class="text-[0.65rem] text-muted uppercase font-bold tracking-wider">Est. Travel Time</span>
                        <div id="routeTime" class="font-bold font-body" style="color: var(--color-primary); font-size:1.15rem;">--</div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- AI GENERATED RESULTS CONTAINER -->
    <div id="aiResultContainer" class="container mx-auto px-4 mt-12 mb-20" style="display:none;">
        <div class="flex justify-between items-center mb-8">
            <div>
                <h2 id="aiPlanTitle" class="editorial text-main mb-1" style="font-size: 2.2rem;">Your Personalized Plan</h2>
                <div class="flex gap-4 items-center">
                    <span id="aiPlanMeta" class="text-xs text-muted tracking-widest uppercase font-bold">5 Days • Adventure</span>
                    <button class="btn btn-outline btn-xs" onclick="window.print()">Download PDF</button>
                </div>
            </div>
            <div class="flex gap-2">
                <button id="btnSavePlan" class="btn btn-primary" style="padding: 10px 24px; border-radius: 50px;">Save to Profile</button>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left: Day-wise timeline -->
            <div class="lg:col-span-2">
                <div id="aiDayCards" class="flex flex-col gap-6">
                    <!-- Day cards will be injected here -->
                </div>
            </div>

            <!-- Right: Insights & Budget -->
            <div class="flex flex-col gap-6">
                <div class="glass-panel p-6" style="border-radius: 20px;">
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Budget Breakdown</h3>
                    <div id="aiBudgetList" class="flex flex-col gap-3">
                        <!-- Budget items injected here -->
                    </div>
                </div>

                <div class="glass-panel p-6" style="border-radius: 20px; background: rgba(212, 165, 116, 0.05); border-color: rgba(212, 165, 116, 0.2);">
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Must-Visit Places</h3>
                    <ul id="aiMustVisit" class="flex flex-wrap gap-2">
                        <!-- Chips injected here -->
                    </ul>
                </div>

                <div class="glass-panel p-6" style="border-radius: 20px;">
                    <h3 class="text-main mb-4 font-bold" style="font-size: 1.1rem;">Travel Tips</h3>
                    <ul id="aiTravelTips" class="text-sm text-muted list-disc pl-4 flex flex-col gap-2">
                        <!-- Tips injected here -->
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Hidden input to safely store the JSON string from the server -->
<input type="hidden" id="hdnItineraryJson" value='${itineraryJson}'>

<script>
// Global state to track edited plan
let currentAiPlan = null;

// --- MAP LOGIC ---
let map, directionsService, directionsRenderer;

function initMap() {
    // If maps API failed or blocked, just return safely
    if (typeof google === 'undefined') return;

    // Center map on India roughly
    const indiaCenter = { lat: 20.5937, lng: 78.9629 };
    
    // Custom darkish map styling to match our UI
    const customMapStyle = [
      { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
      { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] },
      { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] },
      { featureType: "road", elementType: "geometry.stroke", stylers: [{ color: "#212a37" }] },
      { featureType: "road.highway", elementType: "geometry", stylers: [{ color: "#746855" }] },
      { featureType: "road.highway", elementType: "geometry.stroke", stylers: [{ color: "#1f2835" }] }
    ];

    map = new google.maps.Map(document.getElementById("plannerMap"), {
        zoom: 5,
        center: indiaCenter,
        disableDefaultUI: true,
        zoomControl: true,
        styles: document.documentElement.getAttribute('data-theme') === 'dark' ? customMapStyle : []
    });

    directionsService = new google.maps.DirectionsService();
    directionsRenderer = new google.maps.DirectionsRenderer({
        map: map,
        suppressMarkers: false,
        polylineOptions: {
            strokeColor: '#d4a574', // Match our primary gold
            strokeOpacity: 0.8,
            strokeWeight: 5
        }
    });

    // Initialize Places Autocomplete for start and end inputs
    const startInput = document.getElementById("routeStart");
    const endInput = document.getElementById("routeEnd");
    
    if (startInput && endInput) {
        new google.maps.places.Autocomplete(startInput);
        new google.maps.places.Autocomplete(endInput);
        
        // Prevent form submission on enter within autocomplete
        [startInput, endInput].forEach(input => {
            input.addEventListener('keydown', e => {
                if (e.key === 'Enter') e.preventDefault();
            });
        });

        // Wire "Update Map" button
        document.getElementById('btnCalcRoute').addEventListener('click', calculateAndDisplayRoute);
    }

    // Auto-calculate if parameters are already present in URL
    const urlParams = new URLSearchParams(window.location.search);
    const locParam = urlParams.get('location');
    if (locParam) {
        document.getElementById('routeEnd').value = locParam;
        // Optionally auto-calculate if stay/start is known, but usually wait for user "Update Map"
    }
}

function calculateAndDisplayRoute() {
    if (!directionsService || !directionsRenderer) return;
    
    const start = document.getElementById("routeStart").value;
    const end = document.getElementById("routeEnd").value;
    
    if (!start || !end) {
        VoyastraToast.show("Please enter both Starting Point and Destination.", "info");
        return;
    }

    directionsService.route(
        {
            origin: start,
            destination: end,
            travelMode: google.maps.TravelMode.DRIVING
        },
        (response, status) => {
            if (status === "OK") {
                directionsRenderer.setDirections(response);
                
                // Show route info panel
                const route = response.routes[0].legs[0];
                document.getElementById("routeDist").innerText = route.distance.text;
                document.getElementById("routeTime").innerText = route.duration.text;
                document.getElementById("routeInfoOverlay").style.display = "block";
                
                // Add soft animation classes
                document.getElementById("routeInfoOverlay").classList.add("slide-up");
            } else {
                VoyastraToast.show("Directions request failed: " + status, "error");
            }
        }
    );
}

// --- AI GENERATION LOGIC ---
const plannerForm = document.getElementById('plannerChatForm');
if (plannerForm) {
    plannerForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Stop default instant redirect
        
        // 1. Enforce Auth
        if (typeof VoyastraAuth !== 'undefined' && !VoyastraAuth.isAuthenticated()) {
            VoyastraAuth.requireAuth('planner.jsp');
            return;
        }

        // 2. Trigger Loading Animation
        const overlay = document.getElementById('aiLoadingOverlay');
        const subtext = document.getElementById('aiLoadingSubtext');
        overlay.classList.add('active');

        // 3. Cycle Text to simulate AI working
        const stages = [
            "Analyzing geographical data...",
            "Curating hidden-gem experiences...",
            "Validating seasonal weather...",
            "Finalizing your perfect itinerary..."
        ];
        
        let step = 0;
        const interval = setInterval(() => {
            if (step < stages.length) {
                subtext.innerText = stages[step];
                step++;
            }
        }, 800);

        // 4. Redirect after simulation completes (4 seconds)
        // setTimeout(() => {
        //     clearInterval(interval);
        //     plannerForm.submit(); 
        // }, 4000);

        // 4. Submit form normally to allow request attribute flow
        plannerForm.submit();
    });
}

// --- SERVER SIDE DATA HANDLING ---
window.addEventListener('DOMContentLoaded', () => {
    const errorMsg = "${error}";
    if (errorMsg) {
        VoyastraToast.show(errorMsg, "error");
    }

    const itineraryJson = document.getElementById('hdnItineraryJson').value;
    if (itineraryJson && itineraryJson !== "null" && itineraryJson.trim() !== "") {
        try {
            const data = JSON.parse(itineraryJson);
            renderItinerary(data);
            VoyastraToast.show("Your itinerary is ready!", "success");
        } catch (e) {
            console.error("Failed to parse itinerary JSON:", e);
        }
    }
});

function fetchAIPlan(intervalIdx, formData) {
    // This function is now a fallback or can be removed if strictly using forward
    // But keeping it defined to avoid errors, although not called in the forward flow
}

function renderItinerary(data) {
    const container = document.getElementById('aiResultContainer');
    container.style.display = 'block';

    // Set Meta
    document.getElementById('aiPlanTitle').innerText = data.title || "Custom Itinerary";
    currentAiPlan = data; // Set current state for saving
    
    // Render Days
    const dayList = document.getElementById('aiDayCards');
    dayList.innerHTML = '';
    data.days.forEach(day => {
        const card = document.createElement('div');
        card.className = 'glass-panel p-6 reveal-item';
        card.style.borderRadius = '20px';
        
        let activitiesHtml = '';
        day.activities.forEach((act, idx) => {
            activitiesHtml += `
                <div class="flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group">
                    <div class="text-[0.65rem] text-muted font-bold uppercase w-16 pt-1">${act.time}</div>
                    <div class="flex-1">
                        <p class="text-sm text-main m-0 editable-activity" contenteditable="true" onblur="updateActivity(${day.day}, ${idx}, this.innerText)">${act.description}</p>
                    </div>
                </div>
            `;
        });

        card.innerHTML = `
            <div class="flex justify-between items-center mb-4">
                <h4 class="text-primary font-bold editorial" style="font-size: 1.4rem;">Day ${day.day}: ${day.title}</h4>
            </div>
            <div class="flex flex-col gap-2">
                ${activitiesHtml}
            </div>
        `;
        dayList.appendChild(card);
    });

    // Render Budget
    const budgetList = document.getElementById('aiBudgetList');
    budgetList.innerHTML = '';
    data.budget_summary.forEach(item => {
        const row = document.createElement('div');
        row.className = 'flex justify-between text-sm';
        row.innerHTML = `<span class="text-muted">${item.category}</span><span class="text-main font-bold">${item.amount}</span>`;
        budgetList.appendChild(row);
    });

    // Render Chips
    const chips = document.getElementById('aiMustVisit');
    chips.innerHTML = '';
    data.must_visit.forEach(v => {
        const chip = document.createElement('li');
        chip.className = 'px-3 py-1 bg-white/10 rounded-full text-[0.7rem] text-muted border border-white/5';
        chip.innerText = v;
        chips.appendChild(chip);
    });

    // Render Tips
    const tips = document.getElementById('aiTravelTips');
    tips.innerHTML = '';
    data.travel_tips.forEach(t => {
        const tip = document.createElement('li');
        tip.innerText = t;
        tips.appendChild(tip);
    });
    container.scrollIntoView({ behavior: 'smooth' });
    
    if (typeof VoyastraLoader !== 'undefined') VoyastraLoader.reveal();
}

function updateActivity(dayNum, actIdx, newText) {
    if (currentAiPlan && currentAiPlan.days) {
        const day = currentAiPlan.days.find(d => d.day === dayNum);
        if (day && day.activities[actIdx]) {
            day.activities[actIdx].description = newText;
            console.log("Updated Plan State:", currentAiPlan);
        }
    }
}

document.getElementById('btnSavePlan')?.addEventListener('click', function() {
    // 1. Auth check
    const userName = "${sessionScope.user_name}";
    if (!userName) {
        VoyastraToast.show("Please login to save your plan!", "warning");
        return;
    }

    if (!currentAiPlan) {
        VoyastraToast.show("No itinerary to save!", "error");
        return;
    }

    // 2. Perform Save
    VoyastraToast.show("Saving your itinerary...", "info");
    const saveBtn = this;
    
    const params = new URLSearchParams();
    params.append('title', currentAiPlan.title || 'My Smart Trip');
    params.append('destination', "${param.destination}" || 'Custom Destination');
    params.append('itineraryData', JSON.stringify(currentAiPlan));

    fetch('itinerary', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            VoyastraToast.show("✨ Trip saved successfully to your Profile!", "success");
            saveBtn.innerHTML = '✓ Saved';
            saveBtn.classList.replace('btn-primary', 'btn-outline');
            saveBtn.disabled = true;
        } else {
            VoyastraToast.show("Error: " + data.message, "error");
        }
    })
    .catch(error => {
        console.error('Error saving itinerary:', error);
        VoyastraToast.show("Failed to save itinerary. Please try again.", "error");
    });
});

// Request the centralized script to load Google Maps and call initMap when ready
window.addEventListener('DOMContentLoaded', () => {
    if (typeof loadGoogleMaps === 'function') {
        loadGoogleMaps('initMap');
    }
});

// Update budget display dynamically
document.getElementById('budgetSlider')?.addEventListener('input', function(e) {
    document.getElementById('budgetDisplay').innerText = '₹' + parseInt(e.target.value).toLocaleString();
});
</script>

<%@ include file="components/footer.jsp" %>
