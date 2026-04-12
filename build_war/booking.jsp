<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="components/header.jsp" %>

<%@ include file="components/global_ui.jsp" %>

<main style="padding-top: 80px; padding-bottom: 60px; overflow-x: hidden;">

    <!-- ===== MMT-STYLE BOOKING HERO ===== -->
    <div class="booking-hero-section" style="padding: 28px 0 0;">
        <div class="container">

            <!-- MASTER BOOKING WIDGET -->
            <div class="booking-widget-wrapper" style="background: var(--color-surface); backdrop-filter: blur(20px); border-radius: 12px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); overflow: hidden; margin-bottom: 32px;">

                <!-- Tab Bar (MMT Style - horizontal, tight) -->
                <div class="booking-tab-bar" style="display: flex; align-items: center; overflow-x: auto; border-bottom: 2px solid var(--color-border); padding: 0 8px; background: rgba(255,255,255,0.03);">
                    <button class="booking-tab active" data-form="form-flights" onclick="switchTab(this, 'form-flights')">
                        <span class="tab-icon">✈️</span><span class="tab-label">Flights</span>
                    </button>
                    <button class="booking-tab" data-form="form-hotels" onclick="switchTab(this, 'form-hotels')">
                        <span class="tab-icon">🏨</span><span class="tab-label">Hotels</span>
                    </button>
                    <button class="booking-tab" data-form="form-hotels" onclick="switchTab(this, 'form-hotels')">
                        <span class="tab-icon">🏡</span><span class="tab-label">Homestays</span>
                    </button>
                    <button class="booking-tab" data-form="form-trains" onclick="switchTab(this, 'form-trains')">
                        <span class="tab-icon">🚆</span><span class="tab-label">Trains</span>
                    </button>
                    <button class="booking-tab" data-form="form-trains" onclick="switchTab(this, 'form-trains')">
                        <span class="tab-icon">🚌</span><span class="tab-label">Buses</span>
                    </button>
                    <button class="booking-tab" data-form="form-trains" onclick="switchTab(this, 'form-trains')">
                        <span class="tab-icon">🚖</span><span class="tab-label">Cabs</span>
                    </button>
                    <button class="booking-tab" data-form="form-activities" onclick="switchTab(this, 'form-activities')">
                        <span class="tab-icon">🎟️</span><span class="tab-label">Tours</span>
                    </button>
                    <button class="booking-tab" data-form="form-activities" onclick="switchTab(this, 'form-activities')">
                        <span class="tab-icon">🌍</span><span class="tab-label">Packages</span>
                    </button>
                </div>

                <!-- Search Forms Area -->
                <div style="padding: 20px 24px 24px;">

                    <!-- FLIGHTS FORM -->
                    <div id="form-flights" class="booking-form active">
                        <div class="trip-type-row" style="display: flex; gap: 20px; margin-bottom: 14px;">
                            <label class="radio-label"><input type="radio" name="tripType" value="one-way" checked> One Way</label>
                            <label class="radio-label"><input type="radio" name="tripType" value="round-trip"> Round Trip</label>
                            <label class="radio-label"><input type="radio" name="tripType" value="multi-city"> Multi-City</label>
                        </div>
                        <div class="search-fields-row">
                            <div class="search-field">
                                <div class="field-label">From</div>
                                <div class="field-value">Delhi</div>
                                <div class="field-sub">DEL, Indira Gandhi Intl</div>
                            </div>
                            <div class="swap-btn" title="Swap" onclick="swapFields()">⇄</div>
                            <div class="search-field">
                                <div class="field-label">To</div>
                                <div class="field-value">Mumbai</div>
                                <div class="field-sub">BOM, Chhatrapati Shivaji Intl</div>
                            </div>
                            <div class="search-field">
                                <div class="field-label">Departure</div>
                                <div class="field-value">10 Apr <span style="font-size:1rem;font-weight:600;">2026</span></div>
                                <div class="field-sub">Friday</div>
                            </div>
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">Travellers &amp; Class</div>
                                <div class="field-value">1 Adult</div>
                                <div class="field-sub">Economy</div>
                            </div>
                            <button class="search-cta-btn">SEARCH</button>
                        </div>
                    </div>

                    <!-- HOTELS FORM -->
                    <div id="form-hotels" class="booking-form">
                        <div class="trip-type-row" style="display: flex; gap: 20px; margin-bottom: 14px;">
                            <label class="radio-label"><input type="radio" name="hotelType" value="rooms" checked> Upto 4 Rooms</label>
                            <label class="radio-label"><input type="radio" name="hotelType" value="group"> Group Booking</label>
                        </div>
                        <div class="search-fields-row">
                            <div class="search-field" style="flex: 2;">
                                <div class="field-label">City, Property Name or Location</div>
                                <div class="field-value">Jaipur</div>
                                <div class="field-sub">Rajasthan, India</div>
                            </div>
                            <div class="search-field">
                                <div class="field-label">Check-In</div>
                                <div class="field-value">15 May <span style="font-size:1rem;">2026</span></div>
                                <div class="field-sub">Thursday</div>
                            </div>
                            <div class="search-field">
                                <div class="field-label">Check-Out</div>
                                <div class="field-value">18 May <span style="font-size:1rem;">2026</span></div>
                                <div class="field-sub">3 Nights</div>
                            </div>
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">Rooms &amp; Guests</div>
                                <div class="field-value">1 Room</div>
                                <div class="field-sub">2 Adults</div>
                            </div>
                            <button class="search-cta-btn">SEARCH</button>
                        </div>
                    </div>

                    <!-- TRAINS / BUSES / CABS FORM -->
                    <div id="form-trains" class="booking-form">
                        <div class="search-fields-row">
                            <div class="search-field">
                                <div class="field-label">From</div>
                                <div class="field-value">New Delhi</div>
                                <div class="field-sub">NDLS</div>
                            </div>
                            <div class="swap-btn" title="Swap">⇄</div>
                            <div class="search-field">
                                <div class="field-label">To</div>
                                <div class="field-value">Jaipur</div>
                                <div class="field-sub">JP</div>
                            </div>
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">Travel Date</div>
                                <div class="field-value">12 Apr <span style="font-size:1rem;">2026</span></div>
                                <div class="field-sub">Sunday</div>
                            </div>
                            <button class="search-cta-btn">SEARCH</button>
                        </div>
                    </div>

                    <!-- TOURS / PACKAGES FORM -->
                    <div id="form-activities" class="booking-form">
                        <div class="search-fields-row">
                            <div class="search-field" style="flex: 2;">
                                <div class="field-label">Destination / Activity</div>
                                <div class="field-value">Goa</div>
                                <div class="field-sub">India</div>
                            </div>
                            <div class="search-field" style="border-right: none;">
                                <div class="field-label">When</div>
                                <div class="field-value">18 May <span style="font-size:1rem;">2026</span></div>
                                <div class="field-sub">Flexible</div>
                            </div>
                            <button class="search-cta-btn">SEARCH</button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- ===== RESULTS & MAP SECTION ===== -->
    <div class="container flex flex-col lg:flex-row gap-8" style="padding-bottom: 60px;">
        
        <!-- Left Side: Results -->
        <div class="flex-1" style="min-width: 0;">

        <!-- TRANSPORT OPTIONS -->
        <div class="results-section">
            <div class="results-header">
                <h2 class="results-title">
                    <c:choose>
                        <c:when test="${not empty searchOrigin && not empty searchDestination}">
                            Transportation: <c:out value="${searchOrigin}"/> ➔ <c:out value="${searchDestination}"/>
                        </c:when>
                        <c:otherwise>
                            Transportation Options
                        </c:otherwise>
                    </c:choose>
                </h2>
                <a href="#" class="results-view-all">View all →</a>
            </div>
            <div class="results-grid results-grid-3" data-skeleton="card" data-skeleton-count="3">

                <c:choose>
                    <c:when test="${not empty transports}">
                        <c:forEach items="${transports}" var="t">
                            <div class="result-card">
                                <div class="result-card-header">
                                    <div class="airline-info">
                                        <c:set var="logoStyle" value=""/>
                                        <c:if test="${t.type eq 'train'}"><c:set var="logoStyle" value="background: var(--color-accent);"/></c:if>
                                        <c:if test="${t.type eq 'cab' || t.type eq 'bus'}"><c:set var="logoStyle" value="background: #374151; font-size: 1.1rem;"/></c:if>
                                        <div class="airline-logo" style="<c:out value='${logoStyle}'/>">
                                            <c:out value="${t.companyLogo}"/>
                                        </div>
                                        <div>
                                            <div class="airline-name"><c:out value="${t.companyName}"/></div>
                                            <div class="flight-num"><c:out value="${t.transportNumber}"/></div>
                                        </div>
                                    </div>
                                    <c:if test="${not empty t.badge}">
                                        <span class="result-badge <c:out value="${t.badge.toLowerCase()}"/>"><c:out value="${t.badge}"/></span>
                                    </c:if>
                                </div>

                                <c:choose>
                                    <c:when test="${t.type == 'cab' || t.type == 'bus'}">
                                        <div style="text-align: center; padding: 16px 0; border-bottom: 1px solid var(--color-border);">
                                            <div class="font-bold text-main" style="font-size: 1rem;">
                                                <c:out value="${t.originCode}"/> → <c:out value="${t.destinationCode}"/>
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--color-muted); margin-top: 4px;">
                                                <c:out value="${t.duration}"/>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="flight-times">
                                            <div class="time-block">
                                                <div class="time"><c:out value="${t.departureTime}"/></div>
                                                <div class="airport"><c:out value="${t.originCode}"/></div>
                                            </div>
                                            <div class="flight-duration">
                                                <div class="duration-line"></div>
                                                <div class="duration-text"><c:out value="${t.duration}"/></div>
                                            </div>
                                            <div class="time-block">
                                                <div class="time"><c:out value="${t.arrivalTime}"/></div>
                                                <div class="airport"><c:out value="${t.destinationCode}"/></div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="result-card-footer">
                                    <div class="result-price">₹<fmt:formatNumber value="${t.price}" type="number" groupingUsed="true"/></div>
                                    <button class="btn-select" onclick="VoyastraAuth.requireAuth('booking.jsp')">Select</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="vx-empty-state">
                            <div class="vx-empty-icon">🚆</div>
                            <h3 class="vx-empty-title">No routes available</h3>
                            <p class="vx-empty-desc">We couldn't find any transport options for this specific route. Try selecting another destination.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

        <!-- TOP STAYS -->
        <div class="results-section">
            <div class="results-header">
                <h2 class="results-title">
                    <c:choose>
                        <c:when test="${not empty searchLocation}">
                            Top Recommended Stays in <c:out value="${searchLocation}"/>
                        </c:when>
                        <c:otherwise>
                            Top Recommended Stays
                        </c:otherwise>
                    </c:choose>
                </h2>
                <a href="#" class="results-view-all">View all →</a>
            </div>
            <div class="results-grid results-grid-2" data-skeleton="card" data-skeleton-count="2">
                <c:choose>
                    <c:when test="${not empty stays}">
                        <c:forEach items="${stays}" var="s">
                            <div class="stay-card result-card" style="display: flex; flex-direction: row; padding: 0; overflow: hidden;">
                                <img src="${s.imageUrl}" alt="${s.name}" class="stay-card-img">
                                <div class="stay-card-body">
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 4px;">
                                        <h4 class="stay-name">${s.name}</h4>
                                        <c:if test="${not empty s.badge}">
                                            <span class="result-badge" style="background: ${s.type == 'villa' ? 'var(--color-accent)' : 'var(--color-primary)'};">
                                                ${s.badge}
                                            </span>
                                        </c:if>
                                    </div>
                                    <p class="stay-location">📍 ${s.location}</p>
                                    <ul class="stay-amenities">
                                        <c:forEach items="${s.amenities.split(',')}" var="amenity">
                                            <li>${amenity.trim()}</li>
                                        </c:forEach>
                                    </ul>
                                    <div class="stay-footer">
                                        <div>
                                            <c:if test="${s.originalPrice > s.discountedPrice}">
                                                <div class="original-price">₹<fmt:formatNumber value="${s.originalPrice}" groupingUsed="true"/></div>
                                            </c:if>
                                            <div class="discounted-price" style="${s.type == 'villa' ? 'color: var(--color-accent);' : ''}">₹<fmt:formatNumber value="${s.discountedPrice}" groupingUsed="true"/></div>
                                            <div style="font-size: 0.72rem; color: var(--color-muted);">${s.priceNote}</div>
                                        </div>
                                        <button class="btn-book" style="${s.type == 'villa' ? 'background: var(--color-accent);' : ''}" onclick="VoyastraAuth.requireAuth('booking.jsp')">
                                            Book ${s.type == 'villa' ? 'Villa' : 'Now'}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="vx-empty-state">
                            <div class="vx-empty-icon">🏨</div>
                            <h3 class="vx-empty-title">No stays found</h3>
                            <p class="vx-empty-desc">We don't have any recommended stays for this location yet. Check back soon for hand-picked villas and hotels.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- ACTIVITIES -->
        <div class="results-section" style="margin-bottom: 16px;">
            <div class="results-header">
                <h2 class="results-title">Things to Do in <c:out value="${destinationName != null ? destinationName : 'Local Areas'}" /></h2>
                <a href="#" class="results-view-all">View all →</a>
            </div>
            <div class="results-grid results-grid-4" data-skeleton="trending" data-skeleton-count="4">

                <c:choose>
                    <c:when test="${not empty activities}">
                        <c:forEach items="${activities}" var="activity">
                            <div class="activity-card" onclick="location.href='activity-details.jsp?id=${activity.id}'">
                                <div class="activity-img-wrap">
                                    <img src="${activity.imageUrl}" alt="${activity.name}">
                                </div>
                                <div class="activity-info">
                                    <h5 class="activity-name">${activity.name}</h5>
                                    <div class="activity-rating">⭐ ${activity.rating} <span style="color: var(--color-muted); font-weight: 400;">(${activity.reviewsCount} reviews)</span></div>
                                    <div class="activity-price">₹${activity.price} <span>/ person</span></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="vx-empty-state">
                            <div class="vx-empty-icon">🎟️</div>
                            <h3 class="vx-empty-title">No activities found</h3>
                            <p class="vx-empty-desc">Explore other regions to find exciting tours, treks, and cultural experiences.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
            </div>
        </div>

        </div> <!-- End Left Side Results -->

        <!-- Right Side: Mini Map Sidebar -->
        <div class="w-full lg:w-1/3 xl:w-1/4 hidden lg:block">
            <div class="sticky glass-panel slide-up delay-2" style="top: 120px; padding: 0; overflow: hidden; border-radius: 16px; border: 1px solid var(--color-border); box-shadow: var(--shadow-md);">
                <div id="bookingMiniMap" style="width: 100%; height: 350px; background: #e5e3df;"></div>
                <div class="p-4" style="border-top: 1px solid var(--color-border); background: var(--surface-glass); backdrop-filter: blur(12px);">
                    <h5 class="text-main mb-1 editorial" style="font-size: 1.15rem; font-weight: 700;">Route Preview</h5>
                    <div class="flex justify-between items-center mb-4">
                        <span class="text-sm font-bold tracking-wide text-main">DEL ✈ BOM</span>
                        <span id="miniMapDist" class="text-sm text-primary font-bold">1,148 km</span>
                    </div>
                    <a href="route.jsp" class="btn btn-secondary w-full flex justify-center items-center" style="padding: 10px; font-size: 0.85rem;">
                        View Full Navigation ➔
                    </a>
                </div>
            </div>
        </div>

    </div> <!-- End Container flex -->
