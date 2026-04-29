<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 80px; padding-bottom: 80px;">

    <!-- Hero Banner -->
    <div class="relative" style="height: 280px; overflow: hidden;">
        <img src="${trip.imageUrl}" style="width:100%;height:100%;object-fit:cover;filter:brightness(0.45);">
        <div class="absolute w-full text-center" style="top:50%;transform:translateY(-50%);z-index:10;">
            <p class="text-primary fw-bold text-sm uppercase tracking-widest mb-2">Book Your Adventure</p>
            <h1 class="text-white fw-bold" style="font-size:clamp(1.8rem,4vw,3rem);text-shadow:0 4px 20px rgba(0,0,0,0.6);">${trip.title}</h1>
            <p class="text-white opacity-70">${trip.destination} • ${trip.duration}</p>
        </div>
    </div>

    <div class="container" style="margin-top:-40px;position:relative;z-index:20;">
        <form method="POST" action="${pageContext.request.contextPath}/booking" id="bookingForm">
            <input type="hidden" name="action" value="submitBooking">
            <input type="hidden" name="tripId" value="${trip.id}">

            <div class="grid md:grid-cols-3 gap-6">
                <!-- LEFT: Package Summary + Form -->
                <div class="md:col-span-2">

                    <!-- Package Summary Card -->
                    <div class="glass-panel p-5 mb-5 flex flex-col sm:flex-row gap-5 items-center slide-up">
                        <div style="width:140px;height:100px;border-radius:12px;overflow:hidden;flex-shrink:0;">
                            <img src="${trip.imageUrl}" style="width:100%;height:100%;object-fit:cover;">
                        </div>
                        <div class="flex-1">
                            <span class="text-primary text-xs fw-bold uppercase tracking-widest">${trip.category}</span>
                            <h3 class="text-main fw-bold" style="font-size:1.4rem;margin:4px 0;">${trip.title}</h3>
                            <div class="flex flex-wrap gap-4 text-muted text-sm">
                                <span>📍 ${trip.destination}</span>
                                <span>⏱ ${trip.duration}</span>
                                <span>⭐ ${trip.rating}</span>
                                <span>🗓 ${trip.bestSeason}</span>
                            </div>
                        </div>
                        <div class="text-center">
                            <div class="text-muted text-xs line-through">₹<fmt:formatNumber value="${trip.priceInr}" type="number" maxFractionDigits="0"/></div>
                            <div class="text-primary fw-bold" style="font-size:1.6rem;">₹<fmt:formatNumber value="${trip.discountPrice}" type="number" maxFractionDigits="0"/></div>
                            <div class="text-muted text-xs">per person</div>
                        </div>
                    </div>

                    <!-- Travel Details -->
                    <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.1s;">
                        <h3 class="fw-bold text-main mb-4" style="font-size:1.2rem;">
                            <span class="text-primary mr-2">①</span> Travel Details
                        </h3>
                        <div class="grid sm:grid-cols-2 gap-4">
                            <div class="form-group">
                                <label class="form-label">Travel Date *</label>
                                <input type="date" name="travelDate" required class="form-input" min="2026-05-01">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Pickup City *</label>
                                <select name="pickupCity" required class="form-input">
                                    <option value="">Select City</option>
                                    <option>New Delhi</option><option>Mumbai</option><option>Bangalore</option>
                                    <option>Chennai</option><option>Kolkata</option><option>Hyderabad</option>
                                    <option>Pune</option><option>Ahmedabad</option><option>Jaipur</option>
                                    <option>Lucknow</option><option>Chandigarh</option><option>Kochi</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Adults *</label>
                                <select name="numAdults" id="numAdults" required class="form-input" onchange="updatePrice()">
                                    <option value="1">1 Adult</option><option value="2" selected>2 Adults</option>
                                    <option value="3">3 Adults</option><option value="4">4 Adults</option>
                                    <option value="5">5 Adults</option><option value="6">6 Adults</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Children (under 12)</label>
                                <select name="numChildren" id="numChildren" class="form-input" onchange="updatePrice()">
                                    <option value="0" selected>No Children</option><option value="1">1 Child</option>
                                    <option value="2">2 Children</option><option value="3">3 Children</option>
                                </select>
                            </div>
                            <div class="form-group sm:col-span-2">
                                <label class="form-label">Room Type</label>
                                <select name="roomType" id="roomType" class="form-input" onchange="updatePrice()">
                                    <option value="Standard">Standard Room</option>
                                    <option value="Deluxe">Deluxe Room (+30%)</option>
                                    <option value="Suite">Suite (+80%)</option>
                                    <option value="Premium Suite">Premium Suite (+150%)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Customer Details -->
                    <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.2s;">
                        <h3 class="fw-bold text-main mb-4" style="font-size:1.2rem;">
                            <span class="text-primary mr-2">②</span> Customer Details
                        </h3>
                        <div class="grid sm:grid-cols-2 gap-4">
                            <div class="form-group">
                                <label class="form-label">Full Name *</label>
                                <input type="text" name="customerName" required class="form-input" placeholder="Enter your full name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Address *</label>
                                <input type="email" name="customerEmail" required class="form-input" placeholder="you@example.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Number *</label>
                                <input type="tel" name="customerPhone" required class="form-input" placeholder="+91 XXXXX XXXXX">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Special Requests</label>
                                <textarea name="specialRequests" class="form-input" rows="2" placeholder="Any dietary needs, accessibility requirements..."></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: Price Breakdown Sidebar -->
                <div>
                    <div class="glass-panel p-5 sticky slide-up" style="top:100px;animation-delay:0.3s;">
                        <h3 class="fw-bold text-main mb-4" style="font-size:1.2rem;">Price Breakdown</h3>

                        <div class="mb-4" style="border-bottom:1px solid var(--color-border);padding-bottom:16px;">
                            <div class="flex justify-between mb-2">
                                <span class="text-muted text-sm">Base Price</span>
                                <span class="text-main fw-bold">₹<fmt:formatNumber value="${trip.discountPrice > 0 ? trip.discountPrice : trip.priceInr}" type="number" maxFractionDigits="0"/></span>
                            </div>
                            <div class="flex justify-between mb-2">
                                <span class="text-muted text-sm">Travelers</span>
                                <span class="text-main" id="displayTravelers">× 2</span>
                            </div>
                            <div class="flex justify-between mb-2">
                                <span class="text-muted text-sm">Room Upgrade</span>
                                <span class="text-main" id="displayRoomUpgrade">× 1.0</span>
                            </div>
                        </div>

                        <div class="mb-4" style="border-bottom:1px solid var(--color-border);padding-bottom:16px;">
                            <div class="flex justify-between mb-2">
                                <span class="text-muted text-sm">Subtotal</span>
                                <span class="text-main fw-bold" id="displaySubtotal">₹0</span>
                            </div>
                            <div class="flex justify-between mb-2">
                                <span class="text-muted text-sm">GST (5%)</span>
                                <span class="text-main" id="displayTax">₹0</span>
                            </div>
                        </div>

                        <div class="flex justify-between mb-4">
                            <span class="text-main fw-bold" style="font-size:1.1rem;">Total</span>
                            <span class="text-primary fw-bold" style="font-size:1.4rem;" id="displayTotal">₹0</span>
                        </div>

                        <button type="submit" class="btn-primary w-full" style="padding:14px;border-radius:8px;font-size:1rem;font-weight:700;cursor:pointer;">
                            Proceed to Confirmation →
                        </button>

                        <div class="text-center mt-3">
                            <span class="text-muted text-xs">🔒 Secure & encrypted booking</span>
                        </div>

                        <div class="mt-4 p-3" style="background:rgba(212,165,116,0.08);border-radius:8px;border:1px solid rgba(212,165,116,0.2);">
                            <p class="text-xs text-muted mb-1"><strong class="text-primary">Free Cancellation</strong></p>
                            <p class="text-xs text-muted">Full refund up to 30 days before departure date.</p>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<style>
    .form-group { display: flex; flex-direction: column; gap: 6px; }
    .form-label { font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: var(--color-muted); }
    .form-input {
        padding: 10px 14px; border-radius: 8px; border: 1.5px solid var(--color-border);
        background: var(--color-surface); color: var(--color-main); font-size: 0.95rem;
        transition: border-color 0.2s; outline: none; font-family: inherit;
    }
    .form-input:focus { border-color: var(--color-primary); box-shadow: 0 0 0 3px rgba(212,165,116,0.15); }
    select.form-input { cursor: pointer; }
    textarea.form-input { resize: vertical; min-height: 60px; }
