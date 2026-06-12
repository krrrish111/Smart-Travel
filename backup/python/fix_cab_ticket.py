import os
import re

# 1. Update CabTicketServlet.java
servlet_path = 'src/main/java/com/voyastra/servlet/transport/CabTicketServlet.java'
with open(servlet_path, 'r', encoding='utf-8') as f:
    servlet_content = f.read()

servlet_content = servlet_content.replace(
'''        CabBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new CabBookingDAO().getBookingById(idParam);
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }''',
'''        CabBooking booking = null;
        try {
            String idParam = bookingId;
            booking = new CabBookingDAO().getBookingById(idParam);
            System.out.println("Cab Ticket ID=" + idParam);
            System.out.println("Booking=" + booking);
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        if (booking == null) {
            request.setAttribute("errorMessage", "Cab Booking not found or invalid.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }'''
)

with open(servlet_path, 'w', encoding='utf-8') as f:
    f.write(servlet_content)

# 2. Update cab-ticket.jsp
jsp_path = 'src/main/webapp/pages/transport/cab-ticket.jsp'
with open(jsp_path, 'r', encoding='utf-8') as f:
    jsp_content = f.read()

# Make sure JSTL is included
if '<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>' not in jsp_content:
    jsp_content = jsp_content.replace('<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>',
                                      '<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>\n<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>')

# Replace fare with amount and drop with dropoff
jsp_content = jsp_content.replace('${booking.fare}', '${booking.amount}')
jsp_content = jsp_content.replace('${booking.drop}', '${booking.dropoff}')

# Also handle the unsafe passenger name, although the user mentioned ${booking.customer.name}, the code has ${booking.passengerName}.
# We will wrap the ticket content in <c:if test="${not empty booking}">
ticket_body = re.search(r'(<div class="ticket-container" id="ticketArea">.*</div>)', jsp_content, re.DOTALL)
if ticket_body:
    old_body = ticket_body.group(1)
    new_body = f'<c:if test="${{not empty booking}}">\n    {old_body}\n    </c:if>'
    jsp_content = jsp_content.replace(old_body, new_body)

with open(jsp_path, 'w', encoding='utf-8') as f:
    f.write(jsp_content)

print("Cab ticket flow fixed.")
