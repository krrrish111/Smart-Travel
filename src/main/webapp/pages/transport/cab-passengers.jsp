<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Rider Details</h1>
            
            <div class="bg-gray-800 p-4 rounded mb-6 border border-gray-700">
                <p class="text-yellow-400 font-bold">${booking.provider} ${booking.vehicleType}</p>
                <p class="text-gray-300 text-sm">${booking.date} | ${booking.time}</p>
            </div>

            <form action="${pageContext.request.contextPath}/transport/cab/booking" method="post">
                <input type="hidden" name="action" value="passengers">
                
                <div class="grid grid-cols-1 gap-4 mb-6">
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                        <input type="text" name="name" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Mobile Number (Driver will contact this number)</label>
                        <input type="text" name="phone" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Email ID</label>
                        <input type="email" name="email" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                </div>

                <div class="text-right">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold" style="background-color: #eab308; color: #111827;">Review Trip</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
