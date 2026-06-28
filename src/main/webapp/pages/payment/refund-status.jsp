<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    body {
        background: radial-gradient(circle at top right, rgba(255, 59, 48, 0.06), transparent 40%),
                    radial-gradient(circle at bottom left, rgba(255, 107, 0, 0.04), transparent 40%),
                    #0a0a0a;
        min-height: 100vh;
    }

    .refund-page {
        max-width: 860px;
        margin: 50px auto;
        padding: 0 20px 60px;
    }

    /* ── Breadcrumb-style back link ── */
    .back-link {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        color: var(--text-secondary);
        text-decoration: none;
        font-size: 0.9rem;
        margin-bottom: 30px;
        transition: color 0.2s;
    }
    .back-link:hover { color: white; }

    /* ── Top hero card ── */
    .refund-hero {
        background: linear-gradient(135deg, rgba(255,59,48,0.12) 0%, rgba(255,107,0,0.07) 100%);
        border: 1px solid rgba(255, 59, 48, 0.25);
        border-radius: 28px;
        padding: 40px;
        display: flex;
        align-items: center;
        gap: 28px;
        margin-bottom: 30px;
        position: relative;
        overflow: hidden;
    }

    .refund-hero::before {
        content: '';
        position: absolute;
        top: -60px; right: -60px;
        width: 200px; height: 200px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255,59,48,0.15), transparent 70%);
    }

    .refund-hero-icon {
        width: 80px; height: 80px;
        border-radius: 20px;
        background: rgba(255, 59, 48, 0.12);
        border: 1px solid rgba(255, 59, 48, 0.3);
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0;
        z-index: 1;
    }

    .refund-hero-info { z-index: 1; }

    .refund-hero-info h1 {
        font-size: 1.8rem;
        font-weight: 700;
        margin: 0 0 6px;
        color: white;
    }

    .refund-hero-info p {
        color: var(--text-secondary);
        margin: 0 0 14px;
        font-size: 0.95rem;
    }

    .amount-badge {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: rgba(255, 107, 0, 0.12);
        border: 1px solid rgba(255,107,0,0.3);
        border-radius: 50px;
        padding: 8px 20px;
        font-size: 1.3rem;
        font-weight: 800;
        color: var(--color-primary);
    }

    /* ── Booking summary card ── */
    .info-card {
        background: rgba(255,255,255,0.03);
        border: 1px solid var(--color-border);
        border-radius: 20px;
        padding: 28px 32px;
        margin-bottom: 24px;
    }

    .info-card-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 1.2px;
        margin: 0 0 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .info-card-title svg { color: var(--color-primary); }

    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 20px;
    }

    .info-item { }

    .info-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 4px;
    }

    .info-value {
        font-size: 1rem;
        font-weight: 600;
        color: white;
    }

    /* ── Timeline Tracker ── */
    .tracker-card {
        background: rgba(255,255,255,0.02);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 36px 40px;
        margin-bottom: 24px;
    }

    .tracker-title {
        font-size: 1.2rem;
        font-weight: 700;
        color: white;
        margin: 0 0 36px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .tracker-timeline {
        position: relative;
        display: flex;
        flex-direction: column;
        gap: 0;
    }

    .tracker-step {
        display: flex;
        gap: 24px;
        position: relative;
    }

    .tracker-step:not(:last-child) .tracker-line {
        height: 100%;
    }

    .tracker-left {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 48px;
        flex-shrink: 0;
    }

    .tracker-dot {
        width: 48px; height: 48px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        z-index: 1;
        transition: all 0.4s ease;
    }

    .tracker-dot.done {
        background: linear-gradient(135deg, #00c851, #00e676);
        box-shadow: 0 0 20px rgba(0,200,81,0.4);
    }

    .tracker-dot.active {
        background: linear-gradient(135deg, var(--color-primary), #ff8c42);
        box-shadow: 0 0 24px rgba(255,107,0,0.5);
        animation: pulse-dot 2s ease-in-out infinite;
    }

    .tracker-dot.pending {
        background: rgba(255,255,255,0.06);
        border: 2px solid rgba(255,255,255,0.1);
    }

    @keyframes pulse-dot {
        0%, 100% { box-shadow: 0 0 20px rgba(255,107,0,0.4); transform: scale(1); }
        50%       { box-shadow: 0 0 32px rgba(255,107,0,0.7); transform: scale(1.06); }
    }

    .tracker-connector {
        width: 2px;
        flex: 1;
        min-height: 36px;
        margin: 4px 0;
    }

    .tracker-connector.done { background: linear-gradient(to bottom, #00c851, #00e676); }
    .tracker-connector.active { background: linear-gradient(to bottom, var(--color-primary), rgba(255,107,0,0.2)); }
    .tracker-connector.pending { background: rgba(255,255,255,0.08); }

    .tracker-content {
        padding: 10px 0 36px;
        flex: 1;
    }

    .tracker-step:last-child .tracker-content {
        padding-bottom: 0;
    }

    .tracker-step-title {
        font-size: 1rem;
        font-weight: 700;
        margin: 0 0 4px;
    }

    .tracker-step-title.done  { color: #00c851; }
    .tracker-step-title.active { color: var(--color-primary); }
    .tracker-step-title.pending { color: rgba(255,255,255,0.4); }

    .tracker-step-desc {
        font-size: 0.85rem;
        color: var(--text-secondary);
        margin: 0 0 6px;
        line-height: 1.5;
    }

    .tracker-step-time {
        font-size: 0.78rem;
        color: rgba(255,255,255,0.3);
        font-style: italic;
    }

    /* Status chip */
    .status-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 16px;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }
    .status-chip.pending    { background: rgba(255,184,0,0.12); border: 1px solid rgba(255,184,0,0.3); color: #ffb800; }
    .status-chip.processing { background: rgba(0,122,255,0.12); border: 1px solid rgba(0,122,255,0.3); color: #007aff; }
    .status-chip.completed  { background: rgba(0,200,81,0.12);  border: 1px solid rgba(0,200,81,0.3);  color: #00c851; }
    .status-chip.cancelled  { background: rgba(255,59,48,0.12); border: 1px solid rgba(255,59,48,0.3); color: #ff3b30; }

    .status-chip .dot {
        width: 6px; height: 6px;
        border-radius: 50%;
        background: currentColor;
    }
    .status-chip.active .dot { animation: blink 1.2s ease infinite; }
    @keyframes blink {
        0%, 100% { opacity: 1; }
        50%       { opacity: 0.3; }
    }

    /* ── Method info ── */
    .method-card {
        background: rgba(255,255,255,0.02);
        border: 1px solid var(--color-border);
        border-radius: 20px;
        padding: 24px 28px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 24px;
    }

    .method-left { display: flex; align-items: center; gap: 16px; }

    .method-icon {
        width: 52px; height: 52px;
        border-radius: 14px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.4rem;
    }

    .method-icon.wallet { background: rgba(255,107,0,0.12); }
    .method-icon.original { background: rgba(0,122,255,0.12); }

    .method-label { font-size: 0.8rem; color: var(--text-secondary); margin: 0 0 3px; }
    .method-name  { font-size: 1rem; font-weight: 700; color: white; margin: 0; }

    /* ── CTA Buttons ── */
    .cta-row {
        display: flex;
        gap: 12px;
        margin-top: 10px;
        flex-wrap: wrap;
    }

    .btn-glass {
        padding: 12px 24px;
        border-radius: 12px;
        border: 1px solid var(--color-border);
        background: rgba(255,255,255,0.04);
        color: white;
        font-weight: 600;
        font-size: 0.9rem;
        cursor: pointer;
        text-decoration: none;
        transition: all 0.3s ease;
        display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-glass:hover {
        background: rgba(255,255,255,0.08);
        border-color: rgba(255,255,255,0.3);
        transform: translateY(-2px);
    }

    @media (max-width: 640px) {
        .refund-hero { flex-direction: column; text-align: center; }
        .tracker-card { padding: 24px 20px; }
        .info-grid { grid-template-columns: 1fr 1fr; }
        .method-card { flex-direction: column; text-align: center; }
    }
</style>

<main>
<div class="refund-page">

    <a href="${pageContext.request.contextPath}/profile?tab=bookings" class="back-link">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="15 18 9 12 15 6"/>
        </svg>
        Back to Bookings
    </a>

    <%-- ── Determine step state based on refund status ── --%>
    <%
        com.voyastra.model.Refund refund = (com.voyastra.model.Refund) request.getAttribute("refund");
        com.voyastra.model.HotelBooking booking = (com.voyastra.model.HotelBooking) request.getAttribute("booking");

        String refundStatus = (refund != null) ? refund.getStatus().toUpperCase() : "PENDING";
        // Steps: CANCELLED → PENDING → PROCESSING → COMPLETED
        boolean step1Done  = true; // Booking cancelled = always done on this page
        boolean step2Done  = refundStatus.equals("PROCESSING") || refundStatus.equals("COMPLETED");
        boolean step2Active = refundStatus.equals("PENDING");
        boolean step3Done  = refundStatus.equals("COMPLETED");
        boolean step3Active = refundStatus.equals("PROCESSING");

        String methodLabel  = "Original Payment Method";
        String methodClass  = "original";
        String methodEmoji  = "💳";
        String methodDesc   = "Will be credited back in 3-5 business days";
        if (refund != null && "WALLET".equals(refund.getRefundMethod())) {
            methodLabel = "Voyastra Wallet";
            methodClass = "wallet";
            methodEmoji = "👛";
            methodDesc  = "Credited instantly to your wallet";
        }
    %>

    <%-- ── Hero ── --%>
    <div class="refund-hero">
        <div class="refund-hero-icon">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#ff3b30" stroke-width="1.8">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                <polyline points="9 22 9 12 15 12 15 22"/>
            </svg>
        </div>
        <div class="refund-hero-info">
            <h1>Refund Tracker</h1>
            <p>
                Booking Code: <strong style="color:white;">
                    <c:if test="${booking != null}">${booking.bookingCode}</c:if>
                    <c:if test="${booking == null}">N/A</c:if>
                </strong>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                Status:&nbsp;
                <c:choose>
                    <c:when test="${refund.status == 'COMPLETED'}">
                        <span class="status-chip completed"><span class="dot"></span>Completed</span>
                    </c:when>
                    <c:when test="${refund.status == 'PROCESSING'}">
                        <span class="status-chip processing active"><span class="dot"></span>Processing</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-chip pending active"><span class="dot"></span>Pending</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <div class="amount-badge">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="1" x2="12" y2="23"/>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                </svg>
                Refund: ₹<fmt:formatNumber value="${refund.amount}" pattern="#,##0.00"/>
            </div>
        </div>
    </div>

    <%-- ── Booking Summary ── --%>
    <c:if test="${booking != null}">
    <div class="info-card">
        <div class="info-card-title">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            </svg>
            Booking Details
        </div>
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Hotel</div>
                <div class="info-value">${booking.hotel.name}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Room Type</div>
                <div class="info-value">${booking.room.type}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Guest Name</div>
                <div class="info-value">${booking.guestName}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Check-in</div>
                <div class="info-value"><fmt:formatDate value="${booking.checkIn}" pattern="dd MMM yyyy"/></div>
            </div>
            <div class="info-item">
                <div class="info-label">Check-out</div>
                <div class="info-value"><fmt:formatDate value="${booking.checkOut}" pattern="dd MMM yyyy"/></div>
            </div>
            <div class="info-item">
                <div class="info-label">Original Amount</div>
                <div class="info-value" style="color: var(--color-primary);">₹<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></div>
            </div>
        </div>
    </div>
    </c:if>

    <%-- ── Refund Method ── --%>
    <div class="method-card">
        <div class="method-left">
            <div class="method-icon <%= methodClass %>">
                <%= methodEmoji %>
            </div>
            <div>
                <div class="method-label">Refund Channel</div>
                <div class="method-name"><%= methodLabel %></div>
                <div style="font-size:0.82rem; color: var(--text-secondary); margin-top:3px;"><%= methodDesc %></div>
            </div>
        </div>
        <div class="amount-badge" style="font-size:1.1rem;">
            ₹<fmt:formatNumber value="${refund.amount}" pattern="#,##0.00"/>
        </div>
    </div>

    <%-- ── Progress Tracker ── --%>
    <div class="tracker-card">
        <div class="tracker-title">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="var(--color-primary)" stroke-width="2">
                <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
            </svg>
            Refund Progress
        </div>

        <div class="tracker-timeline">

            <%-- Step 1: Cancellation Requested --%>
            <div class="tracker-step">
                <div class="tracker-left">
                    <div class="tracker-dot done">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <div class="tracker-connector done"></div>
                </div>
                <div class="tracker-content">
                    <div class="tracker-step-title done">Cancellation Requested</div>
                    <div class="tracker-step-desc">Your booking has been successfully cancelled. A refund of ₹<fmt:formatNumber value="${refund.amount}" pattern="#,##0.00"/> has been initiated.</div>
                    <div class="tracker-step-time">
                        <c:if test="${refund.createdAt != null}">
                            <fmt:formatDate value="${refund.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                        </c:if>
                    </div>
                </div>
            </div>

            <%-- Step 2: Refund Processing --%>
            <div class="tracker-step">
                <div class="tracker-left">
                    <div class="tracker-dot <%= step2Done ? "done" : step2Active ? "active" : "pending" %>">
                        <c:choose>
                            <c:when test="${refund.status == 'PROCESSING' or refund.status == 'COMPLETED'}">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"/>
                                </svg>
                            </c:when>
                            <c:when test="${refund.status == 'PENDING'}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                                    <path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/>
                                </svg>
                            </c:when>
                            <c:otherwise>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                </svg>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="tracker-connector <%= step2Done ? "done" : step2Active ? "active" : "pending" %>"></div>
                </div>
                <div class="tracker-content">
                    <div class="tracker-step-title <%= step2Done ? "done" : step2Active ? "active" : "pending" %>">Refund Processing</div>
                    <c:choose>
                        <c:when test="${refund.status == 'COMPLETED' or refund.status == 'PROCESSING'}">
                            <div class="tracker-step-desc">Our payments team has verified and is processing your refund to your selected channel.</div>
                        </c:when>
                        <c:when test="${refund.status == 'PENDING'}">
                            <div class="tracker-step-desc">Your refund request is queued. Our team reviews refunds within 24 hours on business days.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="tracker-step-desc" style="opacity:0.4;">Awaiting previous step to complete.</div>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${refund.status == 'PROCESSING' or refund.status == 'COMPLETED'}">
                        <div class="tracker-step-time">Under review</div>
                    </c:if>
                </div>
            </div>

            <%-- Step 3: Refund Completed --%>
            <div class="tracker-step">
                <div class="tracker-left">
                    <div class="tracker-dot <%= step3Done ? "done" : step3Active ? "active" : "pending" %>">
                        <c:choose>
                            <c:when test="${refund.status == 'COMPLETED'}">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"/>
                                </svg>
                            </c:when>
                            <c:when test="${refund.status == 'PROCESSING'}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                </svg>
                            </c:when>
                            <c:otherwise>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                </svg>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="tracker-content">
                    <div class="tracker-step-title <%= step3Done ? "done" : step3Active ? "active" : "pending" %>">Refund Completed</div>
                    <c:choose>
                        <c:when test="${refund.status == 'COMPLETED'}">
                            <div class="tracker-step-desc">🎉 Your refund of ₹<fmt:formatNumber value="${refund.amount}" pattern="#,##0.00"/> has been successfully credited to your <strong><%= methodLabel %></strong>.</div>
                        </c:when>
                        <c:when test="${refund.status == 'PROCESSING'}">
                            <div class="tracker-step-desc">Finalizing transfer to your <%= methodLabel %>. Expected within 2–3 business days.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="tracker-step-desc" style="opacity:0.4;">
                                <c:choose>
                                    <c:when test="${refund.refundMethod == 'WALLET'}">Instant wallet credit upon processing.</c:when>
                                    <c:otherwise>Credit in 3-5 business days after processing.</c:otherwise>
                                </c:choose>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div><%-- /tracker-timeline --%>
    </div>

    <%-- ── Support Notice ── --%>
    <div class="info-card" style="border-color: rgba(255,107,0,0.2); background: rgba(255,107,0,0.03);">
        <div style="display:flex; align-items:flex-start; gap:16px;">
            <div style="font-size:1.8rem; flex-shrink:0;">💬</div>
            <div>
                <div style="font-weight:700; color:white; margin-bottom:6px;">Need Help?</div>
                <div style="color:var(--text-secondary); font-size:0.9rem; line-height:1.6;">
                    If your refund is delayed or you have any queries, contact our support team at
                    <strong style="color:var(--color-primary);">support@voyastra.com</strong> or call
                    <strong style="color:white;">+1-800-VOYASTRA</strong>. Please keep your Booking Code handy.
                </div>
            </div>
        </div>
    </div>

    <%-- ── CTA Buttons ── --%>
    <div class="cta-row">
        <a href="${pageContext.request.contextPath}/profile?tab=bookings" class="btn btn-outline btn-glass">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="15 18 9 12 15 6"/>
            </svg>
            Back to My Bookings
        </a>
        <a href="${pageContext.request.contextPath}/hotels" class="btn btn-primary">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            </svg>
            Book Another Hotel
        </a>
    </div>

</div>
</main>

<%@ include file="/components/footer.jsp" %>
