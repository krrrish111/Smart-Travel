import os

base_dir = "c:/Users/Dell/Desktop/antigravity/src/main/java/com/voyastra/"
servlets_dir = base_dir + "servlet/transport/"
webapp_dir = "c:/Users/Dell/Desktop/antigravity/src/main/webapp/pages/transport/"

# TrainPaymentServlet.java
train_payment_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.TrainBookingDAO;
import com.voyastra.model.TrainBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/train/payment-callback")
public class TrainPaymentServlet extends HttpServlet {
    private TrainBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new TrainBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!RazorpayConfig.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            System.err.println("Razorpay signature verification failed!");
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Payment%20Verification%20Failed");
            return;
        }

        TrainBooking draft = (TrainBooking) request.getSession().getAttribute("currentTrainBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            // Save to database only after successful payment
            boolean saved = bookingDAO.saveDraft(draft);
            if (saved) {
                // Payment and DB save successful
                response.sendRedirect(request.getContextPath() + "/transport/train/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
"""
with open(servlets_dir + "TrainPaymentServlet.java", "w", encoding="utf-8") as f:
    f.write(train_payment_servlet_java)

# TrainConfirmationServlet.java
train_confirmation_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.model.TrainBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/train/confirmation")
public class TrainConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        TrainBooking confirmedBooking = (TrainBooking) request.getSession().getAttribute("currentTrainBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/train-confirmation.jsp").forward(request, response);
    }
}
"""
with open(servlets_dir + "TrainConfirmationServlet.java", "w", encoding="utf-8") as f:
    f.write(train_confirmation_servlet_java)


# train-payment.jsp
train_payment_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Secure Payment</h1>
            <p class="text-gray-400 mb-8">Please complete your payment to confirm the booking.</p>
            
            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-green-400">₹${(currentTrainBooking.fare * currentTrainBooking.passengers.size()) + 150}</p>
            </div>

            <button id="rzp-button1" class="btn-primary w-full py-4 rounded-lg font-bold text-xl uppercase tracking-wider">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/train/payment-callback" method="POST" style="display: none;">
                <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
                <input type="hidden" name="razorpay_order_id" id="razorpay_order_id">
                <input type="hidden" name="razorpay_signature" id="razorpay_signature">
            </form>
        </div>
    </div>
</main>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    document.getElementById('rzp-button1').onclick = function(e) {
        e.preventDefault();
        
        // Fetch order ID from our backend
        fetch('${pageContext.request.contextPath}/api/razorpay/create-order', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'amount=' + ${(currentTrainBooking.fare * currentTrainBooking.passengers.size()) + 150} + '&receipt=${currentTrainBooking.id}'
        })
        .then(response => response.json())
        .then(orderData => {
            var options = {
                "key": "rzp_test_YourKeyIdHere", // Replace if needed, but RazorpayConfig handles backend. For test frontend:
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Voyastra",
                "description": "Train Booking Payment",
                "image": "https://example.com/your_logo",
                "order_id": orderData.id,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": "${currentTrainBooking.passengers[0].name}",
                    "email": "user@example.com",
                    "contact": "9999999999"
                },
                "theme": { "color": "#00d2ff" }
            };
            var rzp1 = new Razorpay(options);
            rzp1.open();
        })
        .catch(err => {
            alert('Error initializing payment. ' + err);
        });
    }
</script>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "train-payment.jsp", "w", encoding="utf-8") as f:
    f.write(train_payment_jsp)


# train-confirmation.jsp
train_confirmation_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-white">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Booking Confirmed!</h1>
            <p class="text-gray-400">Your payment was successful and your train tickets are confirmed.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking ID</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Train Number</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.trainNumber}</p>
                </div>
            </div>

            <h3 class="text-lg font-bold text-white mb-4">Passengers</h3>
            <div class="space-y-3 mb-6 border-b border-gray-700 pb-6">
                <c:forEach var="pax" items="${booking.passengers}">
                    <div class="flex justify-between items-center bg-gray-800 p-3 rounded">
                        <div>
                            <p class="text-white font-bold">${pax.name}</p>
                            <p class="text-xs text-gray-400">${pax.age} yrs, ${pax.gender}</p>
                        </div>
                        <span class="bg-green-500 bg-opacity-20 text-green-400 px-3 py-1 rounded text-sm font-bold">
                            CNF / ${pax.berthPreference}
                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="flex justify-center gap-4">
                <a href="${pageContext.request.contextPath}/pages/transport/train-ticket.jsp" target="_blank" class="px-6 py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-lg font-bold flex items-center gap-2 transition">
                    <span>📄</span> Download Ticket (PDF)
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="px-6 py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-bold transition">
                    Go to My Bookings
                </a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "train-confirmation.jsp", "w", encoding="utf-8") as f:
    f.write(train_confirmation_jsp)


# train-ticket.jsp (Print friendly layout for PDF generation)
train_ticket_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
"""
with open(webapp_dir + "train-ticket.jsp", "w", encoding="utf-8") as f:
    f.write(train_ticket_jsp)

print("Phase 5 files generated!")
