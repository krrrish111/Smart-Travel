<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<%
    // Generate a simple Booking ID if not passed
    String bookingId = request.getParameter("paymentId");
    if (bookingId == null || bookingId.isEmpty()) {
        bookingId = "TRIP_" + System.currentTimeMillis();
    }
%>

<main style="padding-top: 120px; padding-bottom: 80px; min-height: 100vh; background: #080808;">
    <div class="container mx-auto max-w-3xl px-4 text-center">

        <div class="mb-8 flex justify-center">
            <div class="w-24 h-24 bg-green-500 rounded-full flex items-center justify-center shadow-[0_0_40px_rgba(34,197,94,0.3)]">
                <i class="fas fa-check text-4xl text-white"></i>
            </div>
        </div>

        <h1 class="text-4xl font-bold mb-2 editorial text-white">Booking Confirmed!</h1>
        <p class="text-gray-400 mb-8 text-lg">Thank you, ${param.firstName}. Your trip to ${param.tripDest} is officially booked.</p>

        <div class="surface-panel rounded-2xl p-6 md:p-8 shadow-xl text-left mb-8">
            <div class="flex justify-between items-center mb-6 pb-4 border-b border-gray-200 dark:border-gray-700">
                <div>
                    <div class="text-sm text-gray-500">Booking ID</div>
                    <div class="font-bold text-lg text-primary"><%= bookingId %></div>
                </div>
                <div class="text-right">
                    <div class="text-sm text-gray-500">Payment Status</div>
                    <div class="font-bold text-green-500 flex items-center gap-2 justify-end">
                        <i class="fas fa-check-circle"></i> Paid
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-3 gap-6 mb-2">
                <div>
                    <div class="text-sm text-gray-500 mb-1">Trip Name</div>
                    <div class="font-medium">${param.tripTitle}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500 mb-1">Destination</div>
                    <div class="font-medium">${param.tripDest}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500 mb-1">Travel Date</div>
                    <div class="font-medium">${param.departureDate}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500 mb-1">Travelers</div>
                    <div class="font-medium">${param.guests}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500 mb-1">Lead Traveler</div>
                    <div class="font-medium">${param.firstName} ${param.lastName}</div>
                </div>
                <div>
                    <div class="text-sm text-gray-500 mb-1">Amount Paid</div>
                    <div class="font-medium">₹<fmt:formatNumber value="${param.totalPrice}" type="number" maxFractionDigits="0"/></div>
                </div>
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-4 justify-center">
            <!-- Hidden form to pass data to ticket page -->
            <form action="${pageContext.request.contextPath}/pages/trip-ticket.jsp" method="POST" target="_blank">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                <input type="hidden" name="tripTitle" value="${param.tripTitle}">
                <input type="hidden" name="tripDest" value="${param.tripDest}">
                <input type="hidden" name="departureDate" value="${param.departureDate}">
                <input type="hidden" name="firstName" value="${param.firstName}">
                <input type="hidden" name="lastName" value="${param.lastName}">
                <input type="hidden" name="guestEmail" value="${param.guestEmail}">
                <input type="hidden" name="guestPhone" value="${param.guestPhone}">
                <input type="hidden" name="guests" value="${param.guests}">
                <button type="submit" class="btn-primary px-8 py-3 rounded-xl font-bold w-full md:w-auto flex justify-center items-center gap-2">
                    <i class="fas fa-ticket-alt"></i> Download Ticket
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/my-journey" class="btn-secondary px-8 py-3 rounded-xl font-bold w-full md:w-auto flex justify-center items-center gap-2">
                <i class="fas fa-map-marked-alt"></i> View My Journey
            </a>
        </div>

    </div>
</main>

<%@ include file="/components/footer.jsp" %>
