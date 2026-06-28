<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<c:set var="booking" value="${sessionScope.currentBooking}" />

<main style="padding-top: 100px; padding-bottom: 80px;">
    <div class="container" style="max-width: 800px;">

        <div class="text-center mb-5 slide-up">
            <p class="text-primary fw-bold text-sm uppercase tracking-widest mb-2">Review & Confirm</p>
            <h1 class="section-title" style="font-size:2.2rem;">Confirm Your Booking</h1>
            <p class="text-muted">Please review all details before confirming your trip.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="glass-panel p-4 mb-4 text-center" style="border:1px solid #e74c3c;">
                <p class="text-main fw-bold">${error}</p>
            </div>
        </c:if>

        <!-- Trip Summary -->
        <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.1s;">
            <h3 class="fw-bold text-main mb-4"><span class="text-primary mr-2">📦</span> Package Details</h3>
            <div class="flex flex-col sm:flex-row gap-4 items-center">
                <div class="flex-1">
                    <h4 class="text-main fw-bold" style="font-size:1.2rem;">${booking.planTitle}</h4>
                    <p class="text-muted text-sm">${booking.type}</p>
                </div>
            </div>
        </div>

        <!-- Traveler Info -->
        <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.15s;">
            <h3 class="fw-bold text-main mb-4"><span class="text-primary mr-2">👤</span> Traveler Information</h3>
            <div class="grid sm:grid-cols-2 gap-4">
                <div><span class="text-muted text-xs uppercase">Full Name</span><p class="text-main fw-bold">${booking.customerName}</p></div>
                <div><span class="text-muted text-xs uppercase">Email</span><p class="text-main fw-bold">${booking.customerEmail}</p></div>
                <div><span class="text-muted text-xs uppercase">Travel Date</span><p class="text-main fw-bold">${booking.travelDate}</p></div>
                <div><span class="text-muted text-xs uppercase">Travel Time</span><p class="text-main fw-bold">${booking.roomType}</p></div>
                <div><span class="text-muted text-xs uppercase">Travelers</span><p class="text-main fw-bold">${booking.numAdults} Guests</p></div>
            </div>
        </div>

        <!-- Price Breakdown -->
        <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.2s;">
            <h3 class="fw-bold text-main mb-4"><span class="text-primary mr-2">💰</span> Price Summary</h3>
            <div style="border-bottom:1px solid var(--color-border);padding-bottom:12px;margin-bottom:12px;">
                <div class="flex justify-between mb-2">
                    <span class="text-muted">Subtotal</span>
                    <span class="text-main fw-bold">₹<fmt:formatNumber value="${subtotal}" type="number" maxFractionDigits="0"/></span>
                </div>
                <div class="flex justify-between mb-2">
                    <span class="text-muted">GST (5%)</span>
                    <span class="text-main">₹<fmt:formatNumber value="${tax}" type="number" maxFractionDigits="0"/></span>
                </div>
            </div>
            <div class="flex justify-between">
                <span class="text-main fw-bold" style="font-size:1.1rem;">Total Amount</span>
                <span class="text-primary fw-bold" style="font-size:1.5rem;">₹<fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/></span>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex flex-col sm:flex-row gap-4 slide-up" style="animation-delay:0.25s;">
            <button onclick="history.back()" class="btn-secondary flex-1 text-center" style="padding:14px;border-radius:8px;font-weight:700;text-decoration:none;background:transparent;border:1px solid rgba(255,255,255,0.2);color:white;">
                ← Edit Details
            </button>
            <form action="${pageContext.request.contextPath}/confirm-booking" method="post" class="flex-1 m-0">
                <button type="submit" class="btn-primary w-full text-center" style="padding:14px;border-radius:8px;font-size:1rem;font-weight:700;cursor:pointer;">
                    ✓ Secure Checkout (Pay ₹<fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/>)
                </button>
            </form>
        </div>

        <div class="text-center mt-4">
            <span class="text-muted text-xs">🔒 Your payment is secured with 256-bit SSL encryption</span>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
