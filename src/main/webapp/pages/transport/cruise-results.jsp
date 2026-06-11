<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-cyan-400 font-bold">${departurePort} ➡ ${destination}</span>
            </div>
            <div class="text-sm">
                ${cruiseDate} &nbsp; | &nbsp; ${paxCount} Passenger(s) &nbsp; | &nbsp; ${cabinType}
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Sailings</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="cruise" items="${cruiseResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-cyan-500 transition">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${cruise.shipName}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${cruise.cruiseLine}</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>🌙 ${cruise.durationDays} Nights</span>
                        <span>🛏️ ${cruise.cabinType} Cabin</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/cruise/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="cruiseId" value="${cruise.id}">
                        <input type="hidden" name="cabinType" value="${cabinType}">
                        <input type="hidden" name="paxCount" value="${paxCount}">
                        <input type="hidden" name="departurePort" value="${departurePort}">
                        <input type="hidden" name="destination" value="${destination}">
                        <input type="hidden" name="cruiseDate" value="${cruiseDate}">
                        <button type="submit" class="w-full hover:bg-cyan-600 text-gray-900 font-bold py-3 rounded transition" style="background-color: #06b6d4;">
                            Select Cabin
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
