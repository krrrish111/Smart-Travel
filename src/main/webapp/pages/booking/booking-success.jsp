<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmed - Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    
    <!-- QRCode JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    
    <style>
        .page-header { text-align: center; margin: 40px 0; }
        .success-icon { font-size: 3.5rem; color: #4CAF50; margin-bottom: 16px; }
        
        /* Printable Ticket Container */
        #printableTickets {
            display: flex;
            flex-direction: column;
            gap: 30px;
            margin: 0 auto 40px auto;
            max-width: 850px;
            /* Give it a slight dark background in web view to contrast the white tickets */
        }

        /* Boarding Pass Styling */
        .boarding-pass {
            background: #ffffff;
            color: #000000; /* Force black text for print */
            border-radius: 12px;
            display: flex;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            position: relative;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        /* The perforated line between main ticket and stub */
        .boarding-pass::before, .boarding-pass::after {
            content: '';
            position: absolute;
            width: 30px; height: 30px;
            background: var(--bg-main);
            border-radius: 50%;
            right: 235px; /* 250px stub width - 15px radius */
            z-index: 2;
        }
        .boarding-pass::before { top: -15px; }
        .boarding-pass::after { bottom: -15px; }
        
        .bp-perforation {
            position: absolute;
            right: 250px;
            top: 15px;
            bottom: 15px;
            border-right: 2px dashed #cccccc;
            z-index: 1;
        }

        .bp-main {
            flex: 1;
            padding: 24px;
            padding-right: 40px; /* room for perforation */
        }
        .bp-stub {
            width: 250px;
            background: #f8f9fa;
            padding: 24px;
            border-left: 1px solid #eeeeee;
        }

        .bp-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #000;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }
        .bp-logo { font-size: 1.5rem; font-weight: 800; color: #000; display:flex; align-items:center; gap:8px;}
        .bp-logo img { height: 28px; }
        
        .bp-flight-class { font-weight: 800; text-transform: uppercase; font-size: 1.2rem; color: #000; }

        .bp-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .bp-label { font-size: 0.7rem; color: #666; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
        .bp-val { font-size: 1.1rem; font-weight: 800; color: #000; text-transform: uppercase; }
        
        .bp-route {
            display: flex; justify-content: space-between; align-items: center;
            background: #f1f3f5; padding: 16px; border-radius: 8px; margin-bottom: 20px;
        }
        .bp-route-city { font-size: 1.6rem; font-weight: 800; color: #000; }
        .bp-plane-icon { font-size: 1.5rem; color: #aaa; }

        /* Stub specifics */
        .bp-stub-header { font-weight: 800; font-size: 1.1rem; border-bottom: 1px solid #ccc; padding-bottom: 8px; margin-bottom: 16px; }
        .bp-qr-container { display: flex; justify-content: center; margin-top: 20px; }
        
        .action-buttons { display: flex; gap: 16px; justify-content: center; margin-bottom: 60px; }
        
        /* Print styles */
        @media print {
            body { background: #fff !important; padding: 0 !important; }
            .header, .footer, .action-buttons, .page-header { display: none !important; }
            .boarding-pass { box-shadow: none !important; border: 1px solid #ccc !important; break-inside: avoid; margin-bottom: 20px !important; }
            .boarding-pass::before, .boarding-pass::after { background: #fff !important; }
            * { -webkit-print-color-adjust: exact !important; color-adjust: exact !important; }
        }
    </style>
</head>
<body style="padding-top:80px; padding-bottom:60px;">
<jsp:include page="/components/header.jsp" />

<div class="container">
    <div class="page-header">
        <div class="success-icon">✅</div>
        <h1 style="font-size:2.2rem; font-weight:800; color:var(--text-main); margin:0 0 8px 0;">Booking Confirmed!</h1>
        <p style="color:var(--color-muted); margin:0;">Booking ID: <strong style="color:var(--color-primary);">${booking.bookingCode}</strong></p>
    </div>

    <!-- Hidden values for PNR logic -->
    <c:set var="pnr" value="${fn:substring(booking.bookingCode, 4, 10)}${not empty booking.paymentId ? fn:substring(booking.paymentId, 4, 6) : 'XX'}" />
    <c:set var="flightParts" value="${fn:split(booking.details, '|')}" />
    <c:set var="flightName" value="${fn:trim(flightParts[0])}" />
    <c:set var="flightRoute" value="${fn:trim(flightParts[1])}" />
    <c:set var="flightClass" value="${fn:trim(flightParts[2])}" />
    <c:set var="flightDate" value="${fn:trim(flightParts[5])}" />

    <div id="printableTickets">
        <c:forEach items="${travellers}" var="t" varStatus="st">
            <c:set var="tktNum" value="TKT-${booking.id}0${st.index + 1}-${fn:substring(sessionScope.confirmedPaymentId, 8, 12)}" />
            <c:set var="qrData" value="PNR:${pnr}|TKT:${tktNum}|NAME:${t.firstName} ${t.lastName}" />
            
            <div class="boarding-pass">
                <div class="bp-perforation"></div>
                
                <!-- Main Ticket -->
                <div class="bp-main">
                    <div class="bp-header">
                        <div class="bp-logo">
                            <!-- SVG Airplane Icon as logo -->
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.2-1.1.7l-1.2 3.6 7.6 4.3-3.6 3.6-3.2-.8c-.4-.1-.8.2-1 .6l-.5 1.5 4.3 1.9 1.9 4.3 1.5-.5c.4-.2.7-.6.6-1l-.8-3.2 3.6-3.6 4.3 7.6 3.6-1.2c.5-.2.8-.6.7-1.1z"></path></svg>
                            VOYASTRA
                        </div>
                        <div class="bp-flight-class">${fn:substringAfter(flightClass, ": ")}</div>
                    </div>

                    <div class="bp-route">
                        <div>
                            <div class="bp-label">Origin</div>
                            <div class="bp-route-city">${fn:substringBefore(flightRoute, " → ")}</div>
                        </div>
                        <div class="bp-plane-icon">✈️</div>
                        <div style="text-align:right;">
                            <div class="bp-label">Destination</div>
                            <div class="bp-route-city">${fn:substringAfter(flightRoute, " → ")}</div>
                        </div>
                    </div>

                    <div class="bp-grid">
                        <div>
                            <div class="bp-label">Passenger Name</div>
                            <div class="bp-val">${t.title} ${t.firstName} ${t.lastName}</div>
                        </div>
                        <div>
                            <div class="bp-label">Flight</div>
                            <div class="bp-val" style="font-size:0.9rem;">${fn:substringAfter(flightName, "Flight: ")}</div>
                        </div>
                        <div>
                            <div class="bp-label">Date</div>
                            <div class="bp-val" style="font-size:0.9rem;">${fn:substringAfter(flightDate, "Date: ")}</div>
                        </div>
                    </div>

                    <div class="bp-grid" style="grid-template-columns: 1fr 1fr 1fr 1fr;">
                        <div>
                            <div class="bp-label">PNR</div>
                            <div class="bp-val">${pnr}</div>
                        </div>
                        <div>
                            <div class="bp-label">Gate</div>
                            <div class="bp-val">TBD</div>
                        </div>
                        <div>
                            <div class="bp-label">Boarding Time</div>
                            <div class="bp-val" style="font-size:0.9rem;">Check Screens</div>
                        </div>
                        <div>
                            <div class="bp-label">Seat</div>
                            <div class="bp-val">${t.seatNumber}</div>
                        </div>
                    </div>
                </div>

                <!-- Stub (Right side) -->
                <div class="bp-stub">
                    <div class="bp-stub-header">BOARDING PASS</div>
                    
                    <div style="margin-bottom:12px;">
                        <div class="bp-label">Name</div>
                        <div class="bp-val" style="font-size:0.9rem;">${t.firstName} ${t.lastName}</div>
                    </div>
                    
                    <div style="display:flex; justify-content:space-between; margin-bottom:12px;">
                        <div>
                            <div class="bp-label">Seat</div>
                            <div class="bp-val">${t.seatNumber}</div>
                        </div>
                        <div>
                            <div class="bp-label">PNR</div>
                            <div class="bp-val">${pnr}</div>
                        </div>
                    </div>

                    <div style="margin-bottom:12px;">
                        <div class="bp-label">Ticket No</div>
                        <div class="bp-val" style="font-size:0.8rem;">${tktNum}</div>
                    </div>

                    <!-- QR Code -->
                    <div class="bp-qr-container">
                        <div id="qrcode_${st.index}" data-text="${qrData}"></div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="action-buttons">
        <button onclick="downloadTickets()" class="btn-select" style="padding:14px 28px; border-radius:8px; font-size:1.1rem; font-weight:800; background:var(--color-primary); color:#000; border:none; cursor:pointer; transition:transform 0.2s;">
            📥 Download Boarding Passes (PDF)
        </button>
        <button onclick="alert('Ticket emailed to ${booking.customerEmail}')" class="btn-outline" id="btnEmailStatus">
            ✉️ Email Sent
        </button>
        <a href="${pageContext.request.contextPath}/profile" class="btn-outline" style="border-color:var(--color-border); color:var(--text-main); font-size:1.1rem;">
            View My Bookings
        </a>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // Generate QR codes
    document.addEventListener("DOMContentLoaded", function() {
        const qrContainers = document.querySelectorAll('[id^="qrcode_"]');
        qrContainers.forEach(container => {
            const text = container.getAttribute('data-text');
            new QRCode(container, {
                text: text,
                width: 100,
                height: 100,
                colorDark : "#000000",
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.H
            });
        });

        // Automatically generate and email ticket only for new bookings
        <c:if test="${not empty sessionScope.confirmedBookingCode}">
            setTimeout(autoEmailTicket, 1000); // slight delay to ensure QR renders
        </c:if>
    });

    function autoEmailTicket() {
        const element = document.getElementById('printableTickets');
        const btn = document.getElementById('btnEmailStatus');
        btn.innerHTML = '✉️ Sending Email...';

        // Temporarily adjust styles for perfect PDF rendering
        const originalBg = element.style.background;
        element.style.background = '#ffffff';
        element.style.padding = '20px';

        const opt = {
            margin:       0.2,
            filename:     'ticket.pdf',
            image:        { type: 'jpeg', quality: 1 },
            html2canvas:  { scale: 2, useCORS: true, backgroundColor: '#ffffff' },
            jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
        };

        html2pdf().set(opt).from(element).outputPdf('blob').then((pdfBlob) => {
            // Restore styles
            element.style.background = originalBg;
            element.style.padding = '0';

            const formData = new FormData();
            formData.append("ticketPdf", pdfBlob, "ticket.pdf");

            fetch('${pageContext.request.contextPath}/api/send-ticket', {
                method: 'POST',
                body: formData
            }).then(res => {
                if(res.ok) {
                    btn.innerHTML = '✉️ Email Sent!';
                    btn.style.color = '#4CAF50';
                    btn.style.borderColor = '#4CAF50';
                } else {
                    btn.innerHTML = '⚠️ Email Failed';
                }
            }).catch(err => {
                btn.innerHTML = '⚠️ Email Failed';
                console.error(err);
            });
        });
    }

    // Download PDF
    function downloadTickets() {
        const element = document.getElementById('printableTickets');
        
        // Temporarily adjust styles for perfect PDF rendering
        const originalBg = element.style.background;
        element.style.background = '#ffffff';
        element.style.padding = '20px';

        const opt = {
            margin:       0.2,
            filename:     'Voyastra-Boarding-Pass-${booking.bookingCode}.pdf',
            image:        { type: 'jpeg', quality: 1 },
            html2canvas:  { scale: 2, useCORS: true, backgroundColor: '#ffffff' },
            jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
        };

        html2pdf().set(opt).from(element).save().then(() => {
            element.style.background = originalBg;
            element.style.padding = '0';
        });
    }
</script>

<jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var isAutoPrint = '${autoPrint}';
            var isAutoDownload = '${autoDownload}';
            
            if (isAutoPrint === 'true' || isAutoPrint === true) {
                window.print();
            }
            
            if (isAutoDownload === 'true' || isAutoDownload === true) {
                // Find the main container to print. If ticket-container exists use it, else use body or main
                var element = document.querySelector('.ticket-container');
                if (!element) element = document.getElementById('printableTickets');
                if (!element) element = document.querySelector('.invoice-container');
                if (!element) element = document.body;
                
                var opt = {
                  margin:       1,
                  filename:     'Ticket_${booking.id}.pdf',
                  image:        { type: 'jpeg', quality: 0.98 },
                  html2canvas:  { scale: 2 },
                  jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
                };
                
                html2pdf().set(opt).from(element).save();
            }
        });
    </script>
</body>
</html>
