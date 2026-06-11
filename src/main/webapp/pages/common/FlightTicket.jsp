<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Ticket — ${flightBooking.bookingCode} | Voyastra Airlines</title>
    <meta name="description" content="Your Voyastra flight e-ticket for ${flightBooking.departureCity} to ${flightBooking.arrivalCity}">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,400&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy: #0B1A3B;
            --blue: #1565C0;
            --blue-light: #1976D2;
            --gold: #F59E0B;
            --success: #10B981;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --border: #E2E8F0;
            --bg-page: #F1F5F9;
            --white: #FFFFFF;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-page);
            min-height: 100vh;
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }

        /* --- Action Buttons (hidden on print) --- */
        .actions {
            display: flex;
            gap: 12px;
            width: 100%;
            max-width: 820px;
        }
        .btn {
            padding: 13px 26px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            display: flex; align-items: center; gap: 8px;
        }
        .btn-primary { background: var(--blue); color: #fff; box-shadow: 0 4px 14px rgba(21,101,192,0.35); }
        .btn-primary:hover { background: #0D47A1; transform: translateY(-1px); }
        .btn-secondary { background: #fff; color: var(--text-dark); border: 1px solid var(--border); }
        .btn-secondary:hover { background: #F8FAFC; }

        /* --- Ticket Container --- */
        .ticket {
            width: 100%;
            max-width: 820px;
            background: var(--white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 30px rgba(0,0,0,0.1);
        }

        /* --- Header Band --- */
        .ticket-header {
            background: linear-gradient(135deg, var(--navy) 0%, var(--blue) 100%);
            padding: 28px 36px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .ticket-header .brand h1 {
            font-size: 24px; font-weight: 800; color: #fff; letter-spacing: -0.5px;
        }
        .ticket-header .brand p {
            font-size: 11px; color: rgba(255,255,255,0.65);
            text-transform: uppercase; letter-spacing: 2.5px; margin-top: 3px;
        }
        .ticket-header .badge {
            background: rgba(16,185,129,0.15);
            border: 1px solid rgba(16,185,129,0.4);
            color: #6EE7B7;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        /* --- Route Banner --- */
        .route-banner {
            background: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 100%);
            padding: 30px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            border-bottom: 1px solid var(--border);
        }
        .route-city { text-align: center; }
        .route-city .iata {
            font-size: 44px; font-weight: 800; color: var(--navy); letter-spacing: -1px;
        }
        .route-city .city-name {
            font-size: 13px; color: var(--text-muted); margin-top: 4px; font-weight: 500;
        }
        .route-arrow {
            flex: 1; text-align: center;
            display: flex; flex-direction: column; align-items: center; gap: 6px;
        }
        .route-arrow .flight-line {
            width: 100%; display: flex; align-items: center; gap: 6px;
        }
        .route-arrow .line {
            flex: 1; height: 2px; background: linear-gradient(90deg, #93C5FD, #1565C0);
            border-radius: 2px;
        }
        .route-arrow .plane { font-size: 22px; }
        .route-arrow .meta {
            font-size: 11px; font-weight: 600; color: var(--blue-light);
            text-transform: uppercase; letter-spacing: 1px;
        }
        .route-arrow .stops-badge {
            background: ${flightBooking.stops == '0' ? 'rgba(16,185,129,0.1)' : 'rgba(245,158,11,0.1)'};
            color: ${flightBooking.stops == '0' ? '#059669' : '#D97706'};
            border: 1px solid ${flightBooking.stops == '0' ? 'rgba(16,185,129,0.3)' : 'rgba(245,158,11,0.3)'};
            padding: 3px 10px; border-radius: 10px;
            font-size: 10px; font-weight: 700; text-transform: uppercase;
        }

        /* --- Details Grid --- */
        .details-section {
            padding: 28px 36px;
            border-bottom: 1px solid var(--border);
        }
        .details-section .section-label {
            font-size: 11px; font-weight: 700; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 1.5px;
            margin-bottom: 18px; padding-bottom: 10px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 8px;
        }
        .details-section .section-label::before {
            content: ''; display: inline-block; width: 3px; height: 14px;
            background: var(--blue); border-radius: 2px;
        }
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
        }
        .detail-item label {
            display: block; font-size: 10px; font-weight: 600;
            color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px;
        }
        .detail-item p {
            font-size: 15px; font-weight: 600; color: var(--text-dark);
        }
        .detail-item p.large {
            font-size: 20px; font-weight: 800; color: var(--navy);
            letter-spacing: 2px; font-family: 'Courier New', monospace;
        }
        .detail-item p.muted { font-size: 13px; font-weight: 500; color: var(--text-muted); }

        /* --- Passenger Table --- */
        .pax-table {
            width: 100%;
            border-collapse: collapse;
        }
        .pax-table th {
            background: #F8FAFC;
            padding: 10px 16px;
            text-align: left;
            font-size: 10px; font-weight: 700;
            color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;
            border-bottom: 1px solid var(--border);
        }
        .pax-table td {
            padding: 12px 16px;
            font-size: 14px; color: var(--text-dark);
            border-bottom: 1px solid #F1F5F9;
        }
        .pax-table tr:last-child td { border-bottom: none; }

        /* --- Divider (Tear Line) --- */
        .tear-line {
            display: flex; align-items: center;
            margin: 0;
            background: var(--bg-page);
        }
        .tear-circle { width: 22px; height: 22px; background: var(--bg-page); border-radius: 50%; flex-shrink: 0; }
        .tear-dashes { flex: 1; border-top: 2px dashed var(--border); }

        /* --- Fare Breakdown --- */
        .fare-section {
            padding: 24px 36px;
            background: #FAFAFA;
            border-top: 1px solid var(--border);
        }
        .fare-row {
            display: flex; justify-content: space-between;
            padding: 8px 0;
            font-size: 14px; color: var(--text-muted);
            border-bottom: 1px solid #F1F5F9;
        }
        .fare-row:last-child { border-bottom: none; }
        .fare-row.total {
            font-size: 17px; font-weight: 800; color: var(--text-dark);
            padding-top: 14px; border-top: 2px solid var(--border);
            border-bottom: none; margin-top: 6px;
        }
        .fare-row span:last-child { font-weight: 600; color: var(--text-dark); }
        .fare-row.total span:last-child { color: var(--blue); font-size: 20px; }

        /* --- Footer --- */
        .ticket-footer {
            padding: 18px 36px;
            background: var(--navy);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }
        .ticket-footer p {
            font-size: 11px; color: rgba(255,255,255,0.5); line-height: 1.6;
        }
        .ticket-footer .support {
            font-size: 11px; color: rgba(255,255,255,0.65); text-align: right; flex-shrink: 0;
        }
        .ticket-footer .support strong { color: #fff; display: block; }

        /* --- Print Styles --- */
        @media print {
            body { background: #fff; padding: 0; }
            .actions { display: none; }
            .ticket { box-shadow: none; border: 1px solid #ddd; }
            .ticket-header { background: #0B1A3B !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .route-banner { background: #EFF6FF !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .ticket-footer { background: #0B1A3B !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .tear-circle { background: #fff !important; }
        }
    </style>
</head>
<body>

    <!-- Action Buttons -->
    <div class="actions">
        <button class="btn btn-primary" onclick="downloadPDF()" id="btn-download-pdf">
            ✈️ Download E-Ticket PDF
        </button>
        <button class="btn btn-secondary" onclick="window.print()">
            🖨️ Print E-Ticket
        </button>
    </div>

    <!-- THE TICKET -->
    <div class="ticket" id="eticket">

        <!-- Header -->
        <div class="ticket-header">
            <div class="brand">
                <h1>VOYASTRA</h1>
                <p>Boarding Confirmation · E-Ticket</p>
            </div>
            <div class="badge">✓ CONFIRMED</div>
        </div>

        <!-- Route -->
        <div class="route-banner">
            <div class="route-city">
                <div class="iata">${empty flightBooking.departureCity ? '---' : flightBooking.departureCity}</div>
                <div class="city-name">Origin</div>
                <div style="font-size:13px; color:#1565C0; font-weight:600; margin-top:6px;">
                    ${empty flightBooking.departureTime ? '' : flightBooking.departureTime}
                </div>
            </div>

            <div class="route-arrow">
                <div class="flight-line">
                    <div class="line"></div>
                    <div class="plane">✈</div>
                    <div class="line"></div>
                </div>
                <div class="meta" style="margin-top:6px;">
                    ${empty flightBooking.duration ? 'Direct Flight' : flightBooking.duration}
                </div>
                <c:choose>
                    <c:when test="${flightBooking.stops == '0' or empty flightBooking.stops}">
                        <div class="stops-badge" style="background:rgba(16,185,129,0.1); color:#059669; border:1px solid rgba(16,185,129,0.3);">Non-Stop</div>
                    </c:when>
                    <c:otherwise>
                        <div class="stops-badge" style="background:rgba(245,158,11,0.1); color:#D97706; border:1px solid rgba(245,158,11,0.3);">${flightBooking.stops} Stop(s)</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="route-city" style="text-align:right;">
                <div class="iata">${empty flightBooking.arrivalCity ? '---' : flightBooking.arrivalCity}</div>
                <div class="city-name">Destination</div>
                <div style="font-size:13px; color:#1565C0; font-weight:600; margin-top:6px;">
                    ${empty flightBooking.arrivalTime ? '' : flightBooking.arrivalTime}
                </div>
            </div>
        </div>

        <!-- Flight Details -->
        <div class="details-section">
            <div class="section-label">Flight Information</div>
            <div class="details-grid">
                <div class="detail-item">
                    <label>Booking Reference</label>
                    <p class="large">${flightBooking.bookingCode}</p>
                </div>
                <div class="detail-item">
                    <label>PNR</label>
                    <p class="large">${empty flightBooking.pnr ? 'N/A' : flightBooking.pnr}</p>
                </div>
                <div class="detail-item">
                    <label>Airline</label>
                    <p>${empty flightBooking.airlineName ? 'Voyastra Airlines' : flightBooking.airlineName}</p>
                </div>
                <div class="detail-item">
                    <label>Flight No.</label>
                    <p>${empty flightBooking.flightNumber ? 'N/A' : flightBooking.flightNumber}</p>
                </div>
                <div class="detail-item">
                    <label>Travel Date</label>
                    <p>${empty flightBooking.travelDate ? 'N/A' : flightBooking.travelDate}</p>
                </div>
                <div class="detail-item">
                    <label>Seat Class</label>
                    <p>${empty flightBooking.seatClass ? 'Economy' : flightBooking.seatClass}</p>
                </div>
                <div class="detail-item">
                    <label>Seat(s)</label>
                    <p>${empty flightBooking.seatNumbers ? 'TBA' : flightBooking.seatNumbers}</p>
                </div>
                <div class="detail-item">
                    <label>Baggage</label>
                    <p>15 kg Check-in<br><span style="font-size:12px;color:#64748B;">7 kg Cabin</span></p>
                </div>
                <div class="detail-item">
                    <label>Terminal</label>
                    <p class="muted">As per airline</p>
                </div>
                <div class="detail-item">
                    <label>Gate</label>
                    <p class="muted">As per airline</p>
                </div>
            </div>
        </div>

        <!-- Passenger Details -->
        <div class="details-section">
            <div class="section-label">Passenger Information</div>
            <table class="pax-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Passenger Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Seat</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td><strong>${empty flightBooking.customerName ? 'Voyastra Passenger' : flightBooking.customerName}</strong></td>
                        <td>${empty flightBooking.customerEmail ? '—' : flightBooking.customerEmail}</td>
                        <td>${empty flightBooking.customerPhone ? '—' : flightBooking.customerPhone}</td>
                        <td>${empty flightBooking.seatNumbers ? 'TBA' : flightBooking.seatNumbers}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Tear Line -->
        <div class="tear-line">
            <div class="tear-circle"></div>
            <div class="tear-dashes"></div>
            <div class="tear-circle"></div>
        </div>

        <!-- Payment & Fare Breakdown -->
        <div class="fare-section">
            <div class="section-label">Payment Summary</div>
            <div class="details-grid" style="margin-bottom:20px;">
                <div class="detail-item">
                    <label>Payment ID</label>
                    <p style="font-size:13px; word-break:break-all;">${empty flightBooking.paymentId ? 'N/A' : flightBooking.paymentId}</p>
                </div>
                <div class="detail-item">
                    <label>Payment Status</label>
                    <p style="color:#059669; font-weight:700;">${empty flightBooking.paymentStatus ? 'SUCCESS' : flightBooking.paymentStatus}</p>
                </div>
                <div class="detail-item">
                    <label>Booked On</label>
                    <p style="font-size:13px;">
                        <c:choose>
                            <c:when test="${not empty flightBooking.createdAt}"><fmt:formatDate value="${flightBooking.createdAt}" pattern="MMM dd, yyyy HH:mm"/></c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <div style="max-width:360px; margin-left:auto;">
                <div class="fare-row">
                    <span>Base Fare</span>
                    <span>₹${baseAmount}</span>
                </div>
                <div class="fare-row">
                    <span>Taxes &amp; Surcharges (18% GST)</span>
                    <span>₹${gstAmount}</span>
                </div>
                <div class="fare-row">
                    <span>Convenience Fee</span>
                    <span>₹${convFee}</span>
                </div>
                <div class="fare-row total">
                    <span>Total Paid</span>
                    <span>₹<fmt:formatNumber value="${flightBooking.totalPrice}" pattern="#,##0.00"/></span>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="ticket-footer">
            <p>This is a computer-generated e-ticket and does not require a physical signature.<br>
               Please carry a valid government-issued photo ID during check-in.</p>
            <div class="support">
                <strong>Voyastra Support</strong>
                support@voyastra.com · 1800-VOYASTRA
            </div>
        </div>
    </div>

    <script>
        function downloadPDF() {
            const btn = document.getElementById('btn-download-pdf');
            btn.textContent = '⏳ Generating PDF...';
            btn.disabled = true;

            const el = document.getElementById('eticket');
            const opt = {
                margin:      [0.3, 0.3],
                filename:    'VoyastraETicket-${flightBooking.bookingCode}.pdf',
                image:       { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2, useCORS: true, logging: false, backgroundColor: '#ffffff' },
                jsPDF:       { unit: 'in', format: 'a4', orientation: 'portrait' }
            };

            html2pdf().set(opt).from(el).save().then(() => {
                btn.textContent = '✈️ Download E-Ticket PDF';
                btn.disabled = false;
            }).catch(err => {
                console.error('PDF error:', err);
                btn.textContent = '✈️ Download E-Ticket PDF';
                btn.disabled = false;
            });
        }
    </script>
</body>
</html>
