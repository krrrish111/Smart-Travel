import os
import re

# 1. Update Models
car_booking = 'src/main/java/com/voyastra/model/CarBooking.java'
with open(car_booking, 'r', encoding='utf-8') as f:
    cb_content = f.read()

cb_content = cb_content.replace('public String getCustomerName() { return "Guest"; }', 'public String getCustomerName() { return customer != null ? customer.getName() : "Guest"; }')
cb_content = cb_content.replace('public String getDeposit() { return "₹5000"; }', 'public String getDeposit() { return "₹0"; }')
cb_content = cb_content.replace('public double getTotalPaid() { return 0.0; }', 'public double getTotalPaid() { return amount; }')
if 'public String getVehicleNumber()' not in cb_content:
    cb_content = cb_content.replace('public String getCustomerNameAlias()', 'public String getVehicleNumber() { return "RENTAL-" + (id != null ? id.substring(id.length() - 4) : "0000"); }\n    public String getEmail() { return customer != null ? customer.getEmail() : "N/A"; }\n    public String getPhone() { return customer != null ? customer.getPhone() : "N/A"; }\n    public String getCustomerNameAlias()')
with open(car_booking, 'w', encoding='utf-8') as f:
    f.write(cb_content)

cruise_booking = 'src/main/java/com/voyastra/model/CruiseBooking.java'
with open(cruise_booking, 'r', encoding='utf-8') as f:
    cr_content = f.read()

cr_content = cr_content.replace('public String getPassengerName() { return "Guest"; }', 'public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }')
cr_content = cr_content.replace('public String getCabinNumber() { return "C-402"; }', 'public String getCabinNumber() { return cabinType; }')
cr_content = cr_content.replace('public String getPort() { return "Port"; }', 'public String getPort() { return departurePort; }')
cr_content = cr_content.replace('public String getDuration() { return "5 Days"; }', 'public String getDuration() { return durationDays + " Days"; }')
if 'public String getDestinationPort()' not in cr_content:
    cr_content = cr_content.replace('public String getCustomerNameAlias()', 'public String getDestinationPort() { return destination; }\n    public double getFare() { return amount; }\n    public String getEmail() { return "N/A"; }\n    public String getPhone() { return "N/A"; }\n    public String getCustomerNameAlias()')
with open(cruise_booking, 'w', encoding='utf-8') as f:
    f.write(cr_content)

heli_booking = 'src/main/java/com/voyastra/model/HelicopterBooking.java'
with open(heli_booking, 'r', encoding='utf-8') as f:
    hb_content = f.read()

hb_content = hb_content.replace('public String getPassengerName() { return "Guest"; }', 'public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }')
hb_content = hb_content.replace('public String getSeat() { return "Window"; }', 'public String getSeat() { return "Standard"; }')
hb_content = hb_content.replace('public String getDepartureTime() { return "10:30 AM"; }', 'public String getDepartureTime() { return travelTime != null ? travelTime : "10:00 AM"; }')
if 'public String getSource()' not in hb_content:
    hb_content = hb_content.replace('public String getCustomerNameAlias()', 'public String getSource() { return origin; }\n    public String getFlightNumber() { return "HELI-" + (id != null ? id.substring(id.length() - 4) : "0000"); }\n    public double getFare() { return amount; }\n    public String getEmail() { return "N/A"; }\n    public String getPhone() { return "N/A"; }\n    public String getCustomerNameAlias()')
with open(heli_booking, 'w', encoding='utf-8') as f:
    f.write(hb_content)

# 2. Update JSPs
import glob

def process_jsp(filepath, type_key):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # First, make sure <c:if test="${not empty booking}"> is applied
    if '<c:if test="${not empty booking}">' not in content:
        # Wrap everything inside <div class="content-grid"> ... </div> or <div class="details-grid">
        if 'content-grid' in content:
            content = content.replace('<div class="content-grid">', '<c:if test="${not empty booking}">\n        <div class="content-grid">')
            # Assuming content-grid closes before footer
            content = content.replace('</div>\n        \n        <div class="footer">', '</div>\n        </c:if>\n        \n        <div class="footer">')
        elif 'details-grid' in content:
            content = content.replace('<div class="details-grid">', '<c:if test="${not empty booking}">\n    <div class="details-grid">')
            content = content.replace('</div>\n    \n    <div class="actions">', '</div>\n    </c:if>\n    \n    <div class="actions">')
            
    # Add Email and Phone if not present
    if 'Email' not in content:
        email_phone = f"""            <div class="{"detail-item" if "confirmation" in filepath else "field-group"}">
                <div class="{"detail-label" if "confirmation" in filepath else "label"}">Email</div>
                <div class="{"detail-value" if "confirmation" in filepath else "value"}">${{booking.email}}</div>
            </div>
            <div class="{"detail-item" if "confirmation" in filepath else "field-group"}">
                <div class="{"detail-label" if "confirmation" in filepath else "label"}">Phone</div>
                <div class="{"detail-value" if "confirmation" in filepath else "value"}">${{booking.phone}}</div>
            </div>
"""
        if 'details-grid' in content:
            content = content.replace('<div class="details-grid">', '<div class="details-grid">\n' + email_phone)
        elif 'content-grid' in content:
            content = content.replace('<div class="content-grid">', '<div class="content-grid">\n' + email_phone)
            
    # Ensure taglib is there for c:if
    if '<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>' not in content:
        content = content.replace('<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>', '<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>\n<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

process_jsp('src/main/webapp/pages/transport/car-confirmation.jsp', 'car')
process_jsp('src/main/webapp/pages/transport/car-ticket.jsp', 'car')
process_jsp('src/main/webapp/pages/transport/cruise-confirmation.jsp', 'cruise')
process_jsp('src/main/webapp/pages/transport/cruise-ticket.jsp', 'cruise')
process_jsp('src/main/webapp/pages/transport/helicopter-confirmation.jsp', 'helicopter')
process_jsp('src/main/webapp/pages/transport/helicopter-ticket.jsp', 'helicopter')

print("Fixed JSPs and Models!")
