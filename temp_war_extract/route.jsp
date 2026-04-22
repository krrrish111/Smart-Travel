<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>
<style>
    /* Prevent body scroll for full screen map */
    body { overflow: hidden; }
    
    .timeline-node {
        position: relative;
        padding-left: 32px;
        padding-bottom: 24px;
    }
    .timeline-node::before {
        content: '';
        position: absolute;
        left: 6px; top: 2px;
        width: 14px; height: 14px;
        border-radius: 50%;
        background: var(--color-primary);
        box-shadow: 0 0 0 4px rgba(212, 165, 116, 0.2);
        z-index: 2;
    }
    .timeline-node:not(:last-child)::after {
        content: '';
        position: absolute;
        left: 12px; top: 16px; bottom: -2px;
        width: 2px;
        background: var(--color-border);
        z-index: 1;
    }
    
    .suggestion-card {
        background: rgba(255,255,255,0.03);
        border: 1px solid var(--color-border);
        border-radius: 8px;
        padding: 12px;
        margin-top: 10px;
        display: flex; gap: 12px;
        transition: transform 0.2s ease, background 0.2s ease;
        cursor: pointer;
    }
    .suggestion-card:hover {
        background: rgba(255,255,255,0.08);
        transform: translateY(-2px);
    }
</style>

<main class="flex h-screen" style="padding-top: 80px;">

    <!-- Left Sidebar: Route Navigation -->
    <aside class="glass-panel slide-up slide-right" style="width: 400px; height: 100%; overflow-y: auto; border-radius: 0; border-right: 1px solid var(--color-border); display: flex; flex-direction: column;">
        
        <div class="px-6 py-4 sticky top-0" style="background: var(--surface-glass); backdrop-filter: blur(16px); z-index: 10; border-bottom: 1px solid var(--color-border);">
            <a href="booking.jsp" class="text-primary font-bold text-sm mb-3 inline-block">← Back to Bookings</a>
            <h2 class="editorial text-main mb-1" style="font-size: 1.8rem;">Route Navigation</h2>
            <div class="flex gap-4 text-xs font-bold uppercase tracking-wider text-muted">
                <span><i class="opacity-80">Dist:</i> <span id="navTotalDist" class="text-primary">--</span></span>
                <span><i class="opacity-80">Time:</i> <span id="navTotalTime" class="text-primary">--</span></span>
            </div>
        </div>

        <div class="p-6">
            <!-- Timeline -->
            <div id="routeTimeline">
                
                <!-- Origin -->
                <div class="timeline-node">
                    <h4 class="text-main font-bold mb-1" style="font-size: 1.1rem;">New Delhi</h4>
                    <p class="text-sm text-muted">Departure: 06:00 AM</p>
                    
                    <div class="suggestion-card">
                        <div style="width: 40px; height: 40px; border-radius: 6px; overflow: hidden; flex-shrink: 0;">
                            <img src="https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=100&q=80" alt="Food" class="w-full h-full object-cover">
                        </div>
                        <div>
                            <div class="text-xs text-primary font-bold uppercase tracking-wide">Stop Suggestion</div>
                            <div class="text-sm text-main font-semibold">Amrik Sukhdev Dhaba</div>
                        </div>
                    </div>
                </div>

                <!-- Stop 1 -->
                <div class="timeline-node">
                    <h4 class="text-main font-bold mb-1" style="font-size: 1.1rem;">Jaipur</h4>
                    <p class="text-sm text-muted">Halt: 2 Hours</p>
                    
                    <div class="suggestion-card">
                        <div style="width: 40px; height: 40px; border-radius: 6px; overflow: hidden; flex-shrink: 0;">
                            <img src="https://images.unsplash.com/photo-1477587784381-80796bba6621?auto=format&fit=crop&w=100&q=80" alt="Palace" class="w-full h-full object-cover">
                        </div>
                        <div>
                            <div class="text-xs text-secondary font-bold uppercase tracking-wide">Must See</div>
                            <div class="text-sm text-main font-semibold">Hawa Mahal Viewpoint</div>
                        </div>
                    </div>
                </div>

                <!-- Destination -->
                <div class="timeline-node">
                    <h4 class="text-main font-bold mb-1" style="font-size: 1.1rem;">Mumbai</h4>
                    <p class="text-sm text-muted">Arrival: est. 14:00 PM</p>
                </div>

            </div>
            
            <button class="btn btn-primary w-full mt-4" style="padding: 14px; font-weight: 700; font-size: 1rem;">Start Live Navigation ➔</button>

        </div>
    </aside>

    <!-- Right Area: Fullscreen Map -->
    <div class="flex-1 relative" style="background: #e5e3df;">
        <div id="fullNavMap" class="w-full h-full"></div>
        
        <!-- Floating Tools -->
        <div class="absolute top-4 right-4 flex flex-col gap-2">
            <button class="glass-panel" style="width: 40px; height: 40px; border-radius: 8px; padding:0; display:flex; align-items:center; justify-content:center; color: var(--text-main);">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
            </button>
            <button class="glass-panel" style="width: 40px; height: 40px; border-radius: 8px; padding:0; display:flex; align-items:center; justify-content:center; color: var(--text-main);">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
            </button>
        </div>
    </div>

</main>

<script>
function initRouteMap() {
    if (typeof google === 'undefined') return;

    const customMapStyle = [
      { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
      { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] },
      { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] }
    ];

    const map = new google.maps.Map(document.getElementById("fullNavMap"), {
        zoom: 5,
        center: { lat: 20.5937, lng: 78.9629 },
        disableDefaultUI: true,
        zoomControl: true,
        styles: document.documentElement.getAttribute('data-theme') === 'dark' ? customMapStyle : []
    });

    const dirServ = new google.maps.DirectionsService();
    const dirRen = new google.maps.DirectionsRenderer({
        map: map,
        suppressMarkers: false,
        polylineOptions: { strokeColor: '#d4a574', strokeWeight: 5, strokeOpacity: 0.9 }
    });

    dirServ.route({
        origin: "New Delhi, India",
        destination: "Mumbai, India",
        waypoints: [
            { location: "Jaipur, India", stopover: true }
        ],
        travelMode: google.maps.TravelMode.DRIVING 
    }, (resp, stat) => {
        if (stat === "OK") {
            dirRen.setDirections(resp);
            
            // Calculate total dist/time
            let totalDist = 0;
            let totalTime = 0;
            const route = resp.routes[0];
            for (let i = 0; i < route.legs.length; i++) {
                totalDist += route.legs[i].distance.value;
                totalTime += route.legs[i].duration.value;
            }
            
            // Format
            document.getElementById('navTotalDist').innerText = Math.round(totalDist / 1000) + ' km';
            document.getElementById('navTotalTime').innerText = Math.round(totalTime / 3600) + ' hrs';
        }
    });
}

// Request the centralized script to load Google Maps and call initRouteMap when ready
window.addEventListener('DOMContentLoaded', () => {
    if (typeof loadGoogleMaps === 'function') {
        loadGoogleMaps('initRouteMap');
    }
});
</script>

<!-- Note: Footer omitted to keep map full screen -->
</body>
</html>
