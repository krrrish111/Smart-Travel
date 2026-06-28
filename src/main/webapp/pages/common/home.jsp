<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<!-- ===== PREMIUM PRELOADER (index.jsp — first visit only) ===== -->
<!--
     CRITICAL: Preloader div starts hidden (opacity:0, pointer-events:none).
     The inline script below immediately makes it visible only on first visit,
     BEFORE the rest of the DOM paints — avoiding any flash.
-->
<div id="voyastraPreloader" style="
        display: flex;
        position: fixed;
        inset: 0;
        width: 100vw;
        height: 100vh;
        background: #ffffff;
        z-index: 9999999;
        align-items: center;
        justify-content: center;
        /* Start fully visible and opaque */
        opacity: 1;
        pointer-events: all;">

    <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; gap:0;">
        <!-- Animated infinity SVG path -->
        <svg style="width:300px; height:150px; display:block;" viewBox="0 0 300 150">
            <defs>
                <linearGradient id="preloaderGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stop-color="#4f46e5" />
                    <stop offset="100%" stop-color="#06b6d4" />
                </linearGradient>
            </defs>
            <!-- Draw path -->
            <path class="preloader-infinity-path"
                  d="M 150,75 C 200,15 300,15 300,75 C 300,135 200,135 150,75 C 100,15 0,15 0,75 C 0,135 100,135 150,75 Z" />
            <!-- Airplane following path -->
            <path class="preloader-plane" d="M -5 -4 L 8 0 L -5 4 L -2 0 Z" fill="#0f0b08" />
        </svg>

        <!-- Dynamic font text -->
        <div class="preloader-text-dynamic" style="color: #0f0b08; font-size: 1.5rem; letter-spacing: 0.2em; margin-top: 1rem; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; font-weight: 600;">VOYASTRA</div>
    </div>
</div>

<script>
    /* â”€â”€ Preloader: first-visit gate â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
       Runs synchronously right after the div is in the DOM.
       On RETURN visits â†’ keep opacity 0, replace instantly with display none.
       On FIRST visit  â†’ show the preloader, then hide after 3.5s minimum OR window.load.
    â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
    (function () {
        var el  = document.getElementById('voyastraPreloader');
        var KEY = 'voyastra_visited';

        if (!el) return;

        if (sessionStorage.getItem(KEY)) {
            /* â”€â”€ Return visit: never show, hide synchronously before paint â”€â”€ */
            el.style.display = 'none';
            // Also removing it to clean up DOM
            if (el.parentNode) el.parentNode.removeChild(el);
            return;
        }

        /* â”€â”€ First visit of the session â”€â”€ */
        sessionStorage.setItem(KEY, '1');

        var startTime   = Date.now();
        var MIN_MS      = 3500;   /* minimum visible time in ms */
        var hideApplied = false;

        function applyHide() {
            if (hideApplied) return;
            hideApplied = true;
            // Add transition effect just before fading out
            el.style.transition = 'opacity 0.8s ease-in-out';
            el.style.opacity = '0';
            setTimeout(function () {
                el.style.display = 'none';
                if (el.parentNode) el.parentNode.removeChild(el);
            }, 820); /* matches transition duration */
        }

        /* Wait for full page load */
        window.addEventListener('load', function () {
            var elapsed = Date.now() - startTime;
            var wait    = Math.max(0, MIN_MS - elapsed);
            setTimeout(applyHide, wait);
        });

        /* Hard fallback: hide no matter what after 6 s */
        setTimeout(applyHide, 6000);
    })();
