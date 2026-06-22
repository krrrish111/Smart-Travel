<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Traveller Details - Voyastra</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        .layout-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            margin-top: 24px;
        }
        .card {
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--color-border);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 24px;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .form-group label {
            font-size: 0.85rem;
            color: var(--color-muted);
            font-weight: 600;
        }
        .form-group input, .form-group select {
            background: rgba(0,0,0,0.2);
            border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-main);
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.95rem;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--color-primary);
        }
        .section-title {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        @media (max-width: 768px) {
            .layout-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body style="padding-top: 80px; padding-bottom: 60px; overflow-x: hidden;">

    <jsp:include page="/components/header.jsp" />
    <jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="2"/></jsp:include>

    <div class="container" style="max-width: 1100px; margin: 40px auto; padding: 0 20px;">
        <div style="display: flex; gap: 16px; align-items: center; margin-bottom: 8px;">
            <a href="javascript:history.back()" style="color: var(--color-primary); text-decoration: none;">&larr; Back to Flight Details</a>
        </div>
        <h1 class="text-white font-bold" style="font-size: 2rem;">Traveller Details</h1>
        <p style="color: var(--color-muted);">Enter details for all passengers as they appear on their government ID.</p>

        <c:if test="${not empty error}">
            <div style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 16px; border-radius: 8px; margin-top: 16px;">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/travellers" method="post" id="travellerForm">
            <div class="layout-grid">
                <!-- Left Side: Forms -->
                <div>
                    <!-- Contact Details -->
                    <div class="card">
                        <div class="section-title">Contact Details</div>
                        <p style="font-size: 0.85rem; color: var(--color-muted); margin-bottom: 16px;">Your ticket and flight updates will be sent here.</p>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="contactEmail" value="${sessionScope.email}" required>
                            </div>
                            <div class="form-group">
                                <label>Phone Number</label>
                                <input type="tel" name="contactPhone" placeholder="+91 XXXXX XXXXX" required>
                            </div>
                        </div>
                    </div>

                    <!-- Passenger Details -->
                    <div class="card">
                        <div class="section-title">Passenger Details</div>
                        
                        <c:forEach begin="1" end="${sessionScope.currentFlight.passengers}" varStatus="loop">
                            <div style="background: rgba(0,0,0,0.15); padding: 20px; border-radius: 12px; margin-bottom: 24px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: var(--color-primary); font-weight: 700; margin-bottom: 16px;">Passenger ${loop.index} (Adult)</h4>
                                
                                <div class="form-row">
                                    <div class="form-group" style="flex: 0.5;">
                                        <label>Title</label>
                                        <select name="title_${loop.index}" required>
                                            <option value="Mr">Mr</option>
                                            <option value="Mrs">Mrs</option>
                                            <option value="Ms">Ms</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>First Name</label>
                                        <input type="text" name="firstName_${loop.index}" placeholder="First Name" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Last Name</label>
                                        <input type="text" name="lastName_${loop.index}" placeholder="Last Name" required>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Gender</label>
                                        <select name="gender_${loop.index}" required>
                                            <option value="Male">Male</option>
                                            <option value="Female">Female</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Date of Birth</label>
                                        <input type="date" name="dob_${loop.index}" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Nationality</label>
                                        <select name="nationality_${loop.index}" required>
                                            <option value="Indian">Indian</option>
                                            <option value="American">American</option>
                                            <option value="British">British</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Passport Number (Optional)</label>
                                        <input type="text" name="passport_${loop.index}" placeholder="For international travel">
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- GST Details -->
                    <div class="card">
                        <div class="section-title">GST Details (Optional)</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>GST Number</label>
                                <input type="text" name="gstNumber" placeholder="Enter GST Number for business travel">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Side: Flight Summary -->
                <div class="card" style="align-self: start; position: sticky; top: 100px;">
                    <h3 style="font-size: 1.2rem; font-weight: 800; margin-bottom: 16px; color: var(--text-main);">Flight Summary</h3>
                    
                    <div style="display: flex; gap: 12px; margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 16px;">
                        <div style="font-size: 2rem;">✈️</div>
                        <div>
                            <div style="font-weight: 800;">${sessionScope.currentFlight.from} &rarr; ${sessionScope.currentFlight.to}</div>
                            <div style="color: var(--color-muted); font-size: 0.85rem;">${sessionScope.currentFlight.date} | ${sessionScope.currentFlight.name}</div>
                        </div>
                    </div>
                    
                    <div style="display: flex; justify-content: space-between; font-weight: 800; font-size: 1.2rem;">
                        <span>Total Pay</span>
                        <span style="color: var(--color-primary);">₹<c:out value="${param.totalPrice != null ? param.totalPrice : sessionScope.currentFlight.price}" /></span>
                    </div>

                    <button type="submit" class="btn-select" style="margin-top: 24px; width: 100%; padding: 14px; font-weight: 800; font-size: 1.1rem; border-radius: 8px; background: var(--color-primary); color: #000; border: none; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;"
                            onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(212,165,116,0.3)';"
                            onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
                        Continue to Seat Selection &rarr;
                    </button>
                </div>
            </div>
        </form>
    </div>

    <jsp:include page="/components/footer.jsp" />

    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
