import os

# 1. Update FlightBookingDAO.java
dao_file = 'src/main/java/com/voyastra/dao/FlightBookingDAO.java'
with open(dao_file, 'r', encoding='utf-8') as f:
    dao = f.read()

dao = dao.replace('SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, b.type, b.details, b.booking_code, b.travel_date',
                  'SELECT b.id, b.user_id, b.plan_id, b.total_price, b.status, b.created_at, b.type, b.details, b.booking_code, b.travel_date, b.customer_name, b.customer_email, b.customer_phone')

if 'setCustomerName' not in dao:
    insert_str = """                    fb.setBookingCode(rs.getString("booking_code"));
                    fb.setTravelDate(rs.getString("travel_date"));
                    fb.setCustomerName(rs.getString("customer_name"));
                    fb.setCustomerEmail(rs.getString("customer_email"));
                    fb.setCustomerPhone(rs.getString("customer_phone"));"""
    dao = dao.replace('                    fb.setBookingCode(rs.getString("booking_code"));\n                    fb.setTravelDate(rs.getString("travel_date"));', insert_str)

with open(dao_file, 'w', encoding='utf-8') as f:
    f.write(dao)

# 2. Update FlightBooking.java
model_file = 'src/main/java/com/voyastra/model/FlightBooking.java'
with open(model_file, 'r', encoding='utf-8') as f:
    model = f.read()

model = model.replace('public String getPassengerName() { return "John Doe"; }', 'public String getPassengerName() { return getCustomerName() != null ? getCustomerName() : "Guest"; }')
if 'public String getEmail()' not in model:
    model = model.replace('public String getPassengerName()', 'public String getEmail() { return getCustomerEmail() != null ? getCustomerEmail() : "N/A"; }\n    public String getPhone() { return getCustomerPhone() != null ? getCustomerPhone() : "N/A"; }\n    public String getOrigin() { return departureCity != null ? departureCity : "N/A"; }\n    public String getDestination() { return arrivalCity != null ? arrivalCity : "N/A"; }\n    public String getPassengerName()')

with open(model_file, 'w', encoding='utf-8') as f:
    f.write(model)

# 3. Update JSPs
def process_jsp(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # First, make sure <c:if test="${not empty booking}"> is applied
    if '<c:if test="${not empty booking}">' not in content:
        if 'content-grid' in content:
            content = content.replace('<div class="content-grid">', '<c:if test="${not empty booking}">\n        <div class="content-grid">')
            content = content.replace('</div>\n        \n        <div class="footer">', '</div>\n        </c:if>\n        \n        <div class="footer">')
        elif 'details-grid' in content:
            content = content.replace('<div class="details-grid">', '<c:if test="${not empty booking}">\n    <div class="details-grid">')
            content = content.replace('</div>\n    \n    <div class="actions">', '</div>\n    </c:if>\n    \n    <div class="actions">')
            
    # Add Email and Phone if not present
    if 'Email' not in content:
        email_phone = f"""            <div class="{"detail-item" if "details" in filepath else "field-group"}">
                <div class="{"detail-label" if "details" in filepath else "label"}">Email</div>
                <div class="{"detail-value" if "details" in filepath else "value"}">${{booking.email}}</div>
            </div>
            <div class="{"detail-item" if "details" in filepath else "field-group"}">
                <div class="{"detail-label" if "details" in filepath else "label"}">Phone</div>
                <div class="{"detail-value" if "details" in filepath else "value"}">${{booking.phone}}</div>
            </div>
"""
        if 'details-grid' in content:
            content = content.replace('<div class="details-grid">\n        <div class="detail-item">\n            <div class="detail-label">Passenger Name</div>\n            <div class="detail-value">${booking.passengerName}</div>\n        </div>', 
                                      '<div class="details-grid">\n        <div class="detail-item">\n            <div class="detail-label">Passenger Name</div>\n            <div class="detail-value">${booking.passengerName}</div>\n        </div>\n' + email_phone)
        elif 'content-grid' in content:
            content = content.replace('<div class="content-grid">\n            <div class="field-group">\n                <div class="label">Passenger Name</div>\n                <div class="value">${booking.passengerName}</div>\n            </div>', 
                                      '<div class="content-grid">\n            <div class="field-group">\n                <div class="label">Passenger Name</div>\n                <div class="value">${booking.passengerName}</div>\n            </div>\n' + email_phone)
            
    # Ensure taglib is there for c:if
    if '<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>' not in content:
        content = content.replace('<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>', '<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>\n<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

process_jsp('src/main/webapp/pages/booking/flight-details.jsp')
process_jsp('src/main/webapp/pages/flight-ticket.jsp')

print("Fixed JSPs, DAO, and Model for Flight!")
