<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Charter Flight Voucher - ${currentHeliBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #f9fafb; color: #111827; }
        .receipt-card { max-width: 700px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 10px solid #f59e0b; }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #f59e0b; }
        .ref { text-align: right; }
        .ref-id { font-size: 18px; font-weight: bold; font-family: monospace; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-block { background: #f9fafb; padding: 15px; border-radius: 8px; }
        .label { font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: bold; margin-bottom: 5px; }
        .val { font-size: 16px; font-weight: bold; }
        .manifest-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .manifest-table th, .manifest-table td { padding: 10px; text-align: left; border-bottom: 1px solid #e5e7eb; }
        .manifest-table th { background: #f9fafb; font-size: 12px; text-transform: uppercase; color: #6b7280; }
        .total-row { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; border-top: 2px solid #f3f4f6; padding-top: 20px; }
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #f59e0b; color: #111827; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚁 Voyastra Aviation</div>
            <div class="ref">
                <div class="label">Booking Ref</div>
                <div class="ref-id">${currentHeliBooking.id}</div>
            </div>
        </div>

        <div style="text-align: center; font-size: 20px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase;">
            ${currentHeliBooking.flightType} Flight Voucher
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Operator</div>
                <div class="val">${currentHeliBooking.operator}</div>
            </div>
            <div class="info-block">
                <div class="label">Route</div>
                <div class="val">${currentHeliBooking.origin} -> ${currentHeliBooking.destination}</div>
            </div>
            <div class="info-block">
                <div class="label">Date of Flight</div>
                <div class="val">${currentHeliBooking.travelDate}</div>
            </div>
            <div class="info-block">
                <div class="label">Time</div>
                <div class="val">${currentHeliBooking.travelTime}</div>
            </div>
        </div>

        <div class="label">Manifest & Weight Record</div>
        <table class="manifest-table">
            <thead>
                <tr>
                    <th>Passenger Name</th>
                    <th>Declared Weight</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="totalW" value="0" />
                <c:forEach var="p" items="${currentHeliBooking.passengers}">
                    <c:set var="totalW" value="${totalW + p.weightKg}" />
                    <tr>
                        <td>${p.name}</td>
                        <td>${p.weightKg} kg</td>
                    </tr>
                </c:forEach>
                <tr>
                    <td style="font-weight: bold; text-align: right;">Total Payload:</td>
                    <td style="font-weight: bold;">${totalW} kg</td>
                </tr>
            </tbody>
        </table>

        <div class="total-row">
            <span>Total Amount Paid</span>
            <span style="color: #059669;">Rs. ${currentHeliBooking.amount}</span>
        </div>

        <p style="text-align: center; color: #ef4444; font-size: 12px; margin-top: 40px; font-weight: bold;">
            NOTICE: Baggage strictly limited to 2kg per passenger in soft bags only. Weight variations at helipad may lead to de-boarding.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print Voucher</button>

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
