<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Customer & License Details</h1>
            
            <div class="bg-gray-800 p-4 rounded mb-6 border border-gray-700">
                <p class="text-purple-400 font-bold">${booking.carModel}</p>
                <p class="text-gray-300 text-sm">${booking.pickupDate} to ${booking.returnDate}</p>
            </div>

            <!-- IMPORTANT: enctype multipart/form-data for File Upload -->
            <form action="${pageContext.request.contextPath}/transport/car/booking" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="customer">
                
                <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Primary Driver Information</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                    <div class="md:col-span-2">
                        <label class="block text-gray-400 text-sm mb-1">Full Name (As per Driving License)</label>
                        <input type="text" name="name" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-purple-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Mobile Number</label>
                        <input autocomplete="tel" type="text" name="phone" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-purple-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Email ID</label>
                        <input autocomplete="email" type="email" name="email" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-purple-500 outline-none">
                    </div>
                </div>

                <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Mandatory Document</h3>
                <div class="mb-8 p-6 border-2 border-dashed border-gray-600 rounded-lg text-center bg-gray-900">
                    <label class="block text-gray-300 font-bold mb-2">Upload Driving License</label>
                    <p class="text-xs text-gray-500 mb-4">Please upload a clear image or PDF of your valid driving license.</p>
                    <input type="file" name="driving_license" required accept="image/*,.pdf" class="text-gray-400 w-full md:w-2/3 mx-auto block file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-purple-600 file:text-white hover:file:bg-purple-500">
                </div>

                <div class="text-right">
                    <button type="submit" class="text-white py-3 px-8 rounded-lg font-bold transition" style="background-color: #8b5cf6;">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
