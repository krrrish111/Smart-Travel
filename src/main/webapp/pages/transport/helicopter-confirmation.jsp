<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-yellow-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-gray-900">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Flight Confirmed!</h1>
            <p class="text-gray-400">Your helicopter booking is secured. Please arrive 45 mins early for weighing.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking Reference</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Operator</p>
                    <p class="text-xl font-mono text-yellow-500 font-bold">${booking.operator}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Origin</p>
                    <p class="text-white">${booking.origin}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.travelDate}</p>
                </div>
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Destination</p>
                    <p class="text-white">${booking.destination}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.travelTime}</p>
                </div>
            </div>

            <div class="flex justify-center gap-4 mt-8">
                <a href="${pageContext.request.contextPath}/pages/transport/helicopter-ticket.jsp" target="_blank" class="px-6 py-3 text-gray-900 rounded-lg font-bold flex items-center gap-2 transition" style="background-color: #f59e0b;">
                    <span>🎫</span> Download Flight Voucher
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="px-6 py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-bold transition">
                    View My Bookings
                </a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
