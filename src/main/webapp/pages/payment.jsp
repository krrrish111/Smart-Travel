<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<%
    // Guard: must be logged in and have a currentBooking in session
    com.voyastra.model.Booking cb = (com.voyastra.model.Booking) session.getAttribute("currentBooking");
    if (session.getAttribute("userId") == null || cb == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    double baseFare = cb.getTotalPrice() - 250;
    String typeLabel = "Service";
    String typeIcon  = "🎫";
    if ("flight".equalsIgnoreCase(cb.getType())) { typeLabel = "Flight";    typeIcon = "✈️"; }
    else if ("hotel".equalsIgnoreCase(cb.getType()))  { typeLabel = "Hotel";     typeIcon = "🏨"; }
    else if ("tour".equalsIgnoreCase(cb.getType()))   { typeLabel = "Tour";      typeIcon = "🎟️"; }
    else if ("taxi".equalsIgnoreCase(cb.getType())
          || "car".equalsIgnoreCase(cb.getType()))    { typeLabel = "Transport";  typeIcon = "🚖"; }
    else if ("bus".equalsIgnoreCase(cb.getType()))    { typeLabel = "Bus";        typeIcon = "🚌"; }
    else if ("train".equalsIgnoreCase(cb.getType()))  { typeLabel = "Train";      typeIcon = "🚆"; }
%>

<main style="padding-top: 120px; padding-bottom: 80px;">
    <div class="container">

        <!-- Page header -->
        <div style="text-align: center; margin-bottom: 40px;">
            <p style="color: var(--color-primary); font-size: 0.85rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; margin-bottom: 8px;">Almost There</p>
            <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--color-main); margin: 0;">Complete Your Booking</h1>
            <p style="color: var(--color-muted); margin-top: 8px; font-size: 0.95rem;">Review your order and choose a payment method</p>
        </div>

        <div style="max-width: 960px; margin: 0 auto; display: grid; grid-template-columns: 1fr 380px; gap: 32px; align-items: start;">

            <!-- ===== LEFT: PAYMENT METHODS ===== -->
            <div>

                <!-- Booking Summary Card (at top of left col) -->
                <div class="glass-panel" style="padding: 24px; margin-bottom: 24px; border-left: 3px solid var(--color-primary);">
                    <div style="display: flex; align-items: center; gap: 16px; flex-wrap: wrap;">
                        <div style="font-size: 2.5rem;"><%= typeIcon %></div>
                        <div style="flex: 1;">
                            <div style="font-size: 0.72rem; color: var(--color-primary); font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 2px;"><%= typeLabel %> Booking</div>
                            <div style="font-size: 1rem; font-weight: 700; color: var(--color-main); line-height: 1.4;"><%= cb.getDetails() != null ? cb.getDetails() : "Voyastra " + typeLabel %></div>
                        </div>
                        <div style="text-align: right; flex-shrink: 0;">
                            <div style="font-size: 1.6rem; font-weight: 800; color: var(--color-primary);">₹<fmt:formatNumber value="<%= cb.getTotalPrice() %>" groupingUsed="true"/></div>
                            <div style="font-size: 0.7rem; color: var(--color-muted);">incl. taxes</div>
                        </div>
                    </div>
                    <div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--color-border); display: flex; flex-wrap: wrap; gap: 12px;">
                        <span style="font-size: 0.78rem; color: var(--color-muted);">📋 <strong style="color: var(--color-main);">Booking Code:</strong> <%= cb.getBookingCode() %></span>
                        <span style="font-size: 0.78rem; color: var(--color-muted);">👤 <strong style="color: var(--color-main);">Traveler:</strong> <%= cb.getCustomerName() %></span>
                        <% if (cb.getTravelDate() != null && !cb.getTravelDate().isEmpty()) { %>
                        <span style="font-size: 0.78rem; color: var(--color-muted);">📅 <strong style="color: var(--color-main);">Date:</strong> <%= cb.getTravelDate() %></span>
                        <% } %>
                    </div>
                </div>

                <!-- Payment Methods -->
                <div class="glass-panel" style="padding: 28px;">
                    <h2 style="font-size: 1.2rem; font-weight: 700; color: var(--color-main); margin-bottom: 20px;">Select Payment Method</h2>

                    <div style="display: flex; flex-direction: column; gap: 12px;" id="paymentMethods">

                        <!-- UPI -->
                        <div class="vx-pay-card active" id="card-UPI" onclick="selectMethod(this,'UPI')"
                             style="padding: 18px 20px; border-radius: 14px; border: 2px solid var(--color-primary); background: rgba(212,165,116,0.08); display: flex; align-items: center; gap: 16px; cursor: pointer; transition: all 0.25s;">
                            <div style="font-size: 2rem;">📱</div>
                            <div style="flex: 1;">
                                <div style="font-weight: 700; color: var(--color-main);">UPI / QR Code</div>
                                <div style="font-size: 0.75rem; color: var(--color-muted); margin-top: 2px;">Google Pay, PhonePe, Paytm, or any UPI app</div>
                            </div>
                            <div class="vx-radio active" id="radio-UPI" style="width: 22px; height: 22px; border-radius: 50%; border: 2px solid var(--color-primary); display: flex; align-items: center; justify-content: center;">
                                <div style="width: 10px; height: 10px; background: var(--color-primary); border-radius: 50%;"></div>
                            </div>
                        </div>

                        <!-- Credit/Debit Card -->
                        <div class="vx-pay-card" id="card-CARD" onclick="selectMethod(this,'CARD')"
                             style="padding: 18px 20px; border-radius: 14px; border: 1px solid var(--color-border); background: rgba(255,255,255,0.03); display: flex; align-items: center; gap: 16px; cursor: pointer; transition: all 0.25s;">
                            <div style="font-size: 2rem;">💳</div>
                            <div style="flex: 1;">
                                <div style="font-weight: 700; color: var(--color-main);">Credit / Debit Card</div>
                                <div style="font-size: 0.75rem; color: var(--color-muted); margin-top: 2px;">Visa, Mastercard, Amex, RuPay</div>
                            </div>
                            <div class="vx-radio" id="radio-CARD" style="width: 22px; height: 22px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;">
                                <div style="width: 10px; height: 10px; background: var(--color-primary); border-radius: 50%; display: none;"></div>
                            </div>
                        </div>

                        <!-- Net Banking -->
                        <div class="vx-pay-card" id="card-NET_BANKING" onclick="selectMethod(this,'NET_BANKING')"
                             style="padding: 18px 20px; border-radius: 14px; border: 1px solid var(--color-border); background: rgba(255,255,255,0.03); display: flex; align-items: center; gap: 16px; cursor: pointer; transition: all 0.25s;">
                            <div style="font-size: 2rem;">🏦</div>
                            <div style="flex: 1;">
                                <div style="font-weight: 700; color: var(--color-main);">Net Banking</div>
                                <div style="font-size: 0.75rem; color: var(--color-muted); margin-top: 2px;">HDFC, ICICI, SBI, Axis, Kotak &amp; more</div>
                            </div>
                            <div class="vx-radio" id="radio-NET_BANKING" style="width: 22px; height: 22px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;">
                                <div style="width: 10px; height: 10px; background: var(--color-primary); border-radius: 50%; display: none;"></div>
                            </div>
                        </div>

                        <!-- EMI -->
                        <div class="vx-pay-card" id="card-EMI" onclick="selectMethod(this,'EMI')"
                             style="padding: 18px 20px; border-radius: 14px; border: 1px solid var(--color-border); background: rgba(255,255,255,0.03); display: flex; align-items: center; gap: 16px; cursor: pointer; transition: all 0.25s;">
                            <div style="font-size: 2rem;">📆</div>
                            <div style="flex: 1;">
                                <div style="font-weight: 700; color: var(--color-main);">EMI — No Cost</div>
                                <div style="font-size: 0.75rem; color: var(--color-muted); margin-top: 2px;">0% interest on 3, 6, 12 month plans</div>
                            </div>
                            <div class="vx-radio" id="radio-EMI" style="width: 22px; height: 22px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;">
                                <div style="width: 10px; height: 10px; background: var(--color-primary); border-radius: 50%; display: none;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Pay Button -->
                    <form action="${pageContext.request.contextPath}/process-payment" method="post" id="paymentForm" style="margin-top: 28px;">
                        <input type="hidden" name="bookingId" value="<%= cb.getId() %>">
                        <input type="hidden" name="method"    id="selectedMethodInput" value="UPI">

                        <button type="button" onclick="simulatePayment()" id="payBtn"
                                style="width: 100%; padding: 18px 32px; background: linear-gradient(135deg, var(--color-primary), #c49050); color: #000; font-size: 1.1rem; font-weight: 800; border: none; border-radius: 14px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 12px; transition: all 0.3s; box-shadow: 0 8px 32px rgba(212,165,116,0.3);">
                            <span id="btnText">🔐 Pay ₹<fmt:formatNumber value="<%= cb.getTotalPrice() %>" groupingUsed="true"/></span>
                            <div id="payLoader" style="display:none; width: 20px; height: 20px; border: 3px solid rgba(0,0,0,0.2); border-top-color: #000; border-radius: 50; animation: spin 0.8s linear infinite;"></div>
                        </button>
                    </form>

                    <!-- Trust badges -->
                    <div style="margin-top: 16px; display: flex; align-items: center; justify-content: center; gap: 16px; flex-wrap: wrap;">
                        <span style="font-size: 0.72rem; color: var(--color-muted);">🔒 256-bit SSL</span>
                        <span style="font-size: 0.72rem; color: var(--color-muted);">✅ PCI DSS Compliant</span>
                        <span style="font-size: 0.72rem; color: var(--color-muted);">↩️ Free Cancellation*</span>
                    </div>
                </div>
            </div>

            <!-- ===== RIGHT: ORDER SUMMARY ===== -->
            <div>
                <div class="glass-panel" style="padding: 24px; position: sticky; top: 100px;">
                    <h3 style="font-size: 0.75rem; color: var(--color-muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.15em; margin-bottom: 20px;">Order Summary</h3>

                    <!-- Service image -->
                    <div style="width: 100%; height: 120px; border-radius: 12px; overflow: hidden; margin-bottom: 16px;">
                        <img src="<%= cb.getPlanImage() != null ? cb.getPlanImage() : "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=600&q=80" %>"
                             alt="booking" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>

                    <!-- Service name -->
                    <div style="font-size: 0.9rem; font-weight: 700; color: var(--color-main); margin-bottom: 6px;">
                        <%= typeIcon %> <%= cb.getPlanTitle() != null ? cb.getPlanTitle() : typeLabel + " Booking" %>
                    </div>
                    <div style="font-size: 0.72rem; color: var(--color-muted); margin-bottom: 16px;">
                        Booking Code: <strong style="color: var(--color-main); font-family: monospace;"><%= cb.getBookingCode() %></strong>
                    </div>

                    <!-- Price breakdown -->
                    <div style="border-top: 1px solid var(--color-border); padding-top: 16px; display: flex; flex-direction: column; gap: 10px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--color-muted);">
                            <span>Base Fare</span>
                            <span>₹<fmt:formatNumber value="<%= baseFare %>" groupingUsed="true"/></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--color-muted);">
                            <span>Taxes &amp; Fees</span>
                            <span>₹250</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--color-muted);">
                            <span>Convenience Fee</span>
                            <span style="color: #4ade80;">FREE</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 800; color: var(--color-primary); border-top: 1px solid var(--color-border); padding-top: 12px; margin-top: 4px;">
                            <span>Total</span>
                            <span>₹<fmt:formatNumber value="<%= cb.getTotalPrice() %>" groupingUsed="true"/></span>
                        </div>
                    </div>

                    <!-- Cancellation note -->
                    <div style="margin-top: 16px; padding: 12px; background: rgba(212,165,116,0.08); border: 1px solid rgba(212,165,116,0.2); border-radius: 10px;">
                        <p style="font-size: 0.72rem; color: var(--color-muted); line-height: 1.5; margin: 0;">
                            ✅ Free cancellation up to 24hrs before travel.<br>
                            🔒 Your payment is fully secured and encrypted.
                        </p>
                    </div>
                </div>
            </div>

        </div><!-- /grid -->
    </div><!-- /container -->
