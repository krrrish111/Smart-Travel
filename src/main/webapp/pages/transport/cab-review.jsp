<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">🚕 Review Trip Details</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Trip Information</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Type:</span> <strong class="text-white">${currentCabBooking.bookingType}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Pickup:</span> <strong class="text-white">${currentCabBooking.pickup}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Drop:</span> <strong class="text-white">${currentCabBooking.dropoff}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Date/Time:</span> <strong class="text-white">${currentCabBooking.date} at ${currentCabBooking.time}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 flex justify-between items-center">
                        <div>
                            <h2 class="text-lg font-bold text-white mb-1">Contact Details</h2>
                            <p class="text-gray-400 text-sm">${currentCabBooking.passenger.name}</p>
                            <p class="text-gray-400 text-sm">${currentCabBooking.passenger.phone} | ${currentCabBooking.passenger.email}</p>
                        </div>
                        <div class="text-right">
                            <span class="bg-gray-700 px-3 py-1 rounded text-sm text-yellow-400 font-bold border border-yellow-500">
                                ${currentCabBooking.provider} ${currentCabBooking.vehicleType}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Base Fare</span>
                            <span>₹${currentCabBooking.amount}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Taxes & Surcharges</span>
                            <span>₹50.0</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${currentCabBooking.amount + 50}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/cab/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-gray-900 transition" style="background-color: #eab308;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