</main>

<script>
// Booking Mini Map Setup
function initMiniMap() {
    if (typeof google === 'undefined') return;
    
    // Custom darkish map styling
    const customMapStyle = [
      { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
      { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
      { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] },
      { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] }
    ];

    const map = new google.maps.Map(document.getElementById("bookingMiniMap"), {
        zoom: 4,
        center: { lat: 20.5937, lng: 78.9629 }, // India Map Center
        disableDefaultUI: true,
        styles: document.documentElement.getAttribute('data-theme') === 'dark' ? customMapStyle : []
    });

    const dirServ = new google.maps.DirectionsService();
    const dirRen = new google.maps.DirectionsRenderer({
        map: map,
        suppressMarkers: false,
        polylineOptions: { strokeColor: '#d4a574', strokeWeight: 4 }
    });

    dirServ.route({
        origin: "New Delhi, India",
        destination: "Mumbai, India",
        travelMode: google.maps.TravelMode.FLIGHT || google.maps.TravelMode.DRIVING 
    }, (resp, stat) => {
        if (stat === "OK") {
            dirRen.setDirections(resp);
            document.getElementById('miniMapDist').innerText = resp.routes[0].legs[0].distance.text;
        }
    });
}
// Request the centralized script to load Google Maps and call initMiniMap when ready
window.addEventListener('DOMContentLoaded', () => {
    if (typeof loadGoogleMaps === 'function') {
        loadGoogleMaps('initMiniMap');
    }
});
</script>

