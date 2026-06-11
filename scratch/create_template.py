import os

template_content = """<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>E-Ticket / Voucher - ${empty booking.id ? booking.bookingCode : booking.id}</title>
    <!-- Include html2pdf.js for PDF Generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: rgba(255, 255, 255, 0.03);
            --card-border: rgba(255, 255, 255, 0.1);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --accent: #3b82f6;
            --accent-glow: rgba(59, 130, 246, 0.5);
            --success: #10b981;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            margin: 0;
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        /* Glassmorphism Ticket Container */
        .ticket-wrapper {
            width: 100%;
            max-width: 850px;
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4), 0 0 0 1px inset rgba(255, 255, 255, 0.05);
            position: relative;
            overflow: hidden;
        }

        /* Ambient Glow Effects */
        .ticket-wrapper::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, var(--accent-glow) 0%, transparent 70%);
            opacity: 0.3;
            border-radius: 50%;
            pointer-events: none;
        }

        /* Header Layout */
        .ticket-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px dashed rgba(255, 255, 255, 0.2);
            padding-bottom: 24px;
            margin-bottom: 30px;
        }

        .logo-area h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #fff 0%, #a5b4fc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-area p {
            margin: 4px 0 0 0;
            font-size: 14px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.3);
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Ticket Meta (ID, Date) */
        .ticket-meta {
            display: flex;
            gap: 40px;
            margin-bottom: 40px;
        }

        .meta-group h3 {
            margin: 0 0 6px 0;
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .meta-group p {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: var(--text-main);
        }

        /* Section Titles */
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
        }

        /* Grid Layouts for Data */
        .data-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 24px;
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.05);
            padding: 24px;
            border-radius: 16px;
            margin-bottom: 30px;
        }

        .data-item h4 {
            margin: 0 0 8px 0;
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-item p {
            margin: 0;
            font-size: 16px;
            font-weight: 500;
            color: #fff;
        }

        /* Table Styling */
        .ticket-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 30px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .ticket-table th {
            background: rgba(255, 255, 255, 0.05);
            padding: 14px 20px;
            text-align: left;
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .ticket-table td {
            padding: 16px 20px;
            background: rgba(0, 0, 0, 0.2);
            font-size: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .ticket-table tr:last-child td {
            border-bottom: none;
        }

        /* Pricing Breakdown */
        .pricing-box {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 30px;
        }

        .pricing-grid {
            width: 300px;
            background: rgba(0, 0, 0, 0.2);
            padding: 20px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .pricing-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
            color: var(--text-muted);
        }

        .pricing-row.total {
            margin-top: 16px;
            margin-bottom: 0;
            padding-top: 16px;
            border-top: 1px dashed rgba(255, 255, 255, 0.2);
            font-size: 18px;
            font-weight: 700;
            color: #fff;
        }

        /* Footer Notes */
        .ticket-footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 12px;
            color: var(--text-muted);
            line-height: 1.6;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 16px;
            margin-top: 30px;
            justify-content: center;
        }

        .btn {
            padding: 14px 28px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background: var(--accent);
            color: #fff;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        /* Print Styles */
        @media print {
            body {
                background: #fff;
                color: #000;
                padding: 0;
            }
            .ticket-wrapper {
                box-shadow: none;
                border: 2px solid #ddd;
                background: #fff;
                color: #000;
                backdrop-filter: none;
                max-width: 100%;
            }
            .ticket-wrapper::before { display: none; }
            .logo-area h1 { background: none; -webkit-text-fill-color: #000; color: #000; }
            .logo-area p, .meta-group h3, .data-item h4, .ticket-table th, .pricing-row { color: #555; }
            .meta-group p, .data-item p, .section-title, .pricing-row.total, .ticket-table td { color: #000; }
            .data-grid, .ticket-table td, .pricing-grid { background: #f9fafb; border-color: #e5e7eb; }
            .section-title::after { background: #e5e7eb; }
            .ticket-header, .ticket-table th, .ticket-table td, .pricing-row.total, .ticket-footer { border-color: #e5e7eb; }
            .status-badge { background: #fff; border-color: #000; color: #000; }
            .action-buttons { display: none; }
        }
    </style>
</head>
<body>

    <div class="action-buttons">
        <button class="btn btn-primary" onclick="downloadPDF()">Download PDF</button>
        <button class="btn btn-secondary" onclick="window.print()">Print Ticket</button>
    </div>

    <div class="ticket-wrapper" id="ticketContent">
        <!-- HEADER -->
        <div class="ticket-header">
            <div class="logo-area">
                <h1>VOYASTRA</h1>
                <p>
                    <c:choose>
                        <c:when test="\${bookingType == 'FLIGHT'}">E-Ticket / Tax Invoice</c:when>
                        <c:when test="\${bookingType == 'HOTEL'}">Hotel Accommodation Voucher</c:when>
                        <c:otherwise>\${bookingType} E-Ticket</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div style="text-align: right;">
                <div class="status-badge">
                    <c:choose>
                        <c:when test="\${not empty booking.status}">\${booking.status}</c:when>
                        <c:when test="\${not empty booking.paymentStatus}">\${booking.paymentStatus}</c:when>
                        <c:otherwise>CONFIRMED</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- META INFORMATION -->
        <div class="ticket-meta">
            <div class="meta-group">
                <h3>Booking Reference</h3>
                <p>\${empty booking.id ? booking.bookingCode : booking.id}</p>
            </div>
            <div class="meta-group">
                <h3>Customer Name</h3>
                <p>
                    <c:choose>
                        <c:when test="\${not empty booking.customerName}">\${booking.customerName}</c:when>
                        <c:when test="\${not empty booking.guestName}">\${booking.guestName}</c:when>
                        <c:when test="\${not empty booking.passengers and fn:length(booking.passengers) > 0}">\${booking.passengers[0].name}</c:when>
                        <c:otherwise>Voyastra Guest</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="meta-group">
                <h3>Booking Date</h3>
                <p>
                    <c:choose>
                        <c:when test="\${not empty booking.createdAt}"><fmt:formatDate value="\${booking.createdAt}" pattern="MMM dd, yyyy"/></c:when>
                        <c:otherwise><fmt:formatDate value="\<%= new java.util.Date() %\>" pattern="MMM dd, yyyy"/></c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <!-- DYNAMIC CONTENT BASED ON BOOKING TYPE -->
        
        <!-- ================= FLIGHT ================= -->
        <c:if test="\${bookingType == 'FLIGHT'}">
            <div class="section-title">Flight Details</div>
            <div class="data-grid">
                <div class="data-item">
                    <h4>Description</h4>
                    <p>\${booking.details}</p>
                </div>
                <div class="data-item">
                    <h4>Baggage Allowance</h4>
                    <p>15kg Check-in, 7kg Cabin</p>
                </div>
                <div class="data-item">
                    <h4>Seat Class</h4>
                    <p>Economy</p>
                </div>
            </div>

            <div class="section-title">Fare Breakdown</div>
            <div class="pricing-box">
                <div class="pricing-grid">
                    <div class="pricing-row">
                        <span>Base Fare</span>
                        <span>₹\${baseAmount}</span>
                    </div>
                    <div class="pricing-row">
                        <span>Taxes & Fees (18%)</span>
                        <span>₹\${gstAmount}</span>
                    </div>
                    <div class="pricing-row total">
                        <span>Total Paid</span>
                        <span>₹\${booking.totalPrice}</span>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ================= HOTEL ================= -->
        <c:if test="\${bookingType == 'HOTEL'}">
            <div class="section-title">Stay Information</div>
            <div class="data-grid">
                <div class="data-item">
                    <h4>Property</h4>
                    <p>\${booking.hotel.name}<br><span style="font-size: 12px; color: var(--text-muted);">\${booking.hotel.city}</span></p>
                </div>
                <div class="data-item">
                    <h4>Check-in</h4>
                    <p>\${booking.checkIn}</p>
                </div>
                <div class="data-item">
                    <h4>Check-out</h4>
                    <p>\${booking.checkOut}</p>
                </div>
                <div class="data-item">
                    <h4>Room / Guests</h4>
                    <p>\${booking.room.type} / \${booking.guests} Guests</p>
                </div>
            </div>

            <div class="section-title">Payment Summary</div>
            <div class="pricing-box">
                <div class="pricing-grid">
                    <div class="pricing-row">
                        <span>Room Charges</span>
                        <span>$\${baseAmount}</span>
                    </div>
                    <div class="pricing-row">
                        <span>Taxes & Fees</span>
                        <span>$\${taxAmount}</span>
                    </div>
                    <div class="pricing-row total">
                        <span>Total Paid</span>
                        <span>$\${booking.totalPrice}</span>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ================= TRANSPORT (Train, Bus, Cab, Cruise, Car, Helicopter) ================= -->
        <c:if test="\${bookingType == 'TRAIN' or bookingType == 'BUS' or bookingType == 'CAB' or bookingType == 'CAR' or bookingType == 'CRUISE' or bookingType == 'HELICOPTER'}">
            <div class="section-title">Journey Details</div>
            <div class="data-grid">
                <c:choose>
                    <c:when test="\${bookingType == 'TRAIN'}">
                        <div class="data-item"><h4>Train No / Name</h4><p>\${booking.trainNumber}</p></div>
                    </c:when>
                    <c:when test="\${bookingType == 'BUS'}">
                        <div class="data-item"><h4>Bus Operator</h4><p>\${booking.busName}</p></div>
                    </c:when>
                    <c:when test="\${bookingType == 'CAB'}">
                        <div class="data-item"><h4>Cab Type</h4><p>\${booking.cabType}</p></div>
                        <div class="data-item"><h4>Route</h4><p>\${booking.sourceCity} → \${booking.destinationCity}</p></div>
                        <div class="data-item"><h4>Pickup Date</h4><p>\${booking.pickupDate}</p></div>
                        <div class="data-item"><h4>Pickup Time</h4><p>\${booking.pickupTime}</p></div>
                    </c:when>
                    <c:when test="\${bookingType == 'CAR'}">
                        <div class="data-item"><h4>Car Model</h4><p>\${booking.carModel}</p></div>
                        <div class="data-item"><h4>Pickup Date</h4><p>\${booking.pickupDate}</p></div>
                        <div class="data-item"><h4>Drop Date</h4><p>\${booking.dropDate}</p></div>
                    </c:when>
                    <c:when test="\${bookingType == 'CRUISE'}">
                        <div class="data-item"><h4>Cruise Name</h4><p>\${booking.cruiseName}</p></div>
                        <div class="data-item"><h4>Sailing Date</h4><p>\${booking.sailingDate}</p></div>
                    </c:when>
                    <c:when test="\${bookingType == 'HELICOPTER'}">
                        <div class="data-item"><h4>Service Provider</h4><p>\${booking.providerName}</p></div>
                        <div class="data-item"><h4>Route</h4><p>\${booking.source} → \${booking.destination}</p></div>
                        <div class="data-item"><h4>Date / Time</h4><p>\${booking.flightDate} / \${booking.flightTime}</p></div>
                    </c:when>
                </c:choose>
                <c:if test="\${not empty booking.fare or not empty booking.totalFare or not empty booking.totalPrice}">
                    <div class="data-item">
                        <h4>Total Fare</h4>
                        <p>
                            <c:choose>
                                <c:when test="\${not empty booking.totalFare}">\${booking.totalFare}</c:when>
                                <c:when test="\${not empty booking.totalPrice}">\${booking.totalPrice}</c:when>
                                <c:when test="\${bookingType == 'TRAIN'}">Rs. \${(booking.fare * fn:length(booking.passengers)) + 150}</c:when>
                                <c:when test="\${bookingType == 'BUS'}">Rs. \${(booking.fare * fn:length(booking.passengers)) + 50}</c:when>
                                <c:otherwise>\${booking.fare}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:if>
            </div>

            <!-- Passengers / Customer Table -->
            <div class="section-title">Passenger / Customer Information</div>
            <table class="ticket-table">
                <c:choose>
                    <c:when test="\${not empty booking.passengers and fn:length(booking.passengers) > 0}">
                        <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Name</th>
                                <th>Age</th>
                                <th>Gender</th>
                                <th>Pref / Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pax" items="\${booking.passengers}" varStatus="status">
                                <tr>
                                    <td>\${status.index + 1}</td>
                                    <td><strong>\${pax.name}</strong></td>
                                    <td>\${pax.age}</td>
                                    <td>\${pax.gender}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="\${bookingType == 'TRAIN'}">CNF / \${pax.berthPreference}</c:when>
                                            <c:when test="\${bookingType == 'BUS'}">\${pax.seatPreference}</c:when>
                                            <c:when test="\${bookingType == 'CRUISE'}">Cabin: \${pax.cabinType}</c:when>
                                            <c:when test="\${bookingType == 'HELICOPTER'}">Weight: \${pax.weight}kg</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </c:when>
                    <c:otherwise>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>\${booking.customerName}</strong></td>
                                <td>\${booking.customerEmail}</td>
                                <td>\${booking.customerPhone}</td>
                            </tr>
                        </tbody>
                    </c:otherwise>
                </c:choose>
            </table>
        </c:if>

        <!-- FOOTER -->
        <div class="ticket-footer">
            <p>This is a computer-generated document and does not require a physical signature.<br>
            Please carry a valid government-issued ID proof during your travel/stay.</p>
            <p style="margin-top: 10px; font-weight: 600;">Thank you for choosing Voyastra!</p>
        </div>
    </div>

    <script>
        function downloadPDF() {
            const element = document.getElementById('ticketContent');
            const opt = {
                margin:       0.3,
                filename:     'Voyastra-\${empty booking.id ? booking.bookingCode : booking.id}.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true, logging: false },
                jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
            };
            
            // Add a temporary white background for PDF generation if needed
            const originalBg = element.style.background;
            element.style.background = '#0f172a';
            
            html2pdf().set(opt).from(element).save().then(() => {
                element.style.background = originalBg;
            });
        }
    </script>
</body>
</html>
"""

os.makedirs(r'c:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\common', exist_ok=True)
with open(r'c:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\common\TicketTemplate.jsp', 'w', encoding='utf-8') as f:
    f.write(template_content)
print("Created TicketTemplate.jsp")
