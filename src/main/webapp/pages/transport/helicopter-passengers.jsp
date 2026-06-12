<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div class="bg-yellow-500 bg-opacity-20 border border-yellow-500 rounded-lg p-4 mb-6 flex items-start gap-4">
            <span class="text-3xl">⚖️</span>
            <div>
                <h3 class="text-yellow-500 font-bold text-lg">Aviation Weight Restrictions Apply</h3>
                <p class="text-gray-300 text-sm">For rotary-wing aircraft safety, accurate passenger weights are mandatory. Standard baggage allowance is 2kg per person. Exceeding weight limits may result in boarding denial without refund.</p>
            </div>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Flight Manifest</h1>
            
            <form action="${pageContext.request.contextPath}/transport/helicopter/booking" method="post">
                <input type="hidden" name="action" value="passengers">
                
                <c:if test="${currentHeliBooking.flightType == 'Private'}">
                    <div class="mb-6 p-5 bg-gray-900 rounded-lg border border-gray-700">
                        <h3 class="text-lg text-white mb-2 font-bold text-yellow-500">Private Charter Preferences</h3>
                        <label class="block text-gray-400 text-sm mb-1">Preferred Departure Time</label>
                        <input type="time" name="prefTime" class="bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                </c:if>

                <c:forEach var="i" begin="0" end="${currentHeliBooking.paxCount - 1}">
                    <div class="mb-6 border border-gray-700 rounded-lg p-5 bg-gray-900">
                        <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Passenger ${i + 1}</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                                <input type="text" name="name_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Exact Body Weight (in Kg)</label>
                                <input type="number" step="0.1" name="weight_${i}" required placeholder="e.g. 75.5" class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="text-right">
                    <button type="submit" class="text-gray-900 py-3 px-8 rounded-lg font-bold transition" style="background-color: #f59e0b;">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