<style>
/* ===========================
   BOOKING PAGE — DESIGN SYSTEM
   =========================== */

/* --- TAB BAR --- */
.booking-tab-bar {
    display: flex;
    gap: 0;
    overflow-x: auto;
    scrollbar-width: none;
}
.booking-tab-bar::-webkit-scrollbar { display: none; }

.booking-tab {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    padding: 12px 20px 10px;
    background: none;
    border: none;
    border-bottom: 3px solid transparent;
    cursor: pointer;
    white-space: nowrap;
    transition: all 0.2s ease;
    color: var(--color-muted);
    font-size: 0.8rem;
    font-weight: 600;
    letter-spacing: 0.01em;
}
.booking-tab .tab-icon { font-size: 1.4rem; line-height: 1; }
.booking-tab:hover { color: var(--color-primary); border-bottom-color: var(--color-primary); background: rgba(255,255,255,0.04); }
.booking-tab.active { color: var(--color-primary); border-bottom-color: var(--color-primary); }

/* --- FORMS --- */
.booking-form { display: none; }
.booking-form.active { display: block; }

.trip-type-row label { font-size: 0.85rem; color: var(--color-muted); cursor: pointer; }
.trip-type-row input { accent-color: var(--color-primary); margin-right: 5px; }

/* --- SEARCH FIELDS ROW (MMT horizontal layout) --- */
.search-fields-row {
    display: flex;
    align-items: stretch;
    gap: 0;
    background: var(--color-surface);
    border: 1.5px solid var(--color-border);
    border-radius: 8px;
    overflow: hidden;
}

