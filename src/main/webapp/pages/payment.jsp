<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<c:set var="booking" value="${sessionScope.pendingBooking}" />
<c:set var="trip" value="${sessionScope.pendingTrip}" />

<main style="padding-top: 100px; padding-bottom: 80px;">
    <div class="container" style="max-width: 600px;">
        <div class="text-center mb-5 slide-up">
            <p class="text-primary fw-bold text-sm uppercase tracking-widest mb-2">Secure Checkout</p>
            <h1 class="section-title" style="font-size:2.2rem;">Complete Payment</h1>
            <p class="text-muted">You are one step away from your dream trip.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="glass-panel p-4 mb-4 text-center" style="border:1px solid #e74c3c;">
                <p class="text-main fw-bold">${error}</p>
            </div>
        </c:if>

        <div class="glass-panel p-5 mb-5 slide-up" style="animation-delay:0.1s;">
            <div class="flex justify-between items-center mb-4">
                <span class="text-muted text-sm uppercase tracking-wider">Amount to Pay</span>
                <span class="text-primary fw-bold" style="font-size:1.8rem;">₹<fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/></span>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/payment" id="paymentForm">
                <input type="hidden" name="action" value="process">
                
                <!-- Payment Method Selection -->
                <div class="mb-4">
                    <label class="form-label text-muted uppercase text-xs tracking-wider">Payment Method</label>
                    <div class="grid grid-cols-2 gap-3 mt-2">
                        <label class="glass-panel p-3 text-center cursor-pointer border-primary" style="border: 2px solid var(--color-primary);">
                            <input type="radio" name="paymentMethod" value="Credit Card" checked style="display:none;">
                            <span class="text-main fw-bold">Credit Card</span>
                        </label>
                        <label class="glass-panel p-3 text-center cursor-pointer" style="border: 2px solid transparent;">
                            <input type="radio" name="paymentMethod" value="UPI" style="display:none;">
                            <span class="text-main fw-bold">UPI / Wallet</span>
                        </label>
                    </div>
                </div>

                <!-- Mock Credit Card Form -->
                <div id="creditCardForm" class="mt-4 slide-up">
                    <div class="form-group mb-4">
                        <label class="form-label text-muted uppercase text-xs tracking-wider">Cardholder Name</label>
                        <input type="text" class="form-control" placeholder="Name on card" required value="${booking.customerName}">
                    </div>
                    <div class="form-group mb-4">
                        <label class="form-label text-muted uppercase text-xs tracking-wider">Card Number</label>
                        <input type="text" class="form-control" placeholder="0000 0000 0000 0000" maxlength="19" required>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="form-group mb-4">
                            <label class="form-label text-muted uppercase text-xs tracking-wider">Expiry (MM/YY)</label>
                            <input type="text" class="form-control" placeholder="MM/YY" maxlength="5" required>
                        </div>
                        <div class="form-group mb-4">
                            <label class="form-label text-muted uppercase text-xs tracking-wider">CVV</label>
                            <input type="password" class="form-control" placeholder="123" maxlength="4" required>
                        </div>
                    </div>
                </div>

                <div class="mt-5">
                    <button type="submit" class="btn-primary w-full" style="padding:16px; border-radius:12px; font-size:1.1rem; font-weight:700;">
                        Pay ₹<fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> Securely
                    </button>
                </div>
                
                <div class="text-center mt-4">
                    <span class="text-muted text-xs">🔒 256-bit SSL encrypted. Payment gateway is securely processed.</span>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
    // Simple toggle between mock payment methods visually
    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
        radio.addEventListener('change', function() {
            document.querySelectorAll('input[name="paymentMethod"]').forEach(r => {
                r.parentElement.style.borderColor = r.checked ? 'var(--color-primary)' : 'transparent';
            });
            const ccForm = document.getElementById('creditCardForm');
            if (this.value === 'Credit Card') {
                ccForm.style.display = 'block';
                ccForm.querySelectorAll('input').forEach(inp => inp.setAttribute('required', 'true'));
            } else {
                ccForm.style.display = 'none';
                ccForm.querySelectorAll('input').forEach(inp => inp.removeAttribute('required'));
            }
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>
