<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-md">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 40px 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center; border: 1px solid rgba(239, 68, 68, 0.2);">
            <div style="font-size: 80px; margin-bottom: 20px;">❌</div>
            <h1 class="text-3xl font-bold text-red-500 mb-4">Payment Failed</h1>
            <p class="text-gray-300 mb-8">We could not process your transaction. No charges were made, and your booking has not been confirmed.</p>
            
            <div style="display: flex; flex-direction: column; gap: 15px;">
                <a href="${pageContext.request.contextPath}/pages/transport/${param.type}-payment.jsp" class="btn-primary w-full py-3 rounded-lg font-bold text-center block uppercase tracking-wider" style="text-decoration: none;">
                    🔄 Retry Payment
                </a>
                <a href="${pageContext.request.contextPath}/pages/transport/${param.type}-review.jsp" class="w-full py-3 rounded-lg font-bold text-center block bg-gray-800 text-white border border-gray-600 hover:bg-gray-700 transition" style="text-decoration: none; background: #1e293b; color: white; border: 1px solid #475569; border-radius: 8px;">
                    📋 Return to Review Booking
                </a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
