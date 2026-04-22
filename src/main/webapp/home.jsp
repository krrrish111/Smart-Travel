<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

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
                            Experience <br>
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
                                    <!-- Duplicate first for seamless loop reset -->
                                    <div class="rotator-word text-outline">Taj Mahal, Agra</div>
                                </div>
                            </div>
                        </h1>

                        <p class="mb-4 mx-auto"
                            style="color: var(--text-on-img); font-size: 1.25rem; text-shadow: 0 2px 15px rgba(0,0,0,0.7); opacity: 0.95; max-width: 800px;">
                            Say goodbye to endless research. Our intelligent platform crafts hyper-personalized
                            itineraries, seamlessly balancing iconic landmarks with undiscovered cultural treasures.
                        </p>
                        <div class="flex gap-3 justify-center items-center mb-5">
                            <a href="planner.jsp" id="heroPlanBtn" class="btn btn-primary tilt-card"
                                style="padding: 14px 28px; font-size: 1.1rem; box-shadow: var(--shadow-lg);"
                                onclick="event.preventDefault(); VoyastraAuth.requireAuth('planner.jsp');">
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

            <!-- ====== BOOKING SECTION ====== -->
            <div class="container relative" style="margin-top: -10px;">

                <!-- Booking Search Panel -->
                <div class="booking-panel glass-panel relative"
                    style="border-radius: 16px; padding: 32px; box-shadow: var(--shadow-lg); transition: all 0.3s ease; margin-bottom: 80px; z-index: 10;">

                    <!-- Flights Form -->
                    <div id="tab-flights" class="booking-tab active" style="animation: fadeUp 0.4s ease forwards;">
                        <div class="flex items-center gap-6 mb-6">
                            <label class="radio-label"><input type="radio" name="tripType" value="one-way" checked> One
                                Way</label>
                            <label class="radio-label"><input type="radio" name="tripType" value="round-trip"> Round
                                Trip</label>
                            <label class="radio-label"><input type="radio" name="tripType" value="multi-city">
                                Multi-City</label>
                        </div>
                        <div class="search-fields-row mt-2">
                            <div class="search-field" style="flex: 1.5;">
                                <div class="field-label">From</div>
                                <div class="field-value">Delhi</div>
                                <div class="field-sub">DEL, Indira Gandhi Intl</div>
                            </div>
                            
                            <!-- Swap Button -->
                            <div class="swap-btn" title="Swap">â‡„</div>
                            
                            <div class="search-field" style="flex: 1.5;">
                                <div class="field-label">To</div>
                                <div class="field-value">Mumbai</div>
                                <div class="field-sub">BOM, Chhatrapati Shivaji Intl</div>
                            </div>
                            
                            <div class="search-field">
                                <div class="field-label">Departure <span class="text-primary float-right" style="font-size:0.6rem; margin-top:1px;">+ Return</span></div>
                                <div class="field-value">10 Apr <span style="font-size:1rem; font-weight:600;">'26</span></div>
                                <div class="field-sub">Friday</div>
                            </div>
                            
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">Travellers & Class</div>
                                <div class="field-value">2 Adults</div>
                                <div class="field-sub">Economy / Premium</div>
                            </div>
                            
                            <button class="search-cta-btn">Search Flights →</button>
                        </div>
                    </div>

                    <!-- Hotels Form (Hidden by default) -->
                    <div id="tab-hotels" class="booking-tab"
                        style="display: none; animation: fadeUp 0.4s ease forwards;">
                        <div class="flex items-center gap-6 mb-6">
                            <label class="radio-label"><input type="radio" name="hotelType" value="up-to-4" checked>
                                Upto 4 Rooms</label>
                            <label class="radio-label"><input type="radio" name="hotelType" value="group"> Group
                                Booking</label>
                        </div>
                        <div class="search-fields-row mt-2">
                            <div class="search-field" style="flex: 2;">
                                <div class="field-label">City, Property Name Or Location</div>
                                <div class="field-value">Udaipur</div>
                                <div class="field-sub">Rajasthan, India</div>
                            </div>
                            
                            <div class="search-field" style="flex: 1.5;">
                                <div class="field-label">Check-In <span class="mx-2 opacity-50 text-xs">to</span> Check-Out</div>
                                <div class="field-value">10 Apr - 14 Apr</div>
                                <div class="field-sub">4 Nights</div>
                            </div>
                            
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">Rooms & Guests</div>
                                <div class="field-value">1 Room</div>
                                <div class="field-sub">2 Adults</div>
                            </div>
                            
                            <button class="search-cta-btn">Search Hotels →</button>
                        </div>
                    </div>

                    <!-- Trains Form (Hidden by default) -->
                    <div id="tab-trains" class="booking-tab"
                        style="display: none; animation: fadeUp 0.4s ease forwards;">
                        <div class="search-fields-row mt-2">
                            <div class="search-field" style="flex: 1.5;">
                                <div class="field-label">From</div>
                                <div class="field-value">NDLS</div>
                                <div class="field-sub">New Delhi Railway Station</div>
                            </div>
                            
                            <!-- Swap Button -->
                            <div class="swap-btn" title="Swap">â‡„</div>
                            
                            <div class="search-field" style="flex: 1.5;">
                                <div class="field-label">To</div>
                                <div class="field-value">BCT</div>
                                <div class="field-sub">Mumbai Central</div>
                            </div>
                            
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">Travel Date</div>
                                <div class="field-value">12 Apr <span style="font-size:1rem; font-weight:600;">'26</span></div>
                                <div class="field-sub">Sunday</div>
                            </div>
                            
                            <button class="search-cta-btn">Search Trains →</button>
                        </div>
                    </div>

                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    const tabs = document.querySelectorAll('.sec-nav-item');
                    const contents = document.querySelectorAll('.booking-tab');

                    tabs.forEach(tab => {
                        tab.addEventListener('click', () => {
                            const targetId = 'tab-' + tab.getAttribute('data-tab');
                            const targetElem = document.getElementById(targetId);

                            if (targetElem) {
                                // Remove active class from all tabs
                                tabs.forEach(t => t.classList.remove('active'));
                                tab.classList.add('active');

                                // Hide all contents
                                contents.forEach(c => c.style.display = 'none');
                                // Show target
                                targetElem.style.display = 'block';
                            } else {
                                // Fallback purely visual for missing tabs in prototype
                                tabs.forEach(t => t.classList.remove('active'));
                                tab.classList.add('active');
                            }
                        });
                    });
                });
            </script>

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
                                            <div class="plan-itinerary-step">${trip.shortDescription}</div>
                                        </div>
                                        <div class="plan-card-footer">
                                            <div class="plan-price">₹<fmt:formatNumber value="${trip.discountPrice}" type="number" maxFractionDigits="0" /></div>
                                            <div class="plan-duration">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg> 
                                                ${trip.duration}
                                            </div>
                                        </div>
                                        <a href="trip?slug=${trip.slug}" class="plan-card-view-btn">View Plan &rarr;</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <style>
                    /* ── Premium Carousel Styles ── */
                    .carousel-viewport-wrapper {
                        position: relative;
                        width: 100%;
                        margin-top: 40px;
                        padding: 0 40px; /* Space for arrows if they aren't floating */
                    }

                    .plan-carousel-outer {
                        overflow: hidden;
                        cursor: grab;
                        position: relative;
                        -webkit-user-select: none;
                        user-select: none;
                    }

                    .plan-carousel-outer:active { cursor: grabbing; }

                    .plan-carousel-track {
                        display: flex;
                        gap: 32px;
                        width: max-content;
                        will-change: transform;
                        /* CRITICAL: Disable transitions during JS-driven animation to prevent stutter/static look */
                        transition: none !important;
                    }

                    /* Fade edges for luxury feel */
                    .carousel-edge-fade {
                        position: absolute;
                        top: 0;
                        bottom: 0;
                        width: 120px;
                        z-index: 5;
                        pointer-events: none;
                        display: none; /* Desktop only usually */
                    }
                    @media (min-width: 1024px) {
                        .carousel-edge-fade { display: block; }
                        .carousel-edge-fade.left { left: 0; background: linear-gradient(to right, var(--bg-base) 0%, transparent 100%); }
                        .carousel-edge-fade.right { right: 0; background: linear-gradient(to left, var(--bg-base) 0%, transparent 100%); }
                    }

                    /* Navigation Buttons */
                    .carousel-nav-btn {
                        position: absolute;
                        top: 50%;
                        transform: translateY(-50%);
                        width: 48px;
                        height: 48px;
                        border-radius: 50%;
                        background: var(--surface-glass);
                        border: 1px solid var(--color-border);
                        color: var(--color-primary);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 10;
                        cursor: pointer;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        backdrop-filter: blur(8px);
                    }
                    .carousel-nav-btn:hover {
                        background: var(--color-primary);
                        color: #fff;
                        border-color: var(--color-primary);
                        box-shadow: 0 0 20px rgba(212, 165, 116, 0.4);
                    }
                    .carousel-nav-btn.prev { left: -10px; }
                    .carousel-nav-btn.next { right: -10px; }

                    /* Card Enhancements */
                    .plan-card {
                        transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.4s ease !important;
                    }
                    .plan-card:hover {
                        transform: scale(1.04) translateY(-10px) !important;
                        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 15px rgba(212, 165, 116, 0.2);
                        z-index: 10;
                    }
                    
                    /* Gold Category Badge */
                    .plan-card-category {
                        position: absolute;
                        top: 15px; right: 15px;
                        background: rgba(212, 165, 116, 0.9);
                        color: #fff;
                        padding: 4px 14px;
                        border-radius: 20px;
                        font-size: 0.75rem;
                        font-weight: 700;
                        backdrop-filter: blur(4px);
                        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                    }

                    /* Responsive Adjustments */
                    @media (max-width: 768px) {
                        .carousel-viewport-wrapper { padding: 0 10px; }
                        .carousel-nav-btn { display: none; }
                        .plan-carousel-track { gap: 16px; }
                    }
                </style>

                <script>
                    /**
                     * VOYASTRA INDUSTRIAL CAROUSEL ENGINE v4
                     * Rebuilt for absolute reliability and performance.
                     */
                    (function() {
                        let carouselInited = false;

                        const runCarousel = () => {
                            if (carouselInited) return;
                            
                            const outer = document.getElementById('planCarouselOuter');
                            const track = document.getElementById('planCarouselTrack');
                            const prevBtn = document.getElementById('planPrevBtn');
                            const nextBtn = document.getElementById('planNextBtn');

                            if (!outer || !track) return;

                            // 1. DYNAMIC PREPARATION
                            const originalCards = Array.from(track.querySelectorAll('.plan-card'));
                            if (originalCards.length < 1) return;

                            // Clone strategy: 3 sets (A, B, C)
                            track.innerHTML = '';
                            const createSet = () => {
                                originalCards.forEach(card => {
                                    const clone = card.cloneNode(true);
                                    // Remove any IDs to prevent duplicates
                                    clone.removeAttribute('id');
                                    track.appendChild(clone);
                                });
                            };

                            createSet(); // A
                            createSet(); // B
                            createSet(); // C

                            carouselInited = true;

                            // 2. DIMENSIONS & STATE
                            let setWidth = 0;
                            let currentX = 0;
                            let isPaused = false;
                            let isDragging = false;
                            let startX = 0;
                            let baseScrollLeft = 0;
                            let animationId = null;
                            const autoSpeed = 0.85; // Elegant travel-brand speed

                            const updateDimensions = () => {
                                // Calculate width of exactly one set including gaps
                                // We use the offset of the first card in Set B minus first card in Set A
                                const allCards = track.children;
                                const setSize = originalCards.length;
                                if (allCards.length >= setSize * 2) {
                                    setWidth = allCards[setSize].offsetLeft - allCards[0].offsetLeft;
                                } else {
                                    // Fallback if layout is weird
                                    setWidth = track.scrollWidth / 3;
                                }
                                
                                // Reset to start of Set B if currentX is 0 or out of bounds
                                if (currentX === 0) {
                                    currentX = -setWidth;
                                }
                            };

                            // Initial calculation
                            updateDimensions();
                            track.style.transform = `translateX(${currentX}px)`;

                            // 3. ANIMATION LOOP
                            const step = () => {
                                if (!isPaused && !isDragging) {
                                    currentX -= autoSpeed;

                                    // Seamless Reset Logic
                                    // If we go past Set B into C
                                    if (currentX <= -(setWidth * 2)) {
                                        currentX += setWidth;
                                    }
                                    // If we drag back into A
                                    if (currentX >= 0) {
                                        currentX -= setWidth;
                                    }

                                    track.style.transform = `translateX(${currentX}px)`;
                                }
                                animationId = requestAnimationFrame(step);
                            };

                            // 4. INTERACTION HANDLERS
                            const onDragStart = (e) => {
                                isDragging = true;
                                outer.classList.add('is-dragging');
                                startX = (e.pageX || e.touches[0].pageX);
                                baseScrollLeft = currentX;
                                track.style.transition = 'none'; 
                            };

                            const onDragMove = (e) => {
                                if (!isDragging) return;
                                const x = (e.pageX || e.touches[0].pageX);
                                const walk = x - startX;
                                currentX = baseScrollLeft + walk;

                                // Boundary check during drag
                                if (currentX <= -(setWidth * 2)) currentX += setWidth;
                                if (currentX >= 0) currentX -= setWidth;

                                track.style.transform = `translateX(${currentX}px)`;
                            };

                            const onDragEnd = () => {
                                if (!isDragging) return;
                                isDragging = false;
                                outer.classList.remove('is-dragging');
                                snapToNearest();
                            };

                            const snapToNearest = () => {
                                const cardWidth = (track.children[1].offsetLeft - track.children[0].offsetLeft);
                                const nearestIdx = Math.round(currentX / cardWidth);
                                currentX = nearestIdx * cardWidth;
                                
                                track.style.transition = 'transform 0.6s cubic-bezier(0.16, 1, 0.3, 1)';
                                track.style.transform = `translateX(${currentX}px)`;
                                
                                setTimeout(() => {
                                    track.style.transition = 'none';
                                }, 600);
                            };

                            const manualNav = (dir) => {
                                const cardWidth = (track.children[1].offsetLeft - track.children[0].offsetLeft);
                                const jump = cardWidth * 2;
                                currentX += (dir === 'next' ? -jump : jump);
                                
                                track.style.transition = 'transform 0.7s cubic-bezier(0.16, 1, 0.3, 1)';
                                track.style.transform = `translateX(${currentX}px)`;
                                
                                setTimeout(() => {
                                    track.style.transition = 'none';
                                    if (currentX <= -(setWidth * 2)) currentX += setWidth;
                                    if (currentX >= 0) currentX -= setWidth;
                                }, 700);
                            };

                            // 5. EVENT LISTENERS
                            outer.addEventListener('mousedown', onDragStart);
                            outer.addEventListener('touchstart', onDragStart, {passive: true});
                            
                            window.addEventListener('mousemove', onDragMove);
                            outer.addEventListener('touchmove', onDragMove, {passive: true});
                            
                            window.addEventListener('mouseup', onDragEnd);
                            window.addEventListener('touchend', onDragEnd);

                            outer.addEventListener('mouseenter', () => isPaused = true);
                            outer.addEventListener('mouseleave', () => isPaused = false);

                            if (prevBtn) prevBtn.addEventListener('click', () => manualNav('prev'));
                            if (nextBtn) nextBtn.addEventListener('click', () => manualNav('next'));

                            window.addEventListener('resize', () => {
                                updateDimensions();
                            });

                            // 6. KICKSTART
                            // Force a reflow before starting
                            track.offsetHeight; 
                            animationId = requestAnimationFrame(step);
                        };

                        // Robust Lifecycle Hooks
                        if (document.readyState === 'complete') {
                            setTimeout(runCarousel, 100);
                        } else {
                            window.addEventListener('load', () => setTimeout(runCarousel, 100));
                        }
                    })();
                </script>
            </section>
            </section>
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

                            <c:forEach var="dest" items="${featuredDestinations}" varStatus="status">
                                <div class="dest-card" data-index="${status.index}">
                                    <img src="${not empty dest.imageUrl ? dest.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=800&q=80'}" alt="${dest.name}">
                                    <div class="dest-card-overlay"></div>
                                    <div class="dest-card-rank">#${status.index + 1} Trending</div>
                                    <div class="dest-card-category" style="background: rgba(16,185,129,0.85);">Explore</div>
                                    <div class="dest-card-content">
                                        <div class="dest-card-name">${dest.name}</div>
                                        <div class="dest-card-sub" style="display: -webkit-box; -webkit-line-clamp: 1; line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;">${dest.description}</div>
                                        <div class="dest-card-meta">
                                            <div class="dest-card-price">Best Value</div>
                                            <div class="dest-card-duration">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                Dynamic
                                            </div>
                                            <div class="dest-card-rating">â˜… 4.9</div>
                                        </div>
                                    </div>
                                    <a href="destination?id=${dest.id}" class="dest-card-link" style="position:absolute; inset:0; z-index:5;"></a>
                                </div>
                            </c:forEach>

                            <c:if test="${empty featuredDestinations}">
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

                <script>
                (function () {
                    'use strict';

                    /* â”€â”€ Config â”€â”€ */
                    var AUTO_DELAY   = 4000;   // ms between auto-slides
                    var TRANSITION   = 600;    // ms CSS transition duration

                    /* â”€â”€ DOM â”€â”€ */
                    var track    = document.getElementById('destTrack');
                    var viewport = document.getElementById('destViewport');
                    var prevBtn  = document.getElementById('destPrev');
                    var nextBtn  = document.getElementById('destNext');
                    var dotsEl   = document.getElementById('destDots');
                    var wrap     = document.getElementById('destCarouselWrap');

                    if (!track || !viewport) return;

                    /* â”€â”€ Determine cards-per-view â”€â”€ */
                    function getPerView() {
                        var w = window.innerWidth;
                        if (w >= 1100) return 4;
                        if (w >= 768)  return 3;
                        if (w >= 480)  return 2;
                        return 1;
                    }

                    /* â”€â”€ State â”€â”€ */
                    var cards       = Array.prototype.slice.call(track.querySelectorAll('.dest-card'));
                    var totalCards  = cards.length;
                    var perView     = getPerView();
                    var current     = 0;       // logical index into original cards
                    var isAnimating = false;
                    var autoTimer   = null;
                    var clonesBefore, clonesAfter;

                    /* â”€â”€ Build infinite clone track â”€â”€ */
                    function buildTrack() {
                        perView = getPerView();

                        /* Remove old clones */
                        track.querySelectorAll('.dest-card-clone').forEach(function (el) { el.remove(); });

                        /* Clone a full set before and after */
                        clonesBefore = totalCards;
                        clonesAfter  = totalCards;

                        var frag = document.createDocumentFragment();
                        cards.forEach(function (c) {
                            var cl = c.cloneNode(true);
                            cl.classList.add('dest-card-clone');
                            frag.appendChild(cl);
                        });
                        track.insertBefore(frag, track.firstChild);   // clones BEFORE

                        var frag2 = document.createDocumentFragment();
                        cards.forEach(function (c) {
                            var cl = c.cloneNode(true);
                            cl.classList.add('dest-card-clone');
                            frag2.appendChild(cl);
                        });
                        track.appendChild(frag2);                       // clones AFTER

                        /* Attach 3D tilt to all cards in track */
                        Array.prototype.slice.call(track.querySelectorAll('.dest-card')).forEach(attach3D);

                        /* Jump to real position silently */
                        jumpTo(current, false);
                    }

                    /* â”€â”€ Card width + gap â”€â”€ */
                    function cardWidth() {
                        var allCards = track.querySelectorAll('.dest-card');
                        if (!allCards.length) return 0;
                        var style = getComputedStyle(track);
                        var gap = parseFloat(style.gap) || 24;
                        return allCards[0].offsetWidth + gap;
                    }

                    /* â”€â”€ Translate to position (logical index) â”€â”€ */
                    function jumpTo(idx, animate) {
                        var cw         = cardWidth();
                        var realIdx    = idx + clonesBefore;   // offset by prepended clones
                        var translateX = -realIdx * cw;

                        track.style.transition = animate
                            ? 'transform ' + TRANSITION + 'ms cubic-bezier(0.25,0.46,0.45,0.94)'
                            : 'none';
                        track.style.transform = 'translateX(' + translateX + 'px)';
                    }

                    /* â”€â”€ Infinite-loop bounce fix after transition ends â”€â”€ */
                    function onTransitionEnd() {
                        isAnimating = false;
                        if (current < 0) {
                            current += totalCards;
                            jumpTo(current, false);
                        } else if (current >= totalCards) {
                            current -= totalCards;
                            jumpTo(current, false);
                        }
                        updateDots();
                    }
                    track.addEventListener('transitionend', onTransitionEnd);

                    /* â”€â”€ Go to card â”€â”€ */
                    function goTo(idx, animate) {
                        if (animate && isAnimating) return;
                        if (animate) isAnimating = true;
                        current = idx;
                        jumpTo(current, animate !== false);
                        if (!animate) updateDots();
                    }

                    function goNext() {
                        goTo(current + 1, true);
                        resetAuto();
                    }
                    function goPrev() {
                        goTo(current - 1, true);
                        resetAuto();
                    }

                    /* â”€â”€ Dots â”€â”€ */
                    function buildDots() {
                        dotsEl.innerHTML = '';
                        var pages = Math.ceil(totalCards / perView);
                        for (var i = 0; i < pages; i++) {
                            (function (idx) {
                                var btn = document.createElement('button');
                                btn.className = 'dest-dot' + (idx === 0 ? ' active' : '');
                                btn.setAttribute('aria-label', 'Go to slide ' + (idx + 1));
                                btn.addEventListener('click', function () {
                                    goTo(idx * perView, true);
                                    resetAuto();
                                });
                                dotsEl.appendChild(btn);
                            })(i);
                        }
                    }

                    function updateDots() {
                        var idx = ((current % totalCards) + totalCards) % totalCards;
                        var activePage = Math.floor(idx / perView);
                        Array.prototype.slice.call(dotsEl.querySelectorAll('.dest-dot')).forEach(function (d, i) {
                            d.classList.toggle('active', i === activePage);
                        });
                    }

                    /* â”€â”€ Auto rotation â”€â”€ */
                    function startAuto() {
                        autoTimer = setInterval(goNext, AUTO_DELAY);
                    }
                    function stopAuto() {
                        clearInterval(autoTimer);
                    }
                    function resetAuto() {
                        stopAuto();
                        startAuto();
                    }

                    /* â”€â”€ Pause on hover â”€â”€ */
                    wrap.addEventListener('mouseenter', stopAuto);
                    wrap.addEventListener('mouseleave', startAuto);

                    /* â”€â”€ Arrow controls â”€â”€ */
                    prevBtn && prevBtn.addEventListener('click', goPrev);
                    nextBtn && nextBtn.addEventListener('click', goNext);

                    /* â”€â”€ Touch/swipe support â”€â”€ */
                    var touchStartX = 0;
                    viewport.addEventListener('touchstart', function (e) {
                        touchStartX = e.touches[0].clientX;
                        stopAuto();
                    }, { passive: true });
                    viewport.addEventListener('touchend', function (e) {
                        var dx = e.changedTouches[0].clientX - touchStartX;
                        if (Math.abs(dx) > 40) {
                            dx < 0 ? goNext() : goPrev();
                        }
                        startAuto();
                    }, { passive: true });

                    /* â”€â”€ 3D Tilt effect â”€â”€ */
                    function attach3D(card) {
                        card.addEventListener('mousemove', function (e) {
                            var rect   = card.getBoundingClientRect();
                            var cx     = rect.left + rect.width / 2;
                            var cy     = rect.top  + rect.height / 2;
                            var dx     = (e.clientX - cx) / (rect.width  / 2);  // -1 ”¦ 1
                            var dy     = (e.clientY - cy) / (rect.height / 2);  // -1 ”¦ 1
                            var rotY   =  dx * 10;   // max Â±10Â°
                            var rotX   = -dy *  7;   // max  Â±7Â°
                            card.style.transform =
                                'perspective(1000px) rotateX(' + rotX + 'deg) rotateY(' + rotY + 'deg) scale(1.04)';
                        });
                        card.addEventListener('mouseleave', function () {
                            card.style.transform =
                                'perspective(1000px) rotateX(0deg) rotateY(0deg) scale(1)';
                        });
                    }

                    /* â”€â”€ Resize handler â”€â”€ */
                    var resizeTimer;
                    window.addEventListener('resize', function () {
                        clearTimeout(resizeTimer);
                        resizeTimer = setTimeout(function () {
                            stopAuto();
                            buildTrack();
                            buildDots();
                            startAuto();
                        }, 180);
                    });

                    /* â”€â”€ Init â”€â”€ */
                    buildTrack();
                    buildDots();
                    startAuto();

                })();
                </script>

            </section>


            <!-- ====== MUST-DO THINGS ====== -->
            <section class="section scroll-fade relative" style="padding-top: 80px;">
                <div class="container mb-5">
                    <h2 class="editorial text-main mb-1" style="font-size: 2.5rem;">Must-Do Things</h2>
                    <p class="text-muted" style="font-size: 1.1rem;">Smart curation for popular cities</p>
                </div>

                <div class="plan-scroll-outer" id="mustDoOuter">
                    <div class="plan-scroll-inner" id="mustDoInner" style="animation: none; transition: transform 0.1s linear;">
                        <!-- Activity 1 -->
                        <div class="glass-panel flex gap-4 p-4 active"
                            style="min-width: 320px; border-radius: 16px; cursor: pointer; transition: transform 0.3s ease;">
                            <img src="https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format&fit=crop&w=150&h=150&q=80"
                                alt="Rafting"
                                style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;">
                            <div class="flex flex-col justify-center">
                                <h4 class="font-bold text-main" style="font-size: 1.1rem;">River Rafting</h4>
                                <p class="text-sm text-muted">Rishikesh, Uttarakhand</p>
                                <div class="text-primary font-bold mt-1">₹1,500 <span
                                        class="text-xs text-muted font-normal block md:inline">/ person</span></div>
                            </div>
                        </div>
                        <!-- Activity 2 -->
                        <div class="glass-panel flex gap-4 p-4"
                            style="min-width: 320px; border-radius: 16px; cursor: pointer; transition: transform 0.3s ease;">
                            <img src="https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format&fit=crop&w=150&h=150&q=80"
                                alt="Ganga Aarti"
                                style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;">
                            <div class="flex flex-col justify-center">
                                <h4 class="font-bold text-main" style="font-size: 1.1rem;">Ganga Aarti</h4>
                                <p class="text-sm text-muted">Varanasi, UP</p>
                                <div class="text-primary font-bold mt-1">Free</div>
                            </div>
                        </div>
                        <!-- Activity 3 -->
                        <div class="glass-panel flex gap-4 p-4"
                            style="min-width: 320px; border-radius: 16px; cursor: pointer; transition: transform 0.3s ease;">
                            <img src="https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=150&h=150&q=80"
                                alt="Scuba Diving"
                                style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;">
                            <div class="flex flex-col justify-center">
                                <h4 class="font-bold text-main" style="font-size: 1.1rem;">Nightlife & Beaches</h4>
                                <p class="text-sm text-muted">Goa</p>
                                <div class="text-primary font-bold mt-1">Varies</div>
                            </div>
                        </div>
                        <!-- Activity 4 -->
                        <div class="glass-panel flex gap-4 p-4"
                            style="min-width: 320px; border-radius: 16px; cursor: pointer; transition: transform 0.3s ease;">
                            <img src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=150&h=150&q=80"
                                alt="Taj Mahal"
                                style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;">
                            <div class="flex flex-col justify-center">
                                <h4 class="font-bold text-main" style="font-size: 1.1rem;">Taj Mahal Tour</h4>
                                <p class="text-sm text-muted">Agra, UP</p>
                                <div class="text-primary font-bold mt-1">₹1,100 <span
                                        class="text-xs text-muted font-normal block md:inline">/ person</span></div>
                            </div>
                        </div>
                        <!-- Duplicate for loop -->
                        <div class="glass-panel flex gap-4 p-4"
                            style="min-width: 320px; border-radius: 16px; cursor: pointer; transition: transform 0.3s ease;">
                            <img src="https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format&fit=crop&w=150&h=150&q=80"
                                alt="Rafting"
                                style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;">
                            <div class="flex flex-col justify-center">
                                <h4 class="font-bold text-main" style="font-size: 1.1rem;">River Rafting</h4>
                                <p class="text-sm text-muted">Rishikesh, Uttarakhand</p>
                                <div class="text-primary font-bold mt-1">₹1,500</div>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    (function() {
                        const outer = document.getElementById('mustDoOuter');
                        const inner = document.getElementById('mustDoInner');
                        if (!outer || !inner) return;

                        let scrollPos = 0;
                        let autoSpeed = 0.8; 
                        let currentSpeed = autoSpeed;
                        let isHovering = false;
                        let mouseX = 0;

                        function step() {
                            const rect = outer.getBoundingClientRect();
                            const width = rect.width;
                            const halfWay = inner.scrollWidth / 2;

                            if (isHovering) {
                                const relX = mouseX - rect.left;
                                const edgeSize = width * 0.2;

                                if (relX < edgeSize) {
                                    const intensity = (edgeSize - relX) / edgeSize;
                                    currentSpeed = -intensity * 12;
                                } else if (relX > (width - edgeSize)) {
                                    const intensity = (relX - (width - edgeSize)) / edgeSize;
                                    currentSpeed = intensity * 12;
                                } else {
                                    currentSpeed = 0;
                                }
                            } else {
                                currentSpeed = autoSpeed;
                            }

                            scrollPos += currentSpeed;
                            if (scrollPos > 0) scrollPos = -halfWay;
                            if (scrollPos < -halfWay) scrollPos = 0;

                            inner.style.transform = `translateX(${scrollPos}px)`;
                            requestAnimationFrame(step);
                        }

                        outer.addEventListener('mousemove', (e) => {
                            isHovering = true;
                            mouseX = e.clientX;
                        });
                        outer.addEventListener('mouseleave', () => { isHovering = false; });
                        requestAnimationFrame(step);
                    })();
                </script>
            </section>

            <!-- ====== TOP TRAVEL PLANS THEMATIC ====== -->
            <section class="section scroll-fade relative" style="padding-top: 80px;">
                <div class="container mb-5">
                    <h2 class="editorial text-main mb-1" style="font-size: 2.5rem;">Top Travel Plans</h2>
                    <p class="text-muted" style="font-size: 1.1rem;">Pre-built thematic experiences for every vibe.</p>
                </div>

                <div class="container">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6" data-skeleton="card" data-skeleton-count="3">
                        <!-- Theme 1 -->
                        <div class="plan-card active" style="max-width: none; flex: unset;">
                            <div class="plan-card-img-wrap" style="height: 160px;">
                                <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=800&q=80"
                                    alt="Budget">
                                <div class="plan-card-category" style="background:rgba(59,130,246,0.85);">Budget</div>
                            </div>
                            <div class="plan-card-body">
                                <div class="plan-card-title">Backpacker's Delight</div>
                                <p class="text-sm text-muted mt-2 mb-4">Explore North India's mountains under ₹5,000.
                                    Hostels, street food, and nature trails.</p>
                                <div class="plan-card-footer mt-auto">
                                    <div class="plan-price">₹4,999</div>
                                    <div class="plan-duration"><svg width="12" height="12" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg> 5 Days</div>
                                </div>
                            </div>
                        </div>
                        <!-- Theme 2 -->
                        <div class="plan-card" style="max-width: none; flex: unset;">
                            <div class="plan-card-img-wrap" style="height: 160px;">
                                <img src="https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format&fit=crop&w=800&q=80"
                                    alt="Adventure">
                                <div class="plan-card-category" style="background:rgba(239,68,68,0.85);">Adventure</div>
                            </div>
                            <div class="plan-card-body">
                                <div class="plan-card-title">Himalayan Rush</div>
                                <p class="text-sm text-muted mt-2 mb-4">Trekking, Bungee Jumping, and Rafting for the
                                    ultimate adrenaline junkie.</p>
                                <div class="plan-card-footer mt-auto">
                                    <div class="plan-price">₹18,500</div>
                                    <div class="plan-duration"><svg width="12" height="12" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg> 6 Days</div>
                                </div>
                            </div>
                        </div>
                        <!-- Theme 3 -->
                        <div class="plan-card" style="max-width: none; flex: unset;">
                            <div class="plan-card-img-wrap" style="height: 160px;">
                                <img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=800&q=80"
                                    alt="Family">
                                <div class="plan-card-category" style="background:rgba(16,185,129,0.85);">Family</div>
                            </div>
                            <div class="plan-card-body">
                                <div class="plan-card-title">Serene Retreat</div>
                                <p class="text-sm text-muted mt-2 mb-4">A comfortable, fully guided tour through the
                                    hillsides of Munnar. Perfect for all ages.</p>
                                <div class="plan-card-footer mt-auto">
                                    <div class="plan-price">₹32,000</div>
                                    <div class="plan-duration"><svg width="12" height="12" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg> 4 Days</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Destinations Grid Section -->
            <section class="section scroll-fade relative" id="destinations">
                <div class="container text-center mb-5">
                    <h2 class="editorial text-main mb-2" style="font-size: 3rem;">Iconic Destinations</h2>
                    <p class="text-muted mx-auto" style="max-width: 600px; font-size: 1.1rem;">Hover over a destination
                        to immerse yourself.</p>
                </div>

                <div class="dest-grid hover-triggers" data-skeleton="card" data-skeleton-count="6">
                    <a href="planner.jsp?loc=Jaisalmer" class="dest-item dest-item-1" data-bg-index="2">
                        <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=800&q=80"
                            alt="Jaisalmer">
                        <div class="dest-badge">Jaisalmer • 4 Days</div>
                    </a>
                    <a href="planner.jsp?loc=Varanasi" class="dest-item dest-item-2" data-bg-index="3">
                        <img src="https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format&fit=crop&w=800&q=80"
                            alt="Varanasi">
                        <div class="dest-badge">Varanasi • 2 Days</div>
                    </a>
                    <a href="planner.jsp?loc=Ladakh" class="dest-item dest-item-3" data-bg-index="4">
                        <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=800&q=80"
                            alt="Ladakh">
                        <div class="dest-badge">Ladakh • 7 Days</div>
                    </a>
                    <a href="planner.jsp?loc=Kerala" class="dest-item dest-item-4" data-bg-index="1">
                        <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=800&q=80"
                            alt="Kerala">
                        <div class="dest-badge">Kerala • 5 Days</div>
                    </a>
                    <a href="planner.jsp?loc=Agra" class="dest-item dest-item-5" data-bg-index="0">
                        <img src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=800&q=80"
                            alt="Agra">
                        <div class="dest-badge">Agra • 3 Days</div>
                    </a>
                    <a href="planner.jsp?loc=Goa" class="dest-item dest-item-6" data-bg-index="1">
                        <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=800&q=80"
                            alt="Goa">
                        <div class="dest-badge">Goa • 5 Days</div>
                    </a>
                </div>
            </section>

            <!-- ========== AUTO-SCROLL ITINERARIES STRIP ========== -->
            <section class="strip-section scroll-fade">
                <div class="strip-heading-wrap">
                    <div class="strip-eyebrow">Handpicked for You</div>
                    <h2 class="strip-title">Popular Itineraries</h2>
                </div>

                <div class="strip-outer" id="itinStripOuter">
                    <div class="strip-inner" id="itinStripInner" style="animation: none; transition: transform 0.1s linear;">

                        <!-- SET 1 -->
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=600&q=80"
                                alt="Agra">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Agra</div>
                                <div class="itin-card-region">Uttar Pradesh</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">3 Days</span>
                                    <span class="itin-card-price">₹12,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=600&q=80"
                                alt="Kerala">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Kerala Backwaters</div>
                                <div class="itin-card-region">Kerala</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">5 Days</span>
                                    <span class="itin-card-price">₹18,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=600&q=80"
                                alt="Jaisalmer">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Jaisalmer Fort</div>
                                <div class="itin-card-region">Rajasthan</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹15,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format&fit=crop&w=600&q=80"
                                alt="Varanasi">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Varanasi Ghats</div>
                                <div class="itin-card-region">Uttar Pradesh</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">3 Days</span>
                                    <span class="itin-card-price">₹10,500</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=600&q=80"
                                alt="Ladakh">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Leh, Ladakh</div>
                                <div class="itin-card-region">Jammu &amp; Kashmir</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">8 Days</span>
                                    <span class="itin-card-price">₹35,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80"
                                alt="Goa">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Goa Beaches</div>
                                <div class="itin-card-region">Goa</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹14,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1609766654657-7d98bff1aaad?auto=format&fit=crop&w=600&q=80"
                                alt="Udaipur">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Udaipur Lakes</div>
                                <div class="itin-card-region">Rajasthan</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹17,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=600&q=80"
                                alt="Coorg">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Coorg Estate</div>
                                <div class="itin-card-region">Karnataka</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹16,000</span>
                                </div>
                            </div>
                        </div>

                        <!-- SET 2 (duplicate for seamless loop) -->
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=600&q=80"
                                alt="Agra">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Agra</div>
                                <div class="itin-card-region">Uttar Pradesh</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">3 Days</span>
                                    <span class="itin-card-price">₹12,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=600&q=80"
                                alt="Kerala">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Kerala Backwaters</div>
                                <div class="itin-card-region">Kerala</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">5 Days</span>
                                    <span class="itin-card-price">₹18,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=600&q=80"
                                alt="Jaisalmer">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Jaisalmer Fort</div>
                                <div class="itin-card-region">Rajasthan</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹15,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format&fit=crop&w=600&q=80"
                                alt="Varanasi">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Varanasi Ghats</div>
                                <div class="itin-card-region">Uttar Pradesh</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">3 Days</span>
                                    <span class="itin-card-price">₹10,500</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=600&q=80"
                                alt="Ladakh">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Leh, Ladakh</div>
                                <div class="itin-card-region">Jammu &amp; Kashmir</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">8 Days</span>
                                    <span class="itin-card-price">₹35,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=600&q=80"
                                alt="Goa">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Goa Beaches</div>
                                <div class="itin-card-region">Goa</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹14,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1609766654657-7d98bff1aaad?auto=format&fit=crop&w=600&q=80"
                                alt="Udaipur">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Udaipur Lakes</div>
                                <div class="itin-card-region">Rajasthan</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹17,000</span>
                                </div>
                            </div>
                        </div>
                        <div class="itin-card">
                            <img class="itin-card-img"
                                src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format&fit=crop&w=600&q=80"
                                alt="Coorg">
                            <div class="itin-card-body">
                                <div class="itin-card-city">Coorg Estate</div>
                                <div class="itin-card-region">Karnataka</div>
                                <div class="itin-card-footer">
                                    <span class="itin-card-duration">4 Days</span>
                                    <span class="itin-card-price">₹16,000</span>
                                </div>
                            </div>
                        </div>

                    </div><!-- /strip-inner -->
                </div><!-- /strip-outer -->
                <script>
                    (function() {
                        const outer = document.getElementById('itinStripOuter');
                        const inner = document.getElementById('itinStripInner');
                        if (!outer || !inner) return;

                        let scrollPos = 0;
                        let autoSpeed = 1.2; 
                        let currentSpeed = autoSpeed;
                        let isHovering = false;
                        let mouseX = 0;

                        function step() {
                            const rect = outer.getBoundingClientRect();
                            const width = rect.width;
                            const halfWay = inner.scrollWidth / 2;

                            if (isHovering) {
                                const relX = mouseX - rect.left;
                                const edgeSize = width * 0.2;

                                if (relX < edgeSize) {
                                    const intensity = (edgeSize - relX) / edgeSize;
                                    currentSpeed = -intensity * 15;
                                } else if (relX > (width - edgeSize)) {
                                    const intensity = (relX - (width - edgeSize)) / edgeSize;
                                    currentSpeed = intensity * 15;
                                } else {
                                    currentSpeed = 0;
                                }
                            } else {
                                currentSpeed = autoSpeed;
                            }

                            scrollPos += currentSpeed;
                            if (scrollPos > 0) scrollPos = -halfWay;
                            if (scrollPos < -halfWay) scrollPos = 0;

                            inner.style.transform = `translateX(${scrollPos}px)`;
                            requestAnimationFrame(step);
                        }

                        outer.addEventListener('mousemove', (e) => {
                            isHovering = true;
                            mouseX = e.clientX;
                        });
                        outer.addEventListener('mouseleave', () => { isHovering = false; });
                        requestAnimationFrame(step);
                    })();
                </script>
            </section>

        </main>

        <script>
            /* ===== DYNAMIC THEME SYSTEM — 12 landscapes ===== */
            const themes = [
                // 0 — Agra / Taj Mahal (cool white marble + shadow blue)
                {
                    '--color-primary': '#b8cfe0', '--color-accent': '#6a9ab8',
                    '--color-muted': 'rgba(195,215,230,0.6)',
                    '--color-surface': 'rgba(200,220,235,0.06)', '--color-border': 'rgba(185,210,228,0.16)',
                    '--text-heading': '#edf2f7', '--text-body': 'rgba(215,230,242,0.7)'
                },
                // 1 — Kerala (deep jungle green + golden light)
                {
                    '--color-primary': '#96c98d', '--color-accent': '#4a8c42',
                    '--color-muted': 'rgba(165,205,160,0.6)',
                    '--color-surface': 'rgba(120,180,115,0.06)', '--color-border': 'rgba(148,200,142,0.16)',
                    '--text-heading': '#eef5ec', '--text-body': 'rgba(195,230,190,0.7)'
                },
                // 2 — Rajasthan (sun-baked sandstone)
                {
                    '--color-primary': '#d4a86a', '--color-accent': '#9c6820',
                    '--color-muted': 'rgba(215,185,135,0.6)',
                    '--color-surface': 'rgba(185,140,80,0.06)', '--color-border': 'rgba(210,175,115,0.16)',
                    '--text-heading': '#f7f0e6', '--text-body': 'rgba(235,215,180,0.7)'
                },
                // 3 — Varanasi (deep saffron + ash riverbank)
                {
                    '--color-primary': '#d48c5a', '--color-accent': '#a04818',
                    '--color-muted': 'rgba(215,165,120,0.6)',
                    '--color-surface': 'rgba(180,110,65,0.06)', '--color-border': 'rgba(210,148,95,0.16)',
                    '--text-heading': '#f5ede4', '--text-body': 'rgba(240,205,170,0.7)'
                },
                // 4 — Ladakh (glacial slate + pale sky)
                {
                    '--color-primary': '#9ab8d4', '--color-accent': '#4a7898',
                    '--color-muted': 'rgba(165,195,218,0.6)',
                    '--color-surface': 'rgba(110,160,195,0.06)', '--color-border': 'rgba(145,188,215,0.16)',
                    '--text-heading': '#edf2f8', '--text-body': 'rgba(200,220,238,0.7)'
                },
                // 5 — Mysore (dusk mauve + gold lamp)
                {
                    '--color-primary': '#c8a8d8', '--color-accent': '#7a4898',
                    '--color-muted': 'rgba(198,170,218,0.6)',
                    '--color-surface': 'rgba(155,110,185,0.06)', '--color-border': 'rgba(188,148,210,0.16)',
                    '--text-heading': '#f5f0f8', '--text-body': 'rgba(220,200,235,0.7)'
                },
                // 6 — Rishikesh (river jade + white foam)
                {
                    '--color-primary': '#78c4b8', '--color-accent': '#2a8878',
                    '--color-muted': 'rgba(130,195,188,0.6)',
                    '--color-surface': 'rgba(80,165,155,0.06)', '--color-border': 'rgba(108,188,180,0.16)',
                    '--text-heading': '#edf6f5', '--text-body': 'rgba(185,225,220,0.7)'
                },
                // 7 — Hampi (rust ochre + shadow charcoal)
                {
                    '--color-primary': '#c88858', '--color-accent': '#884018',
                    '--color-muted': 'rgba(200,155,110,0.6)',
                    '--color-surface': 'rgba(165,105,60,0.06)', '--color-border': 'rgba(195,138,88,0.16)',
                    '--text-heading': '#f6ede6', '--text-body': 'rgba(235,210,185,0.7)'
                },
                // 8 — Andaman (reef turquoise + bone sand)
                {
                    '--color-primary': '#68c8d8', '--color-accent': '#1080a0',
                    '--color-muted': 'rgba(118,200,215,0.6)',
                    '--color-surface': 'rgba(65,175,195,0.06)', '--color-border': 'rgba(98,202,218,0.16)',
                    '--text-heading': '#edf8f9', '--text-body': 'rgba(185,230,238,0.7)'
                },
                // 9 — Darjeeling (tea green + mist grey)
                {
                    '--color-primary': '#a8b888', '--color-accent': '#587848',
                    '--color-muted': 'rgba(168,185,145,0.6)',
                    '--color-surface': 'rgba(125,148,100,0.06)', '--color-border': 'rgba(155,172,128,0.16)',
                    '--text-heading': '#f0f2ec', '--text-body': 'rgba(210,220,195,0.7)'
                },
                // 10 — Rann of Kutch (salt white + dusk rose)
                {
                    '--color-primary': '#d8c8b0', '--color-accent': '#907858',
                    '--color-muted': 'rgba(215,200,175,0.6)',
                    '--color-surface': 'rgba(185,168,140,0.06)', '--color-border': 'rgba(210,192,165,0.16)',
                    '--text-heading': '#f8f5f0', '--text-body': 'rgba(238,228,215,0.7)'
                },
                // 11 — Ooty (pine forest dark + mist white)
                {
                    '--color-primary': '#78b890', '--color-accent': '#286848',
                    '--color-muted': 'rgba(128,185,148,0.6)',
                    '--color-surface': 'rgba(75,148,105,0.06)', '--color-border': 'rgba(105,178,130,0.16)',
                    '--text-heading': '#eef4f0', '--text-body': 'rgba(195,228,208,0.7)'
                },
            ];

            /* Luminosity classifier — true = light BG photo needs dark text */
            const themesAreLight = [
                true, false, false, false, false, false, false, false, false, true, true, true
            ];

            /* Darker primary/accent variants for when theme is light */
            const lightThemeDark = {
                0: { primary: '#2d6e98', accent: '#1a4a6a' },  // Taj Mahal
                9: { primary: '#3a5830', accent: '#223520' },  // Darjeeling
                10: { primary: '#7a5830', accent: '#4a3010' },  // Rann of Kutch
                11: { primary: '#1a5c38', accent: '#0a3820' },  // Ooty
            };

            function applyTheme(index) {
                const t = themes[index] || themes[0];
                const root = document.documentElement;
                const isLight = themesAreLight[index] || false;

                // Ensure class is set immediately for all rules
                document.body.classList.toggle('theme-light', isLight);

                // Write all CSS custom properties from theme object
                Object.entries(t).forEach(([k, v]) => root.style.setProperty(k, v));

                let primary, accent, muted, heading, border, surface, textBody;
                if (isLight) {
                    const dk = lightThemeDark[index];
                    primary = dk.primary;
                    accent = dk.accent;
                    muted = 'rgba(40,30,18,0.55)';
                    heading = '#1a1612';
                    textBody = 'rgba(30,22,12,0.72)';
                    surface = 'rgba(15,10,5,0.06)';
                    border = 'rgba(20,14,6,0.15)';
                    root.style.setProperty('--color-primary', primary);
                    root.style.setProperty('--color-accent', accent);
                    root.style.setProperty('--color-muted', muted);
                    root.style.setProperty('--text-heading', heading);
                    root.style.setProperty('--text-body', textBody);
                    root.style.setProperty('--color-surface', surface);
                    root.style.setProperty('--color-border', border);
                    document.querySelectorAll('.bg-slide').forEach(s => s.style.filter = 'brightness(0.78)');
                } else {
                    primary = t['--color-primary'];
                    accent = t['--color-accent'];
                    muted = t['--color-muted'];
                    heading = t['--text-heading'];
                    textBody = t['--text-body'];
                    surface = t['--color-surface'];
                    border = t['--color-border'];
                    document.querySelectorAll('.bg-slide').forEach(s => s.style.filter = 'brightness(0.40)');
                }

                document.querySelectorAll('.bg-dot.active').forEach(d => d.style.boxShadow = '0 0 10px ' + primary);
                document.querySelectorAll('.stat-num').forEach(el => el.style.color = primary);
                document.querySelectorAll('.section-eyebrow').forEach(el => el.style.color = accent);
                document.querySelectorAll('.badge').forEach(el => { el.style.borderColor = border; el.style.color = muted; });

                document.querySelectorAll('.btn-glow-primary').forEach(el => {
                    if (isLight) {
                        el.style.background = accent;
                        el.style.color = '#fff';
                    } else {
                        el.style.background = heading;
                        el.style.color = '#111';
                    }
                });

                document.querySelectorAll('.btn-glow-ghost').forEach(el => { el.style.borderColor = border; el.style.color = heading; });
                document.querySelectorAll('.city-item').forEach(el => el.style.backgroundImage = 'linear-gradient(to right, ' + heading + ', transparent)');
                document.querySelectorAll('.nav-link, .nav-brand').forEach(el => el.style.color = heading);

                const navbar = document.querySelector('.navbar');
                if (navbar) {
                    navbar.style.background = isLight ? 'rgba(255,255,255,0.22)' : 'rgba(10,8,5,0.35)';
                    navbar.style.borderBottom = '1px solid ' + border;
                }
            }

            document.addEventListener('DOMContentLoaded', () => {
                // 1. MUST APPLY THEME BEFORE FIRST PAINT
                applyTheme(0);

                /* --- Custom Cursor --- */
                const cursorDot = document.getElementById('cursorDot');
                const cursorOutline = document.getElementById('cursorOutline');

                window.addEventListener('mousemove', (e) => {
                    const posX = e.clientX;
                    const posY = e.clientY;

                    cursorDot.style.left = posX + 'px';
                    cursorDot.style.top = posY + 'px';

                    // Add a slight delay to the outline using JS animation
                    cursorOutline.animate({
                        left: posX + 'px',
                        top: posY + 'px'
                    }, { duration: 500, fill: "forwards" });
                });

                // Enlarge outline on hoverable elements
                const hoverables = document.querySelectorAll('a, button, .dest-item, .tilt-card');
                hoverables.forEach(el => {
                    el.addEventListener('mouseenter', () => {
                        cursorOutline.style.width = '60px';
                        cursorOutline.style.height = '60px';
                        cursorOutline.style.backgroundColor = 'rgba(79, 70, 229, 0.2)';
                    });
                    el.addEventListener('mouseleave', () => {
                        cursorOutline.style.width = '40px';
                        cursorOutline.style.height = '40px';
                        cursorOutline.style.backgroundColor = 'transparent';
                    });
                });

                /* --- Slot Machine Rotator --- */
                const track = document.getElementById('rotatorTrack');
                const words = track.children;
                const wordHeight = 1.2; // em
                let currentWord = 0;

                setInterval(() => {
                    currentWord++;
                    track.style.transition = 'transform 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55)';
                    track.style.transform = 'translateY(-' + (currentWord * wordHeight) + 'em)';

                    // Reset when reaching the clone
                    if (currentWord === words.length - 1) {
                        setTimeout(() => {
                            track.style.transition = 'none';
                            currentWord = 0;
                            track.style.transform = 'translateY(0)';
                        }, 600);
                    }
                }, 2400);

                /* --- Background Slider & Hover Logic --- */
                const bgSlides = document.querySelectorAll('.bg-slide');
                const bgDots = document.querySelectorAll('.bg-dot');
                let bgIndex = 0;
                let bgInterval;

                function setBg(index) {
                    bgSlides.forEach(s => s.classList.remove('active'));
                    bgDots.forEach(d => d.classList.remove('active'));

                    bgSlides[index].classList.add('active');
                    bgDots[index].classList.add('active');
                    bgIndex = index;

                    // Apply theme 100ms after bg starts fading so colors follow
                    setTimeout(() => applyTheme(index), 100);
                }

                function startBgInterval() {
                    clearInterval(bgInterval);
                    bgInterval = setInterval(() => {
                        let nextIndex = (bgIndex + 1) % bgSlides.length;
                        setBg(nextIndex);
                    }, 5000);
                }

                // Ensure first interval run waits logic
                startBgInterval();

                // Dot clicks
                bgDots.forEach((dot, i) => {
                    dot.addEventListener('click', () => {
                        setBg(i);
                        startBgInterval();
                    });
                });

                // Destination Grid Hover — activates specific BG + theme
                const destItems = document.querySelectorAll('.dest-item');
                destItems.forEach(item => {
                    item.addEventListener('mouseenter', () => {
                        const idx = parseInt(item.getAttribute('data-bg-index'));
                        if (!isNaN(idx)) {
                            setBg(idx);
                            clearInterval(bgInterval);
                        }
                    });
                    item.addEventListener('mouseleave', () => {
                        startBgInterval();
                    });
                });

                /* --- Mouse Parallax --- */
                const parallaxWrappers = document.querySelectorAll('.parallax-wrapper');
                window.addEventListener('mousemove', (e) => {
                    const x = (e.clientX / window.innerWidth - 0.5) * 2; // -1 to 1
                    const y = (e.clientY / window.innerHeight - 0.5) * 2; // -1 to 1

                    parallaxWrappers.forEach(wrapper => {
                        const elements = wrapper.querySelectorAll('.parallax-bg');
                        elements.forEach(el => {
                            const speed = parseFloat(el.getAttribute('data-speed'));
                            const xOffset = x * 100 * speed;
                            const yOffset = y * 100 * speed;
                            el.style.transform = 'translate(' + xOffset + 'px, ' + yOffset + 'px)';
                        });
                    });

                    // Subtly move the background slides in reverse
                    bgSlides.forEach(slide => {
                        if (slide.classList.contains('active')) {
                            const bgX = x * -20;
                            const bgY = y * -20;
                            slide.style.transform = 'translate(' + bgX + 'px, ' + bgY + 'px) scale(1.05)';
                        }
                    });
                });

                /* --- Scroll Fade & Vertical Progress Line --- */
                const scrollFades = document.querySelectorAll('.scroll-fade');
                const scrollProgress = document.getElementById('scrollProgress');

                function checkScroll() {
                    const triggerBottom = window.innerHeight * 0.85;
                    scrollFades.forEach(el => {
                        const top = el.getBoundingClientRect().top;
                        if (top < triggerBottom) {
                            el.classList.add('visible');
                        }
                    });
                }

                checkScroll();

                window.addEventListener('scroll', () => {
                    checkScroll();

                    // Progress Line
                    const scrollPx = document.documentElement.scrollTop;
                    const winHeightPx = document.documentElement.scrollHeight - document.documentElement.clientHeight;
                    const scrolled = (scrollPx / winHeightPx * 100) + '%';
                    if (scrollProgress) scrollProgress.style.height = scrolled;
                });

                /* --- 3D Tilt Effect on Cards --- */
                const tiltElements = document.querySelectorAll('.tilt-card');
                tiltElements.forEach(el => {
                    const restingState = el.style.transform || 'rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
                    el.setAttribute('data-resting', restingState);

                    el.addEventListener('mousemove', (e) => {
                        const rect = el.getBoundingClientRect();
                        const posX = e.clientX - rect.left;
                        const posY = e.clientY - rect.top;
                        const centerX = rect.width / 2;
                        const centerY = rect.height / 2;

                        const rotateX = ((posY - centerY) / centerY) * -12;
                        const rotateY = ((posX - centerX) / centerX) * 12;

                        el.style.transform = 'rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg) scale3d(1.05, 1.05, 1.05)';
                        el.style.transition = 'none';
                    });

                    el.addEventListener('mouseleave', () => {
                        el.style.transform = el.getAttribute('data-resting');
                        el.style.transition = 'transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
                    });

                    el.addEventListener('mouseenter', () => {
                        el.style.transition = 'transform 0.1s ease-out';
                    });
                });

                /* ======== PLAN CARDS PROXIMITY EDGE SCROLL ======== */
                (function () {
                    const outer = document.querySelector('.plan-scroll-outer');
                    const inner = document.getElementById('planScrollInner');
                    if (!outer || !inner) return;

                    const ZONE = 120;   // px from each edge
                    const BASE_RATE = 1;     // normal speed (1x at 58s/loop)
                    const MAX_RATE = 2.636; // 58s / 22s = 2.636x at max edge speed
                    const LERP_T = 0.08;  // lerp factor per rAF frame

                    let targetRate = BASE_RATE;
                    let currentRate = BASE_RATE;
                    let rafId = null;

                    /* Grab the running CSS animation object */
                    function getAnim() {
                        const anims = inner.getAnimations ? inner.getAnimations() : [];
                        return anims[0] || null;
                    }

                    function lerp(a, b, t) { return a + (b - a) * t; }

                    /* rAF loop — only lerps playbackRate, never restarts the animation */
                    function tick() {
                        currentRate = lerp(currentRate, targetRate, LERP_T);
                        if (Math.abs(currentRate - targetRate) < 0.01) currentRate = targetRate;

                        const anim = getAnim();
                        if (anim) anim.playbackRate = currentRate;

                        if (Math.abs(currentRate - targetRate) > 0.01) {
                            rafId = requestAnimationFrame(tick);
                        } else {
                            rafId = null;
                        }
                    }

                    function startLerp() {
                        if (!rafId) rafId = requestAnimationFrame(tick);
                    }

                    /* Mousemove — calculate which zone the cursor is in */
                    outer.addEventListener('mousemove', function (e) {
                        const rect = outer.getBoundingClientRect();
                        const posX = e.clientX - rect.left;
                        const width = rect.width;

                        if (posX < ZONE) {
                            // Left edge zone — reverse + speed up
                            const t = 1 - posX / ZONE;              // 0..1 (0 = zone edge, 1 = far left)
                            targetRate = -lerp(BASE_RATE, MAX_RATE, t);
                        } else if (posX > width - ZONE) {
                            // Right edge zone — forward + speed up
                            const t = 1 - (width - posX) / ZONE;   // 0..1 (0 = zone edge, 1 = far right)
                            targetRate = lerp(BASE_RATE, MAX_RATE, t);
                        } else {
                            // Centre — normal forward speed
                            targetRate = BASE_RATE;
                        }

                        startLerp();
                    });

                    /* Mouse leaves — restore normal forward speed smoothly */
                    outer.addEventListener('mouseleave', function () {
                        targetRate = BASE_RATE;
                        startLerp();
                    });
                })();

                /* ======== DARK / LIGHT MODE TOGGLE ======== */
                (function () {
                    const btn = document.getElementById('themeToggle');
                    const html = document.documentElement;

                    // If no manual preference yet, detect system preference
                    if (!html.getAttribute('data-theme')) {
                        const sys = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
                        html.setAttribute('data-theme', sys);
                    }

                    if (btn) {
                        btn.addEventListener('click', function () {
                            const current = html.getAttribute('data-theme');
                            const next = current === 'dark' ? 'light' : 'dark';
                            html.setAttribute('data-theme', next);
                            localStorage.setItem('theme', next);
                        });
                    }
                })();

            });
        </script>

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

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // DB of Indian Cities/Airports
                const SEARCH_DB = [
                    { city: 'Delhi', airport: 'DEL, Indira Gandhi Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Mumbai', airport: 'BOM, Chhatrapati Shivaji Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Bengaluru', airport: 'BLR, Kempegowda Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Hyderabad', airport: 'HYD, Rajiv Gandhi Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Chennai', airport: 'MAA, Chennai Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Kolkata', airport: 'CCU, Netaji Subhas Chandra Bose', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Goa', airport: 'GOI, Dabolim Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Jaipur', airport: 'JAI, Jaipur Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Udaipur', airport: 'UDR, Maharana Pratap', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Pune', airport: 'PNQ, Pune Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Kochi', airport: 'COK, Cochin Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
                    { city: 'Varanasi', airport: 'VNS, Lal Bahadur Shastri', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' }
                ];

                const RECENTS_KEY = 'voyastra_recent_searches';
                const modal = document.getElementById('intelligentSearchModal');
                const input = document.getElementById('intelligentSearchInput');
                const recentSection = document.getElementById('searchRecentSection');
                const recentList = document.getElementById('searchRecentList');
                const popularSection = document.getElementById('searchPopularSection');
                const popularList = document.getElementById('searchPopularList');
                const suggestionsSection = document.getElementById('searchSuggestionsSection');
                const suggestionsList = document.getElementById('searchSuggestionsList');
                
                let activeSearchField = null;

                // Create a list item HTML string
                const createListItem = (item) => {
                    return `
                        <li class="suggestion-item" data-city="\${item.city}" data-airport="\${item.airport}">
                            <div class="suggestion-icon">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="\${item.icon || 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z'}"></path><circle cx="12" cy="10" r="3"></circle>
                                </svg>
                            </div>
                            <div class="suggestion-text">
                                <span class="suggestion-city">\${item.city}</span>
                                <span class="suggestion-airport">\${item.airport}</span>
                            </div>
                        </li>
                    `;
                };

                // Render lists
                const renderPopular = () => {
                    popularList.innerHTML = SEARCH_DB.slice(0, 4).map(createListItem).join('');
                };

                const getRecents = () => JSON.parse(localStorage.getItem(RECENTS_KEY) || '[]');

                const renderRecents = () => {
                    const recents = getRecents();
                    if (recents.length > 0) {
                        recentList.innerHTML = recents.map(createListItem).join('');
                        recentSection.classList.remove('hidden');
                    } else {
                        recentSection.classList.add('hidden');
                    }
                };

                const saveRecent = (city, airport) => {
                    let recents = getRecents();
                    // Remove if already exists
                    recents = recents.filter(item => item.city !== city);
                    // Add to front
                    recents.unshift({ city, airport });
                    // Keep max 5
                    if (recents.length > 5) recents.pop();
                    localStorage.setItem(RECENTS_KEY, JSON.stringify(recents));
                };

                // Open Modal
                const openSearchModal = (fieldEl) => {
                    activeSearchField = fieldEl;
                    
                    // Render default state
                    input.value = '';
                    renderPopular();
                    renderRecents();
                    popularSection.classList.remove('hidden');
                    suggestionsSection.classList.add('hidden');
                    
                    // Position Modal exactly below the clicked field
                    const rect = fieldEl.getBoundingClientRect();
                    modal.style.top = (rect.bottom + window.scrollY + 8) + 'px';
                    
                    // Handle right edge overflow
                    const dropdownWidth = 320;
                    if (rect.left + dropdownWidth > window.innerWidth) {
                        modal.style.left = (window.innerWidth - dropdownWidth - 24) + 'px';
                    } else {
                        modal.style.left = rect.left + 'px';
                    }

                    modal.classList.remove('hidden');
                    
                    // Focus input smoothly
                    setTimeout(() => input.focus(), 50);
                };

                const closeSearchModal = () => {
                    modal.classList.add('hidden');
                    activeSearchField = null;
                };

                // Attach to Search Fields (From, To, City)
                const searchFields = document.querySelectorAll('.search-field');
                searchFields.forEach(field => {
                    // Only attach if it's an actionable location field -> "From", "To", "City..."
                    const labelNode = field.querySelector('.field-label');
                    if (labelNode && ["From", "To", "City, Property Name Or Location"].includes(labelNode.innerText.trim())) {
                        field.addEventListener('click', (e) => {
                            e.stopPropagation();
                            openSearchModal(field);
                        });
                    }
                });

                // Input Filtering
                input.addEventListener('input', (e) => {
                    const term = e.target.value.toLowerCase().trim();
                    if (term.length === 0) {
                        popularSection.classList.remove('hidden');
                        renderRecents(); // might show/hide depending on count
                        suggestionsSection.classList.add('hidden');
                        return;
                    }

                    popularSection.classList.add('hidden');
                    recentSection.classList.add('hidden');
                    
                    const filtered = SEARCH_DB.filter(item => 
                        item.city.toLowerCase().includes(term) || 
                        item.airport.toLowerCase().includes(term)
                    );

                    if (filtered.length > 0) {
                        suggestionsList.innerHTML = filtered.map(createListItem).join('');
                        suggestionsSection.classList.remove('hidden');
                    } else {
                        suggestionsList.innerHTML = '<li class="p-3 text-muted text-sm text-center">No locations found.</li>';
                        suggestionsSection.classList.remove('hidden');
                    }
                });

                // Handle Selection
                modal.addEventListener('click', (e) => {
                    const li = e.target.closest('.suggestion-item');
                    if (li && activeSearchField) {
                        const city = li.getAttribute('data-city');
                        const airport = li.getAttribute('data-airport');
                        
                        // Update UI
                        const valNode = activeSearchField.querySelector('.field-value');
                        const subNode = activeSearchField.querySelector('.field-sub');
                        if (valNode) valNode.innerText = city;
                        if (subNode) subNode.innerText = airport;

                        // Add pulse effect to highlight change
                        valNode.style.animation = 'none';
                        valNode.offsetHeight; // trigger reflow
                        valNode.style.animation = 'fadeUp 0.3s ease forwards';
                        
                        saveRecent(city, airport);
                        closeSearchModal();
                    }
                });

                // Close on click outside
                document.addEventListener('click', (e) => {
                    if (!modal.classList.contains('hidden') && !modal.contains(e.target)) {
                        closeSearchModal();
                    }
                });
            });
        </script>

        <%@ include file="components/footer.jsp" %>
