<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="components/header.jsp" />

<!-- Main Content Area -->
<main class="trip-detail-page">
    
    <!-- Premium Hero Section -->
    <section class="trip-hero relative flex items-center justify-center" style="min-height: 70vh; overflow: hidden;">
        <div class="absolute w-full h-full" style="z-index: -1;">
            <img src="${trip.imageUrl}" alt="${trip.title}" style="width: 100%; height: 100%; object-fit: cover; filter: brightness(0.6);" />
        </div>
        <div class="container text-center slide-up" style="z-index: 10; margin-top: 80px;">
            <p class="meta-location text-uppercase tracking-widest text-primary fw-bold mb-2">${trip.category} • ${trip.destination}</p>
            <h1 class="section-title text-white" style="font-size: clamp(2.5rem, 6vw, 4.5rem); text-shadow: 0 4px 20px rgba(0,0,0,0.6);">${trip.title}</h1>
            <p class="section-subtitle text-white opacity-80" style="max-width: 600px; margin: 0 auto; font-size: 1.1rem;">${trip.shortDescription}</p>
        </div>
    </section>

    <!-- Trip Overview & Booking Widget -->
    <section class="container" style="margin-top: -60px; position: relative; z-index: 20;">
        <div class="glass-panel p-5 grid sm:grid-cols-2 md:grid-cols-4 gap-4 items-center slide-up" style="animation-delay: 0.2s;">
            <div class="text-center md:text-left">
                <span class="text-muted text-sm d-block">Duration</span>
                <strong class="text-main fw-bold" style="font-size: 1.1rem;">${trip.duration}</strong>
            </div>
            <div class="text-center md:text-left">
                <span class="text-muted text-sm d-block">Best Season</span>
                <strong class="text-main fw-bold" style="font-size: 1.1rem;">${trip.bestSeason}</strong>
            </div>
            <div class="text-center md:text-left">
                <span class="text-muted text-sm d-block">Starting City</span>
                <strong class="text-main fw-bold" style="font-size: 1.1rem;">${trip.startingCity}</strong>
            </div>
            <div class="text-center md:text-right">
                <p class="text-muted text-sm mb-1">Starting from</p>
                <div class="price-highlight mb-2">
                    <fmt:formatNumber value="${trip.discountPrice}" type="currency" currencySymbol="₹" maxFractionDigits="0" />
                </div>
                <a href="booking?action=new&tripId=${trip.id}" class="btn-primary w-full" style="padding: 12px 24px; border-radius: 8px; font-weight: 700;">Book Now →</a>
            </div>
        </div>
    </section>

    <div class="container grid md:grid-cols-3 gap-6" style="margin-top: 60px; margin-bottom: 80px;">
        <!-- Left Column: Details -->
        <div class="md:col-span-2">
            <!-- Description -->
            <div class="mb-5">
                <h2 class="section-title" style="font-size: 2rem;">Overview</h2>
                <p class="text-muted" style="line-height: 1.8; font-size: 1.05rem;">${trip.fullDescription}</p>
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
                </div>
            </div>
        </div>

        <!-- Right Column: Inclusions & Gallery -->
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
                </ul>
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
        </div>
    </section>

</main>

<jsp:include page="components/footer.jsp" />
