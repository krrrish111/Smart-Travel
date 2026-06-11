<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Passenger Details</h1>
            
            <div class="bg-gray-800 p-4 rounded mb-6 border border-gray-700 flex justify-between">
                <div>
                    <p class="text-cyan-400 font-bold text-lg">${currentCruiseBooking.shipName} (${currentCruiseBooking.cruiseLine})</p>
                    <p class="text-gray-300 text-sm">Sailing: ${currentCruiseBooking.cruiseDate} | ${currentCruiseBooking.durationDays} Nights</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Cabin</p>
                    <p class="text-white font-bold">${currentCruiseBooking.cabinType}</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/transport/cruise/booking" method="post">
                <input type="hidden" name="action" value="passengers">
                
                <c:forEach var="i" begin="0" end="${currentCruiseBooking.paxCount - 1}">
                    <div class="mb-6 border border-gray-700 rounded-lg p-5 bg-gray-900">
                        <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Passenger ${i + 1}</h3>
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div class="md:col-span-2">
                                <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                                <input type="text" name="name_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Age</label>
                                <input type="number" name="age_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Gender</label>
                                <select name="gender_${i}" class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                </select>
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-gray-400 text-sm mb-1">Passport Number / Govt ID</label>
                                <input type="text" name="passport_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="text-right">
                    <button type="submit" class="text-gray-900 py-3 px-8 rounded-lg font-bold transition" style="background-color: #06b6d4;">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
