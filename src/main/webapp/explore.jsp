<%@ include file="components/header.jsp" %>

<%@ include file="components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    

    <div class="container relative z-10" style="margin-top: -10px;">
    
        <div class="mb-8 text-center slide-up">
            <h1 class="text-white mb-1 editorial" style="font-size: 3rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">Explore & Discover</h1>
            <p class="text-white opacity-80" style="font-size: 1.1rem; font-family: 'Poppins', sans-serif;">Find out where everyone is going, or go where no one is.</p>
        </div>

        <!-- =======================
             TRENDING NOW SECTION 
             ======================= -->
        <div class="mb-12 w-full relative slide-up delay-1">
            <div class="flex justify-between items-end mb-4">
                <div>
                    <h2 class="text-main editorial" style="font-size: 2rem;">Trending Now 🔥</h2>
                    <p class="text-muted text-sm font-body">Viral spots, seasonal places, and Instagram favorites.</p>
                </div>
                <!-- Toggle Map View -->
                <button class="btn btn-secondary px-4 py-2 flex items-center gap-2" onclick="toggleTrendingMap()" style="font-size:0.85rem; font-weight:bold;">
                    <span id="mapToggleTx">📍 View on Map</span>
                </button>
            </div>

            <!-- Horizontal Scroll Cards -->
            <div id="trendingCarousel" class="flex gap-4 overflow-x-auto pb-4 hide-scrollbar" style="scroll-snap-type: x mandatory; margin-bottom:-10px;">
                
                <!-- TRENDING CARD 1 -->
                <div class="trending-card glass-panel" style="min-width: 300px; padding: 0; overflow: hidden; position: relative; scroll-snap-align: start;" data-lat="33.8967" data-lng="78.2618" data-title="Pangong Lake" data-bg="https://images.unsplash.com/photo-1542442828-287217bfb038?auto=format&fit=crop&w=600&q=80">
                    <div style="height: 180px; overflow: hidden;">
                        <img src="https://images.unsplash.com/photo-1542442828-287217bfb038?auto=format&fit=crop&w=600&q=80" alt="Pangong" class="w-full h-full object-cover explore-img">
                    </div>
                    <div class="p-4">
                        <div class="flex justify-between items-start mb-1">
                            <h3 class="text-main font-bold" style="font-size: 1.25rem;">Pangong Lake</h3>
                            <span style="background: var(--color-primary); color: #000; font-size: 0.65rem; font-weight: 800; padding: 2px 6px; border-radius: 4px;">#1 TRENDING</span>
                        </div>
                        <p class="text-muted text-xs mb-3">The vibrant blue waters of Ladakh.</p>
                        <div class="text-xs font-bold text-main">⭐ 5.0  <span class="text-primary italic ml-2">Seasonal: Summer</span></div>
                    </div>
                </div>

                <!-- TRENDING CARD 2 -->
                <div class="trending-card glass-panel" style="min-width: 300px; padding: 0; overflow: hidden; position: relative; scroll-snap-align: start;" data-lat="16.0592" data-lng="73.4682" data-title="Malvan Coast" data-bg="https://images.unsplash.com/photo-1590050720465-985fde5fb823?auto=format&fit=crop&w=600&q=80">
                    <div style="height: 180px; overflow: hidden;">
                        <img src="https://images.unsplash.com/photo-1590050720465-985fde5fb823?auto=format&fit=crop&w=600&q=80" alt="Malvan" class="w-full h-full object-cover explore-img">
                    </div>
                    <div class="p-4">
                        <div class="flex justify-between items-start mb-1">
                            <h3 class="text-main font-bold" style="font-size: 1.25rem;">Malvan</h3>
                            <span style="background: var(--color-secondary); color: #fff; font-size: 0.65rem; font-weight: 800; padding: 2px 6px; border-radius: 4px;">VIRAL</span>
                        </div>
                        <p class="text-muted text-xs mb-3">Scuba diving hidden gem of West India.</p>
                        <div class="text-xs font-bold text-main">⭐ 4.8  <span class="text-primary italic ml-2">Insta Famous</span></div>
                    </div>
                </div>

                <!-- TRENDING CARD 3 -->
                <div class="trending-card glass-panel" style="min-width: 300px; padding: 0; overflow: hidden; position: relative; scroll-snap-align: start;" data-lat="10.0889" data-lng="77.0595" data-title="Munnar Estates" data-bg="https://images.unsplash.com/photo-1593693397690-362807327341?auto=format&fit=crop&w=600&q=80">
                    <div style="height: 180px; overflow: hidden;">
                        <img src="https://images.unsplash.com/photo-1593693397690-362807327341?auto=format&fit=crop&w=600&q=80" alt="Munnar" class="w-full h-full object-cover explore-img">
                    </div>
                    <div class="p-4">
                        <div class="flex justify-between items-start mb-1">
                            <h3 class="text-main font-bold" style="font-size: 1.25rem;">Munnar</h3>
                            <span style="background: var(--color-primary); color: #000; font-size: 0.65rem; font-weight: 800; padding: 2px 6px; border-radius: 4px;">#3 TRENDING</span>
                        </div>
                        <p class="text-muted text-xs mb-3">Rolling lush green tea gardens.</p>
                        <div class="text-xs font-bold text-main">⭐ 4.9  <span class="text-primary italic ml-2">Monsoon Retreat</span></div>
                    </div>
                </div>

            </div>
            
            <!-- Trending Map View (Hidden By Default) -->
            <div id="trendingMapContainer" class="hidden mt-2 w-full h-[400px] rounded-[16px] overflow-hidden border border-[var(--color-border)] slide-up shadow-lg">
                <div id="exploreMap" class="w-full h-full" style="background: #e5e3df;"></div>
            </div>
        </div>

        <div class="mb-4 flex flex-col items-center slide-up delay-2">
            <h2 class="text-main editorial mb-2" style="font-size: 2rem;">Hidden Gems</h2>
            <div style="width: 40px; height: 3px; background: var(--color-primary); border-radius: 2px; margin-bottom: 12px;"></div>
        </div>

    <!-- Filters -->
    <div class="flex justify-center gap-2 mb-4 slide-up delay-1" style="flex-wrap: wrap;">
        <span class="chip active">All</span>
        <span class="chip">Rural Tourism</span>
        <span class="chip">Mountains</span>
        <span class="chip">Beaches</span>
        <span class="chip">Heritage</span>
        <span class="chip">Budget < 5000</span>
    </div>

    <div class="grid grid-cols-3 gap-4 slide-up delay-2">
        
        <!-- Card 1 -->
        <a href="planner.jsp?location=Spiti" class="glass-panel" style="overflow: hidden; display: block; border-radius: var(--border-radius-lg);">
            <div style="height: 200px; overflow: hidden; position: relative;">
                <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=600&q=80" alt="Spiti Valley" class="w-full h-full explore-img" style="object-fit: cover; transition: transform 0.5s ease;">
                <div class="absolute top-2 right-2">
                    <span class="chip" style="background: rgba(255,255,255,0.9); margin:0; padding: 4px 8px; font-size: 0.75rem;">Offbeat</span>
                </div>
            </div>
            <div style="padding: 20px;">
                <h3 class="text-main mb-1" style="font-size: 1.25rem;">Spiti Valley, Himachal</h3>
                <p class="text-white opacity-80 text-sm mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">Experience the rugged beauty of the cold desert mountain valley.</p>
                <div class="flex justify-between items-center mt-3 pt-3" style="border-top: 1px solid rgba(0,0,0,0.05);">
                    <span class="font-bold text-primary">₹18,000</span>
                    <span class="text-muted" style="font-size: 0.8rem;">⭐ 4.9</span>
                </div>
            </div>
        </a>

        <!-- Card 2 -->
        <a href="planner.jsp?location=Mawlynnong" class="glass-panel" style="overflow: hidden; display: block; border-radius: var(--border-radius-lg);">
            <div style="height: 200px; overflow: hidden; position: relative;">
                <img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=600&q=80" alt="Mawlynnong" class="w-full h-full explore-img" style="object-fit: cover; transition: transform 0.5s ease;">
                <div class="absolute top-2 right-2">
                    <span class="chip" style="background: rgba(255,255,255,0.9); margin:0; padding: 4px 8px; font-size: 0.75rem;">Rural Tourism</span>
                </div>
            </div>
            <div style="padding: 20px;">
                <h3 class="text-main mb-1" style="font-size: 1.25rem;">Mawlynnong, Meghalaya</h3>
                <p class="text-white opacity-80 text-sm mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">Asia's cleanest village, offering a pristine natural environment.</p>
                <div class="flex justify-between items-center mt-3 pt-3" style="border-top: 1px solid rgba(0,0,0,0.05);">
                    <span class="font-bold text-primary">₹12,000</span>
                    <span class="text-muted" style="font-size: 0.8rem;">⭐ 4.8</span>
                </div>
            </div>
        </a>

        <!-- Card 3 -->
        <a href="planner.jsp?location=Gokarna" class="glass-panel" style="overflow: hidden; display: block; border-radius: var(--border-radius-lg);">
            <div style="height: 200px; overflow: hidden; position: relative;">
                <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?auto=format&fit=crop&w=600&q=80" alt="Gokarna" class="w-full h-full explore-img" style="object-fit: cover; transition: transform 0.5s ease;">
                <div class="absolute top-2 right-2">
                    <span class="chip" style="background: rgba(255,255,255,0.9); margin:0; padding: 4px 8px; font-size: 0.75rem;">Beaches</span>
                </div>
            </div>
            <div style="padding: 20px;">
                <h3 class="text-main mb-1" style="font-size: 1.25rem;">Gokarna, Karnataka</h3>
                <p class="text-white opacity-80 text-sm mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">Serene beaches and a laid-back vibe, an alternative to Goa.</p>
                <div class="flex justify-between items-center mt-3 pt-3" style="border-top: 1px solid rgba(0,0,0,0.05);">
                    <span class="font-bold text-primary">₹8,000</span>
                    <span class="text-muted" style="font-size: 0.8rem;">⭐ 4.7</span>
                </div>
            </div>
        </a>

        <!-- Skeleton Loading Cards -->
        <div class="glass-panel" style="padding: 20px; border-radius: 16px; background: var(--color-surface); backdrop-filter: blur(14px);">
            <div class="skeleton w-full mb-3" style="height: 160px; border-radius: 8px;"></div>
            <div class="skeleton mb-2" style="height: 20px; width: 60%; border-radius: 4px;"></div>
            <div class="skeleton" style="height: 15px; width: 100%; border-radius: 4px;"></div>
        </div>
        <div class="glass-panel" style="padding: 20px; border-radius: 16px; background: var(--color-surface); backdrop-filter: blur(14px);">
            <div class="skeleton w-full mb-3" style="height: 160px; border-radius: 8px;"></div>
            <div class="skeleton mb-2" style="height: 20px; width: 60%; border-radius: 4px;"></div>
            <div class="skeleton" style="height: 15px; width: 100%; border-radius: 4px;"></div>
        </div>

    </div>
