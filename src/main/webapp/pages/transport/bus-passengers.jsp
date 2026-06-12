<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-white">Passenger Details</h1>
                <span class="bg-blue-500 bg-opacity-20 text-blue-400 font-bold px-3 py-1 rounded">Selected Seats: ${booking.passengers.size()}</span>
            </div>

            <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post" id="passengerForm">
                <input type="hidden" name="action" value="save_passengers">
                
                <div id="passengerContainer">
                    <c:forEach var="pax" items="${booking.passengers}" varStatus="status">
                        <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 mb-4 passenger-block">
                            <div class="flex justify-between items-center mb-4 border-b border-gray-700 pb-2">
                                <h3 class="text-lg text-white font-bold">Passenger ${status.index + 1}</h3>
                                <span class="bg-gray-900 text-green-400 font-bold font-mono px-3 py-1 rounded">Seat: ${pax.seatPreference}</span>
                            </div>
                            
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <div class="md:col-span-1">
                                    <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                                    <input type="text" name="name[]" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-gray-400 text-sm mb-1">Age</label>
                                    <input type="number" name="age[]" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-gray-400 text-sm mb-1">Gender</label>
                                    <select name="gender[]" class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                                        <option>Male</option><option>Female</option><option>Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="text-right mt-6">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
