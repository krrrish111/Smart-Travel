<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<!-- Load Leaflet Map styles and scripts -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<!-- Load custom premium explorer styling -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/explore.css">

<script>
    // Expose prefilledQuery to JS context
    window.prefilledQuery = "${not empty prefilledQuery ? prefilledQuery : ''}";
</script>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden; position: relative;">
    <!-- Background Gradient Spot Glows -->
    <div class="bg-glow-spot" style="top: 10%; left: 5%;"></div>
    <div class="bg-glow-spot" style="top: 40%; right: 5%; background: radial-gradient(circle, rgba(139, 92, 246, 0.15) 0%, transparent 70%);"></div>

    <div class="explorer-container relative z-10">
        
        <!-- =======================
             HERO SEARCH BANNER
             ======================= -->
        <div class="mb-12 text-center slide-up">
            <h1 class="text-white mb-2 editorial text-5xl font-bold tracking-tight" style="text-shadow: 0 4px 10px rgba(0,0,0,0.6);">Discover Your Next Story</h1>
            <p class="text-white opacity-85 mb-8 font-medium" style="font-size: 1.15rem; font-family: 'Poppins', sans-serif;">Search any destination to explore curated sights, cuisines, guides, and AI recommendations.</p>
            
            <form id="exploreSearchForm" action="#" style="position:relative; max-width: 680px; margin: 0 auto;" autocomplete="off">
                <div class="explore-search-container" style="margin:0; box-shadow: 0 8px 32px rgba(0,0,0,0.4);">
                    <div class="explore-search-icon">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </div>
                    <input id="exploreSearchInput" type="text" 
                           class="explore-search-input"
                           placeholder="Type a city or region (e.g. Goa, Paris, Tokyo)..."
                           aria-label="Search destinations and plans">
                </div>
                <!-- Autocomplete dropdown -->
                <ul id="exploreSearchSuggest"
                    style="display:none; position:absolute; top:calc(100% + 8px); left:0; right:0;
                           background:rgba(20, 20, 25, 0.95); border:1px solid rgba(255,255,255,0.1);
                           border-radius:12px; list-style:none; margin:0; padding:6px 0;
                           z-index:999; box-shadow:0 12px 40px rgba(0,0,0,0.5);
                           max-height:280px; overflow-y:auto; backdrop-filter: blur(12px);">
                </ul>
            </form>
        </div>

        <!-- =======================
             DYNAMIC DOCK (AJAX LOADED)
             ======================= -->
        <div id="explorerDynamicArea" class="hidden slide-up">
            
            <!-- Destination Summary Banner -->
            <div class="glass-card mb-8">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4">
                    <h2 id="explorerDestTitle" class="text-white editorial text-4xl font-bold tracking-tight mb-2 md:mb-0">Goa</h2>
                    <span class="chip font-bold text-xs" style="margin: 0; background: rgba(59, 130, 246, 0.15); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.3);">Verified Insights</span>
                </div>
                <p id="wikiSummaryText" class="text-white opacity-80 leading-relaxed mb-6 font-medium text-base">Loading destination summary...</p>
                <div class="flex items-center gap-4">
                    <a id="wikiLinkBtn" href="#" target="_blank" class="btn btn-secondary px-5 py-2.5 flex items-center gap-2 text-xs font-bold transition-all hover:scale-[1.02]">
                        📖 Read More on Wikipedia
                    </a>
                </div>
            </div>

            <!-- Loader Skeletons -->
            <div class="explorer-loader grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <div class="skeleton skeleton-block"></div>
                <div class="skeleton skeleton-block"></div>
            </div>

            <!-- Immersive Photo Gallery -->
            <div class="mb-12">
                <h3 class="text-white font-bold mb-4 text-xl tracking-tight">📸 Immersive Photo Gallery</h3>
                <div id="galleryScrollBox" class="gallery-scroll-container">
                    <div class="skeleton skeleton-block w-[320px] h-[220px] rounded-xl"></div>
                    <div class="skeleton skeleton-block w-[320px] h-[220px] rounded-xl"></div>
                    <div class="skeleton skeleton-block w-[320px] h-[220px] rounded-xl"></div>
                </div>
            </div>

            <!-- Travel Videos -->
            <div class="mb-12">
                <h3 class="text-white font-bold mb-4 text-xl tracking-tight">🎥 Top Travel Guides & Vlogs</h3>
                <div id="videoScrollBox" class="video-carousel-container">
                    <div class="skeleton skeleton-block w-[300px] h-[220px] rounded-xl"></div>
                    <div class="skeleton skeleton-block w-[300px] h-[220px] rounded-xl"></div>
                </div>
            </div>

            <!-- Map and Sights section -->
            <div class="mb-12">
                <h3 class="text-white font-bold mb-4 text-xl tracking-tight">📍 Interactive Sights Map</h3>
                <div class="map-section-layout">
                    <!-- Left: Leaflet container -->
                    <div id="leafletMapContainer"></div>
                    <!-- Right: Attraction details cards -->
                    <div id="attractionCardsList" class="attraction-card-list">
                        <div class="skeleton h-24 rounded-xl mb-3"></div>
                        <div class="skeleton h-24 rounded-xl mb-3"></div>
                    </div>
                </div>
            </div>

            <!-- Local Cuisines / Food Menu -->
            <div class="mb-12">
                <h3 class="text-white font-bold mb-4 text-xl tracking-tight">🍜 Signature Food Explorer</h3>
                <div id="foodCardsDeck" class="food-card-deck">
                    <div class="skeleton h-40 rounded-xl"></div>
                    <div class="skeleton h-40 rounded-xl"></div>
                </div>
            </div>

            <!-- AI Recommendations & Custom Insight Card -->
            <div class="glass-card mb-12" style="background: linear-gradient(135deg, rgba(30, 27, 75, 0.4), rgba(76, 29, 149, 0.3)); border-color: rgba(139, 92, 246, 0.2);">
                <div class="flex items-center gap-3 mb-4">
                    <span class="text-2xl">🤖</span>
                    <h3 class="text-white font-bold text-lg" style="margin: 0;">AI Assistant Insights</h3>
                </div>
                <p id="aiInsightsBlock" class="text-white opacity-85 leading-relaxed text-sm">Generating travel tips...</p>
            </div>

            <!-- Call-To-Action (Plan My Trip) -->
            <div class="text-center py-8">
                <div class="glass-card max-w-[600px] margin-auto inline-block p-8" style="background: linear-gradient(rgba(10,10,12,0.8), rgba(10,10,12,0.9));">
                    <h3 class="text-white text-2xl font-bold mb-3">Ready to Pack Your Bags?</h3>
                    <p class="text-white opacity-70 text-sm mb-6">Convert this exploration list into a high-fidelity custom travel itinerary with just one click.</p>
                    <a id="ctaPlanTripBtn" href="#" class="btn btn-primary px-8 py-3.5 text-sm font-bold uppercase tracking-wider inline-flex items-center gap-2">
                        🚀 Plan My Trip
                    </a>
                </div>
            </div>

        </div>

        <!-- =======================
             STATIC DEFAULTS (TRENDING & PLANS)
             ======================= -->
        <div id="trendingSectionArea">
            <!-- Trending Now -->
            <div class="mb-12 w-full relative slide-up delay-1">
                <div class="flex justify-between items-end mb-6">
                    <div>
                        <h2 class="text-main editorial text-3xl font-bold tracking-tight">Trending Sights & Stays 🔥</h2>
                        <p class="text-muted text-sm font-body">Explore viral spots, local favorites, and stunning scenery.</p>
                    </div>
                </div>

                <div class="flex gap-4 overflow-x-auto pb-4 hide-scrollbar" style="scroll-snap-type: x mandatory;">
                    <c:forEach var="dest" items="${destinations}">
                        <div class="trending-card glass-card cursor-pointer" 
                             style="min-width: 320px; padding: 0; overflow: hidden; position: relative; scroll-snap-align: start;"
                             onclick="document.getElementById('exploreSearchInput').value='${dest.name}'; triggerDestinationExploration('${dest.name}');">
                            <div style="height: 190px; overflow: hidden;">
                                <img src="${not empty dest.imageUrl ? dest.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}" 
                                     alt="${dest.name}" class="w-full h-full object-cover explore-img">
                            </div>
                            <div class="p-5">
                                <div class="flex justify-between items-center mb-2">
                                    <h3 class="text-main font-bold text-lg">${dest.name}</h3>
                                    <span class="chip text-[0.65rem] font-bold" style="background: var(--color-primary); color: #000; margin:0; padding:2px 8px;">TRENDING</span>
                                </div>
                                <p class="text-muted text-xs leading-relaxed" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">${dest.description}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Curated Plans -->
            <div class="mb-12">
                <h2 class="text-main editorial text-3xl font-bold tracking-tight mb-6">Curated Travel Packages</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="plan" items="${plans}">
                        <a href="${pageContext.request.contextPath}/planner?location=${plan.title}" class="glass-card" style="padding: 0; overflow: hidden; display: block; text-decoration: none;">
                            <div style="height: 200px; overflow: hidden;">
                                <img src="${not empty plan.image ? plan.image : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=600&q=80'}" 
                                     alt="${plan.title}" class="w-full h-full object-cover explore-img">
                            </div>
                            <div class="p-5">
                                <span class="chip text-xs" style="background: rgba(255,255,255,0.08); color: var(--color-primary); font-weight: 700; margin-bottom: 8px; display: inline-block;">${plan.category}</span>
                                <h3 class="text-main font-bold text-lg mb-1">${plan.title}</h3>
                                <p class="text-primary text-xs mb-3 font-bold">📍 <c:out value="${not empty plan.destinationName ? plan.destinationName : 'Unknown Destination'}"/></p>
                                <p class="text-white opacity-70 text-xs mb-4" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${plan.description}
                                </p>
                                <div class="flex justify-between items-center pt-3" style="border-top: 1px solid rgba(255,255,255,0.08);">
                                    <span class="font-bold text-primary">₹${plan.price}</span>
                                    <span class="text-muted text-xs">${plan.days}D / ${plan.nights}N</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

    </div>
</main>

<!-- Load logic controller -->
<script src="${pageContext.request.contextPath}/js/explore.js"></script>

<%@ include file="/components/footer.jsp" %>
