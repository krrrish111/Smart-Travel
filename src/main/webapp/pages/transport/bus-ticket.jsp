<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>E-Ticket - Voyastra</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 40px;
            color: #333;
        }
        .ticket-container {
            background: #fff;
            max-width: 800px;
            margin: 0 auto;
            padding: 50px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border-top: 10px solid #ff6b00;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px dashed #ccc;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .logo {
            font-size: 2rem;
            font-weight: 800;
            color: #ff6b00;
            margin: 0;
        }
        .ticket-title {
            font-size: 1.5rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #111;
        }
        .icon-large {
            font-size: 3rem;
            color: #ff6b00;
        }
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        .field-group {
            margin-bottom: 15px;
        }
        .label {
            font-size: 0.85rem;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
            font-weight: 600;
        }
        .value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #000;
        }
        .footer {
            text-align: center;
            border-top: 2px dashed #ccc;
            padding-top: 20px;
            font-size: 0.9rem;
            color: #888;
        }
        .actions-bar {
            text-align: center;
            margin-top: 30px;
        }
        .btn {
            display: inline-block;
            background: #ff6b00;
            color: #fff;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: bold;
            margin: 0 10px;
            cursor: pointer;
            border: none;
        }
        @media print {
            body { background: #fff; padding: 0; }
            .ticket-container { box-shadow: none; padding: 20px; border-top: none; border: 2px solid #000; }
            .actions-bar { display: none; }
        }
    </style>
</head>
<body>

    <div class="actions-bar" id="actionButtons">
        <button class="btn" onclick="downloadPDF()">Download PDF</button>
        <button class="btn" onclick="window.print()">Print Ticket</button>
        <button class="btn" style="background:#333;" onclick="window.history.back()">Back</button>
    </div>

    <div class="ticket-container" id="ticketArea">
        <div class="header">
            <div>
                <h1 class="logo">VOYASTRA</h1>
                <p style="margin:5px 0 0 0; color:#666;">Travel Smarter.</p>
            </div>
            <div style="text-align:right;">
                <div class="icon-large">🚌</div>
                <div class="ticket-title">E-Ticket</div>
                <div style="font-weight: bold; color: #555; margin-top: 5px;">Ref: ${booking.id != null ? booking.id : 'N/A'}</div>
            </div>
        </div>
        
        <c:if test="${not empty booking}">
        <div class="content-grid">
            <div class="field-group">
                <div class="label">Passenger Name</div>
                <div class="value">${booking.passengerName}</div>
            </div>
            <div class="field-group">
                <div class="label">Age</div>
                <div class="value">${booking.passengerAge}</div>
            </div>
            <div class="field-group">
                <div class="label">Gender</div>
                <div class="value">${booking.passengerGender}</div>
            </div>
            <div class="field-group">
                <div class="label">Email</div>
                <div class="value">${booking.email}</div>
            </div>
            <div class="field-group">
                <div class="label">Phone</div>
                <div class="value">${booking.phone}</div>
            </div>
            <div class="field-group">
                <div class="label">Bus Operator</div>
                <div class="value">${booking.busOperator} | ${booking.busType}</div>
            </div>
            <div class="field-group">
                <div class="label">Seat Number</div>
                <div class="value">${booking.seatNumber}</div>
            </div>
            <div class="field-group">
                <div class="label">Route</div>
                <div class="value">${booking.boardingPoint} to ${booking.dropPoint}</div>
            </div>
            <div class="field-group">
                <div class="label">Time</div>
                <div class="value">${booking.departureTime} - ${booking.arrivalTime}</div>
            </div>
            <div class="field-group">
                <div class="label">Amount</div>
                <div class="value">₹${booking.amountPaid}</div>
            </div>

        </div>
        </c:if>
        
        <div class="footer">
            <p>Thank you for choosing Voyastra! For support, visit voyastra.com/help</p>
            <p>Generated on <%= new java.util.Date() %></p>
        </div>
    </div>

    <script>
        function downloadPDF() {
            const element = document.getElementById('ticketArea');
            const opt = {
                margin:       0.5,
                filename:     'E-Ticket_${booking.id}.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2 },
                jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
            };
            document.getElementById('actionButtons').style.display = 'none';
            html2pdf().set(opt).from(element).save().then(() => {
                document.getElementById('actionButtons').style.display = 'block';
            });
        }
        
        window.onload = function() {
            if ('${autoDownload}' === 'true') {
                downloadPDF();
            }
            if ('${autoPrint}' === 'true') {
                window.print();
            }
        };
    </script>
</body>
</html>
