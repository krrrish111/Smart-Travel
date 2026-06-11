<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Bus Details</h1>
            <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 mb-6">
                <h2 class="text-xl font-bold text-blue-400">${bus.operatorName}</h2>
                <p class="text-gray-400">${bus.busType}</p>
                <div class="mt-4 flex justify-between text-gray-300">
                    <div>
                        <p class="text-sm">Departure</p>
                        <p class="font-bold text-lg text-white">${bus.departureTime}</p>
                    </div>
                    <div>
                        <p class="text-sm">Duration</p>
                        <p class="font-bold">${bus.duration}</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm">Arrival</p>
                        <p class="font-bold text-lg text-white">${bus.arrivalTime}</p>
                    </div>
                </div>
            </div>
            
            <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post" class="text-right mt-6">
                <input type="hidden" name="action" value="seats">
                <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Select Seats</button>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
