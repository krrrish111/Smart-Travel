<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voyastra Ticket - ${booking.bookingCode}</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; color: #1f2937; }
        .ticket-container { max-width: 800px; margin: 2rem auto; }
        .ticket {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }
        .ticket-header { background: #111827; color: white; padding: 1.5rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .ticket-body { padding: 2rem; }
        .ticket-footer { background: #f9fafb; padding: 1.5rem 2rem; border-top: 1px dashed #d1d5db; display: flex; justify-content: space-between; align-items: center; }
        
        .divider { border-top: 1px dashed #d1d5db; margin: 1.5rem 0; }
        
        @media print {
            body { background: white; }
            .ticket-container { margin: 0; max-width: 100%; width: 100%; }
            .ticket { box-shadow: none; border: 1px solid #000; }
            .no-print { display: none !important; }
            .ticket-header { background: #000 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
        }
    </style>
</head>
<body>

<div class="ticket-container">
    <!-- Print Actions -->
    <div class="flex justify-end gap-4 mb-4 no-print">
        <a href="${pageContext.request.contextPath}/my-journey" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 font-medium transition-colors">
            <i class="fas fa-arrow-left mr-2"></i> Back
        </a>
        <button onclick="window.print()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium transition-colors shadow-md">
            <i class="fas fa-print mr-2"></i> Download / Print
        </button>
    </div>

    <div class="ticket">
        <!-- Header -->
        <div class="ticket-header">
            <div>
                <h1 class="text-2xl font-bold tracking-wider flex items-center gap-2">
                    <i class="fas fa-plane-departure"></i> VOYASTRA
                </h1>
                <p class="text-gray-400 text-sm mt-1">E-Ticket / Booking Confirmation</p>
            </div>
            <div class="text-right">
                <div class="text-sm text-gray-400">PNR / Booking ID</div>
                <div class="text-xl font-bold text-white tracking-widest">${booking.bookingCode != null ? booking.bookingCode : 'PENDING'}</div>
            </div>
        </div>

        <!-- Body -->
        <div class="ticket-body">
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Left Details -->
                <div class="md:col-span-2 space-y-6">
                    <div>
                        <h2 class="text-lg font-bold text-gray-800 border-b pb-2 mb-3">Passenger Information</h2>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Lead Passenger</div>
                                <div class="font-medium text-gray-900">${booking.customerName != null ? booking.customerName : 'N/A'}</div>
                            </div>
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Contact</div>
                                <div class="font-medium text-gray-900">${booking.customerPhone != null ? booking.customerPhone : 'N/A'}</div>
                                <div class="text-sm text-gray-600">${booking.customerEmail != null ? booking.customerEmail : 'N/A'}</div>
                            </div>
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Total Travelers</div>
                                <div class="font-medium text-gray-900">${booking.numAdults} Adult(s), ${booking.numChildren} Child(ren)</div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h2 class="text-lg font-bold text-gray-800 border-b pb-2 mb-3">Trip Details</h2>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Trip / Package</div>
                                <div class="font-medium text-gray-900">${booking.planTitle != null ? booking.planTitle : 'Custom Booking'}</div>
                            </div>
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Destination</div>
                                <div class="font-medium text-gray-900">${booking.pickupCity != null ? booking.pickupCity : 'N/A'}</div>
                            </div>
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Travel Date</div>
                                <div class="font-medium text-gray-900">${booking.travelDate != null ? booking.travelDate : 'Not Specified'}</div>
                            </div>
                            <div>
                                <div class="text-xs text-gray-500 uppercase tracking-wide">Booking Status</div>
                                <div class="font-bold text-green-600 uppercase">${booking.status != null ? booking.status : 'CONFIRMED'}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right QR & Amount -->
                <div class="flex flex-col items-center justify-center border-l md:pl-6">
                    <div class="mb-4 text-center">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=VOYASTRA-${booking.bookingCode}" alt="QR Code" class="w-32 h-32 mx-auto border p-1 rounded" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                        <div class="text-xs text-gray-500 mt-2">Scan for details</div>
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <!-- Payment Summary -->
            <div>
                <h2 class="text-lg font-bold text-gray-800 mb-4">Payment Summary</h2>
                <div class="bg-gray-50 p-4 rounded-lg border">
                    <div class="flex justify-between mb-2">
                        <span class="text-gray-600">Base Fare</span>
                        <span class="font-medium">₹<fmt:formatNumber value="${booking.totalPrice * 0.82}" type="number" maxFractionDigits="2"/></span>
                    </div>
                    <div class="flex justify-between mb-2">
                        <span class="text-gray-600">Taxes & GST (18%)</span>
                        <span class="font-medium">₹<fmt:formatNumber value="${booking.totalPrice * 0.18}" type="number" maxFractionDigits="2"/></span>
                    </div>
                    <div class="divider !my-2"></div>
                    <div class="flex justify-between items-center">
                        <span class="font-bold text-gray-800">Total Paid</span>
                        <span class="text-xl font-bold text-blue-600">₹<fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="2"/></span>
                    </div>
                    <div class="mt-4 flex justify-between items-center text-sm">
                        <div>
                            <span class="text-gray-500">Transaction ID:</span> 
                            <span class="font-mono text-gray-800">${booking.transactionId != null ? booking.transactionId : 'N/A'}</span>
                        </div>
                        <div class="font-bold text-green-600">
                            <i class="fas fa-check-circle"></i> ${booking.paymentStatus != null ? booking.paymentStatus : 'SUCCESS'}
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Footer -->
        <div class="ticket-footer">
            <div class="text-sm text-gray-500">
                <i class="fas fa-headset mr-1"></i> Support: support@voyastra.com | +91 1800 123 4567
            </div>
            <div class="text-sm font-medium text-gray-500">
                Generated: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMM yyyy HH:mm" />
            </div>
        </div>
    </div>
    
    <div class="text-center text-xs text-gray-400 mt-4 no-print">
        Please carry a valid government-issued photo ID during travel.
    </div>
</div>

</body>
</html>