</main>

<style>
@keyframes spin { to { transform: rotate(360deg); } }
</style>

<script>
let currentMethod = 'UPI';

function selectMethod(el, method) {
    currentMethod = method;
    // Reset all cards
    document.querySelectorAll('.vx-pay-card').forEach(c => {
        c.style.border = '1px solid var(--color-border)';
        c.style.background = 'rgba(255,255,255,0.03)';
        const dot = c.querySelector('.vx-radio div');
        if (dot) dot.style.display = 'none';
        const radio = c.querySelector('.vx-radio');
        if (radio) radio.style.borderColor = 'rgba(255,255,255,0.2)';
    });
    // Activate selected
    el.style.border = '2px solid var(--color-primary)';
    el.style.background = 'rgba(212,165,116,0.08)';
    const dot = el.querySelector('.vx-radio div');
    if (dot) dot.style.display = 'block';
    const radio = el.querySelector('.vx-radio');
    if (radio) radio.style.borderColor = 'var(--color-primary)';
    document.getElementById('selectedMethodInput').value = method;
}

function simulatePayment() {
    const btn    = document.getElementById('payBtn');
    const loader = document.getElementById('payLoader');
    const form   = document.getElementById('paymentForm');

    btn.disabled = true;
    btn.style.opacity = '0.8';
    loader.style.display = 'block';
    document.getElementById('btnText').innerText = 'Securing Transaction...';

    // Simulate gateway delay then submit
    setTimeout(() => { form.submit(); }, 2400);
}
</script>

<%@ include file="/components/footer.jsp" %>
