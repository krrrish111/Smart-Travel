<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-white">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Booking Confirmed!</h1>
            <p class="text-gray-400">Your payment was successful and your train tickets are confirmed.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking ID</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Train Number</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.trainNumber}</p>
                </div>
            </div>

            <h3 class="text-lg font-bold text-white mb-4">Passengers</h3>
            <div class="space-y-3 mb-6 border-b border-gray-700 pb-6">
                <c:forEach var="pax" items="${booking.passengers}">
                    <div class="flex justify-between items-center bg-gray-800 p-3 rounded">
                        <div>
                            <p class="text-white font-bold">${pax.name}</p>
                            <p class="text-xs text-gray-400">${pax.age} yrs, ${pax.gender}</p>
                        </div>
                        <span class="bg-green-500 bg-opacity-20 text-green-400 px-3 py-1 rounded text-sm font-bold">
                            CNF / ${pax.berthPreference}
                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="flex justify-center gap-4">
                <a href="${pageContext.request.contextPath}/pages/transport/train-ticket.jsp" target="_blank" class="px-6 py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-lg font-bold flex items-center gap-2 transition">
                    <span>📄</span> Download Ticket (PDF)
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="px-6 py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-bold transition">
                    Go to My Bookings
                </a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
