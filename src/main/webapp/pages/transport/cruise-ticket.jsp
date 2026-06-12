<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cruise E-Ticket - ${booking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #f9fafb; color: #111827; }
        .receipt-card { max-width: 700px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 10px solid #06b6d4; }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #06b6d4; }
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
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #06b6d4; color: #fff; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚢 Voyastra Cruises</div>
            <div class="ref">
                <div class="label">Booking Ref</div>
                <div class="ref-id">${booking.id}</div>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Vessel</div>
                <div class="val">${booking.shipName} (${booking.cruiseLine})</div>
            </div>
            <div class="info-block">
                <div class="label">Cabin Details</div>
                <div class="val">${booking.cabinType}</div>
            </div>
            <div class="info-block">
                <div class="label">Embarkation Port</div>
                <div class="val">${booking.departurePort}</div>
            </div>
            <div class="info-block">
                <div class="label">Sailing Date</div>
                <div class="val">${booking.cruiseDate} (${booking.durationDays} Nights)</div>
            </div>
        </div>

        <div class="label">Passenger Manifest</div>
        <table class="manifest-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Age</th>
                    <th>Gender</th>
                    <th>Passport/ID</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${booking.passengers}">
                    <tr>
                        <td>${p.name}</td>
                        <td>${p.age}</td>
                        <td>${p.gender}</td>
                        <td>${p.passportNumber}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="total-row">
            <span>Total Paid Amount</span>
            <span style="color: #059669;">Rs. ${booking.amount + (booking.paxCount * 2500)}</span>
        </div>

        <p style="text-align: center; color: #ef4444; font-size: 12px; margin-top: 40px; font-weight: bold;">
            Gates close 2 hours prior to departure. Original passports are mandatory for international waters.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print E-Ticket</button>

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