.search-field {
    display: flex;
    flex-direction: column;
    justify-content: center;
    flex: 1;
    padding: 12px 16px;
    cursor: pointer;
    border-right: 1.5px solid var(--color-border);
    transition: background 0.15s ease;
    min-width: 140px;
}
.search-field:hover { background: rgba(255,255,255,0.05); }

.field-label {
    font-size: 0.68rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: var(--color-muted);
    margin-bottom: 2px;
}
.field-value {
    font-size: 1.35rem;
    font-weight: 800;
    color: var(--color-main);
    line-height: 1.2;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.field-sub {
    font-size: 0.73rem;
    color: var(--color-muted);
    margin-top: 1px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* Swap Button */
.swap-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    min-width: 36px;
    font-size: 1.1rem;
    cursor: pointer;
    color: var(--color-primary);
    border-right: 1.5px solid var(--color-border);
    transition: all 0.2s ease;
    background: rgba(255,255,255,0.03);
}
.swap-btn:hover { background: var(--color-primary); color: #fff; }

/* Search CTA Button */
.search-cta-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 14px 28px;
    background: var(--color-primary);
    color: #fff;
    border: none;
    font-weight: 800;
    font-size: 0.9rem;
    letter-spacing: 0.08em;
    cursor: pointer;
    transition: all 0.2s ease;
    min-width: 120px;
    white-space: nowrap;
}
.search-cta-btn:hover { background: var(--color-accent); filter: brightness(1.05); }

/* ===========================
   RESULTS SECTION
   =========================== */
.results-section {
    margin-bottom: 36px;
}
.results-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16px;
    padding-bottom: 10px;
    border-bottom: 1.5px solid var(--color-border);
}
.results-title {
    font-family: 'Georgia', serif;
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--color-main);
    margin: 0;
}
.results-view-all {
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--color-primary);
    text-decoration: none;
    transition: opacity 0.2s;
}
.results-view-all:hover { opacity: 0.75; }

