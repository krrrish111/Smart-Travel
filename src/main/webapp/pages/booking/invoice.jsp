<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tax Invoice - ${booking.bookingCode}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f4f6f8; margin: 0; padding: 40px; color: #333; }
        .invoice-container { background: #fff; max-width: 800px; margin: 0 auto; padding: 50px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px; }
        .logo { font-size: 2rem; font-weight: 800; color: #ff6b00; margin: 0; }
        .company-details { text-align: right; font-size: 0.9rem; color: #666; }
        .invoice-title { font-size: 1.5rem; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 20px; }
        
        .bill-to { display: flex; justify-content: space-between; margin-bottom: 40px; }
        .bill-info h4 { margin: 0 0 5px 0; color: #000; font-size: 1rem; }
        .bill-info p { margin: 0; font-size: 0.9rem; color: #555; }
        
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th { background: #f8f9fa; padding: 12px; text-align: left; font-size: 0.9rem; border-bottom: 2px solid #ddd; }
        td { padding: 12px; font-size: 0.9rem; border-bottom: 1px solid #eee; }
        
        .totals { display: flex; justify-content: flex-end; }
        .totals-table { width: 300px; }
        .totals-table td { padding: 8px 12px; border: none; }
        .totals-table tr.grand-total td { font-weight: 800; font-size: 1.2rem; border-top: 2px solid #333; }
        
        .footer { margin-top: 50px; text-align: center; font-size: 0.8rem; color: #888; border-top: 1px solid #eee; padding-top: 20px; }
        
        .btn-download { display: block; width: 200px; margin: 20px auto; padding: 15px; text-align: center; background: #ff6b00; color: #fff; text-decoration: none; border-radius: 8px; font-weight: 700; cursor: pointer; border: none; }
        
        @media print {
            body { padding: 0; background: #fff; }
            .invoice-container { box-shadow: none; padding: 0; }
            .btn-download { display: none; }
        }
    </style>
</head>
<body>
    
    <button class="btn-download" onclick="downloadInvoice()">Download PDF</button>

    <div class="invoice-container" id="invoiceArea">
        <div class="header">
            <div>
                <h1 class="logo">VOYASTRA</h1>
                <div style="font-size:0.85rem; color:#666; margin-top:5px;">GSTIN: 07AADCS2582Q1Z4</div>
            </div>
            <div class="company-details">
                <strong>Voyastra Travels Pvt. Ltd.</strong><br>
                123 Horizon Avenue, Tech Park<br>
                New Delhi, DL 110001, India<br>
                support@voyastra.com | +91-800-VOYASTRA
            </div>
        </div>

        <h2 class="invoice-title">Tax Invoice</h2>

        <div class="bill-to">
            <div class="bill-info">
                <h4>Billed To:</h4>
                <p><strong>${booking.customerName}</strong></p>
                <p>${booking.customerEmail}</p>
            </div>
            <div class="bill-info" style="text-align: right;">
                <p><strong>Invoice No:</strong> INV-${booking.bookingCode}</p>
                <p><strong>Date:</strong> <fmt:formatDate value="${booking.createdAt}" pattern="MMM dd, yyyy"/></p>
                <p><strong>Payment Status:</strong> ${booking.paymentStatus}</p>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Description</th>
                    <th>SAC Code</th>
                    <th style="text-align:right;">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <strong>Flight Booking</strong><br>
                        <span style="font-size:0.8rem; color:#666;">${booking.details}</span>
                    </td>
                    <td>996411</td>
                    <td style="text-align:right;">₹${baseAmount}</td>
                </tr>
            </tbody>
        </table>

        <div class="totals">
            <table class="totals-table">
                <tr>
                    <td>Taxable Value</td>
                    <td style="text-align:right;">₹${baseAmount}</td>
                </tr>
                <tr>
                    <td>IGST (18%)</td>
                    <td style="text-align:right;">₹${gstAmount}</td>
                </tr>
                <tr class="grand-total">
                    <td>Grand Total</td>
                    <td style="text-align:right;">₹${booking.totalPrice}</td>
                </tr>
            </table>
        </div>

        <div class="footer">
            <p>This is a computer generated invoice and does not require physical signature.</p>
            <p>Thank you for choosing Voyastra for your travel needs.</p>
        </div>
    </div>

    <script>
        function downloadInvoice() {
            const element = document.getElementById('invoiceArea');
            const opt = {
                margin:       [0.5, 0.5],
                filename:     'Invoice-${booking.bookingCode}.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2 },
                jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
            };
            html2pdf().set(opt).from(element).save();
        }
    </script>
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
