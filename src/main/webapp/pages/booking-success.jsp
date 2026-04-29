<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<jsp:include page="components/header.jsp" />
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px;">
    <div class="container" style="max-width: 700px;">

        <!-- Success Animation -->
        <div class="text-center mb-5 slide-up">
            <div class="success-check-wrap">
                <svg class="success-check" viewBox="0 0 52 52" style="width:80px;height:80px;margin:0 auto 20px;">
                    <circle class="success-check-circle" cx="26" cy="26" r="25" fill="none" stroke="var(--color-primary)" stroke-width="2"/>
                    <path class="success-check-mark" fill="none" stroke="var(--color-primary)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
                </svg>
            </div>
            <h1 class="section-title text-primary" style="font-size:2.5rem;">Booking Confirmed!</h1>
            <p class="text-muted" style="font-size:1.1rem;">Your adventure has been successfully booked. Get ready!</p>
        </div>

        <!-- Booking ID Card -->
        <div class="glass-panel p-5 mb-5 text-center slide-up" style="animation-delay:0.15s;border:2px solid var(--color-primary);background:rgba(212,165,116,0.05);">
            <p class="text-muted text-xs uppercase tracking-widest mb-2">Your Booking ID</p>
            <h2 class="text-primary fw-bold" style="font-size:2rem;letter-spacing:0.1em;">${booking.bookingCode}</h2>
            <p class="text-muted text-xs mt-2">Save this ID for your records. A confirmation email will be sent shortly.</p>
        </div>

        <!-- Trip Summary -->
        <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.2s;">
            <h3 class="fw-bold text-main mb-4"><span class="text-primary mr-2">✈</span> Trip Summary</h3>
            <c:if test="${not empty trip}">
                <div class="flex flex-col sm:flex-row gap-4 items-center mb-4" style="border-bottom:1px solid var(--color-border);padding-bottom:16px;">
                    <div style="width:100px;height:70px;border-radius:10px;overflow:hidden;flex-shrink:0;">
                        <img src="${trip.imageUrl}" style="width:100%;height:100%;object-fit:cover;">
                    </div>
                    <div class="flex-1">
                        <h4 class="text-main fw-bold">${trip.title}</h4>
                        <p class="text-muted text-sm">${trip.destination} • ${trip.duration}</p>
                    </div>
                </div>
            </c:if>
            <div class="grid sm:grid-cols-2 gap-3">
                <div><span class="text-muted text-xs">Travel Date</span><p class="text-main fw-bold text-sm">${booking.travelDate}</p></div>
                <div><span class="text-muted text-xs">Travelers</span><p class="text-main fw-bold text-sm">${booking.numAdults} Adults, ${booking.numChildren} Children</p></div>
                <div><span class="text-muted text-xs">Room Type</span><p class="text-main fw-bold text-sm">${booking.roomType}</p></div>
                <div><span class="text-muted text-xs">Pickup City</span><p class="text-main fw-bold text-sm">${booking.pickupCity}</p></div>
                <div><span class="text-muted text-xs">Status</span><p class="fw-bold text-sm" style="color:#27ae60;">✓ CONFIRMED</p></div>
                <div><span class="text-muted text-xs">Total Paid</span><p class="text-primary fw-bold text-sm" style="font-size:1.1rem;">₹<fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/></p></div>
                <c:if test="${not empty param.txId}">
                    <div class="sm:col-span-2"><span class="text-muted text-xs">Transaction ID</span><p class="text-main fw-bold text-sm" style="color:var(--color-primary);">${param.txId}</p></div>
                </c:if>
            </div>
        </div>

        <!-- What's Next -->
        <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.25s;">
            <h3 class="fw-bold text-main mb-4"><span class="text-primary mr-2">📋</span> What Happens Next</h3>
            <div class="flex gap-3 mb-3 items-start">
                <div style="min-width:28px;height:28px;border-radius:50%;background:var(--color-primary);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">1</div>
                <div><p class="text-main fw-bold text-sm">Confirmation Email</p><p class="text-muted text-xs">A detailed itinerary and voucher will be sent to ${booking.customerEmail}</p></div>
            </div>
            <div class="flex gap-3 mb-3 items-start">
                <div style="min-width:28px;height:28px;border-radius:50%;background:var(--color-primary);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">2</div>
                <div><p class="text-main fw-bold text-sm">Trip Coordinator Call</p><p class="text-muted text-xs">Our travel expert will call you at ${booking.customerPhone} within 24 hours.</p></div>
            </div>
            <div class="flex gap-3 items-start">
                <div style="min-width:28px;height:28px;border-radius:50%;background:var(--color-primary);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;">3</div>
                <div><p class="text-main fw-bold text-sm">Pre-Trip Checklist</p><p class="text-muted text-xs">7 days before travel, you'll receive a packing list and pickup details.</p></div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex flex-col sm:flex-row gap-4 slide-up" style="animation-delay:0.3s;">
            <a href="${pageContext.request.contextPath}/" class="btn-primary flex-1 text-center" style="padding:14px;border-radius:8px;font-weight:700;text-decoration:none;">
                🏠 Back to Home
            </a>
            <a href="${pageContext.request.contextPath}/user-home" class="btn-secondary flex-1 text-center" style="padding:14px;border-radius:8px;font-weight:700;text-decoration:none;">
                📊 My Dashboard
            </a>
        </div>
    </div>
</main>

<style>
    .success-check-circle { stroke-dasharray: 166; stroke-dashoffset: 166; animation: stroke 0.6s cubic-bezier(0.65,0,0.45,1) forwards; }
    .success-check-mark { stroke-dasharray: 48; stroke-dashoffset: 48; animation: stroke 0.3s cubic-bezier(0.65,0,0.45,1) 0.6s forwards; }
    @keyframes stroke { 100% { stroke-dashoffset: 0; } }
</style>

<jsp:include page="components/footer.jsp" />