</script>


        <main style="padding-top: 120px; overflow-x: hidden;">
            <!-- Hero Section -->
            <section class="container relative parallax-wrapper" style="margin-bottom: 80px;">
                <div class="flex items-center justify-center h-full" style="min-height: 80vh;">

                    <!-- Hero Content -->
                    <div class="hero-content parallax-bg text-center max-w-4xl mx-auto" style="position: relative; z-index: 10;" data-speed="0.05">
                        <div class="mb-3 inline-block slide-up"
                            style="padding: 6px 16px; background: var(--surface-glass); backdrop-filter: blur(8px); border-radius: 30px; border: 1px solid rgba(255,255,255,0.2); animation-delay: 0.2s;">
                            <span class="text-primary font-bold text-sm"
                                style="font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color: var(--color-primary); letter-spacing: 0.05em; display: flex; align-items: center; gap: 6px;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 2L11 13"></path><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                                </svg>
                                VOYASTRA INTELLIGENCE
                            </span>
                        </div>
                        
                        <h1 class="mb-3 editorial text-on-img p-hide"
                            style="font-size: 4rem; line-height: 1.1; font-weight: 700; text-shadow: 0 2px 20px rgba(0,0,0,0.8);">
                            ${heroContent != null && heroContent.isActive() ? heroContent.title : 'Experience'} <br>
                            <!-- Rotator -->
                            <div class="rotator-container mx-1"
                                style="margin-top: -10px; text-shadow: 0 2px 20px rgba(0,0,0,0.8); color: var(--color-primary);">
                                <div class="rotator-track" id="rotatorTrack">
                                    <div class="rotator-word text-outline">Taj Mahal, Agra</div>
                                    <div class="rotator-word italic-accent">Kerala Backwaters</div>
                                    <div class="rotator-word text-outline">Jaisalmer Fort</div>
                                    <div class="rotator-word italic-accent">Varanasi Ghats</div>
                                    <div class="rotator-word text-outline">Coorg, Karnataka</div>
                                    <div class="rotator-word italic-accent">Munnar, Kerala</div>
                                    <div class="rotator-word text-outline">Leh, Ladakh</div>
                                </div>
                            </div>
                        </h1>

                        <p class="mb-4 mx-auto"
                            style="color: var(--text-on-img); font-size: 1.25rem; text-shadow: 0 2px 15px rgba(0,0,0,0.7); opacity: 0.95; max-width: 800px;">
                            ${heroContent != null && heroContent.isActive() ? heroContent.subtitle : 'Say goodbye to endless research. Our intelligent platform crafts hyper-personalized itineraries, seamlessly balancing iconic landmarks with undiscovered cultural treasures.'}
                        </p>
                        <div class="flex gap-3 justify-center items-center mb-5">
                            <a href="${pageContext.request.contextPath}/planner" id="heroPlanBtn" class="btn btn-primary tilt-card"
                                style="padding: 14px 28px; font-size: 1.1rem; box-shadow: var(--shadow-lg);"
                                onclick="event.preventDefault(); VoyastraAuth.requireAuth('${pageContext.request.contextPath}/planner');">
                                <div class="tilt-content flex items-center">
                                    Design My Itinerary
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" style="margin-left: 8px;">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </div>
                            </a>
                        </div>

                        <!-- Manual BG Dots -->
                        <div class="bg-dots flex justify-center" id="bgDots" style="margin-top: 1rem;">
                            <div class="bg-dot active" data-index="0"></div>
                            <div class="bg-dot" data-index="1"></div>
                            <div class="bg-dot" data-index="2"></div>
                            <div class="bg-dot" data-index="3"></div>
                            <div class="bg-dot" data-index="4"></div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ====== AI PLANNER WIDGET ====== -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
            <div class="container relative ai-hero-container">
                <div class="ai-planner-card glass-panel relative">
                    <div class="ai-planner-header text-center mb-6">
                        <h2 class="editorial ai-planner-title">✨ Design Your Perfect Journey</h2>
                        <p class="text-muted ai-planner-subtitle mt-2">Tell us your preferences and let Voyastra AI build the perfect itinerary.</p>
                    </div>

                    <form id="aiPlannerHeroForm" class="ai-planner-form">
                        
                        <div class="ai-planner-grid">
                            <!-- Destination -->
                            <div class="ai-field-group">
                                <label class="ai-field-label">Destination</label>
                                <div class="ai-input-wrap">
                                    <span class="ai-input-icon">📍</span>
                                    <input type="text" id="aiDestInput" placeholder="Where to?" required class="ai-dest-input" autocomplete="off" />
                                </div>
                            </div>

                            <!-- Duration -->
                            <div class="ai-field-group">
                                <label class="ai-field-label">Duration</label>
                                <div class="ai-chip-group" id="aiDurationGroup">
                                    <label class="ai-chip"><input type="radio" name="duration" value="Weekend"><span>Weekend</span></label>
                                    <label class="ai-chip"><input type="radio" name="duration" value="3-5 Days" checked><span>3-5 Days</span></label>
                                    <label class="ai-chip"><input type="radio" name="duration" value="1 Week"><span>1 Week</span></label>
                                    <label class="ai-chip"><input type="radio" name="duration" value="Custom"><span>Custom</span></label>
                                </div>
                            </div>

                            <!-- Budget -->
                            <div class="ai-field-group">
                                <label class="ai-field-label">Budget</label>
                                <div class="ai-chip-group" id="aiBudgetGroup">
                                    <label class="ai-chip"><input type="radio" name="budget" value="10k"><span>₹10K</span></label>
                                    <label class="ai-chip"><input type="radio" name="budget" value="25k" checked><span>₹25K</span></label>
                                    <label class="ai-chip"><input type="radio" name="budget" value="50k"><span>₹50K</span></label>
                                    <label class="ai-chip"><input type="radio" name="budget" value="luxury"><span>Luxury</span></label>
                                </div>
                            </div>

                            <!-- Travel Style -->
                            <div class="ai-field-group">
                                <label class="ai-field-label">Travel Style</label>
                                <div class="ai-chip-group" id="aiStyleGroup">
                                    <label class="ai-chip"><input type="radio" name="style" value="Solo"><span>Solo</span></label>
                                    <label class="ai-chip"><input type="radio" name="style" value="Couple" checked><span>Couple</span></label>
                                    <label class="ai-chip"><input type="radio" name="style" value="Family"><span>Family</span></label>
                                    <label class="ai-chip"><input type="radio" name="style" value="Adventure"><span>Adventure</span></label>
                                </div>
                            </div>
                        </div>

                        <div class="ai-cta-row mt-8 flex justify-center">
                            <button type="button" id="aiGenerateBtn" class="ai-generate-btn">
                                <span>🚀 Generate My AI Itinerary</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <script>
                window.CONTEXT_PATH = '${pageContext.request.contextPath}';
            </script>
            <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

            <!-- ====== PREMIUM TRIP PLANS CAROUSEL ====== -->
            <section class="premium-carousel-section container scroll-fade">
                <div class="carousel-header">
                    <div>
                        <h2 class="editorial text-main mb-1" style="font-size: 2.8rem;">Popular Trip Plans</h2>
                        <p class="text-muted" style="font-size:1rem;">Curated itineraries, ready to personalise.</p>
                    </div>
                </div>

                <div class="carousel-viewport-wrapper">
                    <!-- Left/Right navigation arrows -->
                    <button class="carousel-nav-btn prev" id="planPrevBtn" aria-label="Previous">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                    </button>
                    <button class="carousel-nav-btn next" id="planNextBtn" aria-label="Next">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </button>

                    <!-- Edge Fades -->
                    <div class="carousel-edge-fade left"></div>
                    <div class="carousel-edge-fade right"></div>

                    <!-- Outer Container -->
                    <div class="plan-carousel-outer" id="planCarouselOuter">
                        <!-- Inner Track: Cards are duplicated dynamically in JS for infinite effect -->
                        <div class="plan-carousel-track" id="planCarouselTrack">
                            <c:forEach var="trip" items="${premiumTrips}">
                                <div class="plan-card active">
                                    <div class="plan-card-img-wrap">
                                        <img src="${trip.imageUrl}" alt="${trip.title}" loading="lazy">
                                        <div class="plan-card-category">${trip.category}</div>
                                    </div>
                                    <div class="plan-card-body">
                                        <div class="plan-card-location">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg> 
                                            ${trip.destination}
                                        </div>
                                        <div class="plan-card-title">${trip.title}</div>
                                        <div class="plan-tags">
                                            <span class="plan-tag">${trip.bestSeason}</span>
                                            <span class="plan-tag">${trip.startingCity}</span>
                                        </div>
                                        <div class="plan-itinerary">
                                            <div class="plan-itinerary-step" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">${trip.shortDescription}</div>
                                        </div>
                                        <div class="plan-card-footer">
                                            <div class="plan-price">₹<fmt:formatNumber value="${trip.discountPrice != null && trip.discountPrice > 0 ? trip.discountPrice : trip.priceInr}" type="number" maxFractionDigits="0" /></div>
                                            <div class="plan-duration">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg> 
                                                ${trip.duration}
                                            </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/trip?id=${trip.id}" class="plan-card-view-btn">View Plan &rarr;</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ====== DESTINATION CAROUSEL ====== -->
            <section class="section scroll-fade relative dest-carousel-section" style="background: var(--color-surface); padding-top: 80px; padding-bottom: 80px;">

                <style>
                /* â”€â”€â”€ Destination Carousel â”€â”€â”€ */
                .dest-carousel-wrap {
                    position: relative;
                    max-width: 1400px;
                    margin: 0 auto;
                    padding: 0 24px;
                }
                .dest-carousel-viewport {
                    overflow: hidden;
                    border-radius: 20px;
                    position: relative;
                }
                .dest-carousel-track {
                    display: flex;
                    gap: 24px;
                    transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                    will-change: transform;
                }
                /* â”€â”€â”€ Destination Card â”€â”€â”€ */
                .dest-card {
                    flex: 0 0 calc(25% - 18px);
                    min-width: 0;
                    border-radius: 20px;
                    overflow: hidden;
                    position: relative;
                    height: 360px;
                    cursor: pointer;
                    /* 3D perspective origin */
                    transform-style: preserve-3d;
                    transform: perspective(1000px) rotateX(0deg) rotateY(0deg) scale(1);
                    transition: transform 0.4s cubic-bezier(0.23, 1, 0.32, 1),
                                box-shadow 0.4s cubic-bezier(0.23, 1, 0.32, 1);
                    box-shadow: 0 8px 32px rgba(0,0,0,0.25);
                    background: var(--surface-glass);
                    border: 1px solid var(--color-border);
                }
                .dest-card:hover {
                    box-shadow: 0 24px 60px rgba(0,0,0,0.45);
                }
                .dest-card img {
                    width: 100%; height: 100%;
                    object-fit: cover;
                    display: block;
                    transition: transform 0.6s cubic-bezier(0.23, 1, 0.32, 1);
                }
                .dest-card:hover img { transform: scale(1.07); }
                /* Gradient overlay */
                .dest-card-overlay {
                    position: absolute;
                    inset: 0;
                    background: linear-gradient(
                        to top,
                        rgba(0,0,0,0.85) 0%,
                        rgba(0,0,0,0.35) 50%,
                        rgba(0,0,0,0.05) 100%
                    );
                    z-index: 1;
                    transition: background 0.4s ease;
                }
                .dest-card:hover .dest-card-overlay {
                    background: linear-gradient(
                        to top,
                        rgba(0,0,0,0.9) 0%,
                        rgba(0,0,0,0.45) 55%,
                        rgba(0,0,0,0.12) 100%
                    );
                }
                /* Rank badge */
                .dest-card-rank {
                    position: absolute;
                    top: 16px; right: 16px;
                    z-index: 3;
                    background: var(--color-primary);
                    color: #fff;
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-weight: 700;
                    font-size: 0.75rem;
                    padding: 4px 12px;
                    border-radius: 30px;
                    letter-spacing: 0.06em;
                    text-transform: uppercase;
                    backdrop-filter: blur(8px);
                    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                }
                /* Category chip */
                .dest-card-category {
                    position: absolute;
                    top: 16px; left: 16px;
                    z-index: 3;
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-size: 0.68rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 0.1em;
                    padding: 4px 12px;
                    border-radius: 30px;
                    color: #fff;
                    backdrop-filter: blur(8px);
                    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                }
                /* Card content */
                .dest-card-content {
                    position: absolute;
                    bottom: 0; left: 0; right: 0;
                    padding: 24px;
                    z-index: 2;
                }
                .dest-card-name {
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-size: 1.85rem;
                    font-weight: 700;
                    color: #fff;
                    line-height: 1.05;
                    text-shadow: 0 2px 16px rgba(0,0,0,0.7);
                    margin-bottom: 5px;
                    letter-spacing: 0.01em;
                }
                .dest-card-sub {
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-size: 0.82rem;
                    font-weight: 400;
                    color: rgba(255,255,255,0.72);
                    margin-bottom: 14px;
                    text-shadow: 0 1px 4px rgba(0,0,0,0.4);
                    letter-spacing: 0.01em;
                }
                .dest-card-meta {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    background: rgba(255,255,255,0.12);
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255,255,255,0.15);
                    border-radius: 12px;
                    padding: 10px 16px;
                    transform: translateY(8px);
                    opacity: 0;
                    transition: transform 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0.05s,
                                opacity 0.4s ease 0.05s;
                }
                .dest-card:hover .dest-card-meta {
                    transform: translateY(0);
                    opacity: 1;
                }
                .dest-card-price {
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-weight: 800;
                    font-size: 1.15rem;
                    letter-spacing: -0.02em;
                    background: linear-gradient(135deg, #f6d365 0%, #d4a574 40%, #e8b86d 70%, #c9943d 100%);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                    filter: drop-shadow(0 0 6px rgba(212,165,116,0.5));
                    line-height: 1;
                }
                .dest-card-duration {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-size: 0.78rem;
                    color: rgba(255,255,255,0.82);
                    font-weight: 500;
                }
                .dest-card-rating {
                    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                    font-size: 0.8rem;
                    font-weight: 700;
                    background: linear-gradient(135deg, #f6d365 0%, #d4a574 100%);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                }
                /* â”€â”€â”€ Carousel Controls â”€â”€â”€ */
                .dest-carousel-ctrl {
                    position: absolute;
                    top: 50%; transform: translateY(-50%);
                    width: 52px; height: 52px;
                    border-radius: 50%;
                    border: none;
                    cursor: pointer;
                    display: flex; align-items: center; justify-content: center;
                    background: var(--color-surface);
                    backdrop-filter: blur(16px);
                    border: 1.5px solid var(--color-border);
                    color: var(--text-main);
                    box-shadow: 0 8px 32px rgba(0,0,0,0.25);
                    z-index: 20;
                    transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
                }
                .dest-carousel-ctrl:hover {
                    background: var(--color-primary);
                    border-color: var(--color-primary);
                    color: #fff;
                    transform: translateY(-50%) scale(1.1);
                    box-shadow: 0 12px 40px rgba(0,0,0,0.35);
                }
                .dest-carousel-ctrl.prev { left: -26px; }
                .dest-carousel-ctrl.next { right: -26px; }
                /* â”€â”€â”€ Dot Indicators â”€â”€â”€ */
                .dest-carousel-dots {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    gap: 10px;
                    margin-top: 36px;
                }
                .dest-dot {
                    width: 8px; height: 8px;
                    border-radius: 50%;
                    background: var(--color-border);
                    border: none; cursor: pointer;
                    transition: all 0.35s cubic-bezier(0.23, 1, 0.32, 1);
                    padding: 0;
                }
                .dest-dot.active {
                    width: 28px;
                    border-radius: 4px;
                    background: var(--color-primary);
                }
                /* â”€â”€â”€ Responsive â”€â”€â”€ */
                @media (max-width: 1100px) {
                    .dest-card { flex: 0 0 calc(33.333% - 16px); }
                }
                @media (max-width: 768px) {
                    .dest-card { flex: 0 0 calc(50% - 12px); height: 300px; }
                    .dest-carousel-ctrl { display: none; }
                }
                @media (max-width: 480px) {
                    .dest-card { flex: 0 0 calc(100% - 0px); height: 280px; }
                }
                </style>

                <div class="container text-center mb-5" style="padding: 0 24px;">
                    <h2 class="editorial text-main mb-2" style="font-size: 3rem;">Top Trending Destinations</h2>
                    <p class="text-muted mx-auto" style="max-width: 560px; font-size: 1.05rem;">
                        The most sought-after destinations this season, curated from millions of traveller journeys.
                    </p>
                </div>



                <div class="dest-carousel-wrap" id="destCarouselWrap">
                    <!-- Prev Arrow -->
                    <button class="dest-carousel-ctrl prev" id="destPrev" aria-label="Previous destinations">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="15 18 9 12 15 6"/>
                        </svg>
                    </button>

                    <div class="dest-carousel-viewport" id="destViewport">
                        <div class="dest-carousel-track" id="destTrack">

                            <c:forEach var="dest" items="${trendingDestinations}" varStatus="status">
                                <div class="dest-card" data-index="${status.index}">
                                    <img src="${not empty dest.imageUrl ? dest.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=800&q=80'}" alt="${dest.title}">
                                    <div class="dest-card-overlay"></div>
                                    <div class="dest-card-rank">#${status.index + 1} Trending</div>
                                    <div class="dest-card-category" style="background: rgba(16,185,129,0.85);">${dest.category != null ? dest.category : 'Explore'}</div>
                                    <div class="dest-card-content">
                                        <div class="dest-card-name">${dest.title}</div>
                                        <div class="dest-card-sub" style="display: -webkit-box; -webkit-line-clamp: 1; line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;">${dest.shortDescription}</div>
                                        <div class="dest-card-meta">
                                            <div class="dest-card-price">Best Value</div>
                                            <div class="dest-card-duration">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                ${dest.durationDays} Days
                                            </div>
                                            <div class="dest-card-rating">★ ${dest.rating}</div>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/destination/details?id=${dest.id}" class="dest-card-link" style="position:absolute; inset:0; z-index:5;"></a>
                                </div>
                            </c:forEach>

                            <c:if test="${empty trendingDestinations}">
                                <div class="dest-card" style="display:flex; align-items:center; justify-content:center; background:rgba(255,255,255,0.05);">
                                    <p class="text-muted">No trending spots yet.</p>
                                </div>
                            </c:if>

                        </div><!-- /track -->
                    </div><!-- /viewport -->

                    <!-- Next Arrow -->
                    <button class="dest-carousel-ctrl next" id="destNext" aria-label="Next destinations">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="9 18 15 12 9 6"/>
                        </svg>
                    </button>
                </div><!-- /wrap -->

                <!-- Dot indicators -->
                <div class="dest-carousel-dots" id="destDots"></div>


            </section>


            <!-- ====== MUST-DO THINGS ====== -->
            <section class="section scroll-fade relative" style="padding-top: 80px;">
                <div class="container mb-5">
                    <h2 class="editorial text-main mb-1" style="font-size: 2.5rem;">Must-Do Things</h2>
                    <p class="text-muted" style="font-size: 1.1rem;">Smart curation for popular cities</p>
                </div>

                <div class="plan-scroll-outer" id="mustDoOuter">
                    <div class="plan-scroll-inner" id="mustDoInner" style="animation: none; transition: transform 0.1s linear; display: flex; gap: 24px;">
                        <c:forEach var="experience" items="${mustDoExperiences}">
                            <a href="${pageContext.request.contextPath}/experience/details?id=${experience.id}" class="glass-panel flex gap-4 p-4" style="min-width: 320px; border-radius: 16px; cursor: pointer; transition: transform 0.3s ease; text-decoration: none; display: flex;">
                                <img src="${not empty experience.coverImage ? experience.coverImage : 'https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format,compress&fit=crop&w=150&h=150&q=75'}" alt="${experience.title}" style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;" loading="lazy">
                                <div class="flex flex-col justify-center">
                                    <h4 class="font-bold text-main" style="font-size: 1.1rem;">${experience.title}</h4>
                                    <p class="text-sm text-muted">${experience.location}</p>
                                    <div class="text-primary font-bold mt-1">
                                        <c:choose>
                                            <c:when test="${experience.price > 0}">
                                                ₹<fmt:formatNumber value="${experience.price}" pattern="#,###" /> <span class="text-xs text-muted font-normal block md:inline">/ person</span>
                                            </c:when>
                                            <c:otherwise>Free</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </section>

            <!-- ====== TOP TRAVEL PLANS THEMATIC ====== -->
            <section class="section scroll-fade relative" style="padding-top: 80px;">
                <div class="container mb-5">
                    <h2 class="editorial text-main mb-1" style="font-size: 2.5rem;">Top Travel Plans</h2>
                    <p class="text-muted" style="font-size: 1.1rem;">Pre-built thematic experiences for every vibe.</p>
                </div>

                <div class="container">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6" data-skeleton="card" data-skeleton-count="3">
                        <c:forEach var="trip" items="${premiumTrips}">
                        <a href="${pageContext.request.contextPath}/trip?id=${trip.id}" class="plan-card active" style="max-width: none; flex: unset; text-decoration: none;">
                            <div class="plan-card-img-wrap" style="height: 160px;">
                                <img src="${trip.imageUrl}" alt="${trip.title}" loading="lazy">
                                <div class="plan-card-category" style="background:rgba(59,130,246,0.85);">${trip.category}</div>
                            </div>
                            <div class="plan-card-body">
                                <div class="plan-card-title">${trip.title}</div>
                                <p class="text-sm text-muted mt-2 mb-4" style="display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">${trip.shortDescription}</p>
                                <div class="plan-card-footer mt-auto">
                                    <div class="plan-price">₹<fmt:formatNumber value="${trip.priceInr}" type="number" maxFractionDigits="0"/></div>
                                    <div class="plan-duration"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg> ${trip.duration}</div>
                                </div>
                            </div>
                        </a>
                        </c:forEach>
                    </div>
                </div>
            </section>

            <!-- Destinations Grid Section -->
            <section class="section scroll-fade relative" id="destinations">
                <div class="container mb-12">
                    <div class="flex flex-col items-center text-center mb-8">
                        <h2 class="text-xs tracking-[0.2em] text-yellow-500 uppercase font-bold mb-2">Iconic Destinations</h2>
                        <h3 class="editorial text-main mb-2 text-4xl md:text-5xl lg:text-6xl text-white">Explore India's timeless wonders</h3>
                        <div class="h-[1px] w-24 bg-gradient-to-r from-transparent via-yellow-500 to-transparent mt-4"></div>
                    </div>
                    
                    <c:if test="${not empty iconicDestinations}">
                        <!-- Hero Showcase -->
                        <c:set var="heroDest" value="${iconicDestinations[0]}" />
                        <div class="iconic-hero relative overflow-hidden rounded-3xl mb-12 shadow-2xl group">
                            <img src="${heroDest.imageUrl}" alt="${heroDest.title}" class="w-full h-[600px] object-cover transition-transform duration-700 group-hover:scale-105">
                            <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent"></div>
                            
                            <div class="absolute bottom-0 left-0 p-8 md:p-16 w-full">
                                <div class="flex items-center gap-3 mb-4">
                                    <c:if test="${heroDest.reviewCount > 100}">
                                        <span class="px-3 py-1 bg-yellow-500/20 text-yellow-400 border border-yellow-500/30 rounded-full text-xs font-bold tracking-widest uppercase backdrop-blur-md">
                                            UNESCO World Heritage
                                        </span>
                                    </c:if>
                                    <span class="flex items-center gap-1 text-white font-medium">
                                        <span class="text-yellow-400">★</span> ${heroDest.rating}
                                    </span>
                                </div>
                                
                                <h3 class="text-5xl md:text-7xl font-bold text-white mb-4 editorial drop-shadow-lg">${heroDest.title}</h3>
                                <p class="text-xl text-gray-200 mb-8 max-w-2xl font-light italic">"${heroDest.shortDescription}"</p>
                                
                                <div class="flex flex-wrap gap-4">
                                    <a href="${pageContext.request.contextPath}/destination/details?id=${heroDest.id}" class="px-8 py-4 bg-white text-black rounded-full font-bold hover:bg-gray-100 transition-colors shadow-[0_0_20px_rgba(255,255,255,0.3)] no-underline">
                                        Explore ${heroDest.title}
                                    </a>
                                    <a href="${pageContext.request.contextPath}/destination/customize?id=${heroDest.id}" class="px-8 py-4 bg-transparent border border-white/30 text-white rounded-full font-bold hover:bg-white/10 backdrop-blur-sm transition-colors no-underline">
                                        Book Journey
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Thumbnail Grid -->
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                            <c:forEach var="dest" items="${iconicDestinations}" begin="1">
                                <div class="iconic-card group relative bg-black/40 border border-white/10 rounded-2xl overflow-hidden hover:border-yellow-500/50 transition-all duration-500 hover:-translate-y-2 hover:shadow-[0_10px_40px_-10px_rgba(234,179,8,0.3)] backdrop-blur-xl flex flex-col">
                                    <div class="relative h-64 overflow-hidden shrink-0">
                                        <img src="${dest.imageUrl}" alt="${dest.title}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/90 to-transparent"></div>
                                        <div class="absolute top-4 right-4 bg-black/50 backdrop-blur-md px-2 py-1 rounded border border-white/20 text-xs font-bold text-white flex items-center gap-1">
                                            <span class="text-yellow-400">★</span> ${dest.rating}
                                        </div>
                                        <c:if test="${dest.reviewCount > 100}">
                                            <div class="absolute top-4 left-4 bg-yellow-500/90 text-black px-2 py-1 rounded text-xs font-bold">
                                                UNESCO
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="p-6 relative flex-grow flex flex-col">
                                        <!-- Gold accent line -->
                                        <div class="absolute top-0 left-6 right-6 h-[1px] bg-gradient-to-r from-transparent via-yellow-500/50 to-transparent"></div>
                                        
                                        <div class="flex justify-between items-start mb-2">
                                            <div>
                                                <div class="text-xs text-yellow-500 font-bold tracking-wider uppercase mb-1">${not empty dest.startingCity ? dest.startingCity : dest.category}</div>
                                                <h4 class="text-2xl font-bold text-white editorial">${dest.title}</h4>
                                            </div>
                                            <div class="text-right">
                                                <div class="text-xs text-gray-400 mb-1">Starting from</div>
                                                <div class="text-lg font-bold text-white">₹<fmt:formatNumber value="${dest.priceInr}" type="number" maxFractionDigits="0"/></div>
                                            </div>
                                        </div>
                                        
                                        <p class="text-sm text-gray-400 mb-6 line-clamp-2 flex-grow">${dest.shortDescription}</p>
                                        
                                        <div class="grid grid-cols-2 gap-y-3 gap-x-4 mb-6 text-xs text-gray-300">
                                            <div class="flex items-center gap-2">
                                                <span class="text-yellow-500">⏱</span> ${dest.durationDays}D / ${dest.durationNights}N
                                            </div>
                                            <div class="flex items-center gap-2">
                                                <span class="text-yellow-500">🌤</span> ${not empty dest.bestSeason ? dest.bestSeason : 'All Year'}
                                            </div>
                                            <div class="flex items-center gap-2">
                                                <span class="text-yellow-500">🏷</span> ${not empty dest.category ? dest.category : 'Premium'}
                                            </div>
                                            <div class="flex items-center gap-2">
                                                <span class="text-yellow-500">👥</span> ${dest.reviewCount}+ Visitors
                                            </div>
                                        </div>
                                        
                                        <div class="flex gap-3 mt-auto">
                                            <a href="${pageContext.request.contextPath}/destination/details?id=${dest.id}" class="flex-1 py-3 px-2 text-center text-sm font-bold text-white bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-colors no-underline">
                                                Explore
                                            </a>
                                            <a href="${pageContext.request.contextPath}/destination/customize?id=${dest.id}" class="flex-1 py-3 px-2 text-center text-sm font-bold text-black bg-yellow-500 rounded-xl hover:bg-yellow-400 transition-colors shadow-[0_0_15px_rgba(234,179,8,0.2)] hover:shadow-[0_0_20px_rgba(234,179,8,0.4)] no-underline">
                                                Book Journey
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </section>

            <!-- ========== AUTO-SCROLL ITINERARIES STRIP ========== -->
            <section class="strip-section scroll-fade">
                <div class="strip-heading-wrap">
                    <div class="strip-eyebrow">Handpicked for You</div>
                    <h2 class="strip-title">Popular Itineraries</h2>
                </div>

                <div class="strip-outer" id="itinStripOuter" style="position: relative; overflow: hidden; cursor: grab; padding: 20px 0;">
                    <div class="strip-inner" id="itinStripInner" style="display: flex; gap: 30px; width: max-content; transition: none; will-change: transform;">
                        <a href="${pageContext.request.contextPath}/itinerary-details?id=Agra" class="itin-card" style="flex: 0 0 320px; text-decoration: none;">
                            <img class="itin-card-img" src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format,compress&fit=crop&w=600&q=75" alt="Agra" loading="lazy">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Agra</div>
                                <div class="itin-card-region">Uttar Pradesh</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">3 Days</span>
                                    <span class="itin-card-price">₹12,000</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/itinerary-details?id=Kerala" class="itin-card" style="flex: 0 0 320px; text-decoration: none;">
                            <img class="itin-card-img" src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format,compress&fit=crop&w=600&q=75" alt="Kerala" loading="lazy">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Kerala Backwaters</div>
                                <div class="itin-card-region">Kerala</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">5 Days</span>
                                    <span class="itin-card-price">₹18,000</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/itinerary-details?id=Jaisalmer" class="itin-card" style="flex: 0 0 320px; text-decoration: none;">
                            <img class="itin-card-img" src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format,compress&fit=crop&w=600&q=75" alt="Jaisalmer" loading="lazy">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Jaisalmer Fort</div>
                                <div class="itin-card-region">Rajasthan</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹15,000</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/itinerary-details?id=Varanasi" class="itin-card" style="flex: 0 0 320px; text-decoration: none;">
                            <img class="itin-card-img" src="https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format,compress&fit=crop&w=600&q=75" alt="Varanasi" loading="lazy">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Varanasi Ghats</div>
                                <div class="itin-card-region">Uttar Pradesh</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">3 Days</span>
                                    <span class="itin-card-price">₹10,500</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </section>



        <!-- ===== INTELLIGENT SEARCH MODAL ===== -->
        <div id="intelligentSearchModal" class="search-dropdown hidden">
            <div class="dropdown-header">
                <input type="text" id="intelligentSearchInput" class="search-dropdown-input" placeholder="Search city or airport..." autocomplete="off">
            </div>
            <div class="dropdown-body">
                <!-- Recent searches section -->
                <div id="searchRecentSection" class="dropdown-section hidden">
                    <div class="section-title">Recent Searches</div>
                    <ul class="suggestion-list" id="searchRecentList"></ul>
                </div>
                <!-- Popular destinations section -->
                <div id="searchPopularSection" class="dropdown-section">
                    <div class="section-title">Popular Destinations</div>
                    <ul class="suggestion-list" id="searchPopularList"></ul>
                </div>
                <!-- Auto-suggestions (Filtered) -->
                <div id="searchSuggestionsSection" class="dropdown-section hidden">
                    <ul class="suggestion-list" id="searchSuggestionsList"></ul>
                </div>
            </div>
        </div>


        <!-- ====== RECOMMENDED HOTELS ====== -->
        <c:if test="${not empty recommendedHotels}">
            <section class="section scroll-fade relative" style="padding-top: 80px;">
                <div class="container mb-5">
                    <h2 class="editorial text-main mb-1" style="font-size: 2.5rem;">Recommended Stays</h2>
                    <p class="text-muted" style="font-size: 1.1rem;">Handpicked personalized suggestions based on your search history.</p>
                </div>
                <div class="container">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                        <c:forEach var="hotel" items="${recommendedHotels}" end="3">
                            <a href="${pageContext.request.contextPath}/hotel/details?id=${hotel.id}" class="plan-card" style="max-width: none; flex: unset;">
                                <div class="plan-card-img-wrap" style="height: 160px;">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(hotel.imageUrl, 'http')}">
                                            <img src="${hotel.imageUrl}" alt="${hotel.name}" loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${hotel.imageUrl}" alt="${hotel.name}" loading="lazy">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="plan-card-category" style="background:rgba(139,92,246,0.85);">Recommended</div>
                                </div>
                                <div class="plan-card-body p-4">
                                    <div class="plan-card-title text-lg font-bold truncate">${hotel.name}</div>
                                    <div class="text-sm text-gray-500 mb-2"><i class="fas fa-map-marker-alt text-primary"></i> ${hotel.city}</div>
                                    <div class="flex items-center gap-1 mb-2">
                                        <i class="fas fa-star text-accent text-xs"></i><span class="text-sm font-bold">${hotel.rating}</span>
                                    </div>
                                    <div class="plan-card-footer mt-auto pt-3 border-t border-gray-100 dark:border-gray-800">
                                        <div class="plan-price text-lg font-bold">₹<fmt:formatNumber value="${hotel.startingPrice}" type="number" maxFractionDigits="0" /></div>
                                        <div class="plan-duration text-xs text-gray-500">per night</div>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </section>
        </c:if>

        <!-- ====== RECENTLY VIEWED HOTELS ====== -->
        <c:if test="${not empty recentlyViewedHotels}">
            <section class="section scroll-fade relative" style="padding-top: 80px;">
                <div class="container mb-5">
                    <h2 class="editorial text-main mb-1" style="font-size: 2.5rem;">Recently Viewed</h2>
                    <p class="text-muted" style="font-size: 1.1rem;">Pick up where you left off.</p>
                </div>
                <div class="container">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                        <c:forEach var="hotel" items="${recentlyViewedHotels}" end="3">
                            <a href="${pageContext.request.contextPath}/hotel/details?id=${hotel.id}" class="plan-card" style="max-width: none; flex: unset;">
                                <div class="plan-card-img-wrap" style="height: 160px;">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(hotel.imageUrl, 'http')}">
                                            <img src="${hotel.imageUrl}" alt="${hotel.name}" loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${hotel.imageUrl}" alt="${hotel.name}" loading="lazy">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="plan-card-body p-4">
                                    <div class="plan-card-title text-lg font-bold truncate">${hotel.name}</div>
                                    <div class="text-sm text-gray-500 mb-2"><i class="fas fa-map-marker-alt text-primary"></i> ${hotel.city}</div>
                                    <div class="plan-card-footer mt-auto pt-3 border-t border-gray-100 dark:border-gray-800">
                                        <div class="plan-price text-lg font-bold">₹<fmt:formatNumber value="${hotel.startingPrice}" type="number" maxFractionDigits="0" /></div>
                                        <div class="plan-duration text-xs text-gray-500">per night</div>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </section>
        </c:if>

        <!-- ====== TRAVEL PARTNERS MARQUEE ====== -->
        <section class="scroll-fade" style="padding: 60px 0; overflow: hidden;">
            <div class="container text-center mb-4">
                <p class="text-muted text-sm uppercase tracking-widest fw-bold" style="letter-spacing:0.15em;">Trusted By Leading Travel Brands</p>
            </div>
            <div id="partnersOuter" style="overflow:hidden;position:relative;padding:20px 0;">
                <div id="partnersTrack" style="display:flex;gap:60px;width:max-content;will-change:transform;transition:transform 0.1s linear;">
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">✈️</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">Air India</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🏨</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">Taj Hotels</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🚂</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">IRCTC</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🛫</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">IndiGo</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🏖️</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">Club Mahindra</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🌍</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">MakeMyTrip</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🏔️</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">Thomas Cook</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">⛵</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">Cordelia Cruises</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">✨</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">ITC Hotels</span></div>
                    <div class="partner-logo" style="display:flex;align-items:center;gap:10px;min-width:160px;opacity:0.5;transition:opacity 0.3s;"><span style="font-size:1.6rem;">🛩️</span><span class="text-muted fw-bold" style="font-size:1rem;white-space:nowrap;">Vistara</span></div>
                </div>
            </div>
        </section>

        <!-- ====== TESTIMONIALS AUTO-SCROLL ====== -->
        <section class="scroll-fade testimonials-section" style="padding:60px 0 80px;overflow:hidden;">
            <div class="container text-center mb-5">
                <h2 class="editorial text-main mb-2" style="font-size:2.5rem;">What Our Travelers Say</h2>
                <p class="text-muted" style="font-size:1rem;">Real stories from real adventurers.</p>
            </div>
            <div id="testiOuter" style="overflow:hidden;position:relative;cursor:grab;">
                <div id="testiTrack" style="display:flex;gap:24px;width:max-content;will-change:transform;transition:transform 0.1s linear;">
                    <!-- Set 1 -->
                    <div class="testimonial-card glass-panel p-4" style="min-width:340px;max-width:340px;border-radius:16px;">
                        <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                        <p class="text-main fw-bold text-sm mb-2">"Life-changing experience!"</p>
                        <p class="text-muted text-xs italic mb-3">"The Kashmir trip was beyond anything I imagined. The houseboat stay on Dal Lake with snow-capped mountains... absolutely magical."</p>
                        <div class="flex items-center gap-2"><div style="width:32px;height:32px;border-radius:50%;background:var(--color-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.65rem;font-weight:700;">PR</div><div><span class="text-xs fw-bold">Priya R.</span><div class="text-muted" style="font-size:0.65rem;">Kashmir Trip • Jan 2026</div></div></div>
                    </div>
                    <div class="testimonial-card glass-panel p-4" style="min-width:340px;max-width:340px;border-radius:16px;">
                        <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                        <p class="text-main fw-bold text-sm mb-2">"Perfect honeymoon!"</p>
                        <p class="text-muted text-xs italic mb-3">"Voyastra made our Maldives honeymoon stress-free. The overwater villa, private dinner on the sandbank — every detail was perfect."</p>
                        <div class="flex items-center gap-2"><div style="width:32px;height:32px;border-radius:50%;background:var(--color-accent);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.65rem;font-weight:700;">AM</div><div><span class="text-xs fw-bold">Arjun M.</span><div class="text-muted" style="font-size:0.65rem;">Maldives Trip • Dec 2025</div></div></div>
                    </div>
                    <div class="testimonial-card glass-panel p-4" style="min-width:340px;max-width:340px;border-radius:16px;">
                        <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                        <p class="text-main fw-bold text-sm mb-2">"Best family vacation ever!"</p>
                        <p class="text-muted text-xs italic mb-3">"Took the kids to Kerala backwaters. The houseboat ride, elephant sanctuary, and tea garden visit — they still talk about it daily!"</p>
                        <div class="flex items-center gap-2"><div style="width:32px;height:32px;border-radius:50%;background:var(--color-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.65rem;font-weight:700;">SG</div><div><span class="text-xs fw-bold">Sunita G.</span><div class="text-muted" style="font-size:0.65rem;">Kerala Trip • Feb 2026</div></div></div>
                    </div>
                    <div class="testimonial-card glass-panel p-4" style="min-width:340px;max-width:340px;border-radius:16px;">
                        <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                        <p class="text-main fw-bold text-sm mb-2">"Adventure of a lifetime!"</p>
                        <p class="text-muted text-xs italic mb-3">"The Ladakh road trip was incredible. Khardung La, Pangong Lake, camping under stars — Voyastra's planning made it seamless."</p>
                        <div class="flex items-center gap-2"><div style="width:32px;height:32px;border-radius:50%;background:var(--color-accent);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.65rem;font-weight:700;">RK</div><div><span class="text-xs fw-bold">Rohan K.</span><div class="text-muted" style="font-size:0.65rem;">Ladakh Trip • Mar 2026</div></div></div>
                    </div>
                    <div class="testimonial-card glass-panel p-4" style="min-width:340px;max-width:340px;border-radius:16px;">
                        <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                        <p class="text-main fw-bold text-sm mb-2">"Luxury redefined!"</p>
                        <p class="text-muted text-xs italic mb-3">"The Rajasthan heritage tour was royal in every sense. Palace stays, desert safaris, folk dance evenings — felt like actual royalty."</p>
                        <div class="flex items-center gap-2"><div style="width:32px;height:32px;border-radius:50%;background:var(--color-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.65rem;font-weight:700;">NK</div><div><span class="text-xs fw-bold">Neha K.</span><div class="text-muted" style="font-size:0.65rem;">Rajasthan Trip • Jan 2026</div></div></div>
                    </div>
                    <div class="testimonial-card glass-panel p-4" style="min-width:340px;max-width:340px;border-radius:16px;">
                        <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                        <p class="text-main fw-bold text-sm mb-2">"Solo trip made easy!"</p>
                        <p class="text-muted text-xs italic mb-3">"As a solo female traveler, safety was my priority. Voyastra's guides and hotels were exceptional. Bali was a dream come true."</p>
                        <div class="flex items-center gap-2"><div style="width:32px;height:32px;border-radius:50%;background:var(--color-accent);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.65rem;font-weight:700;">DD</div><div><span class="text-xs fw-bold">Divya D.</span><div class="text-muted" style="font-size:0.65rem;">Bali Trip • Nov 2025</div></div></div>
                    </div>
                </div>
            </div>
        </section>

        </main>

        <script src="${pageContext.request.contextPath}/assets/js/home_dynamic.js"></script>
        <%@ include file="/components/footer.jsp" %>

