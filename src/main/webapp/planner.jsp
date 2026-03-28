<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<main class="container mx-auto px-4" style="padding-top: 100px; padding-bottom: 40px; height: 100vh; min-height: 800px; overflow: hidden; display: flex; flex-direction: column;">
    
    <div class="text-center mb-6 slide-up">
        <h1 class="text-primary mb-1 editorial" style="font-size: 2.5rem;">Interactive Trip Planner</h1>
        <p class="text-muted text-sm" style="font-family: 'Poppins', sans-serif;">Map your route and let AI optimize your Indian adventure.</p>
    </div>

    <div class="flex flex-col lg:flex-row gap-6 h-full w-full slide-up delay-1" style="flex: 1; overflow: hidden; padding-bottom:20px;">
        
        <!-- LEFT PANEL: Form -->
        <div class="glass-panel flex flex-col w-full lg:max-w-[400px]" style="padding: 24px; overflow-y: auto; border-radius: 16px;">
            
            <form action="itinerary.jsp" method="get" class="flex flex-col h-full gap-4">
                
                <!-- Routing Inputs -->
                <div class="p-4" style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 12px;">
                    <h3 class="text-main mb-3" style="font-size: 1.1rem; font-family: 'Playfair Display', serif;">Route Details</h3>
                    
                    <div class="form-group mb-3 relative">
                        <label class="form-label" style="font-size: 0.8rem;">Starting Point</label>
                        <input type="text" id="routeStart" name="startLocation" class="form-control" placeholder="e.g. Delhi, Mumbai" required>
                    </div>
                    
                    <div class="form-group relative">
                        <label class="form-label" style="font-size: 0.8rem;">Destination</label>
                        <input type="text" id="routeEnd" name="location" class="form-control" placeholder="e.g. Manali, Goa" required>
                    </div>
                    
                    <button type="button" id="btnCalcRoute" class="btn btn-secondary mt-3 w-full" style="padding: 10px; font-size: 0.9rem;">Preview Route</button>
                </div>

                <!-- Budget Slider -->
                <div class="form-group slide-up delay-2">
                    <div class="flex justify-between items-end mb-2">
                        <label class="form-label" style="margin-bottom:0;">Estimated Budget</label>
                        <div id="budgetDisplay" class="font-bold text-primary" style="font-size: 1.15rem;">₹50,000</div>
                    </div>
                    <input type="range" name="budget" id="budgetSlider" class="range-slider w-full" min="5000" max="200000" step="1000" value="50000">
                </div>

                <!-- Days Selector -->
                <div class="form-group slide-up delay-3">
                    <label class="form-label">Duration (Days)</label>
                    <input type="number" name="days" class="form-control" min="1" max="30" value="5" required>
                </div>

                <!-- Interest Tags -->
                <div class="form-group slide-up delay-3">
                    <label class="form-label mb-2">Interests</label>
                    <div class="flex" style="flex-wrap: wrap; gap: 8px;">
                        <span class="chip active" onclick="this.classList.toggle('active')">Culture</span>
                        <span class="chip" onclick="this.classList.toggle('active')">Nature</span>
                        <span class="chip" onclick="this.classList.toggle('active')">Adventure</span>
                        <span class="chip" onclick="this.classList.toggle('active')">Food</span>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="mt-auto pt-4 text-center slide-up delay-3" style="border-top: 1px solid var(--color-border);">
                    <button type="submit" class="btn btn-primary w-full" style="padding: 16px; font-size: 1.05rem; font-weight: 700; font-family: 'Poppins', sans-serif;">
                        Generate Itinerary ➔
                    </button>
                </div>
            </form>
        </div>

        <!-- RIGHT PANEL: Google Map -->
        <div class="glass-panel relative flex-1 hidden lg:flex" style="overflow: hidden; padding: 0; border-radius: 16px; border: 1px solid var(--color-border);">
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
</main>

<script>
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

    // Auto-complete (Requires Places Library)
    const startInput = document.getElementById("routeStart");
    const endInput = document.getElementById("routeEnd");
    
    if (startInput && endInput) {
        new google.maps.places.Autocomplete(startInput);
        new google.maps.places.Autocomplete(endInput);
        
        document.getElementById('btnCalcRoute').addEventListener('click', calculateAndDisplayRoute);
    }
}

function calculateAndDisplayRoute() {
    if (!directionsService || !directionsRenderer) return;
    
    const start = document.getElementById("routeStart").value;
    const end = document.getElementById("routeEnd").value;
    
    if (!start || !end) {
        alert("Please enter both Starting Point and Destination.");
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
                window.alert("Directions request failed due to " + status);
            }
        }
    );
}

// Request the centralized script to load Google Maps and call initMap when ready
window.addEventListener('DOMContentLoaded', () => {
    if (typeof loadGoogleMaps === 'function') {
        loadGoogleMaps('initMap');
    }
});
</script>

<%@ include file="components/footer.jsp" %>
