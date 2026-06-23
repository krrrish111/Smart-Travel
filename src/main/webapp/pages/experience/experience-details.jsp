<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
            <div style="display: flex; gap: 20px; margin-top: 15px; color: #555; font-weight: bold; align-items: center;">
                <span><i class="fas fa-clock text-primary"></i> Duration: ${not empty experience.duration ? experience.duration : '3-4 Hours'}</span>
                <span><i class="fas fa-user-friends text-primary"></i> Max Group: ${not empty experience.capacity ? experience.capacity : '10'} People</span>
                <span><i class="fas fa-language text-primary"></i> Languages: English, Hindi</span>
            </div>
            <p style="font-size: 1.1rem; line-height: 1.6; color: #555; margin-top: 20px;">
                ${not empty experience.description ? experience.description : 'Dive into an unforgettable adventure! This experience is carefully crafted to immerse you in local culture and give you hands-on exposure to activities you will cherish for a lifetime. Guided by experts, you are guaranteed a safe and thrilling journey.'}
            </p>
            
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

            <!-- Photo Gallery -->
            <h2 style="margin-top: 40px; margin-bottom: 20px;">Experience Gallery</h2>
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 30px;">
                <img src="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=400&q=75" alt="Gallery 1" style="width: 100%; height: 120px; object-fit: cover; border-radius: 12px; cursor: pointer;">
                <img src="https://images.unsplash.com/photo-1517400508447-f8dd518b86db?auto=format&fit=crop&w=400&q=75" alt="Gallery 2" style="width: 100%; height: 120px; object-fit: cover; border-radius: 12px; cursor: pointer;">
                <img src="https://images.unsplash.com/photo-1533692328991-08159ff19fca?auto=format&fit=crop&w=400&q=75" alt="Gallery 3" style="width: 100%; height: 120px; object-fit: cover; border-radius: 12px; cursor: pointer;">
            </div>

            <!-- Traveler Reviews -->
            <h2 style="margin-top: 40px; margin-bottom: 20px;">Traveler Reviews</h2>
            <div style="display: flex; flex-direction: column; gap: 20px; margin-bottom: 40px;">
                <div style="background: #F8F9FA; padding: 20px; border-radius: 15px; display: flex; gap: 15px;">
                    <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; flex-shrink: 0;">SA</div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
                            <h4 style="margin: 0;">Sarah A.</h4>
                            <span style="color: #F1C40F; font-size: 0.8rem;">★★★★★</span>
                        </div>
                        <p style="color: #666; font-size: 0.95rem; margin: 0;">"An absolute blast! The host was super knowledgeable and the entire experience was so well organized. Highly recommended."</p>
                    </div>
                </div>
                <div style="background: #F8F9FA; padding: 20px; border-radius: 15px; display: flex; gap: 15px;">
                    <div style="width: 48px; height: 48px; border-radius: 50%; background: #9b59b6; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; flex-shrink: 0;">DJ</div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
                            <h4 style="margin: 0;">David J.</h4>
                            <span style="color: #F1C40F; font-size: 0.8rem;">★★★★★</span>
                        </div>
                        <p style="color: #666; font-size: 0.95rem; margin: 0;">"Worth every penny. We got to see parts of the city we would never have found on our own. The pictures came out amazing too!"</p>
                    </div>
                </div>
            </div>
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
        const basePrice = Number('${not empty experience.price ? experience.price : 0}') || 0;
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
