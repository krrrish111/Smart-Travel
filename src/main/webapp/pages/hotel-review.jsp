<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .step-bar { display: flex; align-items: center; gap: 0; margin-bottom: 32px; }
    .step-item { display: flex; align-items: center; flex: 1; }
    .step-circle {
        width: 36px; height: 36px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 0.85rem; flex-shrink: 0;
        transition: all 0.3s;
    }
    .step-circle.done   { background: var(--color-primary, #f97316); color: white; }
    .step-circle.active { background: white; color: #111; box-shadow: 0 0 0 3px var(--color-primary, #f97316); }
    .step-circle.pending{ background: rgba(255,255,255,0.08); color: #666; border: 2px solid rgba(255,255,255,0.1); }
    .step-line  { flex: 1; height: 2px; background: rgba(255,255,255,0.1); margin: 0 6px; }
    .step-line.done { background: var(--color-primary, #f97316); }
    .step-label { font-size: 0.7rem; font-weight: 600; margin-top: 4px; color: #888; }
    .step-label.active { color: var(--color-primary, #f97316); }
    .step-label.done   { color: #ccc; }
    .step-col { display: flex; flex-direction: column; align-items: center; }

    .review-section {
        background: rgba(255,255,255,0.03);
        border: 1px solid rgba(255,255,255,0.07);
        border-radius: 16px;
        padding: 24px 28px;
        margin-bottom: 16px;
    }
    .review-section h3 {
        font-size: 0.75rem;
        font-weight: 700;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: #888;
        margin-bottom: 16px;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.06);
    }
    .review-row {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 10px;
        gap: 16px;
    }
    .review-label { font-size: 0.85rem; color: #888; flex-shrink: 0; }
    .review-value { font-size: 0.9rem; font-weight: 600; color: white; text-align: right; }
    .addon-pill {
        display: inline-flex; align-items: center; gap: 5px;
        padding: 4px 10px; border-radius: 999px;
        background: rgba(99, 102, 241, 0.15);
        border: 1px solid rgba(99, 102, 241, 0.3);
        color: #a5b4fc;
        font-size: 0.78rem; font-weight: 600;
    }
    .terms-card {
        background: rgba(255,255,255,0.03);
        border: 1.5px solid rgba(255,255,255,0.07);
        border-radius: 16px;
        padding: 20px 24px;
        display: flex;
        align-items: flex-start;
        gap: 14px;
        cursor: pointer;
        transition: border-color 0.2s;
        margin-bottom: 20px;
    }
    .terms-card:has(input:checked) {
        border-color: var(--color-primary, #f97316);
        background: rgba(249, 115, 22, 0.05);
    }
    .price-total-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 18px 0;
        border-top: 2px solid rgba(255,255,255,0.1);
    }
</style>

<main style="padding-top: 100px; padding-bottom: 100px; background: #080808; min-height: 100vh;">
    <div class="container mx-auto max-w-5xl px-4">

        <!-- 5-Step Progress Bar -->
        <div class="step-bar mb-8">
            <div class="step-item">
                <div class="step-col">
                    <div class="step-circle done"><i class="fas fa-check"></i></div>
                    <div class="step-label done">Search</div>
                </div>
                <div class="step-line done"></div>
            </div>
            <div class="step-item">
                <div class="step-col">
                    <div class="step-circle done"><i class="fas fa-check"></i></div>
                    <div class="step-label done">Room</div>
                </div>
                <div class="step-line done"></div>
            </div>
            <div class="step-item">
                <div class="step-col">
                    <div class="step-circle done"><i class="fas fa-check"></i></div>
                    <div class="step-label done">Details</div>
                </div>
                <div class="step-line done"></div>
            </div>
            <div class="step-item">
                <div class="step-col">
                    <div class="step-circle active">4</div>
                    <div class="step-label active">Review</div>
                </div>
                <div class="step-line"></div>
            </div>
            <div class="step-col">
                <div class="step-circle pending">5</div>
                <div class="step-label">Confirm</div>
            </div>
        </div>

        <h1 class="text-3xl font-bold mb-2 editorial">Review Your Booking</h1>
        <p class="text-gray-400 mb-8">Please review all details carefully before confirming your reservation.</p>

        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-900/30 border border-red-700 rounded-xl text-red-300 font-medium flex items-center gap-3">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="flex flex-col lg:flex-row gap-8">

            <!-- Left: Review Sections -->
            <div class="lg:w-2/3 flex flex-col gap-4">

                <!-- Hotel & Room -->
                <div class="review-section">
                    <h3><i class="fas fa-hotel mr-2"></i>Property</h3>
                    <div class="flex gap-4">
                        <img src="${pending.hotel.imageUrl}" alt="${pending.hotel.name}"
                             class="w-20 h-20 rounded-xl object-cover flex-shrink-0">
                        <div>
                            <div class="font-bold text-white text-lg mb-1">${pending.hotel.name}</div>
                            <div class="text-gray-400 text-sm mb-2"><i class="fas fa-map-marker-alt mr-1 text-primary"></i>${pending.hotel.city}</div>
                            <div class="text-sm font-semibold text-gray-300">
                                <i class="fas fa-bed mr-1 text-gray-500"></i>${pending.room.type}
                                &nbsp;&bull;&nbsp;
                                <span class="text-yellow-400"><i class="fas fa-star"></i></span> ${pending.hotel.rating}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stay Details -->
                <div class="review-section">
                    <h3><i class="fas fa-calendar-alt mr-2"></i>Stay Details</h3>
                    <div class="grid grid-cols-2 gap-y-4 gap-x-8">
                        <div>
                            <div class="review-label">Check-in</div>
                            <div class="review-value text-primary">${pending.checkIn}</div>
                        </div>
                        <div>
                            <div class="review-label">Check-out</div>
                            <div class="review-value text-primary">${pending.checkOut}</div>
                        </div>
                        <div>
                            <div class="review-label">Total Nights</div>
                            <div class="review-value">${nights} Night(s)</div>
                        </div>
                        <div>
                            <div class="review-label">Guests</div>
                            <div class="review-value">${pending.guests} Person(s)</div>
                        </div>
                        <div>
                            <div class="review-label">Room Type</div>
                            <div class="review-value">${pending.room.type}</div>
                        </div>
                        <div>
                            <div class="review-label">Booking Code</div>
                            <div class="review-value font-mono text-sm text-gray-300">${pending.bookingCode}</div>
                        </div>
                    </div>
                </div>

                <!-- Guest Details -->
                <div class="review-section">
                    <h3><i class="fas fa-user mr-2"></i>Guest Details</h3>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-3 gap-x-8">
                        <div class="review-row"><span class="review-label">Full Name</span><span class="review-value">${pending.guestName}</span></div>
                        <div class="review-row"><span class="review-label">Email</span><span class="review-value">${pending.guestEmail}</span></div>
                        <div class="review-row"><span class="review-label">Phone</span><span class="review-value">${pending.guestPhone}</span></div>
                        <%-- Parse Nationality from specialRequests --%>
                        <c:set var="parts" value="${fn:split(pending.specialRequests, '|')}" />
                        <c:forEach var="part" items="${parts}">
                            <c:set var="t" value="${fn:trim(part)}" />
                            <c:if test="${fn:startsWith(t, 'Nationality:')}">
                                <div class="review-row"><span class="review-label">Nationality</span><span class="review-value">${fn:trim(fn:substringAfter(t, 'Nationality:'))}</span></div>
                            </c:if>
                            <c:if test="${fn:startsWith(t, 'Late Check-in:')}">
                                <div class="review-row"><span class="review-label">Late Check-in</span><span class="review-value">${fn:trim(fn:substringAfter(t, 'Late Check-in:'))}</span></div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- Add-ons -->
                <div class="review-section">
                    <h3><i class="fas fa-concierge-bell mr-2"></i>Add-ons Selected</h3>
                    <c:choose>
                        <c:when test="${not empty addons}">
                            <div class="flex flex-wrap gap-2">
                                <c:forEach var="addon" items="${addons}">
                                    <span class="addon-pill"><i class="fas fa-check-circle"></i>${addon}</span>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-gray-500 text-sm">No add-ons selected</p>
                        </c:otherwise>
                    </c:choose>

                    <%-- Special Requests --%>
                    <c:forEach var="part" items="${parts}">
                        <c:set var="t" value="${fn:trim(part)}" />
                        <c:if test="${fn:startsWith(t, 'Requests:') and fn:trim(fn:substringAfter(t, 'Requests:')) ne 'None'}">
                            <div class="mt-4 p-3 bg-white/5 rounded-xl text-sm text-gray-300 border border-white/10">
                                <span class="text-gray-500 text-xs block mb-1">Special Requests</span>
                                ${fn:trim(fn:substringAfter(t, 'Requests:'))}
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <!-- Terms & Conditions -->
                <form action="${pageContext.request.contextPath}/hotel-review" method="POST">
                    <label class="terms-card">
                        <input type="checkbox" name="termsAccepted" class="mt-0.5 w-5 h-5 rounded text-primary flex-shrink-0" required>
                        <div>
                            <div class="font-semibold text-white mb-1">I agree to the Terms & Conditions</div>
                            <div class="text-xs text-gray-400 leading-relaxed">
                                By proceeding, I confirm that all details are correct and agree to Voyastra's
                                <a href="#" class="text-primary hover:underline">Terms of Service</a>,
                                <a href="#" class="text-primary hover:underline">Privacy Policy</a>,
                                and the property's cancellation policy. I understand this booking is subject to
                                availability and the rate shown is inclusive of taxes.
                            </div>
                        </div>
                    </label>

                    <button type="submit" class="btn-primary w-full py-4 rounded-xl text-lg font-bold shadow-lg
                        transform transition-all hover:-translate-y-1 hover:shadow-primary/30 flex items-center justify-center gap-3">
                        <i class="fas fa-lock text-sm"></i>
                        Proceed to Payment &mdash; $${grandTotal}
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/hotel-checkout?hotelId=${pending.hotelId}&roomId=${pending.roomId}&checkIn=${pending.checkIn}&checkOut=${pending.checkOut}&guests=${pending.guests}"
                   class="text-center text-sm text-gray-500 hover:text-gray-300 transition-colors mt-2 block">
                    <i class="fas fa-arrow-left mr-1"></i> Edit Guest Details
                </a>

            </div>

            <!-- Right: Price Summary -->
            <aside class="lg:w-1/3">
                <div class="sticky top-[100px] review-section" style="border-color: rgba(255,255,255,0.1);">
                    <h3><i class="fas fa-receipt mr-2"></i>Price Summary</h3>

                    <div class="space-y-3 mb-4">
                        <div class="review-row">
                            <span class="review-label">Room Rate</span>
                            <span class="review-value">$${pending.room.pricePerNight} &times; ${nights} nights</span>
                        </div>
                        <c:if test="${not empty addons}">
                            <c:forEach var="addon" items="${addons}">
                                <div class="review-row">
                                    <span class="review-label">${addon}</span>
                                    <span class="review-value text-indigo-400">Included</span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <div class="review-row">
                            <span class="review-label">Subtotal</span>
                            <span class="review-value">$${pending.totalPrice}</span>
                        </div>
                        <div class="review-row">
                            <span class="review-label text-green-400">Taxes & Fees (10%)</span>
                            <span class="review-value text-green-400">+ $${tax}</span>
                        </div>
                    </div>

                    <div class="price-total-row">
                        <span class="font-bold text-white text-lg">Grand Total</span>
                        <span class="font-bold text-primary text-2xl">$${grandTotal}</span>
                    </div>

                    <div class="mt-4 flex flex-col gap-2 text-xs text-gray-500">
                        <div class="flex items-center gap-2"><i class="fas fa-shield-alt text-green-500"></i> Secure SSL encrypted payment</div>
                        <div class="flex items-center gap-2"><i class="fas fa-check text-green-500"></i> Instant booking confirmation</div>
                        <div class="flex items-center gap-2"><i class="fas fa-envelope text-green-500"></i> Confirmation email sent automatically</div>
                    </div>

                    <div class="mt-6 flex justify-center gap-4 text-gray-600 text-2xl">
                        <i class="fab fa-cc-visa"></i>
                        <i class="fab fa-cc-mastercard"></i>
                        <i class="fab fa-cc-amex"></i>
                        <i class="fab fa-cc-paypal"></i>
                    </div>
                </div>
            </aside>

        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
