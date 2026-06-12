<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">📋 Review Your Bus Booking</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-3">🚌 Bus Details</h2>
                        <p class="text-gray-300">Operator: <span class="font-bold text-white">${booking.busName}</span></p>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-3">👥 Passengers</h2>
                        <div class="flex flex-col gap-3">
                            <c:forEach var="pax" items="${booking.passengers}">
                                <div class="flex justify-between items-center bg-gray-900 p-3 rounded">
                                    <div>
                                        <p class="text-white font-bold">${pax.name}</p>
                                        <p class="text-xs text-gray-400">${pax.age} yrs, ${pax.gender}</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-sm text-gray-300">Seat Pref: ${pax.seatPreference}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Price Summary</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Base Fare (x${booking.passengers.size()})</span>
                            <span>₹${booking.fare * booking.passengers.size()}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Taxes & Fees</span>
                            <span>₹50.0</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${(booking.fare * booking.passengers.size()) + 50}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="btn-primary w-full py-3 rounded-lg font-bold text-lg">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
