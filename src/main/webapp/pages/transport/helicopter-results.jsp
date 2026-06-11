<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-yellow-500 font-bold">${origin} ➡ ${destination}</span>
            </div>
            <div class="text-sm">
                ${travelDate} &nbsp; | &nbsp; ${paxCount} Pax &nbsp; | &nbsp; ${flightType} Class
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Choppers</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="heli" items="${heliResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-yellow-500 transition relative overflow-hidden">
                    <c:if test="${heli.type == 'Private'}">
                        <div class="absolute top-0 right-0 bg-yellow-500 text-gray-900 text-xs font-bold px-3 py-1 rounded-bl-lg uppercase">Exclusive</div>
                    </c:if>

                    <div class="flex justify-between items-start mb-4 mt-2">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${heli.operator}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${heli.type} Flight</p>
                        </div>
                        <div class="text-right">
                            <p class="text-2xl font-bold text-white">₹${heli.baseFare}</p>
                            <p class="text-xs text-gray-500 uppercase">${heli.type == 'Shared' ? 'Per Seat' : 'Total Charter'}</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>🕒 ${heli.eta}</span>
                        <span>💺 Max Cap: ${heli.capacity} Pax</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/helicopter/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="heliId" value="${heli.id}">
                        <input type="hidden" name="paxCount" value="${paxCount}">
                        <input type="hidden" name="origin" value="${origin}">
                        <input type="hidden" name="destination" value="${destination}">
                        <input type="hidden" name="travelDate" value="${travelDate}">
                        <button type="submit" class="w-full hover:bg-yellow-600 text-gray-900 font-bold py-3 rounded transition" style="background-color: #f59e0b;">
                            Select Flight
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