.results-grid { display: grid; gap: 16px; }
.results-grid-2 { grid-template-columns: repeat(2, 1fr); }
.results-grid-3 { grid-template-columns: repeat(3, 1fr); }
.results-grid-4 { grid-template-columns: repeat(4, 1fr); }

/* --- RESULT CARD --- */
.result-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: 10px;
    padding: 16px;
    transition: box-shadow 0.2s ease, transform 0.2s ease;
    backdrop-filter: blur(12px);
}
.result-card:hover {
    box-shadow: 0 6px 24px rgba(0,0,0,0.2);
    transform: translateY(-2px);
}

.result-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--color-border);
}
.airline-info { display: flex; align-items: center; gap: 10px; }
.airline-logo {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: var(--color-primary);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    font-size: 0.7rem;
    flex-shrink: 0;
}
.airline-name { font-weight: 700; font-size: 0.9rem; color: var(--color-main); }
.flight-num { font-size: 0.72rem; color: var(--color-muted); margin-top: 1px; }

.result-badge {
    font-size: 0.65rem;
    font-weight: 700;
    padding: 3px 8px;
    border-radius: 20px;
    color: #fff;
    background: var(--color-primary);
    white-space: nowrap;
}
.result-badge.fastest { background: #059669; }

.flight-times {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;
    padding: 8px 0;
}
.time-block { text-align: center; }
.time { font-size: 1.2rem; font-weight: 800; color: var(--color-main); }
.airport { font-size: 0.7rem; font-weight: 600; color: var(--color-muted); letter-spacing: 0.04em; }

.flight-duration {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 3px;
}
.duration-line {
    width: 100%;
    height: 1px;
    background: var(--color-border);
    position: relative;
}
.duration-line::before, .duration-line::after {
    content: '';
    position: absolute;
    top: -3px;
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--color-border);
}
.duration-line::before { left: 0; }
.duration-line::after { right: 0; }
.duration-text { font-size: 0.7rem; color: var(--color-muted); font-weight: 600; }

