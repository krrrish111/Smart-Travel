<%@ page language="java" contentType="text/html; charset=UTF-8" pageContext="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${experience.title} | Voyastra Experiences</title>
    <jsp:include page="/components/config.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Include Razorpay Checkout script -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        .exp-header {
            height: 500px;
            background: url('${experience.coverImage}') center/cover;
            position: relative;
        }
        .exp-header-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            padding: 50px 5%;
            color: white;
        }
        .container {
            display: flex;
            gap: 40px;
            padding: 50px 5%;
            max-width: 1400px;
            margin: 0 auto;
        }
        .main-content {
            flex: 2;
        }
        .booking-sidebar {
            flex: 1;
            position: sticky;
            top: 100px;
            height: max-content;
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        .score-row {
            display: flex;
            gap: 20px;
            margin: 30px 0;
        }
        .score-box {
            background: #F8F9FA;
            padding: 15px 25px;
            border-radius: 15px;
            text-align: center;
            flex: 1;
        }
        .score-box h4 { margin-bottom: 5px; color: var(--primary); font-size: 1.5rem; }
        .guide-section {
            background: #F8F9FA;
            padding: 25px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            gap: 20px;
            margin-top: 40px;
        }
        .guide-avatar {
            width: 80px; height: 80px; border-radius: 50%; background: #ddd;
            display: flex; align-items: center; justify-content: center; font-size: 30px;
        }
        .book-btn {
            width: 100%;
            background: var(--primary);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
        }
        .input-group {
            margin-bottom: 20px;
        }
        .input-group label { display: block; margin-bottom: 8px; font-weight: bold; }
        .input-group input {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp" />

    <div class="exp-header">
        <div class="exp-header-content">
            <span style="background: var(--primary); padding: 5px 15px; border-radius: 20px; font-weight: bold;">${experience.category}</span>
            <h1 style="font-size: 3rem; margin: 15px 0;">${experience.title}</h1>
            <p style="font-size: 1.2rem;"><i class="fas fa-map-marker-alt"></i> ${experience.location} • <i class="fas fa-star" style="color: #F1C40F;"></i> ${experience.rating} (${experience.reviewCount} reviews)</p>
        </div>
    </div>

    <div class="container">
        <div class="main-content">
            <h2>About this Experience</h2>
            <p style="font-size: 1.1rem; line-height: 1.6; color: #555; margin-top: 20px;">${experience.description}</p>
            
            <div class="score-row">
                <div class="score-box">
                    <h4>${experience.funScore}</h4>
                    <span>Fun Score</span>
                </div>
                <div class="score-box">
                    <h4>${experience.adventureScore}</h4>
                    <span>Adventure</span>
                </div>
                <div class="score-box">
                    <h4>${experience.authenticityScore}</h4>
                    <span>Authenticity</span>
                </div>
            </div>

            <c:if test="${guide != null}">
                <div class="guide-section">
                    <div class="guide-avatar">👤</div>
                    <div>
                        <h3>Hosted by ${guide.userId} <i class="fas fa-check-circle" style="color: #2ecc71;" title="Verified Local"></i></h3>
                        <p style="color: #666; margin: 5px 0;">${guide.bio}</p>
                        <p style="font-size: 0.9rem;"><strong>Languages:</strong> ${guide.languages}</p>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="booking-sidebar">
            <h2 style="font-size: 2rem; margin-bottom: 20px;">₹<span id="priceDisplay">${experience.price}</span> <small style="font-size: 1rem; color: #666;">/ person</small></h2>
            
            <form id="bookingForm" action="${pageContext.request.contextPath}/api/experience/book" method="POST">
                <input type="hidden" name="experienceId" value="${experience.id}">
                <input type="hidden" name="totalAmount" id="totalAmountInput" value="${experience.price}">
                <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
                
                <div class="input-group">
                    <label>Date</label>
                    <input type="date" name="date" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                <div class="input-group">
                    <label>Travelers</label>
                    <input type="number" name="travelers" id="travelersInput" min="1" max="${experience.capacity}" value="1" required>
                </div>
                
                <div style="border-top: 1px solid #ddd; margin-top: 20px; padding-top: 20px; display: flex; justify-content: space-between; font-weight: bold; font-size: 1.2rem;">
                    <span>Total</span>
                    <span>₹<span id="totalDisplay">${experience.price}</span></span>
                </div>
                
                <button type="button" id="rzp-button1" class="book-btn">Book Experience</button>
            </form>
        </div>
    </div>

    <jsp:include page="/components/footer.jsp" />

    <script>
        const basePrice = ${experience.price};
        const travelersInput = document.getElementById('travelersInput');
        const totalDisplay = document.getElementById('totalDisplay');
        const totalAmountInput = document.getElementById('totalAmountInput');

        travelersInput.addEventListener('input', function() {
            const t = parseInt(this.value) || 1;
            const total = basePrice * t;
            totalDisplay.textContent = total;
            totalAmountInput.value = total;
        });

        // Razorpay Mock Integration
        document.getElementById('rzp-button1').onclick = function(e){
            // In a real app, this would call Razorpay
            // We simulate a successful payment here
            const fakePaymentId = 'pay_' + Math.random().toString(36).substring(7);
            document.getElementById('razorpay_payment_id').value = fakePaymentId;
            document.getElementById('bookingForm').submit();
            e.preventDefault();
        }
    </script>
</body>
</html>
