<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 140px; padding-bottom: 80px;">
    <div class="container text-center">
        <div class="glass-panel p-12 max-w-xl mx-auto slide-up">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-6 text-3xl shadow-lg">
                ✅
            </div>
            <h1 class="text-white editorial text-4xl mb-4">Booking Confirmed!</h1>
            <p class="text-white opacity-70 mb-8 leading-relaxed">
                Thank you for choosing Voyastra. Your adventure has been successfully scheduled. 
                A confirmation email has been sent to <strong>${sessionScope.currentBooking.customerEmail}</strong>.
            </p>

            <div class="bg-white bg-opacity-5 rounded-2xl p-6 mb-8 border border-white border-opacity-10 text-left space-y-4">
                <div class="flex justify-between items-start pb-3 border-b border-white border-opacity-10">
                    <span class="text-white opacity-50 text-sm">Selection Details</span>
                    <span class="text-white font-bold text-right ml-4">${not empty sessionScope.currentBooking.details ? sessionScope.currentBooking.details : 'Custom Selection'}</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-white opacity-50 text-sm">Booking ID</span>
                    <span class="text-white font-mono font-bold">#${param.id}</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-white opacity-50 text-sm">Traveler</span>
                    <span class="text-white font-bold">${sessionScope.currentBooking.customerName}</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-white opacity-50 text-sm">Payment Status</span>
                    <div class="flex items-center gap-2">
                        <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                        <span class="text-green-400 text-xs font-bold uppercase tracking-wider">Success</span>
                    </div>
                </div>
                <div class="flex justify-between items-center pt-2">
                    <span class="text-white opacity-50 text-sm">Amount Paid</span>
                    <span class="text-primary font-bold text-2xl">₹${sessionScope.currentBooking.totalPrice}</span>
                </div>
            </div>

            <div class="flex flex-col gap-3">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary w-full py-4 font-bold rounded-xl">
                    Back to Dashboard
                </a>
                <a href="#" onclick="window.print()" class="text-white opacity-50 hover:opacity-100 transition-all text-sm font-bold">
                    🖨️ Print Receipt
                </a>
            </div>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