.result-card-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-top: 10px;
    border-top: 1px solid var(--color-border);
}
.result-price {
    font-size: 1.4rem;
    font-weight: 900;
    color: var(--color-primary);
}
.btn-select {
    padding: 7px 18px;
    border-radius: 20px;
    border: 1.5px solid var(--color-primary);
    background: transparent;
    color: var(--color-primary);
    font-weight: 700;
    font-size: 0.8rem;
    cursor: pointer;
    transition: all 0.2s ease;
}
.btn-select:hover { background: var(--color-primary); color: #fff; }

/* --- STAY CARDS --- */
.stay-card { min-height: 180px; }
.stay-card-img {
    width: 200px;
    min-width: 200px;
    height: 100%;
    object-fit: cover;
    border-radius: 0;
}
.stay-card-body {
    flex: 1;
    padding: 16px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}
.stay-name {
    font-size: 1rem;
    font-weight: 700;
    color: var(--color-main);
    margin: 0;
}
.stay-location {
    font-size: 0.78rem;
    color: var(--color-muted);
    margin: 4px 0 8px;
}
.stay-amenities {
    list-style: none;
    padding: 0;
    margin: 0 0 10px;
}
.stay-amenities li {
    font-size: 0.75rem;
    color: var(--color-muted);
    padding-left: 12px;
    position: relative;
    margin-bottom: 2px;
}
.stay-amenities li::before {
    content: '✓';
    position: absolute;
    left: 0;
    color: var(--color-primary);
    font-weight: 800;
}
.stay-footer {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    padding-top: 10px;
    border-top: 1px solid var(--color-border);
}
.original-price { font-size: 0.75rem; text-decoration: line-through; color: var(--color-muted); }
.discounted-price { font-size: 1.4rem; font-weight: 900; color: var(--color-primary); }
.btn-book {
    padding: 9px 20px;
    border-radius: 20px;
    border: none;
    background: var(--color-primary);
    color: #fff;
    font-weight: 700;
    font-size: 0.82rem;
    cursor: pointer;
    transition: all 0.2s ease;
}
.btn-book:hover { filter: brightness(1.1); transform: scale(1.03); }

/* --- ACTIVITY CARDS --- */
.activity-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: 10px;
    overflow: hidden;
    transition: box-shadow 0.2s ease, transform 0.2s ease;
    cursor: pointer;
}
.activity-card:hover {
    box-shadow: 0 8px 24px rgba(0,0,0,0.18);
    transform: translateY(-3px);
}
.activity-img-wrap { width: 100%; aspect-ratio: 16/9; overflow: hidden; }
.activity-img-wrap img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s ease; }
.activity-card:hover .activity-img-wrap img { transform: scale(1.06); }
.activity-info { padding: 12px; }
.activity-name { font-size: 0.88rem; font-weight: 700; color: var(--color-main); margin: 0 0 4px; }
.activity-rating { font-size: 0.75rem; font-weight: 600; color: var(--color-accent); margin-bottom: 4px; }
.activity-price { font-size: 0.95rem; font-weight: 800; color: var(--color-primary); }
.activity-price span { font-size: 0.72rem; font-weight: 400; color: var(--color-muted); }

