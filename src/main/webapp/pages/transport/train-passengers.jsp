<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">👥 Passenger Details</h1>
            
            <form action="${pageContext.request.contextPath}/transport/train/booking" method="post" id="passengerForm">
                <input type="hidden" name="action" value="review">
                <input type="hidden" name="trainNo" value="${trainNo}">
                <input type="hidden" name="fare" value="${fare}">
                
                <div id="passengerContainer">
                    <!-- Passenger 1 -->
                    <div class="passenger-card p-4 bg-gray-800 rounded-lg mb-4 border border-gray-700">
                        <h3 class="text-white font-bold mb-3">Passenger 1</h3>
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Full Name</label>
                                <input type="text" name="passengerName" class="w-full bg-gray-900 text-white rounded p-2" required>
                            </div>
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Age</label>
                                <input type="number" name="passengerAge" class="w-full bg-gray-900 text-white rounded p-2" required min="1" max="120">
                            </div>
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Gender</label>
                                <select name="passengerGender" class="w-full bg-gray-900 text-white rounded p-2">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Berth Pref.</label>
                                <select name="passengerBerth" class="w-full bg-gray-900 text-white rounded p-2">
                                    <option value="No Preference">No Preference</option>
                                    <option value="Lower">Lower</option>
                                    <option value="Middle">Middle</option>
                                    <option value="Upper">Upper</option>
                                    <option value="Side Lower">Side Lower</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-6">
                    <button type="button" class="text-blue-400 hover:text-blue-300 font-bold" onclick="addPassenger()">+ Add Another Passenger</button>
                </div>

                <div class="mt-6 flex justify-between">
                    <button type="button" onclick="history.back()" class="bg-gray-700 text-white py-3 px-8 rounded-lg">Back</button>
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
    let paxCount = 1;
    function addPassenger() {
        paxCount++;
        const html = `
            <div class="passenger-card p-4 bg-gray-800 rounded-lg mb-4 border border-gray-700">
                <div class="flex justify-between items-center mb-3">
                    <h3 class="text-white font-bold">Passenger ${paxCount}</h3>
                    <button type="button" class="text-red-400 text-sm" onclick="this.parentElement.parentElement.remove()">Remove</button>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <input type="text" name="passengerName" placeholder="Full Name" class="w-full bg-gray-900 text-white rounded p-2" required>
                    </div>
                    <div>
                        <input type="number" name="passengerAge" placeholder="Age" class="w-full bg-gray-900 text-white rounded p-2" required min="1" max="120">
                    </div>
                    <div>
                        <select name="passengerGender" class="w-full bg-gray-900 text-white rounded p-2">
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div>
                        <select name="passengerBerth" class="w-full bg-gray-900 text-white rounded p-2">
                            <option value="No Preference">No Preference</option>
                            <option value="Lower">Lower</option>
                            <option value="Middle">Middle</option>
                            <option value="Upper">Upper</option>
                            <option value="Side Lower">Side Lower</option>
                        </select>
                    </div>
                </div>
            </div>`;
        document.getElementById('passengerContainer').insertAdjacentHTML('beforeend', html);
    }
</script>
<%@ include file="/components/footer.jsp" %>