</main>

<style>
/* Add an image zoom hover effect locally for explore cards */
.glass-panel:hover .explore-img {
    transform: scale(1.05);
}

.hide-scrollbar::-webkit-scrollbar {
    display: none;
}
.hide-scrollbar {
    -ms-overflow-style: none;  /* IE and Edge */
    scrollbar-width: none;  /* Firefox */
}
</style>

<script>
let exploreMapInit = false;
let exMap;

function toggleTrendingMap() {
    const list = document.getElementById('trendingCarousel');
    const mapBox = document.getElementById('trendingMapContainer');
    const btnText = document.getElementById('mapToggleTx');

    if (mapBox.classList.contains('hidden')) {
        // Show Map, Hide List
        list.classList.add('hidden');
        mapBox.classList.remove('hidden');
        btnText.innerText = "🗓️ View as Grid";
        
        if (!exploreMapInit) {
            if (typeof loadGoogleMaps === 'function') {
                loadGoogleMaps('initExploreMap');
            } else {
                initExploreMap();
            }
        }
    } else {
        // Show List, Hide Map
        mapBox.classList.add('hidden');
        list.classList.remove('hidden');
        btnText.innerText = "📍 View on Map";
    }
}

function initExploreMap() {
    if (typeof google === 'undefined') return;
    
    const customMapStyle = [
      { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
      { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] },
      { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] }
    ];

    exMap = new google.maps.Map(document.getElementById("exploreMap"), {
        zoom: 5,
        center: { lat: 21.5, lng: 78.0 },
        disableDefaultUI: true,
        styles: document.documentElement.getAttribute('data-theme') === 'dark' ? customMapStyle : []
    });
    exploreMapInit = true;

    // Read cards data to place markers
    const cards = document.querySelectorAll('.trending-card');
    cards.forEach(card => {
        const lat = parseFloat(card.getAttribute('data-lat'));
        const lng = parseFloat(card.getAttribute('data-lng'));
        const title = card.getAttribute('data-title');
        
        if(lat && lng) {
            new google.maps.Marker({
                position: { lat: lat, lng: lng },
                map: exMap,
                title: title,
                icon: {
                    path: google.maps.SymbolPath.CIRCLE,
                    scale: 8,
                    fillColor: "#d4a574",
                    fillOpacity: 1,
                    strokeWeight: 2,
                    strokeColor: "#ffffff"
                }
            });
        }
    });
}
</script>

<%@ include file="components/footer.jsp" %>
