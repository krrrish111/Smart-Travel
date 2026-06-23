<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; background: #080808; min-height: 100vh;">
    <div class="container mx-auto max-w-4xl px-4">

        <!-- Step Progress Bar -->
        <div class="mb-8">
            <jsp:include page="/components/booking-stepper.jsp">
                <jsp:param name="step" value="3"/>
                <jsp:param name="type" value="trip"/>
            </jsp:include>
        </div>

        <h1 class="text-3xl font-bold mb-6 editorial text-center">Review Your Trip Details</h1>

        <div class="surface-panel rounded-2xl p-6 md:p-8 shadow-xl mb-6">
            <h2 class="text-xl font-medium mb-4 pb-2 border-b border-gray-200 dark:border-gray-700">Trip Information</h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                <div>
                    <div class="text-sm text-gray-500">Trip Name</div>
                    <div class="font-medium">${param.tripTitle}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500">Destination</div>
                    <div class="font-medium">${param.tripDest}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500">Duration</div>
                    <div class="font-medium">${param.tripDuration}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500">Departure Date</div>
                    <div class="font-medium">${param.departureDate}</div>
                </div>
            </div>
        </div>

        <div class="surface-panel rounded-2xl p-6 md:p-8 shadow-xl mb-6">
            <h2 class="text-xl font-medium mb-4 pb-2 border-b border-gray-200 dark:border-gray-700">Lead Traveler Information</h2>
            <div class="grid grid-cols-2 gap-4 mb-4">
                <div>
                    <div class="text-sm text-gray-500">Full Name</div>
                    <div class="font-medium">${param.firstName} ${param.lastName}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500">Contact Email</div>
                    <div class="font-medium">${param.guestEmail}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500">Phone Number</div>
                    <div class="font-medium">${param.guestPhone}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500">Total Travelers</div>
                    <div class="font-medium">${param.guests}</div>
                </div>
            </div>
            
            <c:if test="${not empty param.specialRequests}">
            <div class="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
                <div class="text-sm text-gray-500 mb-1">Special Requests</div>
                <div class="font-medium text-sm">${param.specialRequests}</div>
            </div>
            </c:if>
        </div>

        <div class="surface-panel rounded-2xl p-6 md:p-8 shadow-xl mb-8">
            <h2 class="text-xl font-medium mb-4 pb-2 border-b border-gray-200 dark:border-gray-700">Price Breakdown</h2>
            <div class="space-y-3">
                <div class="flex justify-between">
                    <span class="text-gray-400">Base Price (per traveler)</span>
                    <span class="font-medium">₹<fmt:formatNumber value="${param.basePrice}" type="number" maxFractionDigits="0"/></span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-400">Number of Travelers</span>
                    <span class="font-medium">x ${param.guests}</span>
                </div>
                <div class="flex justify-between text-green-500">
                    <span>Taxes & Fees</span>
                    <span>Included</span>
                </div>
                <div class="flex justify-between text-xl font-bold pt-4 border-t border-gray-200 dark:border-gray-700 mt-2">
                    <span>Total Amount</span>
                    <span class="text-primary">₹<fmt:formatNumber value="${param.totalPrice}" type="number" maxFractionDigits="0"/></span>
                </div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/api/razorpay/trip-payment-init" method="POST" class="flex justify-between items-center gap-4">
            <!-- Hidden inputs to forward the data to the payment page -->
            <input type="hidden" name="tripId" value="${param.tripId}">
            <input type="hidden" name="tripTitle" value="${param.tripTitle}">
            <input type="hidden" name="tripDest" value="${param.tripDest}">
            <input type="hidden" name="departureDate" value="${param.departureDate}">
            <input type="hidden" name="firstName" value="${param.firstName}">
            <input type="hidden" name="lastName" value="${param.lastName}">
            <input type="hidden" name="guestEmail" value="${param.guestEmail}">
            <input type="hidden" name="guestPhone" value="${param.guestPhone}">
            <input type="hidden" name="guests" value="${param.guests}">
            <input type="hidden" name="totalPrice" value="${param.totalPrice}">

            <a href="javascript:history.back()" class="btn-secondary px-8 py-3 rounded-xl font-bold text-center">Back</a>
            <button type="submit" class="btn-primary px-8 py-3 rounded-xl font-bold flex-1 md:flex-none">Proceed to Payment →</button>
        </form>

    </div>
</main>

<%@ include file="/components/footer.jsp" %>
