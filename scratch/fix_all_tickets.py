import os
import re

def ensure_c_if(content):
    if '<c:if test="${not empty booking}">' not in content:
        if '<div class="content-grid">' in content:
            content = content.replace('<div class="content-grid">', '<c:if test="${not empty booking}">\n        <div class="content-grid">')
            content = content.replace('</div>\n        \n        <div class="footer">', '</div>\n        </c:if>\n        \n        <div class="footer">')
            content = content.replace('</div>\n        <div class="footer">', '</div>\n        </c:if>\n        <div class="footer">')
        elif '<div class="details-grid">' in content:
            content = content.replace('<div class="details-grid">', '<c:if test="${not empty booking}">\n    <div class="details-grid">')
            content = content.replace('</div>\n    \n    <div class="actions">', '</div>\n    </c:if>\n    \n    <div class="actions">')
    if '<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>' not in content:
        content = content.replace('<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>', '<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>\n<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>')
    return content

# --- CAB FIXES ---
cab_dao = 'src/main/java/com/voyastra/dao/CabBookingDAO.java'
with open(cab_dao, 'r') as f:
    dao = f.read()
dao = dao.replace('// booking.getPassengers().add(p);', 'booking.setPassenger(p);')
with open(cab_dao, 'w') as f:
    f.write(dao)

cab_model = 'src/main/java/com/voyastra/model/CabBooking.java'
with open(cab_model, 'r') as f:
    model = f.read()
model = model.replace('public String getPassengerName() { return "Guest"; }', 'public String getPassengerName() { return passenger != null ? passenger.getName() : "Guest"; }')
model = model.replace('public String getDriverName() { return "Ramesh Kumar"; }', '')
model = model.replace('public String getVehicleNumber() { return "MH-12-AB-1234"; }', 'public String getVehicleNumber() { return "Not Assigned"; }')
model = model.replace('public String getDrop() { return "Drop Location"; }', '')
model = model.replace('public String getDistance() { return "15 km"; }', '')
model = model.replace('public String getDuration() { return "45 mins"; }', '')
if 'public String getEmail()' not in model:
    model = model.replace('public String getPaymentStatus() { return "PAID"; }', 'public String getPaymentStatus() { return "PAID"; }\n    public String getEmail() { return passenger != null ? passenger.getEmail() : "N/A"; }\n    public String getPhone() { return passenger != null ? passenger.getPhone() : "N/A"; }')
with open(cab_model, 'w') as f:
    f.write(model)

for jsp in ['src/main/webapp/pages/transport/cab-ticket.jsp']:
    if os.path.exists(jsp):
        with open(jsp, 'r') as f:
            c = f.read()
        c = ensure_c_if(c)
        if 'Email' not in c:
            c = c.replace('<div class="label">Passenger Name</div>\n                <div class="value">${booking.passengerName}</div>\n            </div>',
                          '<div class="label">Passenger Name</div>\n                <div class="value">${booking.passengerName}</div>\n            </div>\n            <div class="field-group">\n                <div class="label">Email</div>\n                <div class="value">${booking.email}</div>\n            </div>\n            <div class="field-group">\n                <div class="label">Phone</div>\n                <div class="value">${booking.phone}</div>\n            </div>')
        with open(jsp, 'w') as f:
            f.write(c)

# --- TRAIN FIXES ---
train_dao = 'src/main/java/com/voyastra/dao/TrainBookingDAO.java'
with open(train_dao, 'r') as f:
    dao = f.read()
dao = dao.replace('SELECT * FROM train_bookings WHERE id = ?', 'SELECT t.*, u.email as user_email, u.phone as user_phone FROM train_bookings t LEFT JOIN users u ON t.user_id = u.id WHERE t.id = ?')
if 'booking.setEmail(' not in dao:
    dao = dao.replace('booking.setStatus(rs.getString("status"));', 'booking.setStatus(rs.getString("status"));\n                    booking.setEmail(rs.getString("user_email"));\n                    booking.setPhone(rs.getString("user_phone"));')
with open(train_dao, 'w') as f:
    f.write(dao)

train_model = 'src/main/java/com/voyastra/model/TrainBooking.java'
with open(train_model, 'r') as f:
    model = f.read()
if 'private String email;' not in model:
    model = model.replace('public TrainBooking() {}', 'private String email;\n    private String phone;\n    public String getEmail() { return email; }\n    public void setEmail(String email) { this.email = email; }\n    public String getPhone() { return phone; }\n    public void setPhone(String phone) { this.phone = phone; }\n    public int getPassengerAge() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getAge() : 0; }\n    public String getPassengerGender() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getGender() : "N/A"; }\n\n    public TrainBooking() {}')
model = model.replace('public String getCoach() { return "B1"; }', '')
model = model.replace('public String getDepartureTime() { return "08:00 AM"; }', '')
model = model.replace('public String getArrivalTime() { return "04:00 PM"; }', '')
if 'public String getDepartureTime()' not in model:
    model = model.replace('public String getPaymentStatus() { return "PAID"; }', 'public String getPaymentStatus() { return "PAID"; }\n    public String getDepartureTime() { return "08:00 AM"; }\n    public String getArrivalTime() { return "04:00 PM"; }\n    public String getCoach() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getBerthPreference() : "B1"; }')
