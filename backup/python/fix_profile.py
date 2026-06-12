import re

filepath = r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\profile.jsp"
with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

target = """                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">dY?" No hotel bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- TRAINS -->"""

replacement = """                            <c:otherwise>
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
                                                <a href="${pageContext.request.contextPath}/hotel/details?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/hotel/ticket?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/hotel/ticket?id=${h.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/hotel/download-ticket?id=${h.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
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

                <!-- TRAINS -->"""

if target in content:
    content = content.replace(target, replacement)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    print("Success")
else:
    print("Target not found")
