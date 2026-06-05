<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Seat Selection - Voyastra</title>
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
        /* Airplane Body */
        .airplane {
            background: rgba(255,255,255,0.02);
            border: 2px solid rgba(255,255,255,0.1);
            border-radius: 100px 100px 40px 40px;
            padding: 60px 30px;
            max-width: 400px;
            margin: 0 auto;
            position: relative;
        }
        .seat-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            align-items: center;
        }
        .seat-group {
            display: flex;
            gap: 8px;
        }
        .seat {
            width: 36px;
            height: 42px;
            background: var(--surface-glass);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 6px 6px 4px 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            color: var(--text-main);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }
        .seat::before {
            content: '';
            position: absolute;
            bottom: 4px;
            left: 50%;
            transform: translateX(-50%);
            width: 20px;
            height: 3px;
            background: rgba(255,255,255,0.2);
            border-radius: 2px;
        }
        .seat:hover:not(.booked) {
            border-color: var(--color-primary);
            background: rgba(212,165,116,0.1);
        }
        .seat.selected {
            background: var(--color-primary);
            border-color: var(--color-primary);
            color: #000;
        }
        .seat.selected::before { background: rgba(0,0,0,0.3); }
        .seat.booked {
            background: rgba(255,255,255,0.05);
            border-color: transparent;
            color: rgba(255,255,255,0.2);
            cursor: not-allowed;
        }
        .seat.booked::after {
            content: '✕';
            position: absolute;
            font-size: 1rem;
            color: rgba(255,255,255,0.3);
        }
        /* Legends */
        .legend {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: var(--color-muted);
        }
        .legend-box {
            width: 20px;
            height: 24px;
            border-radius: 4px;
        }
        
        .row-num {
            width: 24px;
            text-align: center;
            font-size: 0.8rem;
            color: var(--color-muted);
            font-weight: 700;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            color: var(--color-muted);
        }
        .summary-row.total {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 16px;
            margin-top: 16px;
            color: var(--text-main);
            font-size: 1.2rem;
            font-weight: 800;
        }
        @media (max-width: 768px) {
            .layout-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body style="padding-top: 80px; padding-bottom: 60px; overflow-x: hidden;">

    <jsp:include page="/components/header.jsp" />
    <jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="3"/></jsp:include>

    <c:set var="isBusiness" value="${fn:toLowerCase(sessionScope.currentFlight['class']) eq 'business'}" />
    <c:set var="maxRows" value="${isBusiness ? 10 : 30}" />
    <c:set var="passengers" value="${sessionScope.currentFlight.passengers}" />

    <div class="container" style="max-width: 1100px; margin: 40px auto; padding: 0 20px;">
        <div style="display: flex; gap: 16px; align-items: center; margin-bottom: 8px;">
            <a href="javascript:history.back()" style="color: var(--color-primary); text-decoration: none;">&larr; Back to Travellers</a>
        </div>
        <h1 class="text-white font-bold" style="font-size: 2rem;">Select Seats</h1>
        <p style="color: var(--color-muted);">Choose ${passengers} seat(s) for your flight.</p>

        <c:if test="${not empty param.error}">
            <div style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 16px; border-radius: 8px; margin-top: 16px;">
                ${param.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/seat-selection" method="post" id="seatForm">
            <input type="hidden" name="selectedSeats" id="selectedSeatsInput" value="">
            
            <div class="layout-grid">
                <!-- Left Side: Seat Map -->
                <div class="card">
                    <div class="legend">
                        <div class="legend-item">
                            <div class="legend-box" style="border: 1px solid rgba(255,255,255,0.2); background: var(--surface-glass);"></div> Available
                        </div>
                        <div class="legend-item">
                            <div class="legend-box" style="background: rgba(255,255,255,0.05);"></div> Booked
                        </div>
                        <div class="legend-item">
                            <div class="legend-box" style="background: var(--color-primary);"></div> Selected
                        </div>
                        <div class="legend-item">
                            <div class="legend-box" style="border: 1px solid var(--color-primary); background: transparent;"></div> Window (+₹300)
                        </div>
                        <div class="legend-item">
                            <div class="legend-box" style="border: 1px solid #10b981; background: transparent;"></div> Extra Legroom (+₹700)
                        </div>
                    </div>

                    <div class="airplane">
                        <!-- Generate Rows -->
                        <c:forEach begin="1" end="${maxRows}" var="r">
                            <!-- Extra legroom marker -->
                            <c:if test="${r == 1 || r == 14 || r == 15}">
                                <div style="text-align: center; color: #10b981; font-size: 0.7rem; letter-spacing: 2px; margin: 20px 0 8px;">EXTRA LEGROOM</div>
                            </c:if>

                            <div class="seat-row">
                                <c:choose>
                                    <c:when test="${isBusiness}">
                                        <!-- Business: 4 seats (A B | C D) -->
                                        <div class="seat-group">
                                            <div class="seat" data-seat="${r}A" data-type="window">A</div>
                                            <div class="seat" data-seat="${r}B" data-type="aisle">B</div>
                                        </div>
                                        <div class="row-num">${r}</div>
                                        <div class="seat-group">
                                            <div class="seat" data-seat="${r}C" data-type="aisle">C</div>
                                            <div class="seat" data-seat="${r}D" data-type="window">D</div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Economy: 6 seats (A B C | D E F) -->
                                        <div class="seat-group">
                                            <div class="seat" data-seat="${r}A" data-type="window">A</div>
                                            <div class="seat" data-seat="${r}B" data-type="middle">B</div>
                                            <div class="seat" data-seat="${r}C" data-type="aisle">C</div>
                                        </div>
                                        <div class="row-num">${r}</div>
                                        <div class="seat-group">
                                            <div class="seat" data-seat="${r}D" data-type="aisle">D</div>
                                            <div class="seat" data-seat="${r}E" data-type="middle">E</div>
                                            <div class="seat" data-seat="${r}F" data-type="window">F</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Right Side: Flight Summary -->
                <div class="card" style="align-self: start; position: sticky; top: 100px;">
                    <h3 style="font-size: 1.2rem; font-weight: 800; margin-bottom: 16px; color: var(--text-main);">Booking Summary</h3>
                    
                    <div class="summary-row">
                        <span>Flight Total</span>
                        <span style="color: var(--text-main); font-weight: 600;">₹${sessionScope.currentFlight.price * passengers}</span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Seats Selected</span>
                        <span id="seatCountDisp" style="color: var(--text-main); font-weight: 600;">0 / ${passengers}</span>
                    </div>

                    <div id="seatDetailsContainer" style="margin-top: 16px; border-top: 1px dashed rgba(255,255,255,0.1); padding-top: 16px;">
                        <!-- Seat charges injected here -->
                    </div>

                    <div class="summary-row total">
                        <span>Total Additional</span>
                        <span id="extraTotalDisp">₹0</span>
                    </div>

                    <button type="submit" id="btnContinue" disabled
                            class="btn-select" style="margin-top: 24px; width: 100%; padding: 14px; font-weight: 800; font-size: 1.1rem; border-radius: 8px; background: var(--color-primary); color: #000; border: none; cursor: not-allowed; opacity: 0.5; transition: transform 0.2s, box-shadow 0.2s;">
                        Continue to Extras &rarr;
                    </button>
                </div>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const maxSeats = parseInt('${passengers}');
            let selectedSeats = [];
            
            const seats = document.querySelectorAll('.seat:not(.booked)');
            const seatCountDisp = document.getElementById('seatCountDisp');
            const seatDetailsContainer = document.getElementById('seatDetailsContainer');
            const extraTotalDisp = document.getElementById('extraTotalDisp');
            const selectedSeatsInput = document.getElementById('selectedSeatsInput');
            const btnContinue = document.getElementById('btnContinue');
            
            // Randomly pre-book some seats to make it realistic
            seats.forEach(s => {
                if (Math.random() < 0.25) {
                    s.classList.add('booked');
                } else {
                    // Add styling hints
                    let num = parseInt(s.dataset.seat);
                    let isExtraLeg = (num == 1 || num == 14 || num == 15);
                    let isWindow = s.dataset.type === 'window';
                    
                    if (isExtraLeg) s.style.borderColor = '#10b981';
                    else if (isWindow) s.style.borderColor = 'var(--color-primary)';
                }
            });

            seats.forEach(seat => {
                seat.addEventListener('click', function() {
                    if (this.classList.contains('booked')) return;
                    
                    const seatId = this.dataset.seat;
                    
                    if (this.classList.contains('selected')) {
                        // Deselect
                        this.classList.remove('selected');
                        selectedSeats = selectedSeats.filter(s => s !== seatId);
                    } else {
                        // Select
                        if (selectedSeats.length >= maxSeats) {
                            // Flash effect if trying to select too many
                            this.style.background = '#ef4444';
                            setTimeout(() => this.style.background = '', 200);
                            return;
                        }
                        this.classList.add('selected');
                        selectedSeats.push(seatId);
                    }
                    
                    updateSummary();
                });
            });

            function updateSummary() {
                seatCountDisp.textContent = selectedSeats.length + " / " + maxSeats;
                selectedSeatsInput.value = selectedSeats.join(',');
                
                let totalCharges = 0;
                seatDetailsContainer.innerHTML = '';
                
                selectedSeats.forEach(sId => {
                    let num = parseInt(sId);
                    let type = document.querySelector(`.seat[data-seat="\${sId}"]`).dataset.type;
                    
                    let charge = 0;
                    let labels = [];
                    
                    if (num == 1 || num == 14 || num == 15) {
                        charge += 700;
                        labels.push("Extra Legroom");
                    }
                    if (type === 'window') {
                        charge += 300;
                        labels.push("Window");
                    }
                    
                    totalCharges += charge;
                    
                    let rowHtml = `
                        <div class="summary-row" style="font-size:0.85rem;">
                            <span>Seat \${sId} \${labels.length ? '(' + labels.join(', ') + ')' : ''}</span>
                            <span style="color:var(--text-main);">₹\${charge}</span>
                        </div>
                    `;
                    seatDetailsContainer.insertAdjacentHTML('beforeend', rowHtml);
                });
                
                extraTotalDisp.textContent = "₹" + totalCharges;
                
                if (selectedSeats.length === maxSeats) {
                    btnContinue.disabled = false;
                    btnContinue.style.opacity = '1';
                    btnContinue.style.cursor = 'pointer';
                } else {
                    btnContinue.disabled = true;
                    btnContinue.style.opacity = '0.5';
                    btnContinue.style.cursor = 'not-allowed';
                }
            }
        });
    </script>

    <jsp:include page="/components/footer.jsp" />

    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
