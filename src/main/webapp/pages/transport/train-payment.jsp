<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Secure Payment</h1>
            <p class="text-gray-400 mb-8">Please complete your payment to confirm the booking.</p>
            
            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-green-400">₹${(booking.fare * booking.passengers.size()) + 150}</p>
            </div>

            <button id="rzp-button1" 
                    data-amount="${(booking.fare * booking.passengers.size()) + 150}"
                    data-receipt="${booking.id}"
                    data-passenger-name="${booking.passengers[0].name}"
                    class="btn-primary w-full py-4 rounded-lg font-bold text-xl uppercase tracking-wider">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/train/payment-callback" method="POST" style="display: none;">
                <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
                <input type="hidden" name="razorpay_order_id" id="razorpay_order_id">
                <input type="hidden" name="razorpay_signature" id="razorpay_signature">
            </form>
        </div>
    </div>
</main>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    document.getElementById('rzp-button1').onclick = function(e) {
        e.preventDefault();
        
        const btn = document.getElementById('rzp-button1');
        const bookingAmount = btn.getAttribute('data-amount');
        const bookingReceipt = btn.getAttribute('data-receipt');
        const passengerName = btn.getAttribute('data-passenger-name');

        btn.disabled = true;
        btn.innerText = 'Initializing Payment...';

        // Fetch order ID from our backend
        fetch('${pageContext.request.contextPath}/api/razorpay/create-order', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'amount=' + bookingAmount + '&receipt=' + bookingReceipt
        })
        .then(response => {
            if (!response.ok) {
                return response.json().then(err => {
                    throw new Error(err.error || 'Server returned error ' + response.status);
                });
            }
            return response.json();
        })
        .then(orderData => {
            const key = "<%= com.voyastra.util.RazorpayConfig.getKeyId() %>";
            const orderId = orderData.id;
            const amount = orderData.amount;

            console.log("Razorpay Key:", key);
            console.log("Order ID:", orderId);
            console.log("Amount:", amount);

            if (!orderId) {
                throw new Error("Order ID is missing from server response.");
            }

            var options = {
                "key": key,
                "amount": amount,
                "currency": "INR",
                "name": "Voyastra",
                "description": "Train Booking Payment",
                "image": "https://example.com/your_logo",
                "order_id": orderId,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": passengerName,
                    "email": "user@example.com",
                    "contact": "9999999999"
                },
                "theme": { "color": "#00d2ff" },
                "modal": {
                    "ondismiss": function() {
                        btn.disabled = false;
                        btn.innerText = 'Pay Now';
                    }
                }
            };
            var rzp1 = new Razorpay(options);
            rzp1.open();
        })
        .catch(err => {
            console.error('Razorpay Init Error:', err);
            alert('Error initializing payment. ' + err.message);
            btn.disabled = false;
            btn.innerText = 'Pay Now';
        });
    }
</script>
<%@ include file="/components/footer.jsp" %>
