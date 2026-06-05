<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    @keyframes successPop {
        0%   { transform: scale(0.5); opacity: 0; }
        70%  { transform: scale(1.15); }
        100% { transform: scale(1); opacity: 1; }
    }
    @keyframes confettiFall {
        0%   { transform: translateY(-40px) rotate(0deg); opacity: 1; }
        100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
    }
    .check-circle { animation: successPop 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275) both; }
    .confetti-piece {
        position: fixed; top: -20px; border-radius: 2px;
        animation: confettiFall linear forwards;
        z-index: 9999; pointer-events: none;
    }
    .booking-voucher-card {
        background: linear-gradient(135deg, rgba(255,255,255,0.04), rgba(255,255,255,0.01));
        border: 1.5px dashed var(--accent-color, #f59e0b);
        border-radius: 20px;
        padding: 32px;
        position: relative;
        overflow: hidden;
    }
    .booking-voucher-card::before {
        content: '';
        position: absolute;
        left: -1px; top: 50%;
        transform: translateY(-50%);
        width: 24px; height: 24px;
        background: var(--bg-main, #0a0a0a);
        border-radius: 50%;
        border-right: 1.5px dashed var(--accent-color, #f59e0b);
    }
    .booking-voucher-card::after {
        content: '';
        position: absolute;
        right: -1px; top: 50%;
        transform: translateY(-50%);
        width: 24px; height: 24px;
        background: var(--bg-main, #0a0a0a);
        border-radius: 50%;
        border-left: 1.5px dashed var(--accent-color, #f59e0b);
    }
    .addon-pill {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 5px 12px; border-radius: 999px;
        background: rgba(99, 102, 241, 0.15);
        border: 1px solid rgba(99, 102, 241, 0.3);
        color: #a5b4fc;
        font-size: 0.8rem; font-weight: 600;
    }
</style>

<main style="padding-top: 100px; padding-bottom: 80px; min-height: 100vh;">
    <div class="container mx-auto max-w-3xl px-4">
        <div class="surface-panel py-12 px-6 md:px-12 rounded-[2rem] shadow-2xl relative overflow-hidden">

            <!-- Animated background shimmer -->
            <div class="absolute inset-0 pointer-events-none opacity-10"
                 style="background: radial-gradient(ellipse at top, #6366f1 0%, transparent 60%);"></div>

            <div class="relative z-10 text-center">
                <!-- Success Icon -->
                <div class="check-circle w-24 h-24 bg-green-900/30 rounded-full flex items-center justify-center mx-auto mb-6 ring-4 ring-green-500/20">
                    <i class="fas fa-check text-5xl text-green-400"></i>
                </div>

                <h1 class="text-4xl md:text-5xl font-bold mb-3 editorial slide-up">Booking Confirmed!</h1>
                <p class="text-gray-400 mb-8 slide-up" style="animation-delay: 0.1s;">
                    Your stay at <strong class="text-white">${booking.hotel.name}</strong> is all set.<br>
                    A confirmation has been sent to <strong class="text-primary">${booking.guestEmail}</strong>.
                </p>

                <!-- Booking Code Banner -->
                <div class="inline-block bg-primary/10 border border-primary/30 rounded-xl px-6 py-3 mb-10 slide-up" style="animation-delay: 0.15s;">
                    <div class="text-xs text-gray-400 mb-1 uppercase tracking-widest">Booking Reference</div>
                    <div class="text-2xl font-mono tracking-widest font-bold text-primary">${booking.bookingCode}</div>
                </div>

                <!-- Voucher Card -->
                <div class="booking-voucher-card text-left mb-8 slide-up" style="animation-delay: 0.2s;">

                    <!-- Header Row -->
                    <div class="flex justify-between items-center mb-6 pb-5" style="border-bottom: 1px dashed rgba(255,255,255,0.1);">
                        <div>
                            <div class="text-sm text-gray-400 mb-1">Property</div>
                            <div class="font-bold text-xl text-white">${booking.hotel.name}</div>
                            <div class="text-sm text-gray-400">${booking.hotel.city}</div>
                        </div>
                        <div class="text-right">
                            <div class="text-sm text-gray-400 mb-1">Total Paid</div>
                            <div class="text-2xl font-bold text-white">$${booking.totalPrice}</div>
                            <span class="text-xs font-semibold px-2 py-0.5 rounded-md bg-green-900/50 text-green-400 border border-green-800">CONFIRMED</span>
                        </div>
                    </div>

                    <!-- Two Column Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-6">

                        <!-- Stay Details -->
                        <div>
                            <h3 class="font-bold text-sm uppercase tracking-wider text-gray-400 mb-4">Stay Details</h3>
                            <ul class="space-y-3">
                                <li>
                                    <span class="text-gray-500 text-xs block">Room Type</span>
                                    <span class="font-semibold text-white">${booking.room.type}</span>
                                </li>
                                <li class="flex gap-8">
                                    <div>
                                        <span class="text-gray-500 text-xs block">Check-in</span>
                                        <span class="font-semibold text-primary">${booking.checkIn}</span>
                                    </div>
                                    <div>
                                        <span class="text-gray-500 text-xs block">Check-out</span>
                                        <span class="font-semibold text-primary">${booking.checkOut}</span>
                                    </div>
                                </li>
                                <li>
                                    <span class="text-gray-500 text-xs block">Guests</span>
                                    <span class="font-semibold text-white">${booking.guests} Person(s)</span>
                                </li>
                            </ul>
                        </div>

                        <!-- Guest Details -->
                        <div>
                            <h3 class="font-bold text-sm uppercase tracking-wider text-gray-400 mb-4">Guest Details</h3>
                            <ul class="space-y-3">
                                <li>
                                    <span class="text-gray-500 text-xs block">Full Name</span>
                                    <span class="font-semibold text-white">${booking.guestName}</span>
                                </li>
                                <li>
                                    <span class="text-gray-500 text-xs block">Email</span>
                                    <span class="font-semibold text-white">${booking.guestEmail}</span>
                                </li>
                                <li>
                                    <span class="text-gray-500 text-xs block">Phone</span>
                                    <span class="font-semibold text-white">${booking.guestPhone}</span>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <!-- Add-ons & Special Requests parsed from specialRequests field -->
                    <c:if test="${not empty booking.specialRequests}">
                        <div style="border-top: 1px dashed rgba(255,255,255,0.1); padding-top: 20px;">
                            <h3 class="font-bold text-sm uppercase tracking-wider text-gray-400 mb-3">Add-ons & Requests</h3>

                            <%-- Parse the formatted special requests string into parts --%>
                            <c:set var="parts" value="${fn:split(booking.specialRequests, '|')}" />
                            <c:forEach var="part" items="${parts}">
                                <c:set var="trimmed" value="${fn:trim(part)}" />
                                <c:choose>
                                    <c:when test="${fn:startsWith(trimmed, 'Add-ons:')}">
                                        <div class="mb-3">
                                            <div class="text-xs text-gray-500 mb-2">Selected Add-ons</div>
                                            <div class="flex flex-wrap gap-2">
                                                <c:set var="addonsStr" value="${fn:trim(fn:substringAfter(trimmed, 'Add-ons:'))}" />
                                                <c:choose>
                                                    <c:when test="${addonsStr eq 'None'}">
                                                        <span class="text-sm text-gray-500">No add-ons selected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="addon" items="${fn:split(addonsStr, ',')}">
                                                            <span class="addon-pill">
                                                                <i class="fas fa-check-circle"></i> ${fn:trim(addon)}
                                                            </span>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${fn:startsWith(trimmed, 'Nationality:')}">
                                        <div class="flex gap-2 items-center mb-2">
                                            <span class="text-gray-500 text-xs">Nationality:</span>
                                            <span class="text-white text-sm font-medium">${fn:trim(fn:substringAfter(trimmed, 'Nationality:'))}</span>
                                        </div>
                                    </c:when>
                                    <c:when test="${fn:startsWith(trimmed, 'Late Check-in:')}">
                                        <div class="flex gap-2 items-center mb-2">
                                            <span class="text-gray-500 text-xs">Late Check-in:</span>
                                            <span class="text-white text-sm font-medium">${fn:trim(fn:substringAfter(trimmed, 'Late Check-in:'))}</span>
                                        </div>
                                    </c:when>
                                    <c:when test="${fn:startsWith(trimmed, 'Requests:')}">
                                        <div class="flex gap-2 items-start mb-2">
                                            <span class="text-gray-500 text-xs mt-0.5">Special Requests:</span>
                                            <span class="text-white text-sm font-medium">${fn:trim(fn:substringAfter(trimmed, 'Requests:'))}</span>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- Action Buttons -->
                <div class="flex flex-col sm:flex-row justify-center gap-4 slide-up" style="animation-delay: 0.3s;">
                    <a href="${pageContext.request.contextPath}/hotel-voucher?id=${booking.id}"
                       class="btn-outline py-3 px-8 rounded-xl flex items-center justify-center gap-2 group font-bold">
                        <i class="fas fa-file-pdf text-red-500 transition-transform group-hover:-translate-y-1"></i>
                        Download PDF Voucher
                    </a>
                    <a href="${pageContext.request.contextPath}/hotels"
                       class="btn-outline py-3 px-8 rounded-xl flex items-center justify-center gap-2 font-bold">
                        <i class="fas fa-search"></i> Book Another Hotel
                    </a>
                    <a href="${pageContext.request.contextPath}/profile?tab=bookings"
                       class="btn-primary py-3 px-8 rounded-xl flex items-center justify-center gap-2 group font-bold">
                        My Bookings <i class="fas fa-arrow-right transition-transform group-hover:translate-x-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Confetti Script -->
<script>
    (function spawnConfetti() {
        const colors = ['#6366f1','#f59e0b','#10b981','#f43f5e','#3b82f6','#a78bfa'];
        for (let i = 0; i < 80; i++) {
            const el = document.createElement('div');
            el.classList.add('confetti-piece');
            const size = Math.random() * 10 + 6;
            el.style.cssText = `
                width: ${size}px; height: ${size}px;
                left: ${Math.random() * 100}vw;
                background: ${colors[Math.floor(Math.random() * colors.length)]};
                animation-duration: ${Math.random() * 2 + 2}s;
                animation-delay: ${Math.random() * 1.5}s;
                opacity: ${Math.random() * 0.5 + 0.5};
            `;
            document.body.appendChild(el);
            el.addEventListener('animationend', () => el.remove());
        }
    })();
</script>

<%@ include file="/components/footer.jsp" %>