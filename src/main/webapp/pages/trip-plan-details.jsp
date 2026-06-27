<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.voyastra.dao.TripDAO, com.voyastra.model.PremiumTrip" %>
<%
    String idParam = request.getParameter("id");
    PremiumTrip trip = null;
    if (idParam != null && !idParam.isEmpty()) {
        try {
            int id = Integer.parseInt(idParam);
            TripDAO dao = new TripDAO();
            trip = dao.getTripById(id);
        } catch (Exception e) {}
    }
    request.setAttribute("trip", trip);
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<!-- Main Content Area -->
<main class="trip-detail-page">
    
    <!-- Premium Hero Section -->
    <section class="trip-hero relative flex items-center justify-center" style="min-height: 70vh; overflow: hidden;">
        <div class="absolute w-full h-full" style="z-index: -1;">
            <img src="${empty trip.imageUrl ? 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format,compress&fit=crop&w=1920&q=80' : trip.imageUrl}" alt="${empty trip.title ? 'Premium Adventure Trip' : trip.title}" style="width: 100%; height: 100%; object-fit: cover; filter: brightness(0.6);" />
        </div>
        <div class="container text-center slide-up" style="z-index: 10; margin-top: 80px;">
            <p class="meta-location text-uppercase tracking-widest text-primary fw-bold mb-2">${empty trip.category ? 'Adventure' : trip.category} • ${empty trip.destination ? 'Exotic Location' : trip.destination}</p>
            <h1 class="section-title text-white" style="font-size: clamp(2.5rem, 6vw, 4.5rem); text-shadow: 0 4px 20px rgba(0,0,0,0.6);">${empty trip.title ? 'Premium Adventure Trip' : trip.title}</h1>
            <p class="section-subtitle text-white opacity-80" style="max-width: 600px; margin: 0 auto; font-size: 1.1rem;">${empty trip.shortDescription ? 'Experience the trip of a lifetime with our carefully curated itinerary through the most beautiful landscapes.' : trip.shortDescription}</p>
            <!-- Star Rating -->
            <div class="mt-3" style="display:inline-flex;align-items:center;gap:8px;background:rgba(0,0,0,0.4);padding:8px 16px;border-radius:20px;">
                <c:set var="ratingVal" value="${empty trip.rating ? 4.8 : trip.rating}" />
                <c:forEach begin="1" end="5" var="star">
                    <c:choose>
                        <c:when test="${star <= ratingVal}">
                            <span style="color:#f1c40f;font-size:1.1rem;">★</span>
                        </c:when>
                        <c:when test="${star - 0.5 <= ratingVal}">
                            <span style="color:#f1c40f;font-size:1.1rem;">★</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:rgba(255,255,255,0.3);font-size:1.1rem;">★</span>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <span class="text-white fw-bold" style="font-size:0.9rem;">${ratingVal}/5</span>
                <span class="text-white opacity-60" style="font-size:0.8rem;">(124 reviews)</span>
            </div>
        </div>
    </section>

    <!-- Trip Overview & Booking Widget -->
    <section class="container" style="margin-top: -60px; position: relative; z-index: 20;">
        <div class="glass-panel p-5 grid sm:grid-cols-2 md:grid-cols-4 gap-4 items-center slide-up" style="animation-delay: 0.2s;">
            <div class="text-center md:text-left">
                <span class="text-muted text-sm d-block">Duration</span>
                <strong class="text-main fw-bold" style="font-size: 1.1rem;">${empty trip.duration ? '5 Days, 4 Nights' : trip.duration}</strong>
            </div>
            <div class="text-center md:text-left">
                <span class="text-muted text-sm d-block">Best Season</span>
                <strong class="text-main fw-bold" style="font-size: 1.1rem;">${empty trip.bestSeason ? 'Sep to Mar' : trip.bestSeason}</strong>
            </div>
            <div class="text-center md:text-left">
                <span class="text-muted text-sm d-block">Starting City</span>
                <strong class="text-main fw-bold" style="font-size: 1.1rem;">${empty trip.startingCity ? 'New Delhi' : trip.startingCity}</strong>
            </div>
            <div class="text-center md:text-right">
                <p class="text-muted text-sm mb-1">Starting from</p>
                <c:set var="priceInrVal" value="${empty trip.priceInr ? 25000 : trip.priceInr}" />
                <c:set var="discPriceVal" value="${empty trip.discountPrice ? 20000 : trip.discountPrice}" />
                <c:if test="${priceInrVal > discPriceVal && discPriceVal > 0}">
                    <span class="text-muted text-sm" style="text-decoration:line-through;">₹<fmt:formatNumber value="${priceInrVal}" type="number" maxFractionDigits="0"/></span>
                </c:if>
                <div class="price-highlight mb-2">
                    <fmt:formatNumber value="${discPriceVal > 0 ? discPriceVal : priceInrVal}" type="currency" currencySymbol="₹" maxFractionDigits="0" />
                </div>
                <a href="${pageContext.request.contextPath}/trip/customize?id=${empty trip.id ? 1 : trip.id}" class="btn-primary w-full" style="padding: 12px 24px; border-radius: 8px; font-weight: 700;">Book Now →</a>
            </div>
        </div>
    </section>

    <div class="container grid md:grid-cols-3 gap-6" style="margin-top: 60px; margin-bottom: 40px;">
        <!-- Left Column: Details -->
        <div class="md:col-span-2">
            <!-- Description -->
            <div class="mb-5">
                <h2 class="section-title" style="font-size: 2rem;">Overview</h2>
                <p class="text-muted" style="line-height: 1.8; font-size: 1.05rem;">${empty trip.fullDescription ? 'This comprehensive package takes you through the most scenic routes and iconic landmarks. You will experience local culture, amazing cuisine, and breathtaking views perfectly organized by our experts.' : trip.fullDescription}</p>
            </div>

            <!-- Itinerary Timeline -->
            <div class="mb-5">
                <h2 class="section-title" style="font-size: 2rem;">Detailed Itinerary</h2>
                <div class="itinerary-wrapper mt-4">
                    <c:forEach var="day" items="${trip.itinerary}">
                        <div class="itinerary-day flex gap-4 mb-4">
                            <div class="day-badge flex items-center justify-center" style="min-width: 60px; height: 60px; background: rgba(212,165,116,0.1); border: 1px solid var(--color-primary); border-radius: 12px; color: var(--color-primary); font-weight: 700; flex-direction: column;">
                                <span class="text-xs uppercase">Day</span>
                                <span class="text-lg">${day.dayNumber}</span>
                            </div>
                            <div class="day-content p-4 w-full" style="background: var(--surface-light); border-radius: 12px; border: 1px solid var(--color-border);">
                                <h4 class="text-main fw-bold mb-2">${day.title}</h4>
                                <p class="text-muted text-sm">${day.details}</p>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty trip.itinerary}">
                        <div class="itinerary-day flex gap-4 mb-4">
                            <div class="day-badge flex items-center justify-center" style="min-width: 60px; height: 60px; background: rgba(212,165,116,0.1); border: 1px solid var(--color-primary); border-radius: 12px; color: var(--color-primary); font-weight: 700; flex-direction: column;">
                                <span class="text-xs uppercase">Day</span>
                                <span class="text-lg">1</span>
                            </div>
                            <div class="day-content p-4 w-full" style="background: var(--surface-light); border-radius: 12px; border: 1px solid var(--color-border);">
                                <h4 class="text-main fw-bold mb-2">Arrival & Local Sightseeing</h4>
                                <p class="text-muted text-sm">Arrive at the destination, check-in to your premium accommodation, and enjoy a guided evening tour of the local highlights.</p>
                            </div>
                        </div>
                        <div class="itinerary-day flex gap-4 mb-4">
                            <div class="day-badge flex items-center justify-center" style="min-width: 60px; height: 60px; background: rgba(212,165,116,0.1); border: 1px solid var(--color-primary); border-radius: 12px; color: var(--color-primary); font-weight: 700; flex-direction: column;">
                                <span class="text-xs uppercase">Day</span>
                                <span class="text-lg">2</span>
                            </div>
                            <div class="day-content p-4 w-full" style="background: var(--surface-light); border-radius: 12px; border: 1px solid var(--color-border);">
                                <h4 class="text-main fw-bold mb-2">Adventure & Exploration</h4>
                                <p class="text-muted text-sm">Engage in thrilling adventure activities included in your package, followed by a cultural dinner experience.</p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Right Column: Inclusions & Booking -->
        <div class="sidebar">
            <div class="glass-panel p-5 mb-5 sticky" style="top: 100px;">
                <h3 class="fw-bold text-main mb-4" style="font-size: 1.3rem;">What's Included</h3>
                <ul class="inclusions-list" style="list-style: none; padding: 0;">
                    <c:forEach var="item" items="${trip.inclusions}">
                        <li class="flex items-center gap-2 mb-3 ${item.included ? 'text-main' : 'text-muted'}" style="${!item.included ? 'text-decoration: line-through; opacity: 0.6;' : ''}">
                            <c:if test="${item.included}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                            </c:if>
                            <c:if test="${!item.included}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                            </c:if>
                            <span style="font-weight: 500; font-size: 0.95rem;">${item.inclusionName}</span>
                        </li>
                    </c:forEach>
                    <c:if test="${empty trip.inclusions}">
                        <li class="flex items-center gap-2 mb-3 text-main">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                            <span style="font-weight: 500; font-size: 0.95rem;">Premium Accommodation</span>
                        </li>
                        <li class="flex items-center gap-2 mb-3 text-main">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                            <span style="font-weight: 500; font-size: 0.95rem;">Daily Breakfast & Dinner</span>
                        </li>
                        <li class="flex items-center gap-2 mb-3 text-main">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                            <span style="font-weight: 500; font-size: 0.95rem;">Expert Tour Guide</span>
                        </li>
                        <li class="flex items-center gap-2 mb-3 text-main">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                            <span style="font-weight: 500; font-size: 0.95rem;">Private Transfers</span>
                        </li>
                    </c:if>
                </ul>

                <!-- Quick Book Button in Sidebar -->
                <div class="mt-4 pt-4" style="border-top:1px solid var(--color-border); display: flex; flex-direction: column; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/trip/customize?id=${empty trip.id ? 1 : trip.id}" class="btn-primary w-full text-center" style="display:block;padding:12px;border-radius:8px;font-weight:700;text-decoration:none;">
                        Book Now →
                    </a>
                    <button onclick="saveTripPlan(${empty trip.id ? 1 : trip.id})" class="btn-outline w-full text-center" style="display:block;padding:12px;border-radius:8px;font-weight:700; border: 1px solid var(--color-primary); color: var(--color-primary); background: transparent;">
                        Save Plan
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Gallery Section -->
    <section class="container mb-5">
        <h2 class="section-title text-center mb-4" style="font-size: 2rem;">Destination Gallery</h2>
        <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-4">
            <c:forEach var="img" items="${trip.gallery}">
                <div class="gallery-item relative overflow-hidden rounded-xl" style="height: 250px;">
                    <img src="${img.imageUrl}" alt="${img.caption}" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease;" onmouseover="this.style.transform='scale(1.08)'" onmouseout="this.style.transform='scale(1)'"/>
                    <div class="absolute w-full p-3" style="bottom: 0; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);">
                        <p class="text-white text-sm fw-bold m-0">${img.caption}</p>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty trip.gallery}">
                <div class="gallery-item relative overflow-hidden rounded-xl" style="height: 250px;">
                    <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format,compress&fit=crop&w=600&q=75" alt="Scenic View" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease;" onmouseover="this.style.transform='scale(1.08)'" onmouseout="this.style.transform='scale(1)'"/>
                    <div class="absolute w-full p-3" style="bottom: 0; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);">
                        <p class="text-white text-sm fw-bold m-0">Scenic View</p>
                    </div>
                </div>
                <div class="gallery-item relative overflow-hidden rounded-xl" style="height: 250px;">
                    <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format,compress&fit=crop&w=600&q=75" alt="Local Culture" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease;" onmouseover="this.style.transform='scale(1.08)'" onmouseout="this.style.transform='scale(1)'"/>
                    <div class="absolute w-full p-3" style="bottom: 0; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);">
                        <p class="text-white text-sm fw-bold m-0">Local Culture</p>
                    </div>
                </div>
                <div class="gallery-item relative overflow-hidden rounded-xl" style="height: 250px;">
                    <img src="https://images.unsplash.com/photo-1542152019-216e257e84cc?auto=format,compress&fit=crop&w=600&q=75" alt="Adventure" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease;" onmouseover="this.style.transform='scale(1.08)'" onmouseout="this.style.transform='scale(1)'"/>
                    <div class="absolute w-full p-3" style="bottom: 0; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);">
                        <p class="text-white text-sm fw-bold m-0">Adventure Activities</p>
                    </div>
                </div>
            </c:if>
        </div>
    </section>

    <!-- Info & FAQs -->
    <section class="container mb-5">
        <div class="grid md:grid-cols-2 gap-8">
            <!-- Important Info -->
            <div class="glass-panel p-5">
                <h3 class="fw-bold text-main mb-4">ℹ️ Important Information</h3>
                <div class="grid sm:grid-cols-2 gap-6">
                    <div>
                        <h5 class="text-primary fw-bold text-sm mb-2">Cancellation Policy</h5>
                        <p class="text-muted text-xs">Full refund up to 30 days before departure. 50% refund between 15-30 days. No refund within 15 days.</p>
                    </div>
                    <div>
                        <h5 class="text-primary fw-bold text-sm mb-2">Travel Insurance</h5>
                        <p class="text-muted text-xs">Comprehensive coverage starting at ₹499. Covers medical emergencies, trip cancellation, and lost baggage.</p>
                    </div>
                    <div>
                        <h5 class="text-primary fw-bold text-sm mb-2">Group Size</h5>
                        <p class="text-muted text-xs">Small groups of 10-15 travelers for personalized experiences. Private tours also available.</p>
                    </div>
                    <div>
                        <h5 class="text-primary fw-bold text-sm mb-2">Health & Safety</h5>
                        <p class="text-muted text-xs">Sanitized vehicles and accommodations. 24/7 emergency support. First-aid trained guides.</p>
                    </div>
                </div>
            </div>

            <!-- FAQs -->
            <div class="glass-panel p-5">
                <h3 class="fw-bold text-main mb-4">❓ Frequently Asked Questions</h3>
                <div class="faq-list">
                    <div class="faq-item mb-3" style="border-bottom:1px solid var(--color-border);padding-bottom:12px;">
                        <div class="faq-q flex justify-between items-center cursor-pointer" onclick="this.parentElement.classList.toggle('open')">
                            <span class="text-main fw-bold text-sm">Is airport pickup included?</span>
                            <span class="faq-arrow text-primary">▼</span>
                        </div>
                        <div class="faq-a" style="max-height:0;overflow:hidden;transition:max-height 0.3s;">
                            <p class="text-muted text-xs mt-2">Yes! Airport/station pickup and drop-off is included in all our packages.</p>
                        </div>
                    </div>
                    <div class="faq-item mb-3" style="border-bottom:1px solid var(--color-border);padding-bottom:12px;">
                        <div class="faq-q flex justify-between items-center cursor-pointer" onclick="this.parentElement.classList.toggle('open')">
                            <span class="text-main fw-bold text-sm">Can I customize the itinerary?</span>
                            <span class="faq-arrow text-primary">▼</span>
                        </div>
                        <div class="faq-a" style="max-height:0;overflow:hidden;transition:max-height 0.3s;">
                            <p class="text-muted text-xs mt-2">Absolutely! Contact our team after booking and we'll tailor the itinerary to your preferences.</p>
                        </div>
                    </div>
                    <div class="faq-item mb-3" style="border-bottom:1px solid var(--color-border);padding-bottom:12px;">
                        <div class="faq-q flex justify-between items-center cursor-pointer" onclick="this.parentElement.classList.toggle('open')">
                            <span class="text-main fw-bold text-sm">What payment methods are accepted?</span>
                            <span class="faq-arrow text-primary">▼</span>
                        </div>
                        <div class="faq-a" style="max-height:0;overflow:hidden;transition:max-height 0.3s;">
                            <p class="text-muted text-xs mt-2">We accept UPI, credit/debit cards, net banking, and EMI options on select cards.</p>
                        </div>
                    </div>
                    <div class="faq-item mb-3">
                        <div class="faq-q flex justify-between items-center cursor-pointer" onclick="this.parentElement.classList.toggle('open')">
                            <span class="text-main fw-bold text-sm">Are meals vegetarian-friendly?</span>
                            <span class="faq-arrow text-primary">▼</span>
                        </div>
                        <div class="faq-a" style="max-height:0;overflow:hidden;transition:max-height 0.3s;">
                            <p class="text-muted text-xs mt-2">Yes, all meals offer vegetarian, vegan, and Jain options. Mention dietary needs while booking.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Customer Reviews -->
    <section class="container mb-5 pb-5">
        <div class="flex items-center justify-between mb-4">
            <h2 class="section-title m-0" style="font-size: 2rem;">Guest Experiences</h2>
            <div class="text-right">
                <div class="text-primary fw-bold" style="font-size: 1.5rem;">${ratingVal} <span class="text-muted" style="font-size: 1rem;">/ 5</span></div>
                <div class="text-muted text-xs">Based on 124 reviews</div>
            </div>
        </div>
        <div class="grid md:grid-cols-3 gap-6">
            <div class="glass-panel p-4">
                <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                <p class="text-main fw-bold text-sm mb-2">"Truly Paradise!"</p>
                <p class="text-muted text-xs italic mb-3">"The entire experience was magical. Voyastra handled everything perfectly from pickup to drop."</p>
                <div class="flex items-center gap-2">
                    <div style="width:30px;height:30px;border-radius:50%;background:var(--color-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.7rem;font-weight:700;">AR</div>
                    <span class="text-xs fw-bold">Ananya R.</span>
                </div>
            </div>
            <div class="glass-panel p-4">
                <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                <p class="text-main fw-bold text-sm mb-2">"Excellent Service"</p>
                <p class="text-muted text-xs italic mb-3">"Professional guides and well-planned itinerary. The hotel upgrades were a wonderful surprise."</p>
                <div class="flex items-center gap-2">
                    <div style="width:30px;height:30px;border-radius:50%;background:var(--color-accent);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.7rem;font-weight:700;">VS</div>
                    <span class="text-xs fw-bold">Vikram S.</span>
                </div>
            </div>
            <div class="glass-panel p-4">
                <div class="flex gap-1 mb-2 text-primary text-xs">★★★★★</div>
                <p class="text-main fw-bold text-sm mb-2">"Worth Every Penny"</p>
                <p class="text-muted text-xs italic mb-3">"Luxury at its best. The candlelight dinner and spa were incredible. Will definitely book again!"</p>
                <div class="flex items-center gap-2">
                    <div style="width:30px;height:30px;border-radius:50%;background:var(--color-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.7rem;font-weight:700;">SK</div>
                    <span class="text-xs fw-bold">Sneha K.</span>
                </div>
            </div>
        </div>
    </section>

</main>

<style>
    .faq-item.open .faq-a { max-height: 200px !important; }
    .faq-item.open .faq-arrow { transform: rotate(180deg); }
    .faq-arrow { transition: transform 0.3s; font-size: 0.7rem; }
</style>

<script>
    function saveTripPlan(tripId) {
        fetch('${pageContext.request.contextPath}/api/trip/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=save&tripId=' + tripId
        }).then(r => {
            if(r.status === 401) {
                window.location.href = '${pageContext.request.contextPath}/pages/login.jsp';
                return null;
            }
            return r.json();
        }).then(data => {
            if(data) {
                alert(data.message);
            }
        }).catch(e => console.error(e));
    }
</script>

<%@ include file="/components/footer.jsp" %>
