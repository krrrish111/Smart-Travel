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
        <div class="details-icon">🚌</div>
        <h1 class="details-title">Bus Booking Details</h1>
        <p style="color:var(--text-secondary); margin-top:10px;">Booking Reference: ${booking.id != null ? booking.id : ''}</p>
    </div>
    
    <div class="details-grid">
        <div class="detail-item">
            <div class="detail-label">Passenger Name</div>
            <div class="detail-value">${booking.passengerName}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Bus Operator</div>
            <div class="detail-value">${booking.busOperator}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Bus Type</div>
            <div class="detail-value">${booking.busType}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Seat Number</div>
            <div class="detail-value">${booking.seatNumber}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Boarding Point</div>
            <div class="detail-value">${booking.boardingPoint}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Drop Point</div>
            <div class="detail-value">${booking.dropPoint}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Departure</div>
            <div class="detail-value">${booking.departure}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Arrival</div>
            <div class="detail-value">${booking.arrival}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Amount Paid</div>
            <div class="detail-value">₹${booking.amountPaid}</div>
        </div>

    </div>
    
    <div class="actions">
        <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=bookings'">Back to My Bookings</button>
    </div>
</div>

<%@ include file="/components/footer.jsp" %>