</style>

<script>
    const BASE_PRICE = ${trip.discountPrice > 0 ? trip.discountPrice : trip.priceInr};

    function updatePrice() {
        const adults = parseInt(document.getElementById('numAdults').value) || 1;
        const children = parseInt(document.getElementById('numChildren').value) || 0;
        const roomType = document.getElementById('roomType').value;

        let roomMult = 1.0;
        if (roomType === 'Deluxe') roomMult = 1.3;
        else if (roomType === 'Suite') roomMult = 1.8;
        else if (roomType === 'Premium Suite') roomMult = 2.5;

        const travelers = adults + children;
        const subtotal = BASE_PRICE * travelers * roomMult;
        const tax = subtotal * 0.05;
        const total = subtotal + tax;

        document.getElementById('displayTravelers').textContent = '× ' + travelers;
        document.getElementById('displayRoomUpgrade').textContent = '× ' + roomMult.toFixed(1);
        document.getElementById('displaySubtotal').textContent = '₹' + Math.round(subtotal).toLocaleString('en-IN');
        document.getElementById('displayTax').textContent = '₹' + Math.round(tax).toLocaleString('en-IN');
        document.getElementById('displayTotal').textContent = '₹' + Math.round(total).toLocaleString('en-IN');
    }

    // Initialize on load
    document.addEventListener('DOMContentLoaded', updatePrice);
</script>

<%@ include file="/components/footer.jsp" %>
