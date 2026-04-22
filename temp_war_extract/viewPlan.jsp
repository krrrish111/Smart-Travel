<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<main style="padding-top: 120px; padding-bottom: 80px; overflow-x: hidden;">
    <div class="container relative z-10">
        
        <c:choose>
            <c:when test="${not empty plan}">
                <!-- Hero Section for the Plan -->
                <div class="plan-hero relative" style="border-radius: var(--border-radius-lg); overflow: hidden; height: 400px; margin-bottom: 40px; box-shadow: var(--shadow-lg);">
                    <img src="${plan.imageUrl}" alt="${plan.title}" style="width: 100%; height: 100%; object-fit: cover;">
                    <div style="position: absolute; inset: 0; background: linear-gradient(to top, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0.2) 60%, rgba(0,0,0,0.1) 100%);"></div>
                    
                    <div style="position: absolute; bottom: 0; left: 0; padding: 40px; width: 100%;">
                        <div class="flex items-center gap-2 mb-3" style="color: var(--color-primary); font-family: 'Poppins', sans-serif; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.1em;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            ${plan.location}
                        </div>
                        <h1 class="editorial" style="color: #ffffff; font-size: 3.5rem; line-height: 1.1; margin-bottom: 10px; text-shadow: 0 4px 20px rgba(0,0,0,0.8);">
                            ${plan.title}
                        </h1>
                        <div class="flex gap-3 mt-4 flex-wrap">
                            <c:if test="${not empty plan.tags}">
                                <c:forTokens items="${plan.tags}" delims="," var="tag">
                                    <span class="plan-tag">
                                        ${tag.trim()}
                                    </span>
                                </c:forTokens>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Main Content Grid -->
                <div class="grid" style="grid-template-columns: 2fr 1fr; gap: 40px;">
                    
                    <!-- Left Column: Details -->
                    <div class="glass-panel" style="padding: 40px; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-sm);">
                        <h2 class="editorial mb-6" style="font-size: 2rem;">Overview</h2>
                        <div style="font-family: 'DM Sans', sans-serif; font-size: 1.1rem; line-height: 1.8; color: var(--text-main); margin-bottom: 40px;">
                            ${plan.description}
                        </div>
                        
                        <h2 class="editorial mb-6" style="font-size: 2rem;">Highlights</h2>
                        <ul style="list-style: none; padding: 0;">
                            <li class="flex items-start gap-4 mb-4" style="background: rgba(212, 165, 116, 0.05); padding: 15px 20px; border-radius: var(--border-radius-sm); border: 1px solid var(--color-border);">
                                <div style="color: var(--color-primary); margin-top: 2px;">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                </div>
                                <div>
                                    <h4 style="font-family: 'Inter', sans-serif; font-weight: 600; margin-bottom: 4px;">Curated Experience</h4>
                                    <p class="text-muted text-sm">Exclusives activities designed just for you.</p>
                                </div>
                            </li>
                            <li class="flex items-start gap-4 mb-4" style="background: rgba(212, 165, 116, 0.05); padding: 15px 20px; border-radius: var(--border-radius-sm); border: 1px solid var(--color-border);">
                                <div style="color: var(--color-primary); margin-top: 2px;">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                </div>
                                <div>
                                    <h4 style="font-family: 'Inter', sans-serif; font-weight: 600; margin-bottom: 4px;">Premium Accommodation</h4>
                                    <p class="text-muted text-sm">Stay in hand-picked luxury properties.</p>
                                </div>
                            </li>
                        </ul>
                    </div>
                    
                    <!-- Right Column: Booking Widget -->
                    <div>
                        <div class="glass-panel" style="padding: 30px; border-radius: var(--border-radius-lg); position: sticky; top: 140px; box-shadow: var(--shadow-md);">
                            <div class="flex justify-between items-end mb-6 pb-6" style="border-bottom: 1px solid var(--color-border);">
                                <div>
                                    <div class="text-muted text-sm mb-1 uppercase tracking-wide font-semibold">Starting From</div>
                                    <div style="font-size: 2.2rem; font-family: 'Poppins', sans-serif; font-weight: 700; color: var(--color-primary); line-height: 1;">
                                        &#8377;${plan.price}
                                    </div>
                                </div>
                                <div class="text-right">
                                    <div class="flex items-center gap-1 justify-end" style="color: var(--text-main); font-weight: 600;">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        ${plan.days} Days
                                    </div>
                                </div>
                            </div>
                            
                            <button class="btn btn-primary w-full py-3 mb-4" style="font-size: 1.1rem;" onclick="VoyastraAuth.requireAuth('booking.jsp?planId=${plan.id}')">
                                Book This Trip
                            </button>
                            <button class="btn btn-outline w-full py-3" onclick="VoyastraAuth.requireAuth('planner.jsp?location=${plan.title}')">
                                Customize Plan
                            </button>
                            
                            <div class="mt-6 text-center text-sm text-muted">
                                <p>Free cancellation up to 48 hours before departure.</p>
                            </div>
                        </div>
                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <div class="text-center" style="padding: 100px 0;">
                    <h2 class="editorial" style="font-size: 2.5rem; margin-bottom: 20px;">Plan Not Found</h2>
                    <p class="text-muted mb-6">We couldn't find the trip plan you're looking for.</p>
                    <a href="home" class="btn btn-primary">Back to Home</a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<%@ include file="components/footer.jsp" %>
