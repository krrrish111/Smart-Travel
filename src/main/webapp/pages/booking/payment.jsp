<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Secure Checkout - Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        .layout-grid { display:grid; grid-template-columns:1fr 400px; gap:30px; margin-top:24px; align-items:start; }
        .card { background:rgba(255,255,255,0.03); border:1px solid var(--color-border); border-radius:16px; padding:32px; }
        
        .method-option {
            display:flex; align-items:center; gap:16px; padding:20px; 
            border:2px solid rgba(255,255,255,0.08); border-radius:12px;
            margin-bottom:16px; cursor:pointer; transition:all 0.2s;
        }
        .method-option:hover { border-color:rgba(212,165,116,0.4); background:rgba(255,255,255,0.02); }
        .method-option.active { border-color:var(--color-primary); background:rgba(212,165,116,0.05); }
        .method-option input { display:none; }
        .method-icon { font-size:2rem; width:48px; text-align:center; }
        .method-details h4 { margin:0 0 4px 0; color:var(--text-main); font-size:1.1rem; }
        .method-details p { margin:0; color:var(--color-muted); font-size:0.85rem; }

        .summary-row { display:flex; justify-content:space-between; margin-bottom:12px; color:var(--color-muted); font-size:0.95rem; }
        .summary-row.total { border-top:1px solid rgba(255,255,255,0.12); padding-top:16px; margin-top:16px; color:var(--text-main); font-size:1.4rem; font-weight:800; }
        
        .secure-badge { display:flex; align-items:center; justify-content:center; gap:8px; margin-top:20px; color:#4CAF50; font-size:0.85rem; font-weight:600; }
        @media(max-width:900px){ .layout-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body style="padding-top:80px; padding-bottom:60px;">
<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="6"/></jsp:include>

<div class="container" style="max-width:1100px; margin:40px auto; padding:0 20px;">
    <h1 class="text-white font-bold" style="font-size:2rem;">Secure Payment</h1>
    <p style="color:var(--color-muted); margin-bottom:30px;">Choose your preferred payment method.</p>

    <div class="layout-grid">
        <!-- Left: Payment Methods -->
        <div class="card">
            <h3 style="font-size:1.2rem; font-weight:800; margin-bottom:24px;">Select Payment Method</h3>
            
            <!-- Wallet Payment -->
            <label class="method-option active" id="lblWallet" onclick="selectMethod('wallet')">
                <input type="radio" name="payMethod" value="wallet" checked>
                <div class="method-icon">💰</div>
                <div class="method-details">
                    <h4>Voyastra Wallet</h4>
                    <p>Pay instantly using your wallet balance. Faster checkout.</p>
                </div>
            </label>

            <!-- Mock Payment (Dev Mode) -->
            <label class="method-option" id="lblMock" onclick="selectMethod('mock')">
                <input type="radio" name="payMethod" value="mock">
                <div class="method-icon">🧪</div>
                <div class="method-details">
                    <h4>Mock Payment (Test)</h4>
                    <p>Instantly simulates a successful transaction. No real money used.</p>
                </div>
            </label>

            <!-- Razorpay Integration -->
            <label class="method-option" id="lblRazorpay" onclick="selectMethod('razorpay')">
                <input type="radio" name="payMethod" value="razorpay">
                <div class="method-icon">⚡</div>
                <div class="method-details">
                    <h4>Razorpay (UPI / Cards / NetBanking)</h4>
                    <p>Pay securely via Razorpay's official checkout UI.</p>
                </div>
            </label>
        </div>

        <!-- Right: Summary & Pay Button -->
        <div class="card" style="position:sticky; top:100px;">
            <h3 style="font-size:1.2rem; font-weight:800; margin-bottom:24px;">Order Summary</h3>
            <div class="summary-row"><span>Booking Ref</span><span style="color:var(--text-main); font-weight:600;">Pending</span></div>
            <div class="summary-row"><span>Email</span><span style="color:var(--text-main); font-weight:600;">${sessionScope.email}</span></div>
            
            <div style="margin-top:20px; padding:15px; border-radius:8px; background:rgba(255,255,255,0.05); border:1px dashed var(--color-border);">
                <div style="font-size:0.9rem; margin-bottom:10px; font-weight:600;">Apply Promo Code</div>
                <div style="display:flex; gap:10px;">
                    <input type="text" id="couponCode" placeholder="Enter Code" style="flex:1; padding:10px; border-radius:6px; border:1px solid var(--color-border); background:rgba(0,0,0,0.2); color:white; text-transform:uppercase;">
                    <button type="button" class="btn btn-outline" onclick="applyCoupon()" style="padding:10px 15px; font-size:0.9rem;" id="btnApplyCoupon">Apply</button>
                </div>
                <div id="couponMessage" style="font-size:0.8rem; margin-top:8px;"></div>
            </div>

            <div class="summary-row total" style="margin-top:20px;">
                <span>Amount to Pay</span>
                <span style="color:var(--color-primary);" id="displayTotal">₹${sessionScope.grandTotal}</span>
            </div>

            <button id="btnPay" class="btn-select" style="margin-top:20px; width:100%; padding:16px; font-weight:800; font-size:1.15rem; border-radius:8px; background:var(--color-primary); color:#000; border:none; cursor:pointer; transition:transform 0.2s, box-shadow 0.2s;"
                    onclick="handlePayment()">
                Pay ₹${sessionScope.grandTotal}
            </button>
            
            <div class="secure-badge">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                100% Secure &amp; Encrypted Payment
            </div>
        </div>
    </div>
</div>

<!-- Hidden Form for submission to our backend -->
<form id="paymentForm" action="${pageContext.request.contextPath}/api/process-payment" method="POST" style="display:none;">
    <input type="hidden" name="method" id="formMethod" value="wallet">
    <input type="hidden" name="payment_id" id="formPaymentId" value="">
    <input type="hidden" name="transaction_id" id="formTransactionId" value="">
    <input type="hidden" name="status" id="formStatus" value="">
</form>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    let currentMethod = 'wallet';

    function selectMethod(method) {
        currentMethod = method;
        document.getElementById('lblWallet').classList.remove('active');
        document.getElementById('lblMock').classList.remove('active');
        document.getElementById('lblRazorpay').classList.remove('active');
        
        if (method === 'wallet') document.getElementById('lblWallet').classList.add('active');
        if (method === 'mock') document.getElementById('lblMock').classList.add('active');
        if (method === 'razorpay') document.getElementById('lblRazorpay').classList.add('active');
    }

    async function applyCoupon() {
        const code = document.getElementById('couponCode').value;
        const msg = document.getElementById('couponMessage');
        if (!code) return;
        
        msg.style.color = '#fff';
        msg.innerHTML = 'Applying...';
        
        try {
            const formData = new URLSearchParams();
            formData.append("code", code);
            
            const response = await fetch('${pageContext.request.contextPath}/api/apply-coupon', {
                method: 'POST',
                body: formData
            });
            const data = await response.json();
            
            if (data.success) {
                msg.style.color = '#4CAF50';
                msg.innerHTML = `Success! Savings: ₹${data.discount}`;
                document.getElementById('displayTotal').innerHTML = `₹${data.newTotal}`;
                document.getElementById('btnPay').innerHTML = `Pay ₹${data.newTotal}`;
            } else {
                msg.style.color = '#ff3b30';
                msg.innerHTML = data.message;
            }
        } catch(e) {
            msg.style.color = '#ff3b30';
            msg.innerHTML = 'Error applying coupon.';
        }
    }

    function handlePayment() {
        const btn = document.getElementById('btnPay');
        btn.disabled = true;
        btn.innerHTML = 'Processing... <span style="font-size:0.8em">⏳</span>';
        
        if (currentMethod === 'wallet') {
            setTimeout(() => {
                submitToBackend('wallet', 'wallet_txn_' + Date.now(), 'txn_' + Math.floor(Math.random()*1000000), 'SUCCESS');
            }, 1000);
        } else if (currentMethod === 'mock') {
            // Simulate brief delay
            setTimeout(() => {
                submitToBackend('mock', 'mock_pay_' + Date.now(), 'txn_' + Math.floor(Math.random()*1000000), 'SUCCESS');
            }, 1000);
        } else if (currentMethod === 'razorpay') {
            openRazorpay();
        }
    }

    function openRazorpay() {
        // Amount is in paise
        const amountPaise = parseInt('${sessionScope.grandTotal}') * 100; 

        var options = {
            "key": "rzp_test_SxfOmTuJ3rh43O", // Test Key (dummy)
            "amount": amountPaise,
            "currency": "INR",
            "name": "Voyastra Airlines",
            "description": "Flight Booking Transaction",
            "image": "https://cdn-icons-png.flaticon.com/512/3143/3143212.png",
            "handler": function (response) {
                // Success Callback
                submitToBackend('razorpay', response.razorpay_payment_id, 'txn_rzp_' + Date.now(), 'SUCCESS');
            },
            "prefill": {
                "name": "${sessionScope.name}",
                "email": "${sessionScope.email}"
            },
            "theme": {
                "color": "#d4a574"
            },
            "modal": {
                "ondismiss": function() {
                    const btn = document.getElementById('btnPay');
                    btn.disabled = false;
                    btn.innerHTML = 'Pay ₹${sessionScope.grandTotal}';
                }
            }
        };
        var rzp1 = new Razorpay(options);
        rzp1.on('payment.failed', function (response){
            alert("Payment Failed: " + response.error.description);
            submitToBackend('razorpay', response.error.metadata.payment_id, 'txn_failed_' + Date.now(), 'FAILED');
        });
        rzp1.open();
    }

    function submitToBackend(method, paymentId, txnId, status) {
        document.getElementById('formMethod').value = method;
        document.getElementById('formPaymentId').value = paymentId;
        document.getElementById('formTransactionId').value = txnId;
        document.getElementById('formStatus').value = status;
        document.getElementById('paymentForm').submit();
    }
</script>

<jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
