<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    .step-circle.done  { background: var(--color-primary, #f97316); color: white; }
    .step-circle.active { background: white; color: #111; box-shadow: 0 0 0 3px var(--color-primary,#f97316); }
    .step-circle.pending { background: rgba(255,255,255,0.08); color: #666; border: 2px solid rgba(255,255,255,0.1); }
    .step-line { flex: 1; height: 2px; background: rgba(255,255,255,0.1); margin: 0 6px; }
    .step-line.done { background: var(--color-primary, #f97316); }
    .step-label { font-size: 0.7rem; font-weight: 600; margin-top: 4px; color: #888; }
    .step-label.active { color: var(--color-primary, #f97316); }
    .step-label.done  { color: #ccc; }
    .step-col { display: flex; flex-direction: column; align-items: center; }
    .hotel-strip {
        background: rgba(255,255,255,0.03);
        border: 1px solid rgba(255,255,255,0.07);
        border-radius: 16px; padding: 16px 20px;
        display: flex; align-items: center; gap: 16px; margin-bottom: 24px;
    }
</style>

<main style="padding-top: 100px; padding-bottom: 80px; background: #080808; min-height: 100vh;">
    <div class="container mx-auto max-w-5xl px-4">

        <!-- Step Progress Bar -->
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
                    <div class="step-circle active">3</div>
                    <div class="step-label active">Details</div>
                </div>
                <div class="step-line"></div>
            </div>
            <div class="step-item">
                <div class="step-col">
                    <div class="step-circle pending">4</div>
                    <div class="step-label">Review</div>
                </div>
                <div class="step-line"></div>
            </div>
            <div class="step-col">
                <div class="step-circle pending">5</div>
                <div class="step-label">Confirm</div>
            </div>
        </div>

        <!-- Hotel / Room Selected Strip -->
        <div class="hotel-strip">
            <img src="${hotel.imageUrl}" class="w-14 h-14 rounded-xl object-cover flex-shrink-0" alt="${hotel.name}">
            <div class="flex-1">
                <div class="font-bold text-white text-sm">${hotel.name}</div>
                <div class="text-xs text-gray-400">${room.type} &nbsp;&bull;&nbsp; ${checkIn} &rarr; ${checkOut} &nbsp;&bull;&nbsp; ${guests} Guest(s)</div>
            </div>
            <div class="text-right flex-shrink-0">
                <div class="font-bold text-primary text-lg">$${totalPrice}</div>
                <div class="text-xs text-gray-500">${days} night(s)</div>
            </div>
        </div>

        <h1 class="text-3xl font-bold mb-6 editorial">Guest Details &amp; Add-ons</h1>
        
        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Left Column: Form -->
            <div class="lg:w-2/3">
                <form action="${pageContext.request.contextPath}/hotel-checkout" method="POST" class="surface-panel rounded-2xl p-6 md:p-8 shadow-xl">
                    <input type="hidden" name="hotelId" value="${hotel.id}">
                    <input type="hidden" name="roomId" value="${room.id}">
                    <input type="hidden" name="checkIn" value="${checkIn}">
                    <input type="hidden" name="checkOut" value="${checkOut}">
                    <input type="hidden" name="guests" value="${guests}">
                    <input type="hidden" id="hiddenTotalPriceInput" name="totalPrice" value="${totalPrice}">

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700">Guest Details</h2>
                    
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
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium mb-1">Nationality <span class="text-red-500">*</span></label>
                            <select name="nationality" class="input-field w-full" required>
                                <option value="">Select your country</option>
                                <option value="US">United States</option>
                                <option value="UK">United Kingdom</option>
                                <option value="CA">Canada</option>
                                <option value="AU">Australia</option>
                                <option value="IN">India</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                    </div>

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700 mt-8">Enhance Your Stay (Add-ons)</h2>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-8">
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Airport Transfer" data-name="Airport Transfer" data-price="45" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Airport Transfer</div>
                                <div class="text-xs text-gray-500">Pick-up and Drop-off</div>
                            </div>
                            <div class="font-bold text-primary">+$45</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Breakfast" data-name="Breakfast" data-price="20" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Breakfast</div>
                                <div class="text-xs text-gray-500">Buffet style daily</div>
                            </div>
                            <div class="font-bold text-primary">+$20</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Dinner" data-name="Dinner" data-price="35" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Dinner</div>
                                <div class="text-xs text-gray-500">Gourmet 3-course meal</div>
                            </div>
                            <div class="font-bold text-primary">+$35</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Spa Access" data-name="Spa Access" data-price="80" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Spa Access</div>
                                <div class="text-xs text-gray-500">Full day pass & massage</div>
                            </div>
                            <div class="font-bold text-primary">+$80</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Laundry Service" data-name="Laundry Service" data-price="15" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Laundry Service</div>
                                <div class="text-xs text-gray-500">Next day return</div>
                            </div>
                            <div class="font-bold text-primary">+$15</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Tour Guide" data-name="Tour Guide" data-price="50" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Tour Guide</div>
                                <div class="text-xs text-gray-500">Half-day city tour</div>
                            </div>
                            <div class="font-bold text-primary">+$50</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="addons" value="Travel Insurance" data-name="Travel Insurance" data-price="25" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Travel Insurance</div>
                                <div class="text-xs text-gray-500">Full coverage</div>
                            </div>
                            <div class="font-bold text-primary">+$25</div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer p-4 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
                            <input type="checkbox" name="lateCheckIn" value="yes" class="w-5 h-5 text-primary rounded border-gray-300 focus:ring-primary">
                            <div class="flex-1">
                                <div class="font-medium text-gray-900 dark:text-white">Late Check-in</div>
                                <div class="text-xs text-gray-500">Arrive after 22:00</div>
                            </div>
                            <div class="font-bold text-gray-400">Free</div>
                        </label>
                    </div>

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700 mt-8">Special Requests</h2>
                    <div class="mb-6">
                        <textarea name="specialRequests" class="input-field w-full h-32" placeholder="Any special requests? (Optional)"></textarea>
                    </div>

                    <h2 class="text-xl font-medium mb-6 pb-2 border-b border-gray-200 dark:border-gray-700 mt-8">Payment Details</h2>
                    <div class="p-4 bg-gray-50 dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 mb-8">
                        <div class="flex items-center gap-3 mb-4 text-gray-500">
                            <i class="fas fa-lock"></i> Secure Payment
                        </div>
                        <div class="mb-4">
                            <label class="block text-sm font-medium mb-1">Card Number</label>
                            <input type="text" class="input-field w-full" placeholder="XXXX XXXX XXXX XXXX" required>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium mb-1">Expiry Date</label>
                                <input type="text" class="input-field w-full" placeholder="MM/YY" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1">CVC</label>
                                <input type="text" class="input-field w-full" placeholder="XXX" required>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary w-full py-4 rounded-xl text-lg font-bold shadow-lg transform transition-transform hover:-translate-y-1">
                        Confirm & Pay <span id="submitButtonDisplay">$${totalPrice}</span>
                    </button>
                    
                    <c:if test="${not empty error}">
                        <div class="mt-4 p-3 bg-red-100 text-red-700 rounded-lg text-sm">
                            ${error}
                        </div>
                    </c:if>
                </form>
            </div>

            <!-- Right Column: Summary -->
            <div class="lg:w-1/3">
                <div class="surface-panel rounded-2xl p-6 shadow-xl sticky top-24">
                    <h2 class="text-xl font-medium mb-4">Booking Summary</h2>
                    
                    <div class="flex gap-4 mb-6">
                        <div class="w-1/3 h-20 rounded-lg overflow-hidden flex-shrink-0">
                             <img src="${hotel.imageUrl}" class="w-full h-full object-cover">
                        </div>
                        <div>
                            <h3 class="font-medium">${hotel.name}</h3>
                            <p class="text-sm text-gray-500">${hotel.city}</p>
                            <div class="text-xs text-primary mt-1"><i class="fas fa-star text-accent"></i> ${hotel.rating}</div>
                        </div>
                    </div>

                    <div class="border-t border-b border-gray-200 dark:border-gray-700 py-4 mb-4 space-y-3 text-sm">
                        <div class="flex justify-between">
                            <span class="text-gray-500">Check-in</span>
                            <span class="font-medium">${checkIn}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500">Check-out</span>
                            <span class="font-medium">${checkOut}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500">Length of stay</span>
                            <span class="font-medium">${days} night(s)</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500">Guests</span>
                            <span class="font-medium">${guests} Guest(s)</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500">Room Type</span>
                            <span class="font-medium">${room.type}</span>
                        </div>
                    </div>

                    <div class="space-y-2 mb-4">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">${room.pricePerNight} x ${days} nights</span>
                            <span>$${totalPrice}</span>
                        </div>
                        <div class="flex justify-between text-sm text-green-600">
                            <span>Taxes & Fees</span>
                            <span>Included</span>
                        </div>
                        <div id="addonsSummaryList" class="border-t border-dashed border-gray-200 dark:border-gray-700 pt-2 mt-2">
                            <!-- JS injected addons -->
                        </div>
                    </div>

                    <div class="border-t border-gray-200 dark:border-gray-700 pt-4 flex justify-between items-center text-lg font-bold">
                        <span>Total Price</span>
                        <span class="text-primary" id="summaryTotalPriceDisplay">$${totalPrice}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const basePrice = parseFloat(${totalPrice});
        const addonCheckboxes = document.querySelectorAll('input[name="addons"]');
        const summaryTotalPriceDisplay = document.getElementById('summaryTotalPriceDisplay');
        const submitButtonDisplay = document.getElementById('submitButtonDisplay');
        const hiddenTotalPriceInput = document.getElementById('hiddenTotalPriceInput');
        const addonsSummaryList = document.getElementById('addonsSummaryList');

        function updateTotal() {
            let addonsTotal = 0;
            let selectedAddons = [];

            addonCheckboxes.forEach(cb => {
                if (cb.checked) {
                    addonsTotal += parseFloat(cb.getAttribute('data-price'));
                    selectedAddons.push({
                        name: cb.getAttribute('data-name'),
                        price: parseFloat(cb.getAttribute('data-price'))
                    });
                }
            });

            const finalPrice = basePrice + addonsTotal;
            const formattedPrice = finalPrice.toFixed(2);

            // Update UI elements
            summaryTotalPriceDisplay.innerText = '$' + formattedPrice;
            submitButtonDisplay.innerText = '$' + formattedPrice;
            hiddenTotalPriceInput.value = formattedPrice;

            // Update summary list
            addonsSummaryList.innerHTML = '';
            if (selectedAddons.length > 0) {
                selectedAddons.forEach(addon => {
                    const row = document.createElement('div');
                    row.className = 'flex justify-between text-sm text-gray-600 dark:text-gray-400 mt-2';
                    row.innerHTML = '<span>+ ' + addon.name + '</span><span>$' + addon.price.toFixed(2) + '</span>';
                    addonsSummaryList.appendChild(row);
                });
            }
        }

        addonCheckboxes.forEach(cb => {
            cb.addEventListener('change', updateTotal);
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>