
                // API Keys are now securely handled by the backend servlets.
                // We no longer inject raw keys into the client-side context.
            

                // Read config from DOM — safe against JSP injection syntax errors
                const _config = document.getElementById('voyastra-config');
                const YOUTUBE_API_KEY  = _config?.dataset?.ytKey        || '';
                const UNSPLASH_KEY     = _config?.dataset?.unsplashKey  || '';
                const CONTEXT_PATH     = _config?.dataset?.contextPath  || '';
                const contextPath      = CONTEXT_PATH; // Alias for existing code

                // Validate on load
                if (!YOUTUBE_API_KEY)  console.warn('[Voyastra] YouTube API key not set');
                if (!UNSPLASH_KEY)     console.warn('[Voyastra] Unsplash API key not set');
                if (!CONTEXT_PATH)     console.warn('[Voyastra] contextPath not set');
            

                // Global state to track edited plan
                let currentAiPlan = null;

                // --- MAP LOGIC (LEAFLET) ---
                let map, routingControl;
                let originMarker, destMarker;
                let mapLayers = {};

                // Icons
                const iconAttraction = L.divIcon({ html: '<i class="ri-map-pin-2-fill text-blue-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });
                const iconHiddenGem = L.divIcon({ html: '<i class="ri-map-pin-2-fill text-purple-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });
                const iconFood = L.divIcon({ html: '<i class="ri-restaurant-2-fill text-orange-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });
                const iconInsta = L.divIcon({ html: '<i class="ri-camera-lens-fill text-pink-500 text-3xl drop-shadow-md"></i>', className: '', iconSize: [30, 30], iconAnchor: [15, 30] });

                function initMap() {
                    // Center map on India roughly
                    map = L.map('plannerMap', { zoomControl: false }).setView([20.5937, 78.9629], 5);

                    // Modern dark-styled map tiles matching our UI
                    let tileUrl = 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';
                    if (document.documentElement.getAttribute('data-theme') === 'dark') {
                        tileUrl = 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
                    }

                    L.tileLayer(tileUrl, {
                        attribution: '&copy; OpenStreetMap contributors',
                        subdomains: 'abcd',
                        maxZoom: 20
                    }).addTo(map);

                    L.control.zoom({ position: 'bottomright' }).addTo(map);

                    // Setup Layer Groups
                    mapLayers.attractions = L.layerGroup().addTo(map);
                    mapLayers.hiddenGems = L.layerGroup().addTo(map);
                    mapLayers.food = L.layerGroup().addTo(map);
                    mapLayers.insta = L.layerGroup().addTo(map);

                    // Add Layer Control
                    L.control.layers(null, {
                        "Tourist Attractions": mapLayers.attractions,
                        "Hidden Gems": mapLayers.hiddenGems,
                        "Restaurants": mapLayers.food,
                        "Instagram Spots": mapLayers.insta
                    }, { position: 'bottomleft' }).addTo(map);

                    // Wire "Update Map" button
                    const updateBtn = document.getElementById('btnCalcRoute');
                    if (updateBtn) {
                        updateBtn.addEventListener('click', calculateAndDisplayRoute);
                    }
                };

                // Helper: Geocode using Nominatim
                async function geocode(query) {
                    const response = await fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query));
                    const data = await response.json();
                    if (data && data.length > 0) {
                        return L.latLng(data[0].lat, data[0].lon);
                    }
                    return null;
                }

                async function calculateAndDisplayRoute() {
                    const start = document.getElementById("routeStart").value;
                    const end = document.getElementById("routeEnd").value;

                    if (!start || !end) {
                        VoyastraToast.show("Please enter both Starting Point and Destination.", "info");
                        return;
                    }

                    VoyastraToast.show("Calculating optimal route...", "info");

                    const startLatLng = await geocode(start);
                    const endLatLng = await geocode(end);

                    if (!startLatLng || !endLatLng) {
                        VoyastraToast.show("Could not find locations. Please be more specific.", "error");
                        return;
                    }

                    if (routingControl) {
                        map.removeControl(routingControl);
                    }

                    routingControl = L.Routing.control({
                        waypoints: [startLatLng, endLatLng],
                        routeWhileDragging: false,
                        show: false,
                        addWaypoints: false,
                        lineOptions: {
                            styles: [{ color: 'var(--color-primary)', opacity: 0.8, weight: 5, className: 'animate-route' }]
                        },
                        createMarker: function () { return null; } // Custom markers used
                    }).on('routesfound', function (e) {
                        const routes = e.routes;
                        const summary = routes[0].summary;
                        const distanceKm = (summary.totalDistance / 1000).toFixed(1);

                        document.getElementById("routeDistance").innerText = distanceKm + " KM";

                        // Calculate Times
                        const hrsFlight = (distanceKm / 800).toFixed(1);
                        const hrsTrain = (distanceKm / 60).toFixed(1);
                        const hrsBus = (distanceKm / 50).toFixed(1);
                        const hrsCar = (distanceKm / 65).toFixed(1);

                        document.getElementById("timeFlight").innerText = hrsFlight + "h";
                        document.getElementById("timeTrain").innerText = hrsTrain + "h";
                        document.getElementById("timeBus").innerText = hrsBus + "h";
                        document.getElementById("timeCar").innerText = hrsCar + "h";

                        // AI Transport Recommendation
                        let rec = "";
                        if (distanceKm < 300) rec = "Car / Cab";
                        else if (distanceKm < 800) rec = "Train / Flight";
                        else rec = "Flight (Recommended)";

                        document.getElementById("aiTransportRec").innerHTML = `<i class="ri-sparkling-fill text-yellow-400"></i> ` + rec;

                        document.getElementById("routeInfoOverlay").style.display = "block";
                        document.getElementById("routeInfoOverlay").classList.add("slide-up");

                        // Hide routing instructions panel
                        setTimeout(() => {
                            const container = document.querySelector('.leaflet-routing-container');
                            if (container) container.style.display = 'none';
                        }, 100);

                    }).addTo(map);

                    // Plot fake markers if AI data exists
                    if (currentAiPlan) {
                        plotAILocations(endLatLng, currentAiPlan);
                    }
                }

                // Function to plot markers around a coordinate
                function plotAILocations(centerLatLng, aiData) {
                    // Clear old
                    mapLayers.attractions.clearLayers();
                    mapLayers.hiddenGems.clearLayers();
                    mapLayers.food.clearLayers();
                    mapLayers.insta.clearLayers();

                    function addMarkers(list, layerGroup, icon, category) {
                        if (!list) return;
                        list.forEach((item, idx) => {
                            let itemName = typeof item === 'string' ? item : item.name;
                            // Random offset within ~10km (0.1 degree roughly)
                            const latOff = (Math.random() - 0.5) * 0.15;
                            const lngOff = (Math.random() - 0.5) * 0.15;
                            const pLat = centerLatLng.lat + latOff;
                            const pLng = centerLatLng.lng + lngOff;

                            const popupHtml = `
                <div class="p-2" style="width: 200px;">
                    <img src="https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=200&q=80" class="w-full h-24 object-cover rounded mb-2">
                    <h5 class="font-bold text-main text-sm mb-1">\${itemName}</h5>
                    <p class="text-xs text-muted mb-2">\${category}</p>
                    <button class="btn btn-primary text-xs py-1 px-3 w-full" onclick="addToTrip('\${itemName.replace(/\\'/g,\`\`)}', '\${category}', \${pLat}, \${pLng})">Add To Trip</button>
                </div>
            `;
                            L.marker([pLat, pLng], { icon: icon }).bindPopup(popupHtml).addTo(layerGroup);
                        });
                    }

                    addMarkers(aiData.must_visit, mapLayers.attractions, iconAttraction, 'Tourist Attraction');
                    addMarkers(aiData.hidden_gems_detailed || aiData.hidden_gems, mapLayers.hiddenGems, iconHiddenGem, 'Hidden Gem');
                    addMarkers(aiData.food_discovery_detailed || aiData.food_discovery, mapLayers.food, iconFood, 'Restaurant / Food');
                    addMarkers(aiData.instagram_spots, mapLayers.insta, iconInsta, 'Instagram Spot');
                }

                window.addToTrip = function (name, cat, lat, lng) {
                    VoyastraToast.show("Saving " + name + "...", "info");
                    fetch('${pageContext.request.contextPath}/api/planner/map-sync', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'placeName=' + encodeURIComponent(name) + '&category=' + encodeURIComponent(cat) + '&lat=' + lat + '&lng=' + lng
                    }).then(res => res.json())
                        .then(data => {
                            if (data.status === 'success') {
                                VoyastraToast.show(name + " added to your trip!", "success");
                            } else {
                                VoyastraToast.show("Failed to add to trip.", "error");
                            }
                        }).catch(err => {
                            VoyastraToast.show("Error connecting to server.", "error");
                        });
                }

                      async function generatePlan(event) {
                    if (event) event.preventDefault();
                
                    console.group('%c[Voyastra Planner] Generate Trip', 'color:#f0b84a;font-weight:bold');
                    console.log('Timestamp:', new Date().toISOString());
                
                    const origin      = document.querySelector('[name="startLocation"]')?.value?.trim();
                    const destination = document.querySelector('[name="destination"]')?.value?.trim();
                    const departureDate = document.querySelector('[name="departureDate"]')?.value;
                    const returnDate = document.querySelector('[name="returnDate"]')?.value;
                    const travelStyle = document.querySelector('[name="travelStyle"]')?.value;
                    const budget      = document.querySelector('[name="budget"]')?.value;
                    const adults = document.querySelector('[name="adults"]')?.value;
                    const children = document.querySelector('[name="children"]')?.value;
                    const seniors = document.querySelector('[name="seniors"]')?.value;
                
                    console.log('Input:', { origin, destination, budget });
                
                    if (!origin || !destination) {
                        console.warn('Validation failed: missing origin or destination');
                        console.groupEnd();
                        VoyastraToast.show('Origin and destination are required.', 'error');
                        return;
                    }

                    if (new Date(departureDate) < new Date(new Date().toDateString())) {
                        VoyastraToast.show("Departure date cannot be in the past.", "error");
                        console.warn('Validation failed: departure date in past');
                        console.groupEnd();
                        return;
                    }
                    if (new Date(returnDate) < new Date(departureDate)) {
                        VoyastraToast.show("Return date must be after departure date.", "error");
                        console.warn('Validation failed: return date before departure');
                        console.groupEnd();
                        return;
                    }
                    if (budget < 1000) {
                        VoyastraToast.show("Budget must be at least ₹1000.", "error");
                        console.warn('Validation failed: budget too low');
                        console.groupEnd();
                        return;
                    }
                
                    const btn = document.getElementById('btnGenerateAI');
                    if (btn) { btn.disabled = true; btn.innerHTML = '⏳ Generating...'; }

                    const overlay = document.getElementById('aiLoadingOverlay');
                    if (overlay) overlay.classList.add('active');

                    showLoader();

                    const subtext = document.getElementById('aiLoadingSubtext');
                    const stages = [
                        "Analyzing geographical data...",
                        "Curating hidden-gem experiences...",
                        "Validating seasonal weather...",
                        "Finalizing your perfect itinerary..."
                    ];
                    let step = 0;
                    const loadingInterval = setInterval(() => {
                        if (step < stages.length && subtext) {
                            subtext.innerText = stages[step];
                            step++;
                        }
                    }, 1500);

                    const resDiv = document.getElementById('tripResultContainer');
                    if (resDiv) {
                        resDiv.innerHTML = `<div class="text-center p-6"><i class="ri-loader-4-line animate-spin text-primary text-3xl"></i><p class="text-muted text-sm mt-2">Generating AI plan...</p></div>`;
                    }
                
                    console.log('Sending POST to:', CONTEXT_PATH + '/generatePlan');
                
                    try {
                        const res = await fetch(CONTEXT_PATH + '/generatePlan', {
                            method: 'POST',
                            credentials: 'include',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: JSON.stringify({ origin, destination, departureDate, returnDate, travelStyle, budget, adults, children, seniors })
                        });
                
                        console.log('Response status:', res.status, res.statusText);
                        console.log('Response Content-Type:', res.headers.get('Content-Type'));
                
                        if (!res.ok) {
                            const errText = await res.text();
                            console.error('Server error:', errText);
                            VoyastraToast.show('Server error: ' + res.status, 'error');
                            clearInterval(loadingInterval);
                            hideLoader();
                            console.groupEnd();
                            return;
                        }
                
                        const data = await res.json();
                        console.log('Itinerary received for:', data.destination);
                        console.log('Sections in response:', Object.keys(data));
                        console.groupEnd();
                
                        await renderItinerary(data);
                
                    } catch (err) {
                        console.error('generatePlan fetch failed:', err);
                        VoyastraToast.show('Planner Servlet Not Reached or Network Error.', 'error');
                        console.groupEnd();
                    } finally {
                        clearInterval(loadingInterval);
                        hideLoader();
                        if (overlay) overlay.classList.remove('active');
                        
                        // Scroll to top of results after generation
                        const resultPanel = document.getElementById('aiHeroBanner');
                        if (resultPanel) {
                            resultPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        }
                    }
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

    function quickFill(destination) {
        const destInput = document.querySelector('[name="destination"]');
        if (destInput) {
            destInput.value = destination;
            destInput.focus();
            // Scroll left panel to show the generate button
            document.getElementById('btnGenerateAI')
                ?.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }

    async function renderItinerary(data) {
        const initialHero = document.getElementById('planner-hero-initial');
        if (initialHero) initialHero.style.display = 'none';
        
        const mapWrapper = document.getElementById('map-wrapper');
        if (mapWrapper) mapWrapper.style.display = 'block';

        const container = document.getElementById('aiResultContainer');
        container.style.display = 'block';

        console.group("VOYASTRA PLANNER");
        console.log("Destination");
        console.log(data.title || data.destination);
        console.log("Budget");
        console.log(data.budget || "Not provided");
        console.groupEnd();

        // FIX 1: Complete stale data reset before every render
        const allDynamicSections = [
            'aiHeroBanner',
            'aiVideoReels',
            'aiDiscoveryGrid',
            'aiPhotoGallery',
            'aiFoodGrid',
            'aiLocalFoodSpecialties',
            'aiExperiencesGrid',
            'aiFoodTrails',
            'aiDayCards',
            'aiBudgetList',
            'aiMustVisit',
            'aiHiddenGems',
            'aiInstaSpots',
            'aiFood',
            'aiTravelTips',
            'aiGamification',
            'aiWarnings'
        ];

        allDynamicSections.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.innerHTML = '';
        });

        // Ensure everything has a data-trip-section attribute (already added to JS creation below, or using exact id strategy)
        // Stamp destination
        document.querySelectorAll('[data-trip-section]').forEach(el => {
            el.dataset.renderedFor = data.destination || data.title;
        });

        // Restore original hero structure for logic compatibility
        document.getElementById('aiHeroBanner').innerHTML = `
            <div class="absolute inset-0 bg-gradient-to-b from-black/60 via-black/40 to-background"></div>
            
            <div class="relative z-10 container mx-auto px-4 text-center slide-up">
                <h1 id="aiHeroTitle" class="editorial text-white mb-4" style="font-size: 5rem; text-shadow: 0 4px 20px rgba(0,0,0,0.5);"></h1>
                <p id="aiHeroStory" class="text-white/90 max-w-3xl mx-auto text-lg leading-relaxed mb-8 italic" style="text-shadow: 0 2px 10px rgba(0,0,0,0.5);"></p>
                
                <div class="flex justify-center gap-6">
                    <div class="glass-panel px-6 py-3 rounded-full border border-white/20 backdrop-blur-md">
                        <span class="text-xs text-white/70 uppercase tracking-widest block mb-1">Trip Score</span>
                        <span id="aiTripScore" class="text-xl text-primary font-bold"></span>
                    </div>
                    <div class="glass-panel px-6 py-3 rounded-full border border-white/20 backdrop-blur-md">
                        <span class="text-xs text-white/70 uppercase tracking-widest block mb-1">Safety</span>
                        <span id="aiSafetyScore" class="text-xl text-green-400 font-bold"></span>
                    </div>
                    <div class="glass-panel px-6 py-3 rounded-full border border-white/20 backdrop-blur-md">
                        <span class="text-xs text-white/70 uppercase tracking-widest block mb-1">Weather</span>
                        <span id="aiHeroWeather" class="text-xl text-yellow-400 font-bold"></span>
                    </div>
                </div>
            </div>`;
                    
                    // Phase 3: Dynamic Image API Integration
                    let destinationPhotos = [];
                    const dest = document.querySelector('[name="destination"]')?.value || data.title || 'Travel';
                    try {
                        const res = await fetch(contextPath + `/api/unsplash/search?destination=\${encodeURIComponent(dest)}&category=landscape`);
                        if (res.ok) {
                            const photoData = await res.json();
                            if (photoData.results) {
                                destinationPhotos = photoData.results.map(r => r.urls.regular);
                                console.log("Images");
                                console.log(destinationPhotos);
                            }
                        }
                    } catch (e) {
                        console.error("Unsplash API fallback", e);
                    }

                    const getPhoto = (idx, fallbackId) => {
                        if (destinationPhotos.length > 0) {
                            return destinationPhotos[idx % destinationPhotos.length];
                        }
                        return `https://images.unsplash.com/photo-\${fallbackId}?q=80&w=600&auto=format&fit=crop&sig=\${idx}`;
                    };

                    // Phase 5: Hero Banner Update
                    document.getElementById('aiHeroTitle').innerText = document.getElementById('routeEnd').value.toUpperCase();
                    if (data.destination_story) {
                        document.getElementById('aiHeroStory').innerText = '"' + data.destination_story + '"';
                    }
                    if (data.trip_score) {
                        document.getElementById('aiTripScore').innerText = data.trip_score + "/100";
                    }

                    // Phase 7: Trip Score Breakdown
                    const tripScoreContainer = document.getElementById('aiTripScoreBreakdown');
                    if (tripScoreContainer && data.trip_score_breakdown) {
                        tripScoreContainer.innerHTML = '';
                        const scores = data.trip_score_breakdown;
                        const addScoreBar = (label, score, colorClass) => {
                            if (!score) return;
                            const pct = (score / 10) * 100;
                            tripScoreContainer.innerHTML += `
                <div class="mb-2">
                    <div class="flex justify-between text-[0.65rem] uppercase font-bold text-muted mb-1">
                        <span>\${label}</span>
                        <span class="text-main">\${score}/10</span>
                    </div>
                    <div class="w-full bg-white/5 rounded-full h-1.5 overflow-hidden">
                        <div class="h-1.5 rounded-full \${colorClass}" style="width: \${pct}%"></div>
                    </div>
                </div>
            `;
                        };
                        addScoreBar('Budget Fit', scores.budget_fit, 'bg-green-400');
                        addScoreBar('Weather', scores.weather, 'bg-blue-400');
                        addScoreBar('Safety', scores.safety, 'bg-purple-400');
                        addScoreBar('Crowd Avoidance', scores.crowd, 'bg-yellow-400');
                        addScoreBar('Comfort', scores.comfort, 'bg-primary');
                        addScoreBar('Photography', scores.photography, 'bg-pink-400');
                        addScoreBar('Food Experience', scores.food, 'bg-orange-400');
                    }

                    document.getElementById('aiHeroWeather').innerText = (Math.floor(Math.random() * 10) + 22) + "°C";

                    // Set Meta
                    document.getElementById('aiPlanTitle').innerText = data.title || "Custom Itinerary";
                    currentAiPlan = data; // Set current state for saving

                    // Set Insights & Warnings
                    document.getElementById('aiBestSeason').innerText = data.best_season || "Year Round";
                    document.getElementById('aiRecDuration').innerText = data.recommended_duration || "Flexible";
                    document.getElementById('aiBestMode').innerText = data.best_travel_mode || "Flight/Cab";

                    const warningsList = document.getElementById('aiWarnings');
                    warningsList.innerHTML = '';
                    if (data.travel_warnings) {
                        data.travel_warnings.forEach(w => {
                            const li = document.createElement('li');
                            li.innerText = w;
                            warningsList.appendChild(li);
                        });
                    }

                    // Phase 4: Set Insight Text
                    const insightText = document.getElementById('aiInsightText');
                    if (insightText) {
                        insightText.innerText = data.ai_recommendation_insight || "I found some great places based on your travel style.";
                    }

                    // Phase 4: Render Hidden Gem Cards
                    const discoveryGrid = document.getElementById('aiDiscoveryGrid');
                    if (discoveryGrid && data.hidden_gems_detailed) {
                        discoveryGrid.innerHTML = '';
                        data.hidden_gems_detailed.forEach((gem, idx) => {
                            const card = document.createElement('div');
                            card.className = 'glass-panel rounded-2xl overflow-hidden hover:shadow-xl transition-all border border-white/5 cursor-grab draggable-item';
                            card.setAttribute('data-title', gem.name);
                            card.setAttribute('data-category', gem.category || "Hidden Gem");

                            const imgUrl = getPhoto(idx, '1501785888041-af3ef285b470');

                            card.innerHTML = `
                <div class="h-40 relative">
                    <img src="\${imgUrl}" class="w-full h-full object-cover" onerror="this.style.display='none'">
                    <div class="absolute top-3 left-3 bg-black/60 backdrop-blur-md text-white text-[0.65rem] uppercase tracking-wider font-bold px-3 py-1 rounded-full border border-white/10">
                        \${gem.category || "Hidden Gem"}
                    </div>
                    <div class="absolute top-3 right-3 bg-primary text-white text-xs font-bold px-2 py-1 rounded border border-primary/50 shadow-lg">
                        <i class="ri-star-fill text-yellow-300"></i> \${gem.overall_score || 9.0}
                    </div>
                </div>
                <div class="p-5">
                    <div class="flex justify-between items-start mb-2">
                        <h4 class="text-main font-bold text-lg leading-tight">\${gem.name}</h4>
                    </div>
                    <p class="text-xs text-muted mb-4 line-clamp-2">\${gem.description}</p>
                    
                    <div class="grid grid-cols-2 gap-y-3 gap-x-2 text-xs mb-4">
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Beauty</span> <span>\${gem.beauty_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-blue-400 h-1.5 rounded-full" style="width: \${(gem.beauty_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Peace</span> <span>\${gem.peace_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-purple-400 h-1.5 rounded-full" style="width: \${(gem.peace_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Photo</span> <span>\${gem.photo_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-pink-400 h-1.5 rounded-full" style="width: \${(gem.photo_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Crowd</span> <span>\${gem.crowd_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-red-400 h-1.5 rounded-full" style="width: \${(gem.crowd_score/10)*100}%"></div></div>
                        </div>
                    </div>

                    <div class="flex gap-2">
                        <button class="btn btn-primary flex-1 py-2 text-xs" onclick="addToTrip('\${gem.name.replace(/\\'/g,\`\`)}', '\${gem.category}', 0, 0)">Add To Trip</button>
                        <button class="btn btn-outline py-2 px-3 text-xs"><i class="ri-bookmark-line"></i></button>
                    </div>
                </div>
            `;
                            discoveryGrid.appendChild(card);
                        });

                        // Phase 8: Initialize Sortable
                        new Sortable(discoveryGrid, {
                            group: { name: 'shared', pull: 'clone', put: false },
                            animation: 150,
                            sort: false
                        });
                    }

                    // Phase 5: Populate Photo Gallery
                    const photoGallery = document.getElementById('aiPhotoGallery');
                    if (photoGallery) {
                        photoGallery.innerHTML = '';
                        let places = [];
                        if (data.must_visit) places.push(...data.must_visit);
                        if (data.hidden_gems_detailed) places.push(...data.hidden_gems_detailed.map(g => g.name));

                        places.forEach((place, idx) => {
                            const placeName = typeof place === 'string' ? place : place.name;
                            const imgUrl = getPhoto(idx + 5, '1506461883276-594a12b11ac3');
                            const div = document.createElement('div');
                            div.className = 'relative group break-inside-avoid rounded-xl overflow-hidden cursor-pointer';
                            div.innerHTML = `
                <img src="\${imgUrl}" class="w-full object-cover transition-transform duration-500 group-hover:scale-105" onerror="this.style.display='none'">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                <div class="absolute bottom-3 left-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                    <span class="text-white font-bold text-sm leading-tight block mb-2">\${placeName}</span>
                    <div class="flex gap-2">
                        <button class="btn btn-primary text-[0.6rem] py-1 px-2 flex-1"><i class="ri-add-line"></i> Add</button>
                        <button class="btn btn-outline text-[0.6rem] py-1 px-2"><i class="ri-heart-line"></i></button>
                    </div>
                </div>
            `;
                            photoGallery.appendChild(div);
                        });
                    }

                    // Phase 6: Food Explorer Data

                    // 1. Local Food Specialties
                    const foodSpecialties = document.getElementById('aiLocalFoodSpecialties');
                    if (foodSpecialties && data.local_food_specialties) {
                        foodSpecialties.innerHTML = '';
                        data.local_food_specialties.forEach(food => {
                            const span = document.createElement('span');
                            span.className = 'px-3 py-1 bg-orange-500/10 text-orange-400 border border-orange-500/20 rounded-full text-xs font-bold';
                            span.innerText = food;
                            foodSpecialties.appendChild(span);
                        });
                    }

                    // 2. Food Discovery Grid
                    const foodGrid = document.getElementById('aiFoodGrid');
                    if (foodGrid && data.food_discovery_detailed) {
                        foodGrid.innerHTML = '';
                        data.food_discovery_detailed.forEach((food, idx) => {
                            const imgUrl = getPhoto(idx + 10, '1517248135467-4c7edcad34c4');

                            const card = document.createElement('div');
                            card.className = 'glass-panel rounded-2xl overflow-hidden hover:shadow-xl transition-all border border-white/5 flex flex-col h-full cursor-grab draggable-item';
                            card.setAttribute('data-title', food.name);
                            card.setAttribute('data-category', food.category || "Food");
                            card.innerHTML = `
                <div class="h-32 relative shrink-0">
                    <img src="\${imgUrl}" class="w-full h-full object-cover" onerror="this.style.display='none'">
                    <div class="absolute top-2 left-2 bg-black/60 backdrop-blur-md text-white text-[0.6rem] uppercase tracking-wider font-bold px-2 py-0.5 rounded border border-white/10">
                        \${food.category}
                    </div>
                    <div class="absolute top-2 right-2 bg-orange-500 text-white text-[0.65rem] font-bold px-2 py-0.5 rounded shadow-lg flex items-center">
                        <i class="ri-star-fill text-yellow-200 mr-1"></i> \${food.rating}
                    </div>
                </div>
                <div class="p-4 flex flex-col flex-1">
                    <h4 class="text-main font-bold text-sm mb-1 line-clamp-1">\${food.name}</h4>
                    <div class="flex gap-2 text-[0.65rem] text-muted mb-2 font-mono">
                        <span class="text-green-400">\${food.price_range}</span>
                        <span>•</span>
                        <span>Crowd: \${food.crowd_level}</span>
                    </div>
                    <p class="text-xs text-muted/80 leading-relaxed italic mb-3 flex-1 line-clamp-3">"\${food.short_story || food.description}"</p>
                    <button class="btn btn-primary w-full py-1.5 text-xs rounded-full mt-auto" onclick="addToTrip('\${food.name.replace(/\\'/g,\`\`)}', '\${food.category}', 0, 0)"><i class="ri-add-line mr-1"></i> Add To Trip</button>
                </div>
            `;
                            foodGrid.appendChild(card);
                        });

                        // Phase 8: Initialize Sortable
                        new Sortable(foodGrid, {
                            group: { name: 'shared', pull: 'clone', put: false },
                            animation: 150,
                            sort: false
                        });
                    }

                    // 3. Local Experiences Grid
                    const expGrid = document.getElementById('aiExperiencesGrid');
                    if (expGrid && data.local_experiences) {
                        expGrid.innerHTML = '';
                        data.local_experiences.forEach(exp => {
                            const card = document.createElement('div');
                            card.className = 'glass-panel p-5 rounded-2xl border border-white/5 relative overflow-hidden';
                            card.innerHTML = `
                <div class="absolute -right-6 -top-6 text-primary/10">
                    <i class="ri-compass-discover-fill" style="font-size: 8rem;"></i>
                </div>
                <div class="relative z-10">
                    <span class="text-[0.6rem] text-primary uppercase font-bold tracking-widest mb-1 block">\${exp.type}</span>
                    <h4 class="text-main font-bold text-md mb-2 leading-tight">\${exp.name}</h4>
                    <p class="text-xs text-muted mb-4 line-clamp-2">"\${exp.short_story}"</p>
                    
                    <div class="space-y-2 text-xs">
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Authenticity</span> <span>\${exp.authenticity_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-amber-500 h-1.5 rounded-full" style="width: \${(exp.authenticity_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Fun</span> <span>\${exp.fun_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-pink-500 h-1.5 rounded-full" style="width: \${(exp.fun_score/10)*100}%"></div></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-[0.6rem] text-muted mb-1 uppercase tracking-wider"><span>Photography</span> <span>\${exp.photography_score}</span></div>
                            <div class="w-full bg-white/5 rounded-full h-1.5"><div class="bg-blue-500 h-1.5 rounded-full" style="width: \${(exp.photography_score/10)*100}%"></div></div>
                        </div>
                    </div>
                </div>
            `;
                            expGrid.appendChild(card);
                        });
                    }

                    // 4. Food Trails
                    const trailsList = document.getElementById('aiFoodTrails');
                    if (trailsList && data.food_trails) {
                        trailsList.innerHTML = '';
                        data.food_trails.forEach(trail => {
                            const div = document.createElement('div');
                            div.className = 'mb-6';
                            div.innerHTML = `
                <h4 class="text-primary font-bold mb-3 uppercase tracking-widest text-xs"><i class="ri-map-pin-user-line mr-1"></i> \${trail.title}</h4>
                <div class="flex flex-col gap-3 relative">
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-cup-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Breakfast</span><span class="text-sm font-bold text-main">\${trail.breakfast}</span></div>
                    </div>
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-restaurant-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Lunch</span><span class="text-sm font-bold text-main">\${trail.lunch}</span></div>
                    </div>
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-goblet-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Evening</span><span class="text-sm font-bold text-main">\${trail.evening}</span></div>
                    </div>
                    <div class="flex items-start gap-3 relative">
                        <div class="w-6 h-6 rounded-full bg-background border border-primary flex items-center justify-center shrink-0 mt-0.5 text-[0.6rem] text-primary"><i class="ri-knife-line"></i></div>
                        <div><span class="block text-[0.65rem] text-muted uppercase font-bold tracking-wider">Dinner</span><span class="text-sm font-bold text-main">\${trail.dinner}</span></div>
                    </div>
                </div>
            `;
                            trailsList.appendChild(div);
                        });
                    }

                    // Phase 7: Events Detected
                    const dayList = document.getElementById('aiDayCards');
                    dayList.innerHTML = '';

                    if (data.events_detected && data.events_detected.length > 0) {
                        const eventsBanner = document.createElement('div');
                        eventsBanner.className = 'glass-panel p-4 mb-6 rounded-2xl bg-orange-500/10 border-orange-500/30';
                        let eventsHtml = '';
                        data.events_detected.forEach(ev => {
                            eventsHtml += `<li class="text-sm text-orange-200"><i class="ri-calendar-event-line mr-2"></i>\${ev}</li>`;
                        });
                        eventsBanner.innerHTML = `<h4 class="text-orange-400 font-bold mb-2 uppercase tracking-widest text-xs"><i class="ri-notification-3-line mr-1"></i> Events Detected</h4><ul>\${eventsHtml}</ul>`;
                        dayList.appendChild(eventsBanner);
                    }

                    // Render Days
                    data.days.forEach(day => {
                        const card = document.createElement('div');
                        card.className = 'glass-panel p-6 reveal-item relative overflow-hidden';
                        card.style.borderRadius = '20px';

                        let diffColor = 'text-green-400 bg-green-400/10 border-green-400/20';
                        if (day.difficulty_level === 'Moderate') diffColor = 'text-orange-400 bg-orange-400/10 border-orange-400/20';
                        if (day.difficulty_level === 'Intense') diffColor = 'text-red-400 bg-red-400/10 border-red-400/20';

                        let activitiesHtml = '';
                        if (day.activities) {
                            day.activities.forEach((act, idx) => {
                                let catIcon = 'ri-map-pin-line';
                                let catColor = 'text-primary bg-primary/10';
                                if (act.category === 'Food') { catIcon = 'ri-restaurant-2-line'; catColor = 'text-orange-400 bg-orange-400/10'; }
                                if (act.category === 'Hidden Gem') { catIcon = 'ri-vip-diamond-line'; catColor = 'text-purple-400 bg-purple-400/10'; }
                                if (act.category === 'Logistics') { catIcon = 'ri-car-line'; catColor = 'text-gray-400 bg-gray-400/10'; }

                                activitiesHtml += `
                    <div class="flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group relative">
                        <div class="w-16 shrink-0 pt-1">
                            <span class="text-[0.65rem] text-muted font-bold uppercase block">\${act.time_slot || act.time}</span>
                            \${act.travel_time ? '<span class="text-[0.55rem] text-muted flex items-center mt-1"><i class="ri-car-line mr-1"></i> ' + act.travel_time + '</span>' : ''}
                        </div>
                        <div class="flex-1">
                            <div class="flex items-center gap-2 mb-1">
                                <h5 class="text-sm text-main font-bold m-0">\${act.title || 'Activity'}</h5>
                                <span class="px-2 py-0.5 rounded text-[0.55rem] uppercase tracking-wider font-bold \${catColor}"><i class="\${catIcon} mr-1"></i>\${act.category || 'General'}</span>
                                \${act.recommended_duration ? '<span class="px-2 py-0.5 rounded text-[0.55rem] uppercase tracking-wider font-bold text-muted bg-white/5"><i class="ri-time-line mr-1"></i>' + act.recommended_duration + '</span>' : ''}
                            </div>
                            <p class="text-xs text-muted/80 leading-relaxed editable-activity" contenteditable="true" onblur="updateActivity(\${day.day}, \${idx}, this.innerText)">\${act.description}</p>
                        </div>
                    </div>
                `;
                            });
                        }

                        card.innerHTML = `
            <div class="absolute -right-10 -top-10 text-white/5 pointer-events-none">
                <span class="font-bold editorial" style="font-size: 10rem;">\${day.day}</span>
            </div>
            <div class="relative z-10">
                <div class="flex justify-between items-start mb-4 cursor-grab drag-handle">
                    <div>
                        <h4 class="text-primary font-bold editorial mb-2" style="font-size: 1.4rem;">Day \${day.day}: \${day.title}</h4>
                        <div class="flex gap-2 mb-3">
                            \${day.difficulty_level ? '<span class="px-2 py-1 rounded text-xs font-bold border ' + diffColor + '"><i class="ri-pulse-line mr-1"></i> ' + day.difficulty_level + '</span>' : ''}
                            \${day.weather_forecast ? '<span class="px-2 py-1 rounded text-xs font-bold border text-blue-400 bg-blue-400/10 border-blue-400/20"><i class="ri-sun-cloudy-line mr-1"></i> ' + day.weather_forecast + '</span>' : ''}
                            \${day.walking_km ? '<span class="px-2 py-1 rounded text-xs font-bold border text-muted bg-white/5 border-white/10"><i class="ri-walk-line mr-1"></i> ' + day.walking_km + '</span>' : ''}
                        </div>
                        \${day.daily_story ? '<p class="text-sm text-muted/90 italic mb-4">"' + day.daily_story + '"</p>' : ''}
                    </div>
                    <i class="ri-draggable text-muted text-lg mt-2"></i>
                </div>
                <div class="flex flex-col gap-1 sortable-activities" data-day="\${day.day}" style="min-height: 50px;">
                    \${activitiesHtml}
                </div>
                <button onclick="addCustomActivity(this, \${day.day})" class="w-full mt-2 py-2 text-xs text-muted hover:text-main hover:bg-white/5 rounded-xl border border-dashed border-white/10 transition-all">
                    <i class="ri-add-line mr-1"></i> Add Custom Activity
                </button>
            </div>
        `;
                        dayList.appendChild(card);
                    });

                    // Phase 7: Alternative Plans
                    if (data.alternative_plans && data.alternative_plans.length > 0) {
                        const altContainer = document.createElement('div');
                        altContainer.className = 'glass-panel p-6 mt-6 rounded-2xl border-dashed border border-white/20';
                        altContainer.innerHTML = `<h3 class="font-bold text-main text-lg mb-4 flex items-center"><i class="ri-shuffle-line text-primary mr-2"></i> Alternative Plans</h3>`;

                        const grid = document.createElement('div');
                        grid.className = 'grid grid-cols-1 md:grid-cols-2 gap-4';

                        data.alternative_plans.forEach(alt => {
                            grid.innerHTML += `
                <div class="p-4 bg-white/5 hover:bg-white/10 rounded-xl transition-all cursor-pointer border border-white/5">
                    <h5 class="text-sm font-bold text-main mb-1">\${alt.plan_name}</h5>
                    <p class="text-xs text-muted">\${alt.description}</p>
                </div>
            `;
                        });
                        altContainer.appendChild(grid);
                        dayList.appendChild(altContainer);
                    }

                    // Initialize Sortable for each day's activities
                    // Phase 8: Initialize Sortable for each day's activities and Optimization Engine
                    window.recalculateTripState = () => {
                        let totalActivities = 0;
                        let totalEstimatedCost = 0;

                        document.querySelectorAll('.sortable-activities').forEach(dayList => {
                            const activities = dayList.querySelectorAll('.group');
                            const dayNum = dayList.getAttribute('data-day');

                            // Overload Detection
                            if (activities.length > 6) {
                                VoyastraToast.show(`Trip Overload Detected on Day \${dayNum}. Too many activities!`, "error");
                            }

                            totalActivities += activities.length;
                            totalEstimatedCost += (activities.length * 500); // Mock cost per activity
                        });

                        // Update Live Budget
                        const budgetRemainingEl = document.getElementById('aiBudgetRemaining');
                        if (budgetRemainingEl && currentAiPlan) {
                            // Updated per fix requirement
                            budgetRemainingEl.innerText = "Estimated";
                        }
                    };

                    document.querySelectorAll('.sortable-activities').forEach(el => {
                        new Sortable(el, {
                            group: 'shared', // set both lists to same group
                            animation: 150,
                            onAdd: function (evt) {
                                const itemEl = evt.item;
                                const title = itemEl.getAttribute('data-title') || 'Custom Activity';
                                let category = itemEl.getAttribute('data-category') || 'General';

                                let catIcon = 'ri-map-pin-line';
                                let catColor = 'text-primary bg-primary/10';
                                if (category === 'Food') { catIcon = 'ri-restaurant-2-line'; catColor = 'text-orange-400 bg-orange-400/10'; }
                                if (category === 'Hidden Gem') { catIcon = 'ri-vip-diamond-line'; catColor = 'text-purple-400 bg-purple-400/10'; }

                                itemEl.className = "flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group relative";
                                itemEl.innerHTML = `
                    <div class="w-16 shrink-0 pt-1">
                        <span class="text-[0.65rem] text-muted font-bold uppercase block">Custom</span>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center gap-2 mb-1">
                            <h5 class="text-sm text-main font-bold m-0">\${title}</h5>
                            <span class="px-2 py-0.5 rounded text-[0.55rem] uppercase tracking-wider font-bold \${catColor}"><i class="\${catIcon} mr-1"></i>\${category}</span>
                        </div>
                        <p class="text-xs text-muted/80 leading-relaxed editable-activity" contenteditable="true">Added from Library</p>
                    </div>
                `;
                                VoyastraToast.show("Activity added to itinerary!", "success");
                                window.recalculateTripState();
                            },
                            onEnd: function (evt) {
                                VoyastraToast.show("Itinerary updated!", "success");
                                window.recalculateTripState();
                            }
                        });
                    });
                    // Phase 8: Add Custom Day Logic
                    window.addCustomDay = () => {
                        const dayList = document.getElementById('aiDayCards');
                        const nextDayNum = dayList.children.length + 1;

                        const card = document.createElement('div');
                        card.className = 'glass-panel p-6 reveal-item relative overflow-hidden';
                        card.style.borderRadius = '20px';

                        card.innerHTML = `
            <div class="absolute -right-10 -top-10 text-white/5 pointer-events-none">
                <span class="font-bold editorial" style="font-size: 10rem;">\${nextDayNum}</span>
            </div>
            <div class="relative z-10">
                <div class="flex justify-between items-start mb-4 cursor-grab drag-handle">
                    <div>
                        <h4 class="text-primary font-bold editorial mb-2" style="font-size: 1.4rem;" contenteditable="true">Day \${nextDayNum}: Custom Day</h4>
                        <div class="flex gap-2 mb-3">
                            <span class="px-2 py-1 rounded text-xs font-bold border text-green-400 bg-green-400/10 border-green-400/20"><i class="ri-pulse-line mr-1"></i> Custom</span>
                        </div>
                    </div>
                    <i class="ri-draggable text-muted text-lg mt-2"></i>
                </div>
                <div class="flex flex-col gap-1 sortable-activities" data-day="\${nextDayNum}" style="min-height: 50px;">
                    <!-- Drop Zone -->
                    <div class="p-4 text-center border-2 border-dashed border-white/10 rounded-xl text-muted text-sm">
                        Drag activities here
                    </div>
                </div>
            </div>
        `;

                        dayList.appendChild(card);

                        // Initialize Sortable on new day
                        const newSortableEl = card.querySelector('.sortable-activities');
                        new Sortable(newSortableEl, {
                            group: 'shared',
                            animation: 150,
                            onAdd: function (evt) {
                                const itemEl = evt.item;
                                const title = itemEl.getAttribute('data-title') || 'Custom Activity';
                                let category = itemEl.getAttribute('data-category') || 'General';
                                let catIcon = 'ri-map-pin-line';
                                let catColor = 'text-primary bg-primary/10';
                                if (category === 'Food') { catIcon = 'ri-restaurant-2-line'; catColor = 'text-orange-400 bg-orange-400/10'; }
                                if (category === 'Hidden Gem') { catIcon = 'ri-vip-diamond-line'; catColor = 'text-purple-400 bg-purple-400/10'; }

                                // Clear the "Drag activities here" placeholder if it exists
                                const placeholder = newSortableEl.querySelector('.text-center');
                                if (placeholder) placeholder.remove();

                                itemEl.className = "flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group relative";
                                itemEl.innerHTML = `
                    <div class="w-16 shrink-0 pt-1">
                        <span class="text-[0.65rem] text-muted font-bold uppercase block">Custom</span>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center gap-2 mb-1">
                            <h5 class="text-sm text-main font-bold m-0">\${title}</h5>
                            <span class="px-2 py-0.5 rounded text-[0.55rem] uppercase tracking-wider font-bold \${catColor}"><i class="\${catIcon} mr-1"></i>\${category}</span>
                        </div>
                        <p class="text-xs text-muted/80 leading-relaxed editable-activity" contenteditable="true">Added from Library</p>
                    </div>
                `;
                                VoyastraToast.show("Activity added to custom day!", "success");
                                window.recalculateTripState();
                            },
                            onEnd: function (evt) {
                                VoyastraToast.show("Itinerary updated!", "success");
                                window.recalculateTripState();
                            }
                        });

                        VoyastraToast.show("Custom Day Added!", "success");
                    };

                    window.addCustomActivity = (btnEl, dayNum) => {
                        const title = prompt("Enter Custom Activity Title (e.g. Dinner Reservation)");
                        if (!title) return;

                        const sortableList = btnEl.previousElementSibling;
                        const placeholder = sortableList.querySelector('.text-center');
                        if (placeholder) placeholder.remove();

                        const card = document.createElement('div');
                        card.className = "flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group relative";
                        card.innerHTML = `
            <div class="w-16 shrink-0 pt-1">
                <span class="text-[0.65rem] text-muted font-bold uppercase block">Custom</span>
            </div>
            <div class="flex-1">
                <div class="flex items-center gap-2 mb-1">
                    <h5 class="text-sm text-main font-bold m-0">\${title}</h5>
                    <span class="px-2 py-0.5 rounded text-[0.55rem] uppercase tracking-wider font-bold text-primary bg-primary/10"><i class="ri-user-star-line mr-1"></i>Personal</span>
                </div>
                <p class="text-xs text-muted/80 leading-relaxed editable-activity" contenteditable="true">Tap to edit notes</p>
            </div>
        `;
                        sortableList.appendChild(card);
                        window.recalculateTripState();
                    };

                    // Render Budget
                    const budgetList = document.getElementById('aiBudgetList');
                    if (budgetList && data.budget_breakdown) {
                        budgetList.innerHTML = '';
                        const b = data.budget_breakdown;
                        const addBudgetRow = (label, val, icon) => {
                            if (!val) return;
                            const row = document.createElement('div');
                            row.className = 'flex justify-between items-center text-sm p-2 hover:bg-white/5 rounded-lg border-b border-white/5';
                            row.innerHTML = `<span class="text-muted flex items-center"><i class="\${icon} mr-2 text-primary"></i> \${label}</span><span class="text-main font-bold font-mono">\${val}</span>`;
                            budgetList.appendChild(row);
                        };
                        addBudgetRow('Flights', b.flights, 'ri-flight-takeoff-line');
                        addBudgetRow('Hotel', b.hotel, 'ri-hotel-bed-line');
                        addBudgetRow('Food', b.food, 'ri-restaurant-2-line');
                        addBudgetRow('Activities', b.activities, 'ri-ticket-2-line');
                        addBudgetRow('Transport', b.transportation, 'ri-car-line');
                        addBudgetRow('Emergency', b.emergency_fund, 'ri-safe-2-line');
                    }


                    // Render Chips
                    // Render Chips
                    const renderChips = (id, items, defaultCategory) => {
                        const el = document.getElementById(id);
                        if (el) {
                            el.innerHTML = '';
                            if (items && Array.isArray(items)) {
                                items.forEach(v => {
                                    const chip = document.createElement('li');
                                    chip.className = 'px-3 py-1 bg-white/10 rounded-full text-[0.7rem] text-muted border border-white/5 cursor-grab draggable-item';
                                    const title = typeof v === 'object' ? v.name : v;
                                    chip.innerText = title;
                                    chip.setAttribute('data-title', title);
                                    chip.setAttribute('data-category', defaultCategory);
                                    el.appendChild(chip);
                                });

                                // Phase 8: Initialize Sortable
                                new Sortable(el, {
                                    group: { name: 'shared', pull: 'clone', put: false },
                                    animation: 150,
                                    sort: false
                                });
                            }
                        }
                    };

                    renderChips('aiMustVisit', data.must_visit, 'Attraction');
                    renderChips('aiHiddenGems', data.hidden_gems, 'Hidden Gem');
                    renderChips('aiInstaSpots', data.instagram_spots, 'Instagram Spot');
                    renderChips('aiFood', data.food_discovery, 'Food');

                    // Weather
                    const weatherEl = document.getElementById('weatherText');
                    if (weatherEl && data.weather) {
                        weatherEl.innerText = data.weather;
                    }

                    // Render Tips
                    const renderList = (id, items) => {
                        const el = document.getElementById(id);
                        if (el) {
                            el.innerHTML = '';
                            if (items && Array.isArray(items)) {
                                items.forEach(t => {
                                    const tip = document.createElement('li');
                                    tip.innerText = t;
                                    el.appendChild(tip);
                                });
                            }
                        }
                    }

                    renderList('aiTravelTips', data.travel_tips);
                    renderList('aiGamification', data.gamification);

        // Phase 2: Fetch Dynamic Videos via Backend
        const videoReels = document.getElementById('aiVideoReels');
        if (videoReels) {
            videoReels.innerHTML = '<div class="text-muted text-sm p-4"><i class="ri-loader-4-line animate-spin"></i> Loading Travel Reels...</div>';
            
            const labels    = ['Destination Trailer', 'Drone Footage', 'Street Food Tour'];
            const sublabels = ['Cinematic', '4K Aerial', 'Local Cuisine'];
            const destName = document.querySelector('[name="destination"]')?.value || data.title || 'Travel';

            try {
                const results = await Promise.allSettled(labels.map(label =>
                    fetch(contextPath + `/api/youtube/search?destination=\${encodeURIComponent(destName)}&type=\${encodeURIComponent(label)}`)
                    .then(r => r.json())
                ));

                videoReels.innerHTML = results.map((result, i) => {
                    const videoId = result.status === 'fulfilled' && result.value?.items?.length > 0
                        ? result.value.items[0].id.videoId
                        : null;

                    return videoId
                        ? `<div class="glass-panel p-2 rounded-2xl shrink-0 w-72">
                            <div class="relative w-full h-40 bg-black rounded-xl overflow-hidden mb-2">
                                <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\${videoId}?autoplay=0&controls=0&modestbranding=1" title="\${labels[i]}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" referrerpolicy="no-referrer-when-downgrade" allowfullscreen loading="lazy"></iframe>
                            </div>
                            <div class="px-2 pb-1">
                                <h4 class="text-sm font-bold text-main mb-1 truncate">\${labels[i]}</h4>
                                <p class="text-[0.65rem] text-muted uppercase tracking-wider font-bold">\${sublabels[i]}</p>
                            </div>
                        </div>`
                        : `<div class="glass-panel p-2 rounded-2xl shrink-0 w-72 flex items-center justify-center bg-white/5">
                            <div class="text-center">
                                <div class="text-2xl mb-2">🎬</div>
                                <p class="text-sm font-bold text-main mb-1">\${labels[i]}</p>
                                <p class="text-[0.65rem] text-muted">Not available</p>
                            </div>
                        </div>`;
                }).join('');

            } catch (err) {
                videoReels.innerHTML = '<p class="text-red-400 text-sm">Could not load reels.</p>';
                console.error('[YouTube]', err);
            }
        }                

                    // Phase 5: Initial Budget Calculation
                    if (window.recalculateTripState) {
                        window.recalculateTripState();
                    }
                    renderList('aiWarnings', data.travel_warnings);

                    // Render Phase 2 Scalar Data
                    const summaryEl = document.getElementById('aiTripSummary');
                    if (summaryEl && data.trip_summary) summaryEl.innerText = data.trip_summary;

                    const seasonEl = document.getElementById('aiBestSeason');
                    if (seasonEl && data.best_season) seasonEl.innerText = data.best_season;

                    const durEl = document.getElementById('aiRecDuration');
                    if (durEl && data.recommended_duration) durEl.innerText = data.recommended_duration;

                    const modeEl = document.getElementById('aiBestMode');
                    if (modeEl && data.best_travel_mode) modeEl.innerText = data.best_travel_mode;

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

                document.getElementById('btnSavePlan')?.addEventListener('click', function () {
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
                    params.append('destination', "\${param.destination}" || 'Custom Destination');
                    params.append('itineraryData', JSON.stringify(currentAiPlan));

                    fetch('${pageContext.request.contextPath}/itinerary', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: params
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === 'success') {
                                VoyastraToast.show("âœ¨ Trip saved successfully to your Profile!", "success");
                                saveBtn.innerHTML = 'âœ“ Saved';
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

                // Set min date for date inputs
                window.addEventListener('DOMContentLoaded', () => {
                    initMap();
                    const today = new Date().toISOString().split('T')[0];
                    const depDateInput = document.getElementById('depDate');
                    const retDateInput = document.getElementById('retDate');
                    if (depDateInput) depDateInput.min = today;
                    if (retDateInput) retDateInput.min = today;
                });
            
