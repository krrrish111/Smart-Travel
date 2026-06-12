<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cab Booking Receipt - ${booking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #f9fafb; color: #111827; }
        .receipt-card { max-width: 600px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #eab308; }
        .ref { text-align: right; }
        .ref-id { font-size: 18px; font-weight: bold; font-family: monospace; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-block { background: #f9fafb; padding: 15px; border-radius: 8px; }
        .label { font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: bold; margin-bottom: 5px; }
        .val { font-size: 16px; font-weight: bold; }
        .total-row { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; border-top: 2px solid #f3f4f6; padding-top: 20px; margin-top: 20px; }
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #eab308; color: #111827; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚕 Voyastra Cabs</div>
            <div class="ref">
                <div class="label">Booking Ref</div>
                <div class="ref-id">${booking.id}</div>
            </div>
        </div>

        <div class="info-block" style="margin-bottom: 20px;">
            <div class="label">Rider</div>
            <div class="val">${booking.passenger.name} (${booking.passenger.phone})</div>
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Pickup</div>
                <div class="val">${booking.pickup}</div>
            </div>
            <div class="info-block">
                <div class="label">Drop / Package</div>
                <div class="val">${booking.dropoff}</div>
            </div>
            <div class="info-block">
                <div class="label">Date & Time</div>
                <div class="val">${booking.date} at ${booking.time}</div>
            </div>
            <div class="info-block">
                <div class="label">Vehicle</div>
                <div class="val">${booking.provider} ${booking.vehicleType}</div>
            </div>
        </div>

        <div class="total-row">
            <span>Total Paid Amount</span>
            <span style="color: #059669;">Rs. ${booking.amount + 50}</span>
        </div>

        <p style="text-align: center; color: #6b7280; font-size: 12px; margin-top: 40px;">
            This is a computer generated receipt.<br>Driver contact details will be shared via SMS 30 mins prior to the pickup time.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print Receipt</button>

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
