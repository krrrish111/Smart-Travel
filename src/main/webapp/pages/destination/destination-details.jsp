<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
/* Destination Details Specific Premium Styling */
.dest-hero-section {
    position: relative;
    width: 100%;
    min-height: 70vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background-size: cover;
    background-position: center;
    /* Default background, will be overridden by inline style if dynamic */
    background-image: url('${not empty destination.imageUrl ? destination.imageUrl : "https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=1920&q=80"}');
    padding-top: 80px;
}
.dest-hero-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom, rgba(0,0,0,0.4) 0%, rgba(15,11,8,0.9) 100%);
    z-index: 1;
}
.dest-hero-content {
    position: relative;
    z-index: 2;
    text-align: center;
    max-width: 900px;
    padding: 0 20px;
}
.dest-hero-title {
    font-size: 4.5rem;
    font-weight: 700;
    color: #fff;
    text-shadow: 0 4px 20px rgba(0,0,0,0.6);
    margin-bottom: 1rem;
}
.dest-hero-subtitle {
    font-size: 1.25rem;
    color: rgba(255,255,255,0.85);
    margin-bottom: 2rem;
    font-weight: 300;
}

/* Action Bar */
.dest-actions-bar {
    position: relative;
    z-index: 10;
    margin-top: -40px;
    margin-bottom: 60px;
}
.dest-actions-glass {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 24px;
    padding: 20px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.5);
}

.action-group-left {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}

.action-group-right {
    display: flex;
}

/* Action Buttons */
.dest-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 24px;
    border-radius: 12px;
    font-weight: 600;
    font-size: 0.95rem;
    transition: all 0.3s ease;
    cursor: pointer;
    text-decoration: none;
}

.btn-glass-secondary {
    background: rgba(255,255,255,0.1);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.15);
}
.btn-glass-secondary:hover {
    background: rgba(255,255,255,0.2);
    transform: translateY(-2px);
}

.btn-primary-gold {
    background: linear-gradient(135deg, #d4af37 0%, #b5952f 100%);
    color: #000;
    border: none;
    box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4);
}
.btn-primary-gold:hover {
    background: linear-gradient(135deg, #ebd671 0%, #c2a138 100%);
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(212, 175, 55, 0.6);
}

/* Content Layout */
.dest-content-grid {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 40px;
    margin-bottom: 80px;
}
@media (max-width: 992px) {
    .dest-content-grid {
        grid-template-columns: 1fr;
    }
}

.dest-section-title {
    font-size: 2rem;
    color: var(--text-main);
    margin-bottom: 1.5rem;
    font-weight: 700;
}

.info-card {
    background: var(--surface-glass);
    backdrop-filter: blur(12px);
    border: 1px solid var(--color-border);
    border-radius: 20px;
    padding: 30px;
    margin-bottom: 30px;
}

.stat-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}
.stat-item {
    display: flex;
    flex-direction: column;
    gap: 5px;
}
.stat-label {
    font-size: 0.85rem;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.05em;
}
.stat-value {
    font-size: 1.2rem;
    font-weight: 600;
    color: var(--text-main);
}
</style>

