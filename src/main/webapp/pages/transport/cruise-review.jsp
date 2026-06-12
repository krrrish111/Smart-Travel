<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">⚓ Review Cruise Itinerary</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Sailing Details</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Vessel:</span> <strong class="text-white">${booking.shipName}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Route:</span> <strong class="text-white">${booking.departurePort} to ${booking.destination}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Departure:</span> <strong class="text-white">${booking.cruiseDate}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Duration:</span> <strong class="text-white">${booking.durationDays} Nights</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Cabin:</span> <strong class="text-white">${booking.cabinType}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-lg font-bold text-white mb-4">Guest Manifest (${booking.paxCount} Pax)</h2>
                        <ul class="space-y-3">
                            <c:forEach var="p" items="${booking.passengers}" varStatus="status">
                                <li class="flex justify-between border-b border-gray-700 pb-2">
                                    <span class="text-gray-300">${status.index + 1}. ${p.name} (${p.age} yrs, ${p.gender})</span>
                                    <span class="text-gray-500 text-sm">Passport: ${p.passportNumber}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Cabin Fare</span>
                            <span>₹${booking.amount}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Port Taxes</span>
                            <span>₹${booking.paxCount * 2500}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Gratuities</span>
                            <span>Included</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${booking.amount + (booking.paxCount * 2500)}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/cruise/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-gray-900 transition" style="background-color: #06b6d4;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
