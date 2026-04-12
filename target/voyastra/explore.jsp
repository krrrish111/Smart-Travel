<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="components/header.jsp" %>

<%@ include file="components/global_ui.jsp" %>

<script>
    // Handle URL parameters for feedback
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('noQuery') === 'true') {
            if (window.VoyastraToast) {
                VoyastraToast.show('🔍 Please enter a search term.', 'info');
            }
        }
        if (urlParams.get('error') === 'searchFailed') {
            if (window.VoyastraToast) {
                VoyastraToast.show('❌ Search failed. Please try again.', 'error');
            }
        }
    });
</script>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    

    <div class="container relative z-10" style="margin-top: -10px;">
    
        <div class="mb-8 text-center slide-up">
            <h1 class="text-white mb-1 editorial" style="font-size: 3rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">Explore & Discover</h1>
            <p class="text-white opacity-80" style="font-size: 1.1rem; font-family: 'Poppins', sans-serif;">Find out where everyone is going, or go where no one is.</p>
            
            <!-- Modern Search Bar (wired to SearchServlet) -->
            <form id="exploreSearchForm" action="${pageContext.request.contextPath}/search" method="get"
                  style="position:relative; max-width: 640px; margin: 0 auto;" autocomplete="off">
                <div class="explore-search-container" style="margin:0;">
                    <div class="explore-search-icon">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </div>
                    <input id="exploreSearchInput" type="text" name="q"
                           class="explore-search-input"
                           placeholder="Search destinations, hidden gems, or experiences..."
                           value="${not empty searchQuery ? searchQuery : ''}"
                           aria-label="Search destinations and plans"
                           aria-autocomplete="list"
                           aria-controls="exploreSearchSuggest">
                </div>
                <!-- Autocomplete dropdown -->
                <ul id="exploreSearchSuggest"
                    style="display:none; position:absolute; top:calc(100% + 8px); left:0; right:0;
                           background:var(--color-surface); border:1px solid var(--color-border);
                           border-radius:12px; list-style:none; margin:0; padding:6px 0;
                           z-index:999; box-shadow:0 12px 40px rgba(0,0,0,0.25);
                           max-height:280px; overflow-y:auto;">
                </ul>
            </form>
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

            <!-- Horizontal Scroll Cards (Dynamic) -->
            <div id="trendingCarousel" class="flex gap-4 overflow-x-auto pb-4 hide-scrollbar" style="scroll-snap-type: x mandatory; margin-bottom:-10px;">
                
                <c:forEach var="dest" items="${destinations}">
                    <div class="trending-card glass-panel" 
                         style="min-width: 300px; padding: 0; overflow: hidden; position: relative; scroll-snap-align: start;" 
                         data-title="${dest.name}" 
                         data-bg="${not empty dest.imageUrl ? dest.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}">
                        <a href="destination?id=${dest.id}" style="text-decoration:none; color:inherit; display:block;">
                            <div style="height: 180px; overflow: hidden;">
                                <img src="${not empty dest.imageUrl ? dest.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}" 
                                     alt="${dest.name}" class="w-full h-full object-cover explore-img">
                            </div>
                            <div class="p-4">
                                <div class="flex justify-between items-start mb-1">
                                    <h3 class="text-main font-bold" style="font-size: 1.25rem;">${dest.name}</h3>
                                    <span style="background: var(--color-primary); color: #000; font-size: 0.65rem; font-weight: 800; padding: 2px 6px; border-radius: 4px;">TRENDING</span>
                                </div>
                                <p class="text-muted text-xs mb-3" style="display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;">${dest.description}</p>
                                <div class="text-xs font-bold text-main">⭐ 5.0  <span class="text-primary italic ml-2">Top Choice</span></div>
                            </div>
                        </a>
                    </div>
                </c:forEach>

                <c:if test="${empty destinations}">
                    <div class="glass-panel text-center py-10 w-full" style="min-width: 300px;">
                        <p class="text-muted">No trending spots found.</p>
                    </div>
                </c:if>

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

    <!-- ===== SEARCH RESULTS (shown only when SearchServlet sets these attributes) ===== -->
    <c:if test="${not empty searchQuery}">
        <div class="slide-up mb-8">
            <div class="flex items-center gap-3 mb-5">
                <h2 class="text-main editorial" style="font-size:1.8rem;">
                    Results for &ldquo;<span style="color:var(--color-primary);">${searchQuery}</span>&rdquo;
                </h2>
                <span class="chip" style="margin:0;">${resultCount} found</span>
                <a href="explore.jsp" class="btn btn-secondary" style="margin-left:auto; font-size:0.8rem; padding:6px 14px;">✕ Clear</a>
            </div>

            <%-- ── Destination results ── --%>
            <c:if test="${not empty destResults}">
                <p class="text-muted mb-3" style="font-size:0.85rem; text-transform:uppercase; letter-spacing:0.08em; font-weight:700;">📍 Destinations</p>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5 mb-8">
                    <c:forEach var="r" items="${destResults}">
                        <a href="destination?id=${r.id}" class="glass-panel" style="overflow:hidden; display:block; border-radius:var(--border-radius-lg);">
                            <div style="height:180px; overflow:hidden; position:relative;">
                                <img src="${not empty r.imageUrl ? r.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}"
                                     alt="${r.name}" style="width:100%; height:100%; object-fit:cover; transition:transform 0.5s ease;" class="explore-img">
                                <span class="chip" style="position:absolute; top:10px; right:10px; margin:0; font-size:0.7rem; background:rgba(255,255,255,0.9); color:#111;">Destination</span>
                            </div>
                            <div style="padding:16px;">
                                <h3 class="text-main mb-1" style="font-size:1.15rem;">${r.name}</h3>
                                <p class="text-white opacity-80 text-sm" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">${r.description}</p>
                                <span class="text-primary text-xs font-bold" style="margin-top:6px; display:block;">View Details →</span>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

            <%-- ── Plan results ── --%>
            <c:if test="${not empty planResults}">
                <p class="text-muted mb-3" style="font-size:0.85rem; text-transform:uppercase; letter-spacing:0.08em; font-weight:700;">🗺️ Travel Plans</p>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5 mb-8">
                    <c:forEach var="r" items="${planResults}">
                        <a href="planner.jsp?location=${r.title}" class="glass-panel" style="overflow:hidden; display:block; border-radius:var(--border-radius-lg);">
                            <div style="height:180px; overflow:hidden; position:relative;">
                                <img src="${not empty r.image ? r.image : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}"
                                     alt="${r.title}" style="width:100%; height:100%; object-fit:cover; transition:transform 0.5s ease;" class="explore-img">
                                <span class="chip" style="position:absolute; top:10px; right:10px; margin:0; font-size:0.7rem; background:rgba(255,255,255,0.9); color:#111;">${r.category}</span>
                            </div>
                            <div style="padding:16px;">
                                <h3 class="text-main mb-1" style="font-size:1.15rem;">${r.title}</h3>
                                <p class="text-primary text-xs font-bold">📍 <c:out value="${not empty r.destinationName ? r.destinationName : 'Unknown'}"/></p>
                                <div class="flex justify-between items-center mt-3 pt-3" style="border-top:1px solid rgba(255,255,255,0.1);">
                                    <span class="font-bold text-primary">₹${r.price}</span>
                                    <span class="text-muted" style="font-size:0.8rem;">${r.days}D / ${r.nights}N</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

            <%-- ── No results ── --%>
            <c:if test="${empty planResults and empty destResults}">
                <div class="vx-empty-state slide-up">
                    <div class="vx-empty-icon">🗺️</div>
                    <h3 class="vx-empty-title">No matches found</h3>
                    <p class="vx-empty-desc">We couldn't find any destinations or plans for "${searchQuery}". Try searching for something broader like "Beach" or "Mountains".</p>
                    <a href="explore.jsp" class="btn btn-primary" style="padding: 10px 24px;">Browse All Destinations</a>
                </div>
            </c:if>

            <hr style="border:none; border-top:1px solid var(--color-border); margin:32px 0;">
            <p class="text-muted text-sm text-center mb-6">Browse all recommendations below</p>
        </div>
    </c:if>

    <!-- Filters -->
    <div class="flex justify-center gap-2 mb-4 slide-up delay-1" style="flex-wrap: wrap;">
        <span class="chip active">All</span>
        <span class="chip">Rural Tourism</span>
        <span class="chip">Mountains</span>
        <span class="chip">Beaches</span>
        <span class="chip">Heritage</span>
        <span class="chip">Budget &lt; 5000</span>
    </div>

    <!-- Destinations Section -->
    <div class="mb-4 flex flex-col items-center slide-up delay-1 mt-8">
        <h2 class="text-main editorial mb-2" style="font-size: 2rem;">Top Destinations</h2>
        <div style="width: 40px; height: 3px; background: var(--color-primary); border-radius: 2px; margin-bottom: 24px;"></div>
    </div>

    <div id="destinationsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 slide-up delay-1 mb-12"
         data-skeleton="card" data-skeleton-count="6">
        <c:forEach var="dest" items="${destinations}">
            <a href="destination?id=${dest.id}" class="glass-panel" style="overflow: hidden; display: block; border-radius: var(--border-radius-lg); padding: 0;">
                <div style="height: 180px; overflow: hidden; position: relative;">
                    <img src="${not empty dest.imageUrl ? dest.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}" 
                         alt="${dest.name}" class="w-full h-full explore-img" style="object-fit: cover; transition: transform 0.5s ease;">
                    <div class="absolute top-3 right-3">
                        <span class="chip" style="background: rgba(255,255,255,0.9); margin:0; padding: 4px 10px; font-size: 0.75rem; color:#111; box-shadow: 0 4px 10px rgba(0,0,0,0.2);">Destination</span>
                    </div>
                </div>
                <div style="padding: 20px;">
                    <h3 class="text-main mb-2" style="font-size: 1.35rem; font-weight: 700;">${dest.name}</h3>
                    <p class="text-white opacity-80 text-sm" style="display: -webkit-box; -webkit-line-clamp: 3; line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; min-height: 60px;">
                        ${dest.description}
                    </p>
                    <div class="mt-4 pt-3" style="border-top: 1px solid rgba(255,255,255,0.1); text-align: right;">
                        <span class="text-primary text-sm font-bold">View Plans →</span>
                    </div>
                </div>
            </a>
        </c:forEach>
        <c:if test="${empty destinations}">
            <div class="col-span-full py-10 text-center glass-panel">
                <p class="text-muted">No destinations found in the database. Add some from the Admin Panel!</p>
            </div>
        </c:if>
    </div>

    <!-- Travel Plans Section -->
    <div class="mb-4 flex flex-col items-center slide-up delay-2">
        <h2 class="text-main editorial mb-2" style="font-size: 2rem;">Curated Plans</h2>
        <div style="width: 40px; height: 3px; background: var(--color-primary); border-radius: 2px; margin-bottom: 24px;"></div>
    </div>

    <div id="plansGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 slide-up delay-2"
         data-skeleton="card" data-skeleton-count="6">
        <c:forEach var="plan" items="${plans}">
            <!-- Card -->
            <a href="planner.jsp?location=${plan.title}" class="glass-panel" style="overflow: hidden; display: block; border-radius: var(--border-radius-lg);">
                <div style="height: 200px; overflow: hidden; position: relative;">
                    <img src="${not empty plan.image ? plan.image : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}" 
                         alt="${plan.title}" class="w-full h-full explore-img" style="object-fit: cover; transition: transform 0.5s ease;">
                    <div class="absolute top-2 right-2">
                        <span class="chip" style="background: rgba(255,255,255,0.9); margin:0; padding: 4px 8px; font-size: 0.75rem;">${plan.category}</span>
                    </div>
                </div>
                <div style="padding: 20px;">
                    <h3 class="text-main mb-1" style="font-size: 1.25rem;">${plan.title}</h3>
                    <p class="text-primary text-xs mb-2 font-bold" style="letter-spacing: 0.5px;">📍 <c:out value="${not empty plan.destinationName ? plan.destinationName : 'Unknown Destination'}"/></p>
                    <p class="text-white opacity-80 text-sm mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                        ${plan.description}
                    </p>
                    <div class="flex justify-between items-center mt-3 pt-3" style="border-top: 1px solid rgba(255,255,255,0.1);">
                        <span class="font-bold text-primary">₹${plan.price}</span>
                        <span class="text-muted" style="font-size: 0.8rem;">${plan.days}D / ${plan.nights}N</span>
                    </div>
                </div>
            </a>
        </c:forEach>

        <!-- No Plans fallback -->
        <c:if test="${empty plans}">
            <div class="col-span-full py-20 text-center glass-panel">
                <p class="text-muted">No travel plans found in the database. Add some to get started!</p>
            </div>
        </c:if>
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
/* ──────────────────────────────────────────────────────
   Dynamic Autocomplete — calls /search?q=<input>&mode=suggest
   and renders a dropdown list beneath the search bar.
────────────────────────────────────────────────────── */
(function () {
    const input   = document.getElementById('exploreSearchInput');
    const suggest = document.getElementById('exploreSearchSuggest');
    const form    = document.getElementById('exploreSearchForm');
    if (!input || !suggest) return;

    let debounceTimer;
    let activeIdx = -1;

    input.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        const q = this.value.trim();
        if (q.length < 2) { hideSuggest(); return; }
        debounceTimer = setTimeout(() => fetchSuggestions(q), 220);
    });

    function fetchSuggestions(q) {
        const url = form.action + '?q=' + encodeURIComponent(q) + '&mode=suggest';
        fetch(url)
            .then(r => r.json())
            .then(renderSuggestions)
            .catch(() => hideSuggest());
    }

    function renderSuggestions(items) {
        suggest.innerHTML = '';
        activeIdx = -1;
        if (!items || items.length === 0) { hideSuggest(); return; }

        items.forEach((text, i) => {
            const li = document.createElement('li');
            li.textContent = text;
            li.style.cssText = 'padding:10px 18px; cursor:pointer; font-family:Poppins,sans-serif; font-size:0.9rem; color:var(--text-main); transition:background 0.15s;';
            li.addEventListener('mouseenter', () => setActive(i));
            li.addEventListener('click', () => { input.value = text; hideSuggest(); form.submit(); });
            suggest.appendChild(li);
        });
        suggest.style.display = 'block';
    }

    function setActive(i) {
        const items = suggest.querySelectorAll('li');
        items.forEach((el, j) => {
            el.style.background = j === i ? 'var(--color-border)' : '';
        });
        activeIdx = i;
    }

    // Keyboard navigation
    input.addEventListener('keydown', function (e) {
        const items = suggest.querySelectorAll('li');
        if (!items.length) return;
        if (e.key === 'ArrowDown')  { e.preventDefault(); setActive(Math.min(activeIdx + 1, items.length - 1)); }
        if (e.key === 'ArrowUp')    { e.preventDefault(); setActive(Math.max(activeIdx - 1, 0)); }
        if (e.key === 'Enter' && activeIdx >= 0) { e.preventDefault(); input.value = items[activeIdx].textContent; hideSuggest(); form.submit(); }
        if (e.key === 'Escape')     { hideSuggest(); }
    });

    function hideSuggest() { suggest.style.display = 'none'; activeIdx = -1; }

    // Hide on outside click
    document.addEventListener('click', function (e) {
        if (!form.contains(e.target)) hideSuggest();
    });
})();

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
