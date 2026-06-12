<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <div class="details-icon">🚁</div>
        <h1 class="details-title">Helicopter Booking Details</h1>
        <p style="color:var(--text-secondary); margin-top:10px;">Booking Reference: ${booking.id != null ? booking.id : ''}</p>
    </div>
    
    <c:if test="${not empty booking}">
    <div class="details-grid">
            <div class="detail-item">
                <div class="detail-label">Email</div>
                <div class="detail-value">${booking.email}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Phone</div>
                <div class="detail-value">${booking.phone}</div>
            </div>

        <div class="detail-item">
            <div class="detail-label">Passenger Name</div>
            <div class="detail-value">${booking.passengerName}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Operator</div>
            <div class="detail-value">${booking.operator}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Flight Number</div>
            <div class="detail-value">${booking.flightNumber}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Origin</div>
            <div class="detail-value">${booking.source}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Destination</div>
            <div class="detail-value">${booking.destination}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Seat</div>
            <div class="detail-value">${booking.seat}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Departure Time</div>
            <div class="detail-value">${booking.departureTime}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Fare</div>
            <div class="detail-value">₹${booking.fare}</div>
        </div>

    </div>
    </c:if>
    
    <div class="actions">
        <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=bookings'">Back to My Bookings</button>
    </div>
</div>

<%@ include file="/components/footer.jsp" %>