with open(train_model, 'w') as f:
    f.write(model)

for jsp in ['src/main/webapp/pages/transport/train-ticket.jsp', 'src/main/webapp/pages/transport/train-details.jsp']:
    if os.path.exists(jsp):
        with open(jsp, 'r') as f:
            c = f.read()
        c = ensure_c_if(c)
        if 'Email' not in c:
            replacement = '''<div class="label">Passenger Name</div>
                <div class="value">${booking.passengerName}</div>
            </div>
            <div class="field-group">
                <div class="label">Age</div>
                <div class="value">${booking.passengerAge}</div>
            </div>
            <div class="field-group">
                <div class="label">Gender</div>
                <div class="value">${booking.passengerGender}</div>
            </div>
            <div class="field-group">
                <div class="label">Email</div>
                <div class="value">${booking.email}</div>
            </div>
            <div class="field-group">
                <div class="label">Phone</div>
                <div class="value">${booking.phone}</div>
            </div>'''
            if 'details' in jsp:
                replacement = replacement.replace('field-group', 'detail-item').replace('label', 'detail-label').replace('value', 'detail-value')
            c = c.replace('<div class="label">Passenger Name</div>\n                <div class="value">${booking.passengerName}</div>\n            </div>', replacement)
            c = c.replace('<div class="detail-label">Passenger Name</div>\n            <div class="detail-value">${booking.passengerName}</div>\n        </div>', replacement.replace('field-group', 'detail-item').replace('label', 'detail-label').replace('value', 'detail-value'))
        with open(jsp, 'w') as f:
            f.write(c)

# --- BUS FIXES ---
bus_dao = 'src/main/java/com/voyastra/dao/BusBookingDAO.java'
with open(bus_dao, 'r') as f:
    dao = f.read()
dao = dao.replace('SELECT * FROM bus_bookings WHERE id = ?', 'SELECT b.*, u.email as user_email, u.phone as user_phone FROM bus_bookings b LEFT JOIN users u ON b.user_id = u.id WHERE b.id = ?')
if 'booking.setEmail(' not in dao:
    dao = dao.replace('booking.setStatus(rs.getString("status"));', 'booking.setStatus(rs.getString("status"));\n                    booking.setEmail(rs.getString("user_email"));\n                    booking.setPhone(rs.getString("user_phone"));')
with open(bus_dao, 'w') as f:
    f.write(dao)

bus_model = 'src/main/java/com/voyastra/model/BusBooking.java'
with open(bus_model, 'r') as f:
    model = f.read()
if 'private String email;' not in model:
    model = model.replace('public BusBooking() {}', 'private String email;\n    private String phone;\n    public String getEmail() { return email; }\n    public void setEmail(String email) { this.email = email; }\n    public String getPhone() { return phone; }\n    public void setPhone(String phone) { this.phone = phone; }\n    public int getPassengerAge() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getAge() : 0; }\n    public String getPassengerGender() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getGender() : "N/A"; }\n\n    public BusBooking() {}')
model = model.replace('public String getDeparture() { return "09:00 PM"; }', '')
model = model.replace('public String getArrival() { return "06:00 AM"; }', '')
if 'public String getDepartureTime()' not in model:
    model = model.replace('public String getPaymentStatus() { return "PAID"; }', 'public String getPaymentStatus() { return "PAID"; }\n    public String getDepartureTime() { return "09:00 PM"; }\n    public String getArrivalTime() { return "06:00 AM"; }')
    model = model.replace('public String getPassengerName() { return "Guest"; }', 'public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }')
with open(bus_model, 'w') as f:
    f.write(model)

for jsp in ['src/main/webapp/pages/transport/bus-ticket.jsp', 'src/main/webapp/pages/transport/bus-details.jsp']:
    if os.path.exists(jsp):
        with open(jsp, 'r') as f:
            c = f.read()
        c = ensure_c_if(c)
        if 'Email' not in c:
            replacement = '''<div class="label">Passenger Name</div>
                <div class="value">${booking.passengerName}</div>
            </div>
            <div class="field-group">
                <div class="label">Age</div>
                <div class="value">${booking.passengerAge}</div>
            </div>
            <div class="field-group">
                <div class="label">Gender</div>
                <div class="value">${booking.passengerGender}</div>
            </div>
            <div class="field-group">
                <div class="label">Email</div>
                <div class="value">${booking.email}</div>
            </div>
            <div class="field-group">
                <div class="label">Phone</div>
                <div class="value">${booking.phone}</div>
            </div>'''
            c = c.replace('<div class="label">Passenger Name</div>\n                <div class="value">${booking.passengerName}</div>\n            </div>', replacement)
            c = c.replace('<div class="detail-label">Passenger Name</div>\n            <div class="detail-value">${booking.passengerName}</div>\n        </div>', replacement.replace('field-group', 'detail-item').replace('label', 'detail-label').replace('value', 'detail-value'))
        # Fix hardcoded departure and arrival calls if any
        c = c.replace('${booking.departure}', '${booking.departureTime}').replace('${booking.arrival}', '${booking.arrivalTime}')
        with open(jsp, 'w') as f:
            f.write(c)

print("Fixed Train, Bus, and Cab!")
