<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    :root {
        --dash-card-bg: rgba(255, 255, 255, 0.03);
        --dash-card-border: rgba(255, 255, 255, 0.1);
    }

    .stat-card {
        background: var(--dash-card-bg);
        border: 1px solid var(--dash-card-border);
        padding: 24px;
        border-radius: 20px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .stat-card:hover {
        background: rgba(255, 255, 255, 0.05);
        border-color: var(--color-primary);
        transform: translateY(-2px);
    }

    .stat-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
    }

    .preview-card {
        background: var(--dash-card-bg);
        border: 1px solid var(--dash-card-border);
        border-radius: 16px;
        overflow: hidden;
        transition: all 0.4s ease;
        margin-bottom: 12px;
    }

    .preview-card:hover {
        background: rgba(255, 255, 255, 0.06);
        border-color: rgba(255, 255, 255, 0.2);
    }

    .dashboard-banner {
        height: 250px;
        width: 100%;
        position: relative;
        border-radius: 24px;
        overflow: hidden;
        margin-bottom: 40px;
        background: #1a1a1a;
        border: 1px solid var(--dash-card-border);
    }

    .banner-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        opacity: 0.6;
    }

    .banner-overlay {
        position: absolute;
        inset: 0;
        background: linear-gradient(to right, rgba(0,0,0,0.8) 0%, transparent 100%);
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding: 0 50px;
    }

    .quick-action-btn {
        padding: 16px;
        border-radius: 16px;
        background: var(--dash-card-bg);
        border: 1px solid var(--dash-card-border);
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        text-align: center;
        color: white;
        text-decoration: none;
    }

    .quick-action-btn:hover {
        background: var(--color-primary);
        border-color: var(--color-primary);
        transform: scale(1.02);
    }

    .quick-action-btn svg { width: 24px; height: 24px; }

    .recommend-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px;
    }

    @media (min-width: 1024px) {
        .recommend-grid { grid-template-columns: repeat(4, minmax(0, 1fr)); }
    }

    .recommend-card {
        background: var(--dash-card-bg);
        border: 1px solid var(--dash-card-border);
        border-radius: 16px;
        overflow: hidden;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex;
        flex-direction: column;
        height: 100%;
    }

    .recommend-card:hover {
        transform: translateY(-5px);
        background: rgba(255, 255, 255, 0.05);
        border-color: var(--color-primary);
    }

    .recommend-img-box {
        width: 100%;
        height: 130px;
        overflow: hidden;
        position: relative;
    }

    .recommend-img-box img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .recommend-body {
        padding: 12px;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }

    .recommend-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background: rgba(0,0,0,0.6);
        backdrop-filter: blur(8px);
        color: white;
        padding: 3px 10px;
        border-radius: 20px;
        font-size: 0.6rem;
        font-weight: 700;
        z-index: 2;
    }
</style>

