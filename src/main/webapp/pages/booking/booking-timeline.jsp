<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Booking Details - Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        .timeline-container { max-width: 800px; margin: 40px auto; padding: 20px; }
        .booking-header { background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 24px; margin-bottom: 40px; display:flex; justify-content:space-between; align-items:center; }
        .booking-header h1 { margin: 0; font-size: 1.5rem; color: var(--text-main); }
        .booking-header p { margin: 5px 0 0 0; color: var(--text-secondary); }
        
        /* Vertical Timeline */
        .timeline { position: relative; padding-left: 30px; margin-bottom: 50px; }
        .timeline::before {
            content: ''; position: absolute; left: 0; top: 0; bottom: 0;
            width: 2px; background: rgba(255, 107, 0, 0.3);
        }
        
        .timeline-item { position: relative; margin-bottom: 30px; padding-left: 20px; }
        .timeline-item::before {
            content: ''; position: absolute; left: -36px; top: 0;
            width: 14px; height: 14px; border-radius: 50%;
            background: var(--color-primary); border: 4px solid var(--bg-main);
        }
        .timeline-item.completed::before { background: #4CAF50; }
        .timeline-item.pending::before { background: #ff9800; }
        .timeline-item.cancelled::before { background: #ff3b30; }

        .timeline-content { background: rgba(255,255,255,0.02); padding: 16px; border-radius: 12px; border: 1px solid var(--color-border); }
        .timeline-content h3 { margin: 0 0 5px 0; font-size: 1.1rem; }
        .timeline-content p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; }
        .timeline-date { font-size: 0.8rem; color: #888; margin-top: 8px; display: block; }
        
        /* Upload Section */
        .upload-section { background: rgba(255,255,255,0.02); border: 1px dashed var(--color-primary); border-radius: 12px; padding: 30px; text-align: center; }
        .upload-section input[type="file"] { display: none; }
        .upload-label { display: inline-block; padding: 10px 20px; background: rgba(255,107,0,0.1); color: var(--color-primary); border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.2s; }
        .upload-label:hover { background: rgba(255,107,0,0.2); }
        
        .pass-list { margin-top: 20px; display:flex; flex-direction:column; gap:10px; }
        .pass-item { display:flex; justify-content:space-between; padding:12px; background:rgba(255,255,255,0.05); border-radius:8px; }
    </style>
</head>
<body style="padding-top:80px; padding-bottom:60px;">
<jsp:include page="/components/header.jsp" />

<div class="container timeline-container">
    <a href="${pageContext.request.contextPath}/profile?tab=bookings" style="color:var(--color-primary); text-decoration:none; margin-bottom:20px; display:inline-block;">&larr; Back to Dashboard</a>
    
    <div class="booking-header">
        <div>
            <h1>Flight Status</h1>
            <p>Booking Ref: <strong style="color:white;">${booking.bookingCode}</strong></p>
        </div>
        <div style="text-align:right;">
            <span class="status-pill status-${booking.status.toLowerCase()}">${booking.status}</span>
            <div style="margin-top:10px;">
                <a href="${pageContext.request.contextPath}/ticket?code=${booking.bookingCode}" class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem;">View Ticket</a>
            </div>
        </div>
    </div>

    <!-- Timeline -->
    <div class="timeline">
        <div class="timeline-item completed">
            <div class="timeline-content">
                <h3>Booking Confirmed</h3>
                <p>Your flight reservation was successfully created.</p>
                <span class="timeline-date"><fmt:formatDate value="${booking.createdAt}" pattern="MMM dd, yyyy HH:mm"/></span>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${booking.status == 'CANCELLED'}">
                <div class="timeline-item cancelled">
                    <div class="timeline-content">
                        <h3>Booking Cancelled</h3>
                        <p>This booking has been cancelled. Refund has been initiated.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="timeline-item completed">
                    <div class="timeline-content">
                        <h3>Payment Processed</h3>
                        <p>Payment of ₹${booking.totalPrice} received successfully via ${booking.paymentStatus}.</p>
                    </div>
                </div>
                
                <div class="timeline-item completed">
                    <div class="timeline-content">
                        <h3>E-Ticket Issued</h3>
                        <p>Your e-ticket and itinerary have been sent to your registered email.</p>
                    </div>
                </div>
                
                <div class="timeline-item pending">
                    <div class="timeline-content">
                        <h3>Web Check-in</h3>
                        <p>Web check-in opens 48 hours before departure.</p>
                    </div>
                </div>
                
                <div class="timeline-item">
                    <div class="timeline-content" style="opacity: 0.5;">
                        <h3>Boarding</h3>
                        <p>Please arrive at the gate 45 minutes before departure.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Boarding Pass Upload -->
    <h3>External Boarding Passes</h3>
    <p style="color:var(--text-secondary); font-size:0.9rem; margin-bottom:20px;">If you received a physical boarding pass or checked in via the airline's official app, you can upload it here for safekeeping.</p>
    
    <div class="upload-section">
        <form action="${pageContext.request.contextPath}/booking-details" method="POST" enctype="multipart/form-data" id="uploadForm">
            <input type="hidden" name="code" value="${booking.bookingCode}">
            <input type="file" name="boardingPass" id="fileInput" onchange="document.getElementById('uploadForm').submit()" accept=".pdf,image/*">
            <label for="fileInput" class="upload-label">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle; margin-right:5px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                Upload Document
            </label>
        </form>
        
        <c:if test="${not empty passes}">
            <div class="pass-list">
                <c:forEach var="p" items="${passes}">
                    <div class="pass-item">
                        <div>
                            <strong>Document</strong>
                            <div style="font-size:0.8rem; color:#888;"><fmt:formatDate value="${p.uploadedAt}" pattern="MMM dd, yyyy HH:mm"/></div>
                        </div>
                        <a href="${pageContext.request.contextPath}/${p.filePath}" target="_blank" style="color:var(--color-primary); font-weight:600; text-decoration:none;">View</a>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
