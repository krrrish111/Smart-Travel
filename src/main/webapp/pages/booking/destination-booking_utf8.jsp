<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
/* Destination Booking Form Styles */
main.container form input,
main.container form textarea,
main.container form select {
    background: rgba(255,255,255,.08) !important;
    color: #ffffff !important;
    caret-color: #ffffff !important;
    border: 1px solid rgba(255,255,255,.15) !important;
    -webkit-text-fill-color: #ffffff !important;
    opacity: 1 !important;
}

main.container form input::placeholder,
main.container form textarea::placeholder {
    color: rgba(255,255,255,.55) !important;
    -webkit-text-fill-color: rgba(255,255,255,.55) !important;
}

main.container form input:focus,
main.container form textarea:focus,
main.container form select:focus {
    color: #ffffff !important;
    border-color: #D4AF37 !important;
    box-shadow: 0 0 0 3px rgba(212,175,55,.15) !important;
    outline: none !important;
    -webkit-text-fill-color: #ffffff !important;
}

/* Fix Autofill styling */
main.container form input:-webkit-autofill,
main.container form textarea:-webkit-autofill,
main.container form select:-webkit-autofill {
    -webkit-text-fill-color: #ffffff !important;
    transition: background-color 9999s ease-in-out 0s !important;
}
</style>

<main class="container my-12 max-w-3xl">
    <div class="glass-panel p-8 rounded-2xl border border-gray-100 dark:border-gray-800">
        <h2 class="text-3xl font-bold text-main editorial mb-6">Traveller Details</h2>
        <p class="text-muted mb-8">Please enter the details for all travellers joining the trip.</p>

        <form action="${pageContext.request.contextPath}/destination/review" method="POST">
            <!-- Hidden Fields from Customize -->
            <input type="hidden" name="destination_id" value="${destination.id}">
            <input type="hidden" name="travel_date" value="${travel_date}">
            <input type="hidden" name="travellers" value="${travellers}">
            <input type="hidden" name="hotel_category" value="${hotel_category}">
            <input type="hidden" name="activities" value="${activities}">
            <input type="hidden" name="final_price" value="${final_price}">

            <h3 class="text-xl font-bold text-main mb-4 border-b border-border pb-2">Primary Contact</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div>
                    <label class="block text-sm font-medium text-muted mb-2">Full Name</label>
                    <input type="text" name="primary_name" class="w-full bg-surface border border-border rounded-lg p-3 text-main" required placeholder="John Doe">
                </div>
                <div>
                    <label class="block text-sm font-medium text-muted mb-2">Email Address</label>
                    <input type="email" name="primary_email" class="w-full bg-surface border border-border rounded-lg p-3 text-main" required placeholder="john@example.com">
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-muted mb-2">Phone Number</label>
                    <input type="tel" name="primary_phone" class="w-full bg-surface border border-border rounded-lg p-3 text-main" required placeholder="+91 9876543210">
                </div>
            </div>

            <c:if test="${travellers > 1}">
                <h3 class="text-xl font-bold text-main mb-4 border-b border-border pb-2 mt-8">Other Travellers</h3>
                <c:forEach begin="2" end="${travellers}" var="i">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-4 p-4 border border-border rounded-lg">
                        <div>
                            <label class="block text-sm font-medium text-muted mb-2">Traveller ${i} Name</label>
                            <input type="text" name="traveller_${i}_name" class="w-full bg-surface border border-border rounded-lg p-3 text-main" required placeholder="Jane Doe">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-muted mb-2">Age</label>
                            <input type="number" name="traveller_${i}_age" class="w-full bg-surface border border-border rounded-lg p-3 text-main" required min="1" max="100">
                        </div>
                    </div>
                </c:forEach>
            </c:if>

            <div class="mt-8 flex justify-between items-center">
                <a href="javascript:history.back()" class="text-muted hover:text-main font-medium">â† Back to Customize</a>
                <button type="submit" class="btn btn-primary px-8 py-3">Continue to Review</button>
            </div>
        </form>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
