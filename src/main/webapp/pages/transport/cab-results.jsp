<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-blue-400 font-bold">${tripType}</span> &nbsp;|&nbsp; 
                ${date} at ${time}
            </div>
            <div class="text-sm">
                <strong>Pickup:</strong> ${pickup} &nbsp; <strong>Drop:</strong> ${dropoff}
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Cabs</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="cab" items="${cabResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-yellow-500 transition">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${cab.provider}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${cab.vehicleType}</p>
                        </div>
                        <div class="text-right">
                            <p class="text-2xl font-bold text-green-400">₹${cab.baseFare}</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>👤 ${cab.capacity} Seats</span>
                        <span>⏱ ETA: ${cab.eta}</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/cab/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="cabId" value="${cab.id}">
                        <input type="hidden" name="tripType" value="${tripType}">
                        <input type="hidden" name="pickup" value="${pickup}">
                        <input type="hidden" name="dropoff" value="${dropoff}">
                        <input type="hidden" name="date" value="${date}">
                        <input type="hidden" name="time" value="${time}">
                        <button type="submit" class="w-full bg-yellow-500 hover:bg-yellow-400 text-gray-900 font-bold py-3 rounded transition">
                            Book This Cab
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
