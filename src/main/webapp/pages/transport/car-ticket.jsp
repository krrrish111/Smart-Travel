<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Car Rental Receipt - ${currentCarBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #fff; color: #111827; }
        .receipt-card { max-width: 600px; margin: 0 auto; border: 2px solid #8b5cf6; padding: 40px; border-radius: 12px; }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #8b5cf6; }
        .ref { text-align: right; }
        .ref-id { font-size: 18px; font-weight: bold; font-family: monospace; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-block { background: #f9fafb; padding: 15px; border-radius: 8px; border: 1px solid #e5e7eb; }
        .label { font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: bold; margin-bottom: 5px; }
        .val { font-size: 16px; font-weight: bold; }
        .total-row { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; border-top: 2px solid #f3f4f6; padding-top: 20px; margin-top: 20px; }
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #8b5cf6; color: #fff; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { padding: 0; } .receipt-card { border: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚗 Voyastra Self Drive</div>
            <div class="ref">
                <div class="label">Booking ID</div>
                <div class="ref-id">${currentCarBooking.id}</div>
            </div>
        </div>

        <div class="info-block" style="margin-bottom: 20px;">
            <div class="label">Driver Details</div>
            <div class="val">${currentCarBooking.customer.name}</div>
            <div style="font-size: 14px; color: #4b5563; margin-top: 4px;">DL Verification: <span style="color: #059669; font-weight: bold;">Document Uploaded ✓</span></div>
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Vehicle</div>
                <div class="val">${currentCarBooking.carModel}</div>
            </div>
            <div class="info-block">
                <div class="label">Location</div>
                <div class="val">${currentCarBooking.pickupCity} Hub</div>
            </div>
            <div class="info-block">
                <div class="label">Pickup Date</div>
                <div class="val">${currentCarBooking.pickupDate}</div>
            </div>
            <div class="info-block">
                <div class="label">Return Date</div>
                <div class="val">${currentCarBooking.returnDate}</div>
            </div>
        </div>

        <div class="total-row">
            <span>Total Paid (inc. Deposit)</span>
            <span style="color: #059669;">Rs. ${currentCarBooking.amount + 5500}</span>
        </div>

        <p style="text-align: center; color: #ef4444; font-size: 12px; margin-top: 40px; font-weight: bold;">
            Original Driving License MUST be presented at the time of pickup.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print Receipt / PDF</button>
</body>
</html>
