<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container my-12 max-w-4xl">
    <div class="glass-panel p-8 rounded-2xl border border-gray-100 dark:border-gray-800">
        <h2 class="text-3xl font-bold text-main editorial mb-6">Review Your Booking</h2>
        <p class="text-muted mb-8">Please review all details before proceeding to payment.</p>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
                <h3 class="text-xl font-bold text-main mb-4 border-b border-border pb-2">Trip Summary</h3>
                <div class="flex flex-col gap-3 text-sm">
                    <p><span class="text-muted">Destination:</span> <strong class="text-main">${destination.title}</strong></p>
                    <p><span class="text-muted">Travel Date:</span> <strong class="text-main">${travel_date}</strong></p>
                    <p><span class="text-muted">Travellers:</span> <strong class="text-main">${travellers} Person(s)</strong></p>
                    <p><span class="text-muted">Hotel Category:</span> <strong class="text-main" style="text-transform:capitalize;">${hotel_category}</strong></p>
                    <p><span class="text-muted">Activities:</span> <strong class="text-main">${not empty activities ? activities : 'None'}</strong></p>
                </div>

                <h3 class="text-xl font-bold text-main mb-4 border-b border-border pb-2 mt-8">Primary Contact</h3>
                <div class="flex flex-col gap-3 text-sm">
                    <p><span class="text-muted">Name:</span> <strong class="text-main">${primary_name}</strong></p>
                    <p><span class="text-muted">Email:</span> <strong class="text-main">${primary_email}</strong></p>
                    <p><span class="text-muted">Phone:</span> <strong class="text-main">${primary_phone}</strong></p>
                </div>
            </div>

            <div>
                <div class="p-6 rounded-xl bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700">
                    <h3 class="text-xl font-bold text-main mb-4">Payment Summary</h3>
                    <div class="flex flex-col gap-4 text-sm">
                        <div class="flex justify-between items-center">
                            <span class="text-lg font-bold text-main">Total Amount to Pay</span>
                            <span class="text-2xl font-bold text-primary">₹${final_price}</span>
                        </div>
                    </div>
                    
                    <button id="rzp-button" class="btn btn-primary w-full text-lg py-4 mt-6">
                        Proceed to Secure Payment
                    </button>
                    <p class="text-xs text-center text-muted mt-3">By proceeding, you agree to Voyastra's Terms & Conditions.</p>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
document.getElementById('rzp-button').onclick = async function(e) {
    e.preventDefault();
    const btn = this;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Initializing...';
    btn.disabled = true;

    try {
        // 1. Call Create Order API
        const createRes = await fetch('${pageContext.request.contextPath}/api/destination/payment/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                'destination_id': '${destination.id}',
                'check_in': '${travel_date}',
                'guests': '${travellers}',
                'final_amount': '${final_price}'
            })
        });

        const orderData = await createRes.json();
        
        if(createRes.ok && orderData.id) {
            // 2. Initialize Razorpay
            var options = {
                "key": "<%= com.voyastra.util.RazorpayConfig.getKeyId() %>", // Dynamic Key
                "amount": orderData.amount, // Amount in paise
                "currency": "INR",
                "name": "Voyastra Destinations",
                "description": "Booking for ${destination.title}",
                "image": "${pageContext.request.contextPath}/assets/img/logo.png",
                "order_id": orderData.id,
                "handler": async function (response){
                    // 3. Verify Payment
                    Voyastra.ui.showLoadingOverlay("Verifying payment...");
                    const verifyRes = await fetch('${pageContext.request.contextPath}/api/destination/payment/validate', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: new URLSearchParams({
                            'razorpay_payment_id': response.razorpay_payment_id,
                            'razorpay_order_id': response.razorpay_order_id,
                            'razorpay_signature': response.razorpay_signature
                        })
                    });

                    if(verifyRes.ok) {
                        window.location.href = '${pageContext.request.contextPath}/destination/confirmation?order_id=' + response.razorpay_order_id;
                    } else {
                        Voyastra.ui.hideLoadingOverlay();
                        toast.error("Payment verification failed. Please contact support.");
                        btn.innerHTML = 'Proceed to Secure Payment';
                        btn.disabled = false;
                    }
                },
                "prefill": {
                    "name": "${primary_name}",
                    "email": "${primary_email}",
                    "contact": "${primary_phone}"
                },
                "theme": {
                    "color": "#d4af37"
                }
            };
            var rzp = new Razorpay(options);
            rzp.on('payment.failed', function (response){
                toast.error("Payment Failed: " + response.error.description);
                btn.innerHTML = 'Proceed to Secure Payment';
                btn.disabled = false;
            });
            rzp.open();
        } else {
            toast.error("Could not initialize payment. Please try again.");
            btn.innerHTML = 'Proceed to Secure Payment';
            btn.disabled = false;
        }
    } catch (err) {
        toast.error("Network error while communicating with payment server.");
        btn.innerHTML = 'Proceed to Secure Payment';
        btn.disabled = false;
    }
};
</script>

<%@ include file="/components/footer.jsp" %>
