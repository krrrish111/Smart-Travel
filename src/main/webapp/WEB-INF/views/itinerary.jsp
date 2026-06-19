<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .itinerary-card {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 20px;
        padding: 24px;
        backdrop-filter: blur(10px);
        margin-bottom: 24px;
    }
    
    .day-badge {
        background: var(--color-primary);
        color: white;
        padding: 4px 12px;
        border-radius: 20px;
        font-weight: bold;
        font-size: 0.8rem;
    }
    
    .score-bar {
        height: 6px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        overflow: hidden;
    }
    
    .score-fill {
        height: 100%;
        background: var(--color-primary);
        border-radius: 10px;
    }
</style>

<main class="container mx-auto mt-24 mb-16 px-4" style="max-width: 1000px;">
    
    <div class="mb-8">
        <a href="${pageContext.request.contextPath}/planner" class="text-primary hover-underline inline-flex items-center gap-2">
            <i class="ri-arrow-left-line"></i> Back to Planner
        </a>
    </div>

    <c:if test="${empty generatedPlan}">
        <div class="glass-panel text-center p-12" style="border-radius: 20px;">
            <p class="text-muted text-lg">No itinerary found.</p>
            <a href="${pageContext.request.contextPath}/planner" class="btn btn-primary mt-4">Generate New Trip</a>
        </div>
    </c:if>

    <c:if test="${not empty generatedPlan}">
        <!-- Header Section -->
        <div class="itinerary-card text-center slide-up">
            <h1 class="text-4xl editorial font-bold text-main mb-2">
                ${generatedPlan.title != null ? generatedPlan.title : 'Your Custom AI Itinerary'}
            </h1>
            <p class="text-xl text-primary font-medium mb-4">
                ${generatedPlan.destination_story != null ? generatedPlan.destination_story : 'Ready for an adventure?'}
            </p>
            
            <div class="flex flex-wrap justify-center gap-4 text-sm mt-6">
                <div class="bg-white/5 border border-white/10 px-4 py-2 rounded-full">
                    <i class="ri-sun-line text-yellow-400 mr-1"></i>
                    ${generatedPlan.best_season != null ? generatedPlan.best_season : 'Year Round'}
                </div>
                <div class="bg-white/5 border border-white/10 px-4 py-2 rounded-full">
                    <i class="ri-time-line text-blue-400 mr-1"></i>
                    ${generatedPlan.recommended_duration != null ? generatedPlan.recommended_duration : 'Flexible'}
                </div>
                <div class="bg-white/5 border border-white/10 px-4 py-2 rounded-full">
                    <i class="ri-car-line text-green-400 mr-1"></i>
                    ${generatedPlan.best_travel_mode != null ? generatedPlan.best_travel_mode : 'Flight/Cab'}
                </div>
                <div class="bg-primary/20 border border-primary/50 text-primary px-4 py-2 rounded-full font-bold">
                    <i class="ri-star-fill text-yellow-400 mr-1"></i>
                    Score: ${generatedPlan.trip_score != null ? generatedPlan.trip_score : '95'}/100
                </div>
            </div>
        </div>

        <!-- Scores and Warnings Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6 slide-up delay-1">
            
            <div class="itinerary-card mb-0">
                <h3 class="text-xl editorial text-main mb-4 border-b border-white/10 pb-2"><i class="ri-bar-chart-2-line text-primary mr-2"></i>Trip Score Breakdown</h3>
                
                <c:if test="${not empty generatedPlan.trip_score_breakdown}">
                    <div class="space-y-3">
                        <c:forEach var="entry" items="${generatedPlan.trip_score_breakdown}">
                            <div>
                                <div class="flex justify-between text-xs text-muted mb-1 uppercase font-bold">
                                    <span>${entry.key}</span>
                                    <span>${entry.value}/10</span>
                                </div>
                                <div class="score-bar">
                                    <div class="score-fill" style="width: ${entry.value * 10}%"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <div class="itinerary-card mb-0 flex flex-col justify-between">
                <div>
                    <h3 class="text-xl editorial text-main mb-4 border-b border-white/10 pb-2"><i class="ri-error-warning-line text-red-400 mr-2"></i>Travel Insights & Warnings</h3>
                    <p class="text-sm text-muted mb-4 italic">"${generatedPlan.ai_recommendation_insight}"</p>
                    
                    <c:if test="${not empty generatedPlan.travel_warnings}">
                        <ul class="text-sm space-y-2">
                            <c:forEach var="warning" items="${generatedPlan.travel_warnings}">
                                <li class="flex items-start gap-2">
                                    <i class="ri-alert-line text-yellow-500 mt-0.5"></i>
                                    <span class="text-muted">${warning}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:if>
                </div>
            </div>

        </div>

        <!-- Hidden Gems -->
        <c:if test="${not empty generatedPlan.hidden_gems_detailed}">
            <h2 class="text-2xl editorial text-main mb-4 mt-8 slide-up delay-2">Hidden Gems</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8 slide-up delay-2">
                <c:forEach var="gem" items="${generatedPlan.hidden_gems_detailed}">
                    <div class="glass-panel p-4 rounded-xl border border-white/10 flex flex-col justify-between">
                        <div>
                            <span class="text-xs text-primary font-bold uppercase tracking-wider">${gem.category != null ? gem.category : 'Hidden Gem'}</span>
                            <h4 class="text-lg font-bold text-white mt-1 mb-2">${gem.name}</h4>
                            <p class="text-xs text-muted line-clamp-3">${gem.description}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Day Wise Plan -->
        <h2 class="text-3xl editorial text-main mb-6 mt-8 slide-up delay-3 text-center">Day-wise Itinerary</h2>
        
        <div class="space-y-6 slide-up delay-3">
            <c:if test="${not empty generatedPlan.itinerary}">
                <c:forEach var="dayObj" items="${generatedPlan.itinerary}">
                    <div class="itinerary-card">
                        <div class="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                            <span class="day-badge">Day ${dayObj.day}</span>
                            <h3 class="text-xl font-bold text-white m-0">${dayObj.theme != null ? dayObj.theme : dayObj.title}</h3>
                        </div>
                        
                        <div class="pl-4 border-l-2 border-white/10 space-y-4 ml-4">
                            <c:forEach var="activity" items="${dayObj.activities}">
                                <div class="relative">
                                    <div class="absolute w-3 h-3 bg-primary rounded-full -left-[23px] top-1.5 ring-4 ring-[#121212]"></div>
                                    <div class="flex flex-col sm:flex-row gap-2 sm:gap-4">
                                        <div class="text-primary font-bold text-sm w-24 shrink-0 pt-0.5">
                                            ${activity.time != null ? activity.time : activity.duration}
                                        </div>
                                        <div>
                                            <h4 class="text-white font-bold text-lg m-0">${activity.name != null ? activity.name : activity.activity}</h4>
                                            <p class="text-muted text-sm mt-1 mb-0">${activity.description}</p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>

    </c:if>

</main>

<%@ include file="/components/footer.jsp" %>
