import re

with open('src/main/webapp/pages/profile.jsp', 'r', encoding='utf-8') as f:
    content = f.read()

replacement = """            <!-- Secondary Filter: Type -->
            <div style="display: flex; gap: 15px; margin-bottom: 30px; border-bottom: 1px solid var(--color-border); padding-bottom: 15px; overflow-x: auto; white-space: nowrap;">
                <button class="type-tab active" onclick="showBookingType('all')" id="tab-type-all" style="background:none; border:none; color:var(--color-primary); font-weight:bold; font-size:1.1rem; cursor:pointer;">All Bookings</button>
                <button class="type-tab" onclick="showBookingType('flights')" id="tab-type-flights" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Flights</button>
                <button class="type-tab" onclick="showBookingType('hotels')" id="tab-type-hotels" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Hotels</button>
                <button class="type-tab" onclick="showBookingType('trains')" id="tab-type-trains" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Trains</button>
                <button class="type-tab" onclick="showBookingType('buses')" id="tab-type-buses" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Buses</button>
                <button class="type-tab" onclick="showBookingType('cabs')" id="tab-type-cabs" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Cabs</button>
                <button class="type-tab" onclick="showBookingType('cars')" id="tab-type-cars" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Cars</button>
                <button class="type-tab" onclick="showBookingType('cruises')" id="tab-type-cruises" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Cruises</button>
                <button class="type-tab" onclick="showBookingType('helicopters')" id="tab-type-helicopters" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Helicopters</button>
            </div>

            <div id="all-bookings-container">
                <!-- FLIGHTS -->
                <div class="booking-category" id="cat-flights">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">✈ Flights</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty flightBookings}">
                                <c:forEach var="f" items="${flightBookings}">
                                    <div class="booking-item booking-card-status" data-status="${f.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: white; overflow: hidden; padding: 5px;">
                                                <img src="${f.airlineLogo}" alt="${f.airlineName}" style="width: 100%; height: 100%; object-fit: contain;">
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${f.airlineName} <span style="color:var(--text-secondary); font-weight: normal;">| ${f.flightNumber}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>PNR:</strong> ${f.pnr} &nbsp;|&nbsp; <strong>Date:</strong> ${f.travelDate} &nbsp;|&nbsp; <strong>Travellers:</strong> ${f.travellerCount} &nbsp;|&nbsp; <strong>Class:</strong> ${f.seatClass}
                                                </div>
                                                <div style="font-weight: 600; margin-top: 5px;">
                                                    ${f.departureCity} <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg> ${f.arrivalCity}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${f.status.toLowerCase() == 'confirmed' ? 'completed' : f.status.toLowerCase()}" style="margin-right:10px;">${f.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${f.totalPrice}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/ticket?pnr=${f.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/ticket-download?pnr=${f.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                                <button class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;" onclick="window.print()">Print Ticket</button>
                                                <c:if test="${f.status != 'CANCELLED' && f.status != 'COMPLETED'}">
                                                    <button type="button" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal('${f.id}', '${f.totalPrice}', 'flight')">Cancel</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">✈ No flight bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- HOTELS -->
                <div class="booking-category" id="cat-hotels" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🏨 Hotels</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty hotelBookings}">
                                <c:forEach var="h" items="${hotelBookings}">
                                    <div class="booking-item booking-card-status" data-status="${h.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="width: 80px; height: 80px; border-radius: 12px; overflow: hidden; padding:0;">
                                                <img src="${not empty h.hotel.imageUrl ? h.hotel.imageUrl : 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200&q=80'}" alt="${h.hotel.name}" style="width: 100%; height: 100%; object-fit: cover;">
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${h.hotel.name}</div>
                                                <div style="color: var(--color-primary); font-size: 0.95rem; margin-top: 2px;">${h.room.type}</div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Check-In:</strong> ${h.checkIn} &nbsp;|&nbsp; <strong>Check-Out:</strong> ${h.checkOut} &nbsp;|&nbsp; <strong>Guests:</strong> ${h.guests}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${h.status.toLowerCase() == 'confirmed' ? 'completed' : h.status.toLowerCase()}" style="margin-right:10px;">${h.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${h.totalPrice}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/hotel-confirmation?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Voucher</a>
                                                <a href="${pageContext.request.contextPath}/hotel-voucher?id=${h.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Voucher</a>
                                                <c:if test="${h.status != 'CANCELLED' && h.status != 'COMPLETED'}">
                                                    <button type="button" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal('${h.id}', '${h.totalPrice}', 'hotel')">Cancel</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🏨 No hotel bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- TRAINS -->
                <div class="booking-category" id="cat-trains" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚆 Trains</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty trainBookings}">
                                <c:forEach var="t" items="${trainBookings}">
                                    <div class="booking-item booking-card-status" data-status="${t.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚆
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${t.trainName} <span style="color:var(--text-secondary); font-weight: normal;">| ${t.trainNumber}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>PNR:</strong> ${t.pnr} &nbsp;|&nbsp; <strong>Date:</strong> ${t.travelDate} &nbsp;|&nbsp; <strong>Class:</strong> ${t.travelClass}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${t.status.toLowerCase() == 'confirmed' ? 'completed' : t.status.toLowerCase()}" style="margin-right:10px;">${t.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${t.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/train-confirmation?bookingRef=${t.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/train-ticket?bookingRef=${t.pnr}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚆 No train bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- BUSES -->
                <div class="booking-category" id="cat-buses" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚌 Buses</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty busBookings}">
                                <c:forEach var="b" items="${busBookings}">
                                    <div class="booking-item booking-card-status" data-status="${b.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚌
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${b.operator} <span style="color:var(--text-secondary); font-weight: normal;">| ${b.busType}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>PNR:</strong> ${b.pnr} &nbsp;|&nbsp; <strong>Date:</strong> ${b.travelDate}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${b.status.toLowerCase() == 'confirmed' ? 'completed' : b.status.toLowerCase()}" style="margin-right:10px;">${b.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${b.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/bus-confirmation?bookingRef=${b.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/bus-ticket?bookingRef=${b.pnr}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚌 No bus bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CABS -->
                <div class="booking-category" id="cat-cabs" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚕 Cabs</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty cabBookings}">
                                <c:forEach var="c" items="${cabBookings}">
                                    <div class="booking-item booking-card-status" data-status="${c.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚕
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${c.vehicleModel} <span style="color:var(--text-secondary); font-weight: normal;">| ${c.provider}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${c.bookingRef} &nbsp;|&nbsp; <strong>Date:</strong> ${c.pickupDate} ${c.pickupTime}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${c.status.toLowerCase() == 'confirmed' ? 'completed' : c.status.toLowerCase()}" style="margin-right:10px;">${c.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${c.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/cab-confirmation?bookingRef=${c.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/cab-ticket?bookingRef=${c.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚕 No cab bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CARS -->
                <div class="booking-category" id="cat-cars" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚖 Self Drive Cars</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty carBookings}">
                                <c:forEach var="car" items="${carBookings}">
                                    <div class="booking-item booking-card-status" data-status="${car.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚖
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${car.vehicleModel}</div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${car.bookingRef} &nbsp;|&nbsp; <strong>Duration:</strong> ${car.pickupDate} to ${car.returnDate}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${car.status.toLowerCase() == 'confirmed' ? 'completed' : car.status.toLowerCase()}" style="margin-right:10px;">${car.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${car.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/car-confirmation?bookingRef=${car.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/car-ticket?bookingRef=${car.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚖 No self-drive car bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CRUISES -->
                <div class="booking-category" id="cat-cruises" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚢 Cruises</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty cruiseBookings}">
                                <c:forEach var="cr" items="${cruiseBookings}">
                                    <div class="booking-item booking-card-status" data-status="${cr.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚢
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${cr.cruiseLine} <span style="color:var(--text-secondary); font-weight: normal;">| ${cr.shipName}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${cr.bookingRef} &nbsp;|&nbsp; <strong>Date:</strong> ${cr.cruiseDate} &nbsp;|&nbsp; <strong>Cabin:</strong> ${cr.cabinType}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${cr.status.toLowerCase() == 'confirmed' ? 'completed' : cr.status.toLowerCase()}" style="margin-right:10px;">${cr.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${cr.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/cruise-confirmation?bookingRef=${cr.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/cruise-ticket?bookingRef=${cr.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚢 No cruise bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- HELICOPTERS -->
                <div class="booking-category" id="cat-helicopters" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚁 Helicopters</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty heliBookings}">
                                <c:forEach var="h" items="${heliBookings}">
                                    <div class="booking-item booking-card-status" data-status="${h.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚁
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${h.operator} <span style="color:var(--text-secondary); font-weight: normal;">| ${h.flightClass}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${h.bookingRef} &nbsp;|&nbsp; <strong>Date:</strong> ${h.travelDate}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${h.status.toLowerCase() == 'confirmed' ? 'completed' : h.status.toLowerCase()}" style="margin-right:10px;">${h.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${h.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/helicopter-confirmation?bookingRef=${h.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/helicopter-ticket?bookingRef=${h.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚁 No helicopter bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

            <script>
                // State variables
                let currentStatusFilter = 'upcoming'; // 'upcoming', 'past', 'cancelled'
                let currentTypeFilter = 'all'; // 'all', 'flights', 'hotels', 'trains', 'buses', 'cabs', 'cars', 'cruises', 'helicopters'

                function showBookingStatus(status) {
                    currentStatusFilter = status;
                    
                    // Update Status Tabs UI
                    ['upcoming', 'past', 'cancelled'].forEach(s => {
                        let btn = document.getElementById('tab-status-' + s);
                        if(btn) {
                            btn.style.borderColor = (s === status) ? 'var(--color-primary)' : 'var(--color-border)';
                            btn.style.color = (s === status) ? 'white' : 'var(--text-secondary)';
                        }
                    });

                    applyFilters();
                }

                function showBookingType(type) {
                    currentTypeFilter = type;
                    
                    // Update Type Tabs UI
                    ['all', 'flights', 'hotels', 'trains', 'buses', 'cabs', 'cars', 'cruises', 'helicopters'].forEach(t => {
                        let btn = document.getElementById('tab-type-' + t);
                        if(btn) {
                            btn.style.color = (t === type) ? 'var(--color-primary)' : 'var(--text-secondary)';
                            btn.style.fontWeight = (t === type) ? 'bold' : '600';
                        }
                    });

                    // Show/Hide Categories based on Type Filter
                    ['flights', 'hotels', 'trains', 'buses', 'cabs', 'cars', 'cruises', 'helicopters'].forEach(cat => {
                        let el = document.getElementById('cat-' + cat);
                        if(el) {
                            if (type === 'all' || type === cat) {
                                el.style.display = 'block';
                            } else {
                                el.style.display = 'none';
                            }
                        }
                    });

                    applyFilters();
                }

                function applyFilters() {
                    // Go through every booking card and show/hide based on currentStatusFilter
                    let cards = document.querySelectorAll('.booking-card-status');
                    cards.forEach(card => {
                        let cardStatus = card.getAttribute('data-status'); // e.g. "confirmed", "cancelled", "completed"
                        
                        let showCard = false;
                        if (currentStatusFilter === 'cancelled' && cardStatus === 'cancelled') {
                            showCard = true;
                        } else if (currentStatusFilter === 'upcoming' && (cardStatus === 'confirmed' || cardStatus === 'pending')) {
                            showCard = true;
                        } else if (currentStatusFilter === 'past' && cardStatus === 'completed') {
                            showCard = true;
                        }
                        
                        card.style.display = showCard ? 'flex' : 'none';
                    });
                }
"""

start_str = "            <!-- Secondary Filter: Type -->"
end_str = "                // Initialize default view"

start_idx = content.find(start_str)
end_idx = content.find(end_str)

if start_idx != -1 and end_idx != -1:
    new_content = content[:start_idx] + replacement + content[end_idx:]
    with open('src/main/webapp/pages/profile.jsp', 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Replaced successfully.")
else:
    print(f"Could not find start or end string. Start: {start_idx}, End: {end_idx}")
