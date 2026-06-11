<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>E-Ticket - ${currentTrainBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 20px; background: #fff; color: #333; }
        .ticket-container { max-width: 800px; margin: 0 auto; border: 2px solid #2c3e50; padding: 30px; border-radius: 8px; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: bold; color: #2980b9; }
        .pnr-box { text-align: right; }
        .pnr-label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
        .pnr-val { font-size: 20px; font-weight: bold; }
        .section-title { font-size: 16px; font-weight: bold; background: #ecf0f1; padding: 8px 12px; margin-bottom: 15px; border-radius: 4px; }
        table { w-full; border-collapse: collapse; margin-bottom: 20px; width: 100%; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
        .print-btn { display: block; margin: 30px auto; padding: 12px 24px; background: #2980b9; color: #fff; text-align: center; font-size: 16px; border: none; border-radius: 4px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { padding: 0; } .ticket-container { border: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="ticket-container">
        <div class="header">
            <div class="logo">🚆 Voyastra IRCTC</div>
            <div class="pnr-box">
                <div class="pnr-label">Booking ID</div>
                <div class="pnr-val">${currentTrainBooking.id}</div>
            </div>
        </div>

        <div class="section-title">Train Details</div>
        <table>
            <tr>
                <th>Train No</th>
                <th>Status</th>
                <th>Total Fare</th>
            </tr>
            <tr>
                <td><strong>${currentTrainBooking.trainNumber}</strong></td>
                <td><strong>${currentTrainBooking.status}</strong></td>
                <td><strong>Rs. ${(currentTrainBooking.fare * currentTrainBooking.passengers.size()) + 150}</strong></td>
            </tr>
        </table>

        <div class="section-title">Passenger Details</div>
        <table>
            <tr>
                <th>S.No</th>
                <th>Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Booking Status/Berth</th>
            </tr>
            <c:forEach var="pax" items="${currentTrainBooking.passengers}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td><strong>${pax.name}</strong></td>
                    <td>${pax.age}</td>
                    <td>${pax.gender}</td>
                    <td><strong>CNF / ${pax.berthPreference}</strong></td>
                </tr>
            </c:forEach>
        </table>

        <div style="font-size: 12px; color: #7f8c8d; margin-top: 30px; text-align: center;">
            <p>This is a computer-generated e-ticket. Please carry a valid ID proof during the journey.</p>
            <p>Thank you for choosing Voyastra!</p>
        </div>
    </div>

    <button class="print-btn" onclick="window.print()">Print Ticket / Save as PDF</button>
</body>
</html>
