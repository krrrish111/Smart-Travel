<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">🚁 Review Flight Details</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Flight Itinerary</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Operator:</span> <strong class="text-white">${currentHeliBooking.operator}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Route:</span> <strong class="text-white">${currentHeliBooking.origin} to ${currentHeliBooking.destination}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Date:</span> <strong class="text-white">${currentHeliBooking.travelDate}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Time:</span> <strong class="text-white">${currentHeliBooking.travelTime}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Class:</span> <strong class="text-yellow-500">${currentHeliBooking.flightType}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-lg font-bold text-white mb-4">Passenger Manifest (${currentHeliBooking.paxCount} Pax)</h2>
                        <ul class="space-y-3">
                            <c:set var="totalWeight" value="0" />
                            <c:forEach var="p" items="${currentHeliBooking.passengers}" varStatus="status">
                                <c:set var="totalWeight" value="${totalWeight + p.weightKg}" />
                                <li class="flex justify-between border-b border-gray-700 pb-2">
                                    <span class="text-gray-300">${status.index + 1}. ${p.name}</span>
                                    <span class="text-gray-500 text-sm">Weight: ${p.weightKg} kg</span>
                                </li>
                            </c:forEach>
                        </ul>
                        <div class="mt-4 text-right">
                            <span class="text-gray-400 text-sm uppercase">Total Manifest Weight: </span>
                            <span class="text-white font-bold">${totalWeight} kg</span>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <c:if test="${currentHeliBooking.flightType == 'Shared'}">
                            <div class="flex justify-between text-gray-300 mb-2">
                                <span>Per Seat Rate</span>
                                <span>₹${currentHeliBooking.amount / currentHeliBooking.paxCount}</span>
                            </div>
                            <div class="flex justify-between text-gray-300 mb-2">
                                <span>Seats</span>
                                <span>x ${currentHeliBooking.paxCount}</span>
                            </div>
                        </c:if>
                        <c:if test="${currentHeliBooking.flightType == 'Private'}">
                            <div class="flex justify-between text-gray-300 mb-2">
                                <span>Whole Charter</span>
                                <span>₹${currentHeliBooking.amount}</span>
                            </div>
                        </c:if>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Aviation Taxes</span>
                            <span>Included</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-yellow-500">₹${currentHeliBooking.amount}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/helicopter/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-gray-900 transition" style="background-color: #f59e0b;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
