<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-4">🚆 Train Details</h1>
            <p class="text-gray-300">Train Number: <strong>${trainNo}</strong></p>
            <p class="text-gray-300">Fare per passenger: <strong>₹${fare}</strong></p>
            
            <div class="mt-6 p-4 bg-gray-800 rounded-lg">
                <h3 class="text-lg font-bold text-white mb-2">Amenities Included</h3>
                <ul class="list-disc list-inside text-gray-400">
                    <li>Pantry Car available</li>
                    <li>Clean Bedrolls (For AC Classes)</li>
                    <li>Charging points in all cabins</li>
                </ul>
            </div>

            <div class="mt-6 flex justify-end gap-4">
                <form action="${pageContext.request.contextPath}/transport/train/booking" method="post">
                    <input type="hidden" name="action" value="passengers">
                    <input type="hidden" name="trainNo" value="${trainNo}">
                    <input type="hidden" name="fare" value="${fare}">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Continue to Passengers</button>
                </form>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