/* ===========================
   RESPONSIVE
   =========================== */
@media (max-width: 1024px) {
    .results-grid-4 { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
    .search-fields-row { flex-direction: column; border-radius: 8px; }
    .search-field { border-right: none; border-bottom: 1.5px solid var(--color-border); }
    .search-field:last-child { border-bottom: none; }
    .swap-btn { display: none; }
    .search-cta-btn { width: 100%; padding: 16px; border-radius: 0; }
    .results-grid-2, .results-grid-3 { grid-template-columns: 1fr; }
    .results-grid-4 { grid-template-columns: repeat(2, 1fr); }
    .stay-card { flex-direction: column !important; }
    .stay-card-img { width: 100% !important; min-width: unset !important; height: 180px !important; }
    .booking-tab { padding: 10px 14px 8px; }
    .booking-tab .tab-label { font-size: 0.7rem; }
}
@media (max-width: 480px) {
    .results-grid-4 { grid-template-columns: 1fr; }
    .field-value { font-size: 1.15rem; }
}
</style>

<script>
    // Theme persistence
    if (localStorage.getItem('theme') === 'theme-light') {
        document.body.classList.add('theme-light');
    }

    // Tab switcher
    function switchTab(clickedTab, targetFormId) {
        // Update active tab
        document.querySelectorAll('.booking-tab').forEach(t => t.classList.remove('active'));
        clickedTab.classList.add('active');

        // Hide all forms
        document.querySelectorAll('.booking-form').forEach(f => f.classList.remove('active'));

        // Show target form
        const form = document.getElementById(targetFormId);
        if (form) form.classList.add('active');
    }

    // Swap from/to fields (Flights)
    function swapFields() {
        // Simple visual swap for demo
        const fromVal = document.querySelector('#form-flights .search-field:first-child .field-value');
        const toVal = document.querySelector('#form-flights .search-field:nth-child(3) .field-value');
        if (fromVal && toVal) {
            const tmp = fromVal.textContent;
            fromVal.textContent = toVal.textContent;
            toVal.textContent = tmp;
        }
    }
</script>
</body>
</html>