<main style="padding-top: 100px; padding-bottom: 80px;">
    <div class="container relative z-10">
        
        <!-- 0. WELCOME BANNER -->
        <div class="dashboard-banner slide-up">
            <img src="https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=1200&q=80" class="banner-img" alt="Voyastra Banner">
            <div class="banner-overlay">
                <h1 class="text-white mb-2 editorial" style="font-size: 3rem;">
                    Hello, ${sessionScope.name != null ? sessionScope.name : 'Explorer'}!
                </h1>
                <p class="text-white opacity-70 text-lg">Where will your next adventure take you?</p>
                <div class="mt-6">
                    <a href="${pageContext.request.contextPath}/explore" class="btn btn-primary" style="border-radius: 50px; padding: 12px 32px;">Start Planning</a>
                </div>
            </div>
        </div>

        <!-- 1. QUICK STATS -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12 slide-up delay-1">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: #3b82f6;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path></svg>
                </div>
                <div>
                    <h3 class="text-2xl font-bold text-white">${totalBookings}</h3>
                    <p class="text-muted text-sm">Total Bookings</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(34, 197, 94, 0.1); color: #22c55e;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                </div>
                <div>
                    <h3 class="text-2xl font-bold text-white">${upcomingTrips}</h3>
                    <p class="text-muted text-sm">Upcoming Trips</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                </div>
                <div>
                    <h3 class="text-2xl font-bold text-white">${savedPlansCount}</h3>
                    <p class="text-muted text-sm">Saved Plans</p>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <!-- Left/Main Column: Recent Activity -->
            <div class="lg:col-span-2 space-y-12 slide-up delay-2">
                
                <!-- 2. RECENT BOOKINGS PREVIEW -->
                <section>
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-white editorial text-2xl m-0">Recent Bookings</h2>
                        <a href="${pageContext.request.contextPath}/booking" class="text-primary font-bold hover-underline">View All &rarr;</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty recentBookings}">
                            <div class="glass-panel text-center p-12" style="border-radius: 20px;">
                                <p class="text-muted mb-4">You haven't booked any adventures yet.</p>
                                <a href="${pageContext.request.contextPath}/explore" class="btn btn-outline" style="border-radius: 12px;">Start Exploring</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-4">
                                <c:forEach var="booking" items="${recentBookings}">
                                    <div class="preview-card p-4 flex gap-6 items-center">
                                        <div style="width: 100px; height: 70px; border-radius: 12px; overflow: hidden; flex-shrink: 0;">
                                            <img src="${not empty booking.planImage ? booking.planImage : 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=200&q=80'}" style="width: 100%; height: 100%; object-fit: cover;">
                                        </div>
                                        <div class="flex-grow">
                                            <h4 class="text-white font-bold m-0">${booking.planTitle}</h4>
                                            <p class="text-muted text-xs m-0">Booked on <fmt:formatDate value="${booking.createdAt}" pattern="MMM dd, yyyy" /></p>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-white font-bold mb-1">₹<fmt:formatNumber value="${booking.totalPrice}" pattern="#,###" /></div>
                                            <span class="badge" style="font-size: 0.65rem;">${booking.status}</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- 3. SAVED PLANS PREVIEW -->
                <section>
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-white editorial text-2xl m-0">Saved Itineraries</h2>
                        <a href="${pageContext.request.contextPath}/user-home?tab=saved-plans" class="text-primary font-bold hover-underline">Manage Plans &rarr;</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty recentPlans}">
                            <div class="glass-panel text-center p-12" style="border-radius: 20px;">
                                <p class="text-muted mb-4">No AI-generated plans saved.</p>
                                <a href="${pageContext.request.contextPath}/planner" class="btn btn-outline" style="border-radius: 12px;">Try AI Planner</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <c:forEach var="plan" items="${recentPlans}">
                                    <div class="glass-panel p-6 flex flex-col justify-between" style="border-radius: 20px; height: 180px;">
                                        <div>
                                            <h4 class="text-white font-bold mb-1">${plan.title}</h4>
                                            <p class="text-muted text-xs">${plan.destination}</p>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/itinerary?id=${plan.id}" class="btn btn-outline w-full py-2 text-xs" style="border-radius: 10px;">View Full Trip</a>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

            </div>

            <!-- Sidebar -->
            <div class="space-y-8 slide-up delay-3" style="max-width: 100%; overflow: hidden;">
                
                <!-- 4. QUICK ACTIONS -->
                <section>
                    <h3 class="text-white editorial text-xl mb-6">Quick Actions</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <a href="${pageContext.request.contextPath}/planner" class="quick-action-btn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 19l7-7 3 3-7 7-3-3z"></path><path d="M18 13l-1.5-7.5L2 2l3.5 14.5L13 18l5-5z"></path><path d="M2 2l7.586 7.586"></path><circle cx="11" cy="11" r="2"></circle></svg>
                            <span class="text-xs font-bold">New Plan</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/explore" class="quick-action-btn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                            <span class="text-xs font-bold">Explore</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/booking" class="quick-action-btn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <span class="text-xs font-bold">Bookings</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/profile" class="quick-action-btn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            <span class="text-xs font-bold">Profile</span>
                        </a>
                    </div>
                </section>

            </div>

        </div>

        <!-- 6. RECOMMENDED DESTINATIONS (NEW COMPACT GRID) -->
        <section class="mt-16 slide-up delay-4">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-white editorial text-3xl m-0">Recommended for You</h2>
                    <p class="text-white opacity-50 text-sm mt-1">Based on your travel preferences and history.</p>
                </div>
                <a href="${pageContext.request.contextPath}/explore" class="btn btn-outline py-2 px-6" style="border-radius: 50px; font-size: 0.8rem;">Explore All</a>
            </div>
            
            <div class="recommend-grid">
                <c:forEach var="dest" items="${recommendations}">
                    <div class="recommend-card">
                        <div class="recommend-img-box">
                            <div class="recommend-badge">${dest.category != null ? dest.category : 'Top'}</div>
                            <img src="${dest.image}" alt="${dest.name}">
                        </div>
                        <div class="recommend-body">
                            <h4 class="text-white font-bold mb-1" style="font-size: 1rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${dest.name}</h4>
                            <p class="text-white opacity-50 mb-4 flex-grow" style="font-size: 0.7rem; line-height: 1.3; height: 36px; overflow: hidden;">
                                Experience the beauty of ${dest.name}, ${dest.country}.
                            </p>
                            <div class="flex items-center justify-between mt-auto">
                                <span class="text-primary font-bold" style="font-size: 0.75rem;">${dest.country}</span>
                                <a href="${pageContext.request.contextPath}/destination?id=${dest.id}" class="btn btn-primary py-1 px-3 text-xs" style="border-radius: 8px; font-size: 0.65rem;">View</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
