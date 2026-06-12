<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .details-container {
        max-width: 800px;
        margin: 60px auto;
        background: var(--surface-glass);
        backdrop-filter: blur(12px);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }
    .details-header {
        text-align: center;
        margin-bottom: 40px;
        border-bottom: 1px solid var(--color-border);
        padding-bottom: 20px;
    }
    .details-icon {
        font-size: 3rem;
        margin-bottom: 10px;
        display: inline-block;
    }
    .details-title {
        font-size: 2rem;
        font-weight: 800;
        color: var(--text-primary);
    }
    .details-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }
    .detail-item {
        background: rgba(255, 255, 255, 0.02);
        padding: 15px 20px;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.05);
    }
    .detail-label {
        font-size: 0.85rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 5px;
        font-weight: 600;
    }
    .detail-value {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--text-primary);
    }
    .actions {
        margin-top: 40px;
        display: flex;
        justify-content: center;
        gap: 15px;
    }
</style>

<div class="details-container">
    <div class="details-header">
        <div class="details-icon">🏨</div>
        <h1 class="details-title">Hotel Booking Details</h1>
        <p style="color:var(--text-secondary); margin-top:10px;">Booking Reference: ${booking.id != null ? booking.id : ''}</p>
    </div>
    
    <div class="details-grid">
        <div class="detail-item">
            <div class="detail-label">Guest Name</div>
            <div class="detail-value">${booking.customerName}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Hotel Name</div>
            <div class="detail-value">${booking.hotelName}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Room Type</div>
            <div class="detail-value">${booking.roomType}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Check In</div>
            <div class="detail-value">${booking.checkInDate}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Check Out</div>
            <div class="detail-value">${booking.checkOutDate}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Guests</div>
            <div class="detail-value">${booking.guestCount}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Address</div>
            <div class="detail-value">${booking.hotelAddress}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Booking ID</div>
            <div class="detail-value">${booking.bookingCode}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Amount Paid</div>
            <div class="detail-value">₹${booking.amountPaid}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Status</div>
            <div class="detail-value">${booking.bookingStatus}</div>
        </div>

    </div>
    
    <div class="actions">
        <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=bookings'">Back to My Bookings</button>
    </div>
</div>

<%@ include file="/components/footer.jsp" %>
