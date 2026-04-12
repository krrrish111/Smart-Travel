<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<style>
    .booking-card {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 16px;
        overflow: hidden;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex;
        margin-bottom: 20px;
        height: 180px;
        position: relative;
    }
    
    .booking-card:hover {
        transform: translateY(-5px);
        background: rgba(255, 255, 255, 0.05);
        border-color: var(--color-primary);
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }
    
    .booking-img-wrap {
        width: 240px;
        height: 100%;
        flex-shrink: 0;
        position: relative;
        overflow: hidden;
    }
    
    .booking-img-wrap img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.6s ease;
    }
    
    .booking-card:hover .booking-img-wrap img {
        transform: scale(1.1);
    }
    
    .booking-info {
        padding: 24px;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    
    .status-badge {
        position: absolute;
        top: 15px;
        right: 15px;
        padding: 6px 12px;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .status-confirmed { background: rgba(34, 197, 94, 0.15); color: #4ade80; border: 1px solid rgba(34, 197, 94, 0.3); }
    .status-pending { background: rgba(245, 158, 11, 0.15); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.3); }
    
    .booking-price {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--color-primary);
    }
</style>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    
    <div class="container relative z-10" style="margin-top: -10px;">
    
        <div class="flex justify-between items-center mb-10 slide-up" style="flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 class="text-white mb-2 editorial" style="font-size: 2.75rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">
                    Welcome back, <span id="dashUserName">${sessionScope.user_name != null ? sessionScope.user_name : 'Explorer'}</span>!
                </h1>
                <p class="text-white opacity-70 font-body" style="font-size: 1.1rem;">Where will your next adventure take you?</p>
            </div>
            <div style="display:flex; gap: 12px; align-items: center;">
                <a href="edit-profile.jsp" class="btn btn-outline" style="padding: 12px 24px; border-radius: 50px;">Settings</a>
                <a href="LogoutServlet" class="btn btn-outline" style="padding: 12px 24px; border-radius: 50px; background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.3); color: #fca5a5;">
                    Sign Out
                </a>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <!-- Main Content: Booking History -->
            <div class="lg:col-span-2 slide-up delay-1">
                <h2 class="text-main mb-6 editorial" style="font-size: 1.75rem;">Your Adventures</h2>
                
                <c:choose>
                    <c:when test="${empty userBookings}">
                        <div class="vx-empty-state">
                            <div class="vx-empty-icon">🎒</div>
                            <h3 class="vx-empty-title">No trips confirmed yet</h3>
                            <p class="vx-empty-desc">Your booked itineraries and travel history will appear here. Ready to start your first journey?</p>
                            <a href="explore.jsp" class="btn btn-primary" style="padding: 14px 32px; border-radius: 50px;">
                                Explore Destinations
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col gap-4">
                            <c:forEach var="booking" items="${userBookings}">
                                <div class="booking-card">
                                    <div class="booking-img-wrap vx-img-wrap">
                                        <img src="${not empty booking.planImage ? booking.planImage : 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=600&q=80'}" alt="${booking.planTitle}">
                                    </div>
                                    <div class="booking-info">
                                        <div>
                                            <div class="status-badge ${booking.status == 'CONFIRMED' ? 'status-confirmed' : 'status-pending'}">
                                                ${booking.status}
                                            </div>
                                            <h3 class="text-white mb-1" style="font-size: 1.4rem;">${booking.planTitle}</h3>
                                            <p class="text-muted text-sm m-0">Booked on <fmt:formatDate value="${booking.createdAt}" pattern="MMM dd, yyyy" /></p>
                                        </div>
                                        <div class="flex justify-between items-end">
                                            <div class="booking-price">
                                                ₹<fmt:formatNumber value="${booking.totalPrice}" pattern="#,###" />
                                            </div>
                                            <a href="plan-details.jsp?id=${booking.planId}" class="text-primary font-bold text-sm hover-underline" style="text-decoration: none;">View Itinerary →</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- AI Generated Itineraries -->
            <div class="lg:col-span-2 slide-up delay-2 mt-12">
                <h2 class="text-main mb-6 editorial" style="font-size: 1.75rem;">AI Smart Plans</h2>
                
                <c:choose>
                    <c:when test="${empty userItineraries}">
                        <div class="vx-empty-state" style="padding: 40px;">
                            <div class="vx-empty-icon">🤖</div>
                            <h3 class="vx-empty-title">No AI plans saved yet</h3>
                            <p class="vx-empty-desc">Your personalized itineraries from the AI Travel Planner will appear here.</p>
                            <a href="planner.jsp" class="btn btn-outline" style="padding: 12px 28px; border-radius: 50px;">
                                Try AI Planner
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <c:forEach var="itinerary" items="${userItineraries}">
                                <div class="glass-panel p-6 flex flex-col justify-between" style="border-radius: 20px; transition: all 0.3s ease; height: 210px;">
                                    <div>
                                        <div class="flex justify-between items-start mb-2">
                                            <h3 class="text-white text-lg font-bold editorial m-0">${itinerary.title}</h3>
                                            <a href="itinerary?action=delete&id=${itinerary.id}" class="text-red-400 hover:text-red-300 transition-colors" onclick="return confirm('Delete this itinerary?')">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                            </a>
                                        </div>
                                        <p class="text-muted text-xs mb-1">Destination: ${itinerary.destination}</p>
                                        <p class="text-muted text-[0.65rem]">Saved <fmt:formatDate value="${itinerary.createdAt}" pattern="MMM dd, yyyy" /></p>
                                    </div>
                                    <a href="itinerary?id=${itinerary.id}" class="btn btn-outline w-full py-2 text-xs" style="border-radius: 12px; font-weight: 600; background: rgba(59, 130, 246, 0.1); border-color: rgba(59, 130, 246, 0.2);">View Full Trip</a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Sidebar: Stats & Perks -->
            <div class="slide-up delay-2">
                
                <div class="glass-panel mb-6" style="padding: 30px; border-radius: 20px;">
                    <h3 class="mb-5 text-main editorial" style="font-size: 1.3rem;">Quick Insights</h3>
                    
                    <div class="flex justify-between items-center mb-4">
                        <div class="flex items-center gap-3">
                            <div style="color: var(--color-primary); background: rgba(59, 130, 246, 0.1); padding: 8px; border-radius: 10px;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            </div>
                            <span class="text-muted">History</span>
                        </div>
                        <span class="text-xl font-bold text-white">${fn:length(userBookings) + fn:length(userItineraries)}</span>
                    </div>
                    
                    <div class="flex justify-between items-center mb-4">
                        <div class="flex items-center gap-3">
                            <div style="color: #f59e0b; background: rgba(245, 158, 11, 0.1); padding: 8px; border-radius: 10px;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            </div>
                            <span class="text-muted">Loyalty Points</span>
                        </div>
                        <span class="text-xl font-bold text-white">${(fn:length(userBookings) * 150) + (fn:length(userItineraries) * 50)}</span>
                    </div>
                </div>

                <div class="glass-panel" style="padding: 30px; text-align: center; border-radius: 20px; border: 1px dashed rgba(245, 158, 11, 0.3);">
                    <div style="width: 56px; height: 56px; border-radius: 50%; background: linear-gradient(135deg, #f59e0b, #d97706); color: white; display:flex; align-items:center; justify-content:center; margin: 0 auto 16px; box-shadow: 0 0 20px rgba(245, 158, 11, 0.3);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg>
                    </div>
                    <h3 class="mb-2 text-main" style="font-size: 1.2rem;">Voyastra Prime</h3>
                    <p class="text-muted text-sm mb-5" style="line-height: 1.6;">Access curated premium itineraries and first-class lounge access worldwide.</p>
                    <button class="btn btn-primary w-full" style="background: linear-gradient(to right, #f59e0b, #d97706); border: none; padding: 12px; font-weight: 700; border-radius: 50px;">Upgrade Now</button>
                </div>

            </div>

        </div>
    </div>
</main>

<%@ include file="components/footer.jsp" %>
