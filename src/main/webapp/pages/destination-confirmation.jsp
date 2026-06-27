<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container my-16 max-w-3xl text-center">
    <div class="glass-panel p-12 rounded-3xl border border-green-500/30">
        <div class="w-20 h-20 bg-green-500/20 text-green-500 rounded-full flex items-center justify-center mx-auto mb-6">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
        </div>
        
        <h1 class="text-4xl font-bold text-main editorial mb-4">Booking Confirmed!</h1>
        <p class="text-lg text-muted mb-8">Your trip has been successfully booked. An email confirmation has been sent to your registered email address.</p>
        
        <div class="bg-surface rounded-xl p-6 mb-8 inline-block text-left border border-border min-w-[300px]">
            <p class="text-muted text-sm uppercase tracking-wider mb-2">Booking Reference</p>
            <p class="text-2xl font-mono text-primary font-bold">${not empty orderId ? orderId : 'REF-12345678'}</p>
        </div>
        
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a href="${pageContext.request.contextPath}/my-journey" class="btn btn-primary px-8 py-3">View in My Journey</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-glass-secondary px-8 py-3">Return to Home</a>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
