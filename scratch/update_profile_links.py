import os
import re

profile_path = r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\profile.jsp"

with open(profile_path, "r", encoding="utf-8") as f:
    content = f.read()

# Pattern for Flight (f), Hotel (h), Train (t), Bus (b), Cab (c), Car (car), Cruise (cr), Helicopter (he/hl... wait, let's check)
# Let's replace the whole "div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;"" block inside the loop!

# Flight
flight_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/flight/details?id=${f.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/flight/ticket?id=${f.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/flight/ticket?id=${f.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/flight/download-ticket?id=${f.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                                <c:if test="${f.status != 'CANCELLED' && f.status != 'COMPLETED'}">"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">.*?<c:if test="\$\{f\.status != \'CANCELLED\' && f\.status != \'COMPLETED\'\}">', flight_replacement, content, flags=re.DOTALL)

# Hotel
hotel_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/hotel/details?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/hotel/ticket?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/hotel/ticket?id=${h.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/hotel/download-ticket?id=${h.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                                <c:if test="${h.status != 'CANCELLED' && h.status != 'COMPLETED'}">"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">.*?<c:if test="\$\{h\.status != \'CANCELLED\' && h\.status != \'COMPLETED\'\}">', hotel_replacement, content, flags=re.DOTALL)

# Train
train_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/train/details?id=${t.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/train/ticket?id=${t.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/train/ticket?id=${t.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/train/download-ticket?id=${t.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                            </div>"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">\s*<a href="\$\{pageContext\.request\.contextPath\}/transport/train.*?</div>', train_replacement, content, flags=re.DOTALL)

# Bus
bus_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/bus/details?id=${b.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/bus/ticket?id=${b.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/bus/ticket?id=${b.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/bus/download-ticket?id=${b.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                            </div>"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">\s*<a href="\$\{pageContext\.request\.contextPath\}/transport/bus.*?</div>', bus_replacement, content, flags=re.DOTALL)

# Cab
cab_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/cab/details?id=${c.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/cab/ticket?id=${c.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/cab/ticket?id=${c.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/cab/download-ticket?id=${c.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                            </div>"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">\s*<a href="\$\{pageContext\.request\.contextPath\}/transport/cab.*?</div>', cab_replacement, content, flags=re.DOTALL)

# Car
car_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/car/details?id=${car.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/car/ticket?id=${car.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/car/ticket?id=${car.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/car/download-ticket?id=${car.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                            </div>"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">\s*<a href="\$\{pageContext\.request\.contextPath\}/transport/car.*?</div>', car_replacement, content, flags=re.DOTALL)

# Cruise
cruise_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/cruise/details?id=${cr.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/cruise/ticket?id=${cr.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/cruise/ticket?id=${cr.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/cruise/download-ticket?id=${cr.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                            </div>"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">\s*<a href="\$\{pageContext\.request\.contextPath\}/transport/cruise.*?</div>', cruise_replacement, content, flags=re.DOTALL)

# Helicopter
heli_replacement = """                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/helicopter/details?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/helicopter/ticket?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/helicopter/ticket?id=${h.id}&print=true" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                                <a href="${pageContext.request.contextPath}/helicopter/download-ticket?id=${h.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                            </div>"""

content = re.sub(r'<div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">\s*<a href="\$\{pageContext\.request\.contextPath\}/transport/helicopter.*?</div>', heli_replacement, content, flags=re.DOTALL)

with open(profile_path, "w", encoding="utf-8") as f:
    f.write(content)

print("profile.jsp updated")
