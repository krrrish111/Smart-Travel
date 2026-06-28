<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .exp-hero {
        position: relative;
        height: 60vh;
        min-height: 400px;
        background-size: cover;
        background-position: center;
    }
    .exp-hero-overlay {
        position: absolute;
        inset: 0;
        background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0.2) 50%, rgba(0,0,0,0.4) 100%);
    }
    .exp-content {
        position: relative;
        z-index: 2;
        padding-top: 120px;
    }
    .exp-card {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(20px);
        border-radius: 20px;
    }
    .highlight-pill {
        background: rgba(212, 175, 55, 0.15);
        color: var(--color-primary);
        border: 1px solid rgba(212, 175, 55, 0.3);
        padding: 6px 14px;
        border-radius: 50px;
        font-size: 0.85rem;
        font-weight: 600;
        display: inline-block;
        margin-right: 8px;
        margin-bottom: 8px;
    }
</style>

<div class="exp-hero" style="background-image: url('${experience.coverImage != null ? experience.coverImage : 'https://images.unsplash.com/photo-1506012787146-f92b2d7d6d96?auto=format&fit=crop&w=1920'}');">
    <div class="exp-hero-overlay"></div>
    <div class="container exp-content h-full flex flex-col justify-end pb-12">
        <div class="mb-4">
            <span class="bg-primary text-black px-4 py-1 rounded-full text-sm font-bold tracking-widest uppercase">Must Do</span>
        </div>
        <h1 class="text-white editorial text-5xl md:text-6xl font-bold mb-4">${experience.title}</h1>
        <div class="flex flex-wrap items-center gap-6 text-white opacity-90">
            <div class="flex items-center gap-2"><i class="fas fa-map-marker-alt text-primary"></i> ${experience.location}</div>
            <div class="flex items-center gap-2"><i class="fas fa-clock text-primary"></i> ${experience.durationMinutes} mins</div>
            <div class="flex items-center gap-2"><i class="fas fa-star text-primary"></i> ${experience.rating} (${experience.reviewCount} Reviews)</div>
        </div>
    </div>
</div>

<main class="container py-12">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
        
        <!-- Left Content -->
        <div class="lg:col-span-2 space-y-10">
            
            <section class="exp-card p-8">
                <h2 class="editorial text-3xl text-main mb-6">About this Experience</h2>
                <p class="text-muted leading-relaxed text-lg">${experience.description}</p>
            </section>
            
            <c:if test="${not empty experience.highlights}">
                <section class="exp-card p-8">
                    <h2 class="editorial text-3xl text-main mb-6">Highlights</h2>
                    <div>
                        <c:forEach var="highlight" items="${fn:split(experience.highlights, '|')}">
                            <span class="highlight-pill"><i class="fas fa-check mr-2"></i> ${highlight}</span>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
            
        </div>
        
        <!-- Right Sidebar (Booking Form) -->
        <div class="lg:col-span-1">
            <div class="exp-card p-8 sticky top-24">
                <div class="mb-6 pb-6 border-b border-white border-opacity-10">
                    <div class="text-3xl font-bold text-primary mb-1">
                        <c:choose>
                            <c:when test="${experience.price > 0}">₹${experience.price}</c:when>
                            <c:otherwise>Free</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="text-muted text-sm uppercase tracking-wider">Per Person</div>
                </div>
                
                <form action="${pageContext.request.contextPath}/submit-booking" method="post" id="bookingForm" class="space-y-6">
                    <input type="hidden" name="type" value="experience">
                    <input type="hidden" name="id" value="${experience.id}">
                    <input type="hidden" name="price" value="${experience.price}">
                    <input type="hidden" name="name" value="${experience.title}">
                    
                    <div class="space-y-2">
                        <label class="text-white text-sm font-bold opacity-80">Select Date</label>
                        <input type="date" name="travelDate" required class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>
                    
                    <div class="space-y-2">
                        <label class="text-white text-sm font-bold opacity-80">Select Time</label>
                        <select name="travelTime" required class="w-full bg-[#1a1c23] border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none">
                            <option value="09:00 AM">09:00 AM</option>
                            <option value="11:30 AM">11:30 AM</option>
                            <option value="02:00 PM">02:00 PM</option>
                            <option value="04:30 PM">04:30 PM</option>
                        </select>
                    </div>
                    
                    <div class="space-y-2">
                        <label class="text-white text-sm font-bold opacity-80">Number of Guests</label>
                        <input type="number" name="guests" min="1" max="10" value="1" required class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none">
                    </div>
                    
                    <!-- Include customer info fields directly here to map easily to submit-booking -->
                    <div class="pt-4 border-t border-white border-opacity-10 space-y-4">
                        <div class="space-y-2">
                            <label class="text-white text-sm font-bold opacity-80">Full Name</label>
                            <input type="text" name="customerName" required value="${sessionScope.name}" class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none" placeholder="John Doe">
                        </div>
                        <div class="space-y-2">
                            <label class="text-white text-sm font-bold opacity-80">Email</label>
                            <input type="email" name="customerEmail" required value="${sessionScope.email}" class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none" placeholder="john@example.com">
                        </div>
                    </div>
                    
                    <button type="submit" class="w-full bg-primary text-black font-bold text-lg py-4 rounded-xl hover:bg-opacity-90 transition transform hover:scale-105">
                        Review Booking
                    </button>
                </form>
            </div>
        </div>
        
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
