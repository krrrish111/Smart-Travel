<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4">
        <h2 class="text-2xl font-bold text-white mb-6">Buses from ${from} to ${to} on ${date}</h2>
        <div class="flex flex-col gap-4">
            <c:forEach var="bus" items="${busResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex justify-between items-center hover:border-blue-500 transition">
                    <div>
                        <h3 class="text-xl font-bold text-white">${bus.operatorName}</h3>
                        <p class="text-gray-400 text-sm mb-2">${bus.busType}</p>
                        <div class="flex items-center gap-4 text-gray-300">
                            <span>${bus.departureTime}</span>
                            <span class="text-gray-500">→</span>
                            <span>${bus.arrivalTime}</span>
                            <span class="text-xs bg-gray-700 px-2 py-1 rounded">${bus.duration}</span>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-2xl font-bold text-green-400 mb-1">₹${bus.fare}</p>
                        <p class="text-sm text-gray-400 mb-3">${bus.availableSeats} Seats Available</p>
                        <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post">
                            <input type="hidden" name="action" value="details">
                            <input type="hidden" name="busId" value="${bus.id}">
                            <button type="submit" class="bg-blue-600 hover:bg-blue-500 text-white font-bold py-2 px-6 rounded transition">Book Now</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