<main>
    <!-- HERO SECTION -->
    <section class="dest-hero-section">
        <div class="dest-hero-overlay"></div>
        <div class="dest-hero-content slide-up">
            <h1 class="dest-hero-title editorial">${not empty destination.title ? destination.title : "Explore Destination"}</h1>
            <p class="dest-hero-subtitle">${not empty destination.shortDescription ? destination.shortDescription : "Discover the beauty, culture, and experiences awaiting you."}</p>
        </div>
    </section>

    <!-- ACTION BAR -->
    <div class="container dest-actions-bar">
        <div class="dest-actions-glass">
            <div class="action-group-left">
                <!-- Action: View Itinerary -->
                <button id="btn-view-itinerary" class="dest-btn btn-glass-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    View Itinerary
                </button>

                <!-- Action: Customize Trip -->
                <a href="${pageContext.request.contextPath}/planner" class="dest-btn btn-glass-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                    Customize Trip
                </a>

                <!-- Action: Save Trip -->
                <button id="btn-save-trip" class="dest-btn btn-glass-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>
                    <span id="save-trip-label">Save Trip</span>
                </button>

                <!-- Action: Share Trip -->
                <button id="btn-share-trip" class="dest-btn btn-glass-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg>
                    Share Trip
                </button>
            </div>

            <div class="action-group-right">
                <!-- Action: Book This Trip -->
                <a href="${pageContext.request.contextPath}/destination/customize?id=${destination.id}" class="dest-btn btn-primary-gold">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    Book This Trip
                </a>
            </div>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="container dest-content-grid">
        <!-- Left Column: Details -->
        <div class="dest-content-main">
            <h2 class="dest-section-title editorial">About this Journey</h2>
            <p class="text-muted mb-6" style="font-size: 1.1rem; line-height: 1.7;">
                ${not empty destination.fullDescription ? destination.fullDescription : "Immerse yourself in a curated experience designed to showcase the very best of this location. From iconic landmarks to hidden gems, every detail has been thoughtfully arranged to ensure an unforgettable journey. Whether you're seeking adventure, relaxation, or cultural immersion, this trip offers a perfect balance."}
            </p>

            <h2 class="dest-section-title editorial mt-8">Highlights</h2>
            <ul class="text-muted" style="list-style-type: disc; padding-left: 20px; font-size: 1.05rem; line-height: 1.8; margin-bottom: 2rem;">
                <li>Exclusive guided tours of historical monuments.</li>
                <li>Authentic local culinary experiences.</li>
                <li>Premium accommodations with scenic views.</li>
                <li>Seamless transportation and transfers included.</li>
            </ul>

            <!-- Day-wise Itinerary -->
            <h2 class="dest-section-title editorial mt-8">Day-wise Itinerary</h2>
            <div class="itinerary-timeline flex flex-col gap-6 mb-8">
                <c:choose>
                    <c:when test="${not empty itineraries}">
                        <c:forEach var="itin" items="${itineraries}">
                            <div class="itinerary-day p-6 glass-panel rounded-2xl border border-gray-100 dark:border-gray-800">
                                <h4 class="font-bold text-lg text-primary mb-2">Day ${itin.dayNumber}: ${itin.title}</h4>
                                <p class="text-muted text-sm leading-relaxed">${itin.details}</p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="itinerary-day p-6 glass-panel rounded-2xl border border-gray-100 dark:border-gray-800">
                            <h4 class="font-bold text-lg text-primary mb-2">Day 1: Arrival & Acclimatization</h4>
                            <p class="text-muted text-sm leading-relaxed">Arrive at the destination. Transfer to your premium hotel. Spend the evening relaxing and enjoying a welcome dinner with local cultural performances.</p>
                        </div>
                        <div class="itinerary-day p-6 glass-panel rounded-2xl border border-gray-100 dark:border-gray-800">
                            <h4 class="font-bold text-lg text-primary mb-2">Day 2: Exploration</h4>
                            <p class="text-muted text-sm leading-relaxed">After breakfast, embark on a guided tour of the iconic landmarks. Explore centuries-old architecture and learn about the rich heritage.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Photo Gallery -->
            <h2 class="dest-section-title editorial mt-8">Photo Gallery</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mb-8">
                <img src="https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=400&q=75" alt="Gallery 1" class="rounded-xl w-full h-32 object-cover hover:opacity-90 transition cursor-pointer" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=400&q=75" alt="Gallery 2" class="rounded-xl w-full h-32 object-cover hover:opacity-90 transition cursor-pointer" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <img src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&w=400&q=75" alt="Gallery 3" class="rounded-xl w-full h-32 object-cover hover:opacity-90 transition cursor-pointer" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=400&q=75" alt="Gallery 4" class="rounded-xl w-full h-32 object-cover hover:opacity-90 transition cursor-pointer" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <img src="https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format&fit=crop&w=400&q=75" alt="Gallery 5" class="rounded-xl w-full h-32 object-cover hover:opacity-90 transition cursor-pointer" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=400&q=75" alt="Gallery 6" class="rounded-xl w-full h-32 object-cover hover:opacity-90 transition cursor-pointer" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            </div>

            <!-- Traveler Reviews -->
            <h2 class="dest-section-title editorial mt-8">Traveler Reviews</h2>
            <div class="flex flex-col gap-6 mb-8">
                <div class="p-6 glass-panel rounded-2xl border border-gray-100 dark:border-gray-800 flex gap-4">
                    <div style="width:48px;height:48px;border-radius:50%;background:var(--color-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;flex-shrink:0;">AJ</div>
                    <div>
                        <div class="flex items-center gap-2 mb-1">
                            <h4 class="font-bold text-main">Anjali J.</h4>
                            <span class="text-primary text-xs">★★★★★</span>
                        </div>
                        <p class="text-muted text-sm">"Absolutely stunning! The itinerary was perfectly balanced between sightseeing and relaxation. The hotels suggested were top-notch."</p>
                    </div>
                </div>
                <div class="p-6 glass-panel rounded-2xl border border-gray-100 dark:border-gray-800 flex gap-4">
                    <div style="width:48px;height:48px;border-radius:50%;background:var(--color-accent);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;flex-shrink:0;">MS</div>
                    <div>
                        <div class="flex items-center gap-2 mb-1">
                            <h4 class="font-bold text-main">Michael S.</h4>
                            <span class="text-primary text-xs">★★★★★</span>
                        </div>
                        <p class="text-muted text-sm">"The local guides provided by Voyastra made this trip unforgettable. Highly recommend booking the full package."</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Quick Stats -->
        <div class="dest-content-sidebar">
            <div class="info-card">
                <h3 class="font-bold text-xl mb-4 text-main">Trip Overview</h3>
                <div class="stat-grid">
                    <div class="stat-item">
                        <span class="stat-label">Duration</span>
                        <span class="stat-value">${destination.durationDays}D / ${destination.durationNights}N</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Best Time</span>
                        <span class="stat-value">${not empty destination.bestSeason ? destination.bestSeason : "All Year"}</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Category</span>
                        <span class="stat-value">${not empty destination.category ? destination.category : "Premium"}</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Starting</span>
                        <span class="stat-value">${not empty destination.startingCity ? destination.startingCity : "TBD"}</span>
                    </div>
                </div>

                <hr class="border-border my-6">
                
                <div class="price-box mb-6">
                    <span class="text-sm text-muted line-through mb-1 block">₹<fmt:formatNumber value="${destination.priceInr}" type="number" maxFractionDigits="0"/></span>
                    <div class="flex items-end gap-2">
                        <span class="text-3xl font-bold text-primary">₹<fmt:formatNumber value="${destination.discountPrice > 0 ? destination.discountPrice : destination.priceInr}" type="number" maxFractionDigits="0"/></span>
                        <span class="text-sm text-muted pb-1">/ person</span>
                    </div>
                    <p class="text-xs text-primary mt-2 flex items-center gap-1">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        Taxes & Fees Included
                    </p>
                </div>
                
                <a href="${pageContext.request.contextPath}/destination/customize?id=<%= request.getParameter("id") != null ? request.getParameter("id") : "1" %>" class="btn btn-primary w-full text-lg py-4 mb-4">
                    Book This Trip
                </a>
            </div>

            <div class="info-card">
                <h3 class="font-bold text-xl mb-4 text-main">What's Included</h3>
                <div class="flex flex-col gap-3">
                    <div class="flex items-center gap-3 text-muted">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        Accommodation
                    </div>
                    <div class="flex items-center gap-3 text-muted">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        Daily Breakfast
                    </div>
                    <div class="flex items-center gap-3 text-muted">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        Airport Transfers
                    </div>
                    <div class="flex items-center gap-3 text-muted">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        Sightseeing
                    </div>
                </div>
            </div>

            <!-- Estimated Budget Breakdown -->
            <div class="info-card">
                <h3 class="font-bold text-xl mb-4 text-main">Estimated Budget</h3>
                <div class="flex flex-col gap-3">
                    <div class="flex justify-between items-center text-sm">
                        <span class="text-muted">Flights / Train</span>
                        <span class="font-bold text-main">₹8,000</span>
                    </div>
                    <div class="flex justify-between items-center text-sm">
                        <span class="text-muted">Accommodation</span>
                        <span class="font-bold text-main">₹10,000</span>
                    </div>
                    <div class="flex justify-between items-center text-sm">
                        <span class="text-muted">Activities & Food</span>
                        <span class="font-bold text-main">₹6,999</span>
                    </div>
                    <hr class="border-gray-200 dark:border-gray-700 my-2">
                    <div class="flex justify-between items-center">
                        <span class="font-bold text-main">Total (Approx)</span>
                        <span class="font-bold text-accent text-lg">₹24,999</span>
                    </div>
                </div>
            </div>

            <!-- Hotel Suggestions -->
            <div class="info-card">
                <h3 class="font-bold text-xl mb-4 text-main">Suggested Stays</h3>
                <div class="flex flex-col gap-4">
                    <a href="${pageContext.request.contextPath}/hotel-details.jsp?id=demo1" class="flex items-center gap-3 hover:bg-gray-50 dark:hover:bg-gray-800 p-2 rounded-lg transition" style="text-decoration:none;">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=80&h=80&q=75" alt="Luxury Resort" class="w-16 h-16 rounded-lg object-cover" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                        <div>
                            <h4 class="font-bold text-sm text-main">The Royal Heritage Resort</h4>
                            <p class="text-xs text-muted mb-1">★★★★★ • Premium</p>
                            <span class="text-xs font-bold text-primary">₹5,500/night</span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/hotel-details.jsp?id=demo2" class="flex items-center gap-3 hover:bg-gray-50 dark:hover:bg-gray-800 p-2 rounded-lg transition" style="text-decoration:none;">
                        <img src="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=80&h=80&q=75" alt="Boutique Stay" class="w-16 h-16 rounded-lg object-cover" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                        <div>
                            <h4 class="font-bold text-sm text-main">Boutique Valley Stay</h4>
                            <p class="text-xs text-muted mb-1">★★★★ • Comfort</p>
                            <span class="text-xs font-bold text-primary">₹3,200/night</span>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Transport Suggestions -->
            <div class="info-card">
                <h3 class="font-bold text-xl mb-4 text-main">Getting Around</h3>
                <div class="flex flex-col gap-3 text-sm text-muted">
                    <div class="flex items-start gap-3">
                        <i class="fas fa-plane text-primary mt-1"></i>
                        <p><strong>Nearest Airport:</strong> International Airport (45 mins away). <a href="${pageContext.request.contextPath}/transport/flight-search" class="text-accent hover:underline">Book flights</a></p>
                    </div>
                    <div class="flex items-start gap-3">
                        <i class="fas fa-train text-primary mt-1"></i>
                        <p><strong>Train:</strong> Central Railway Station connects to all major cities.</p>
                    </div>
                    <div class="flex items-start gap-3">
                        <i class="fas fa-car text-primary mt-1"></i>
                        <p><strong>Local Cabs:</strong> Pre-book daily cabs directly through Voyastra for seamless travel.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    /* ============================================================
     *  Destination Details – Action Button Logic
     *
     *  Servlet contract:  POST /api/destination/save
     *    Required params: destination_id=<int>  action=save|remove
     *    Auth:            session attribute "user" must exist
     *    Responses:
     *      {"success":true}                              → saved (new or duplicate)
     *      {"success":false,"message":"Unauthorized"}    → HTTP 401
     *      {"success":false,"message":"Missing parameters"} → HTTP 400
     *      {"success":false,"message":"Invalid ID"}      → HTTP 400
     *      {"success":false}                             → DB error
     * ============================================================ */
    (function () {
        'use strict';

        var ctx    = window.CONTEXT_PATH || '';
        var destId = '${destination.id}';

        /* ── VoyastraToast helper ──────────────────────────────────────────────
         * Calls window.VoyastraToast.show() directly.
         * Falls back to console only — never uses toast() / toast.success().
         * --------------------------------------------------------------------- */
        function showToast(msg, type) {
            type = type || 'info';
            if (window.VoyastraToast && typeof window.VoyastraToast.show === 'function') {
                window.VoyastraToast.show(msg, type);
            } else {
                console.info('[VoyastraToast ' + type + ']', msg);
                /* Only surface blocking alert for hard errors when toast unavailable */
                if (type === 'error') {
                    alert(msg);
                }
            }
        }

        /* ================================================================
         *  BUTTON 1: VIEW ITINERARY
         *  Navigates to /planner, optionally pre-seeding the destination.
         * ================================================================ */
        var btnItinerary = document.getElementById('btn-view-itinerary');
        if (btnItinerary) {
            btnItinerary.addEventListener('click', function () {
                try {
                    var url = ctx + '/planner';
                    if (destId && destId !== '' && destId !== '0') {
                        url += '?destinationId=' + encodeURIComponent(destId);
                    }
                    window.location.href = url;
                } catch (e) {
                    console.error('[ViewItinerary]', e);
                    showToast('Navigation error: ' + e.message, 'error');
                }
            });
        }

        /* ================================================================
         *  BUTTON 2: SAVE TRIP
         *
         *  POST /api/destination/save
         *  Body (application/x-www-form-urlencoded):
         *    destination_id=<destId>&action=save
         *
         *  Response handling:
         *    HTTP 401 → not logged in  → redirect to login
         *    HTTP 400 → bad request    → show error message from server
         *    HTTP 200 + success:true   → saved (new or already existed)
         *    HTTP 200 + success:false  → DB error
         *
         *  State persistence: localStorage key voyastra_saved_<destId>
         *  ensures "Saved ✓" survives page refresh without an extra server call.
         * ================================================================ */
        var btnSave = document.getElementById('btn-save-trip');
        var lblSave = document.getElementById('save-trip-label');
        var lsKey   = 'voyastra_saved_' + destId;

        /* Update visual state of the Save button */
        function setSavedAppearance(isSaved) {
            if (!btnSave || !lblSave) return;
            if (isSaved) {
                lblSave.textContent          = 'Saved \u2713';
                btnSave.disabled             = true;
                btnSave.style.borderColor    = 'rgba(0,184,148,0.4)';
                btnSave.style.color          = '#00b894';
                btnSave.style.cursor         = 'default';
                btnSave.title                = 'Already in your wishlist';
            } else {
                lblSave.textContent          = 'Save Trip';
                btnSave.disabled             = false;
                btnSave.style.borderColor    = '';
                btnSave.style.color          = '';
                btnSave.style.cursor         = '';
                btnSave.title                = '';
            }
        }

        /* Restore saved state on page load without a server round-trip */
        if (localStorage.getItem(lsKey) === '1') {
            setSavedAppearance(true);
        }

        if (btnSave) {
            btnSave.addEventListener('click', async function () {
                /* Guard: must have a valid destination ID */
                if (!destId || destId === '' || destId === '0') {
                    showToast('Destination ID is not available.', 'error');
                    return;
                }

                /* Disable button immediately to prevent double-submit */
                btnSave.disabled = true;
                var prevLabel    = lblSave ? lblSave.textContent : '';
                if (lblSave) lblSave.textContent = 'Saving\u2026';

                try {
                    /* Build request body exactly as SaveDestinationServlet expects */
                    var params = new URLSearchParams();
                    params.append('destination_id', destId);   /* required: integer ID  */
                    params.append('action', 'save');            /* required: 'save'      */

                    var response = await fetch(ctx + '/api/destination/save', {
                        method:  'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body:    params.toString()
                    });

                    /* ── HTTP 401: not logged in ──────────────────────────────── */
                    if (response.status === 401) {
                        showToast('Please log in to save trips.', 'error');
                        /* Redirect to login, returning to current page after auth */
                        var redirect = encodeURIComponent(window.location.pathname + window.location.search);
                        window.location.href = ctx + '/login?redirect=' + redirect;
                        return;
                    }

                    /* ── HTTP 400: bad request ────────────────────────────────── */
                    if (response.status === 400) {
                        var errData = await response.json().catch(function () { return {}; });
                        showToast(errData.message || 'Invalid request.', 'error');
                        return;
                    }

                    /* ── Any other non-2xx ────────────────────────────────────── */
                    if (!response.ok) {
                        showToast('Server error (' + response.status + '). Please try again.', 'error');
                        return;
                    }

                    /* ── HTTP 200: parse JSON body ────────────────────────────── */
                    var data = await response.json();

                    if (data.success) {
                        /* Both "first save" and "already in wishlist" land here */
                        localStorage.setItem(lsKey, '1');
                        setSavedAppearance(true);   /* shows "Saved ✓" and disables button */
                        window.VoyastraToast && window.VoyastraToast.show('Trip saved to your wishlist!', 'success');
                    } else {
                        /* DB error — server returned {"success":false} */
                        showToast(data.message || 'Could not save trip. Please try again.', 'error');
                        /* Re-enable the button so the user can retry */
                        btnSave.disabled = false;
                        if (lblSave) lblSave.textContent = prevLabel;
                    }

                } catch (networkErr) {
                    /* Network / JSON parse failure */
                    console.error('[SaveTrip] Network error:', networkErr);
                    showToast('Network error — please check your connection and try again.', 'error');
                    btnSave.disabled = false;
                    if (lblSave) lblSave.textContent = prevLabel;
                }
                /* Note: finally is intentionally omitted — setSavedAppearance(true)
                 * already disables the button permanently on success.            */
            });
        }

        /* ================================================================
         *  BUTTON 3: SHARE TRIP
         *  Uses native Web Share API (mobile) with clipboard fallback.
         * ================================================================ */
        var btnShare = document.getElementById('btn-share-trip');
        if (btnShare) {
            btnShare.addEventListener('click', async function () {
                try {
                    var shareData = {
                        title: document.title || 'Voyastra \u2013 Trip Details',
                        text:  'Check out this amazing trip on Voyastra!',
                        url:   window.location.href
                    };

                    if (navigator.share && navigator.canShare && navigator.canShare(shareData)) {
                        await navigator.share(shareData);
                        window.VoyastraToast && window.VoyastraToast.show('Shared successfully!', 'success');
                    } else {
                        await navigator.clipboard.writeText(window.location.href);
                        window.VoyastraToast && window.VoyastraToast.show('Link copied to clipboard!', 'success');
                    }
                } catch (e) {
                    if (e.name === 'AbortError') return; /* user dismissed native share sheet */
                    console.error('[ShareTrip]', e);
                    try {
                        await navigator.clipboard.writeText(window.location.href);
                        window.VoyastraToast && window.VoyastraToast.show('Link copied to clipboard!', 'success');
                    } catch (clipErr) {
                        showToast('Copy this link manually: ' + window.location.href, 'info');
                    }
                }
            });
        }

    })();
</script>
<%@ include file="/components/footer.jsp" %>


