<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.voyastra.dao.TripDAO, com.voyastra.model.PremiumTrip" %>
<%
    String idParam = request.getParameter("id");
    PremiumTrip trip = null;
    if (idParam != null && !idParam.isEmpty()) {
        try {
            int id = Integer.parseInt(idParam);
            TripDAO dao = new TripDAO();
            trip = dao.getTripById(id);
        } catch (Exception e) {}
    }
    request.setAttribute("trip", trip);
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .trip-strip {
        background: rgba(255,255,255,0.03);
        border: 1px solid rgba(255,255,255,0.07);
        border-radius: 16px; padding: 16px 20px;
        display: flex; align-items: center; gap: 16px; margin-bottom: 24px;
    }
</style>

<main style="padding-top: 100px; padding-bottom: 80px; background: #080808; min-height: 100vh;">
    <div class="container mx-auto max-w-5xl px-4">

        <!-- Step Progress Bar -->
        <div class="mb-8">
            <jsp:include page="/components/booking-stepper.jsp">
                <jsp:param name="step" value="2"/>
                <jsp:param name="type" value="trip"/>
            </jsp:include>
        </div>

        <c:set var="tripTitle" value="${empty trip.title ? 'Premium Adventure Trip' : trip.title}" />
        <c:set var="tripImg" value="${empty trip.imageUrl ? 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da' : trip.imageUrl}" />
        <c:set var="tripDest" value="${empty trip.destination ? 'Exotic Location' : trip.destination}" />
        <c:set var="tripDuration" value="${empty trip.duration ? '5 Days, 4 Nights' : trip.duration}" />
        <c:set var="priceInrVal" value="${empty trip.priceInr ? 25000 : trip.priceInr}" />
        <c:set var="discPriceVal" value="${empty trip.discountPrice ? 20000 : trip.discountPrice}" />
        <c:set var="finalPrice" value="${discPriceVal > 0 ? discPriceVal : priceInrVal}" />

        <!-- Trip Selected Strip -->
        <div class="trip-strip">
            <img src="${tripImg}" class="w-14 h-14 rounded-xl object-cover flex-shrink-0" alt="${tripTitle}">
            <div class="flex-1">
                <div class="font-bold text-white text-sm">${tripTitle}</div>
                <div class="text-xs text-gray-400">${tripDest} &nbsp;&bull;&nbsp; ${tripDuration}</div>
            </div>
            <div class="text-right flex-shrink-0">
                <div class="font-bold text-primary text-lg">₹<fmt:formatNumber value="${finalPrice}" type="number" maxFractionDigits="0"/></div>
                <div class="text-xs text-gray-500">per person</div>
            </div>
        </div>

        <h1 class="text-3xl font-bold mb-6 editorial">Traveler Details</h1>
        
        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Left Column: Form -->
            <div class="lg:w-2/3">
                <form action="${pageContext.request.contextPath}/trip/review" method="POST" class="surface-panel rounded-2xl p-6 md:p-8 shadow-xl" id="checkoutForm">
                    <input type="hidden" name="tripId" value="${empty trip.id ? 1 : trip.id}">
                    <input type="hidden" name="tripTitle" value="${tripTitle}">
                    <input type="hidden" name="tripDest" value="${tripDest}">
                    <input type="hidden" name="tripDuration" value="${tripDuration}">
                    <input type="hidden" name="basePrice" value="${finalPrice}">
                    <input type="hidden" id="hiddenTotalPriceInput" name="totalPrice" value="${finalPrice}">

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700">Lead Traveler Information</h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block text-sm font-medium mb-1">First Name <span class="text-red-500">*</span></label>
                            <input type="text" name="firstName" class="input-field w-full" value="${sessionScope.user.name}" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Last Name <span class="text-red-500">*</span></label>
                            <input type="text" name="lastName" class="input-field w-full" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Email Address <span class="text-red-500">*</span></label>
                            <input type="email" name="guestEmail" class="input-field w-full" value="${sessionScope.user.email}" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Phone Number <span class="text-red-500">*</span></label>
                            <input type="tel" name="guestPhone" class="input-field w-full" required>
                        </div>
                    </div>

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700 mt-8">Trip Settings</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block text-sm font-medium mb-1">Number of Travelers <span class="text-red-500">*</span></label>
                            <select name="guests" id="guestsSelect" class="input-field w-full" required>
                                <option value="1" selected>1 Traveler</option>
                                <option value="2">2 Travelers</option>
                                <option value="3">3 Travelers</option>
                                <option value="4">4 Travelers</option>
                                <option value="5">5 Travelers</option>
                                <option value="6">6 Travelers</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Departure Date <span class="text-red-500">*</span></label>
                            <input type="date" name="departureDate" class="input-field w-full" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date(System.currentTimeMillis() + 86400000L * 7)) %>">
                        </div>
                    </div>

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700 mt-8">Special Requests</h2>
                    <div class="mb-6">
                        <textarea name="specialRequests" class="input-field w-full h-32" placeholder="Any dietary requirements, medical conditions, or special requests? (Optional)"></textarea>
                    </div>

                    <button type="submit" class="btn-primary w-full py-4 rounded-xl text-lg font-bold shadow-lg transform transition-transform hover:-translate-y-1">
                        Continue to Review <span id="submitButtonDisplay">₹<fmt:formatNumber value="${finalPrice}" type="number" maxFractionDigits="0"/></span>
                    </button>
                    
                </form>
            </div>

            <!-- Right Column: Summary -->
            <div class="lg:w-1/3">
                <div class="surface-panel rounded-2xl p-6 shadow-xl sticky top-24">
                    <h2 class="text-xl font-medium mb-4">Trip Summary</h2>
                    
                    <div class="flex gap-4 mb-6">
                        <div class="w-1/3 h-20 rounded-lg overflow-hidden flex-shrink-0">
                             <img src="${tripImg}" class="w-full h-full object-cover">
                        </div>
                        <div>
                            <h3 class="font-medium">${tripTitle}</h3>
                            <p class="text-sm text-gray-500">${tripDest}</p>
                            <div class="text-xs text-primary mt-1"><i class="fas fa-star text-accent"></i> ${empty trip.rating ? 4.8 : trip.rating}</div>
                        </div>
                    </div>

                    <div class="border-t border-b border-gray-200 dark:border-gray-700 py-4 mb-4 space-y-3 text-sm">
                        <div class="flex justify-between">
                            <span class="text-gray-500">Duration</span>
                            <span class="font-medium">${tripDuration}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500">Destination</span>
                            <span class="font-medium">${tripDest}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500">Travelers</span>
                            <span class="font-medium" id="summaryGuestsDisplay">1 Traveler</span>
                        </div>
                    </div>

                    <div class="space-y-2 mb-4">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">₹<fmt:formatNumber value="${finalPrice}" type="number" maxFractionDigits="0"/> x <span id="priceMultiplier">1</span></span>
                            <span id="subtotalPriceDisplay">₹<fmt:formatNumber value="${finalPrice}" type="number" maxFractionDigits="0"/></span>
                        </div>
                        <div class="flex justify-between text-sm text-green-600">
                            <span>Taxes & Fees</span>
                            <span>Included</span>
                        </div>
                    </div>

                    <div class="border-t border-gray-200 dark:border-gray-700 pt-4 flex justify-between items-center text-lg font-bold">
                        <span>Total Price</span>
                        <span class="text-primary" id="summaryTotalPriceDisplay">₹<fmt:formatNumber value="${finalPrice}" type="number" maxFractionDigits="0"/></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const basePrice = parseFloat(${finalPrice});
        const guestsSelect = document.getElementById('guestsSelect');
        const summaryGuestsDisplay = document.getElementById('summaryGuestsDisplay');
        const priceMultiplier = document.getElementById('priceMultiplier');
        const subtotalPriceDisplay = document.getElementById('subtotalPriceDisplay');
        const summaryTotalPriceDisplay = document.getElementById('summaryTotalPriceDisplay');
        const submitButtonDisplay = document.getElementById('submitButtonDisplay');
        const hiddenTotalPriceInput = document.getElementById('hiddenTotalPriceInput');

        function updateTotal() {
            const numGuests = parseInt(guestsSelect.value) || 1;
            const total = basePrice * numGuests;

            summaryGuestsDisplay.innerText = numGuests + (numGuests === 1 ? ' Traveler' : ' Travelers');
            priceMultiplier.innerText = numGuests;
            
            // Format currency
            const formatter = new Intl.NumberFormat('en-IN', {
                style: 'currency',
                currency: 'INR',
                maximumFractionDigits: 0
            });
            
            const formattedTotal = formatter.format(total);

            subtotalPriceDisplay.innerText = formattedTotal;
            summaryTotalPriceDisplay.innerText = formattedTotal;
            submitButtonDisplay.innerText = formattedTotal;
            hiddenTotalPriceInput.value = total;
        }

        guestsSelect.addEventListener('change', updateTotal);
    });
</script>

<%@ include file="/components/footer.jsp" %>
