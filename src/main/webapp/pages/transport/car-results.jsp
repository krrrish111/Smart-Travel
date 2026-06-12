<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-purple-400 font-bold">${pickupCity}</span>
            </div>
            <div class="text-sm">
                ${pickupDate} &nbsp; ➡ &nbsp; ${returnDate} &nbsp; <span class="bg-gray-700 px-2 py-1 rounded text-white">${days} Days</span>
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Self Drive Cars</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="car" items="${carResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-purple-500 transition">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${car.carModel}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${car.vehicleType}</p>
                        </div>
                        <div class="text-right">
                            <p class="text-2xl font-bold text-green-400">₹${car.pricePerDay}</p>
                            <p class="text-xs text-gray-500">per day</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>👤 ${car.seats} Seats</span>
                        <span>⚙️ ${car.transmission}</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/car/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="carId" value="${car.id}">
                        <input type="hidden" name="pickupCity" value="${pickupCity}">
                        <input type="hidden" name="pickupDate" value="${pickupDate}">
                        <input type="hidden" name="returnDate" value="${returnDate}">
                        <input type="hidden" name="days" value="${days}">
                        <button type="submit" class="w-full hover:bg-purple-600 text-white font-bold py-3 rounded transition" style="background-color: #8b5cf6;">
                            Select Vehicle
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
