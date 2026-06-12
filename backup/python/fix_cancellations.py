import os

def insert_update_status(file_path, table_name):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if "updateBookingStatus" not in content:
        # insert before the last closing brace
        method = f"""
    public boolean updateBookingStatus(String id, String status) {{
        String sql = "UPDATE {table_name} SET status = ? WHERE id = ?";
        try (java.sql.Connection conn = com.voyastra.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {{
            ps.setString(1, status);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        }} catch (Exception e) {{
            e.printStackTrace();
            return false;
        }}
    }}
"""
        last_brace = content.rfind('}')
        if last_brace != -1:
            content = content[:last_brace] + method + content[last_brace:]
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)

insert_update_status('src/main/java/com/voyastra/dao/CarBookingDAO.java', 'car_bookings')
insert_update_status('src/main/java/com/voyastra/dao/CruiseBookingDAO.java', 'cruise_bookings')
insert_update_status('src/main/java/com/voyastra/dao/HelicopterBookingDAO.java', 'helicopter_bookings')


profile_servlet = 'src/main/java/com/voyastra/servlet/ProfileServlet.java'
with open(profile_servlet, 'r', encoding='utf-8') as f:
    ps_content = f.read()

if "cancelCarBooking" not in ps_content:
    ps_content = ps_content.replace(
        '} else if ("cancelHotelBooking".equals(action)) {',
        '} else if ("cancelCarBooking".equals(action)) {\n            handleCancelCarBooking(request, response, userId);\n        } else if ("cancelCruiseBooking".equals(action)) {\n            handleCancelCruiseBooking(request, response, userId);\n        } else if ("cancelHelicopterBooking".equals(action)) {\n            handleCancelHelicopterBooking(request, response, userId);\n        } else if ("cancelHotelBooking".equals(action)) {'
    )
    
    cancel_methods = """
    private void handleCancelCarBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws java.io.IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null) {
            new com.voyastra.dao.CarBookingDAO().updateBookingStatus(bookingId, "CANCELLED");
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=cancelled");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=cancel_failed");
    }

    private void handleCancelCruiseBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws java.io.IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null) {
            new com.voyastra.dao.CruiseBookingDAO().updateBookingStatus(bookingId, "CANCELLED");
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=cancelled");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=cancel_failed");
    }

    private void handleCancelHelicopterBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws java.io.IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null) {
            new com.voyastra.dao.HelicopterBookingDAO().updateBookingStatus(bookingId, "CANCELLED");
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=cancelled");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=cancel_failed");
    }
"""
    last_brace = ps_content.rfind('}')
    ps_content = ps_content[:last_brace] + cancel_methods + ps_content[last_brace:]

    with open(profile_servlet, 'w', encoding='utf-8') as f:
        f.write(ps_content)

jsp_path = 'src/main/webapp/pages/profile.jsp'
with open(jsp_path, 'r', encoding='utf-8') as f:
    jsp = f.read()

# Add Cancel button for cars
if "openCancelModal('${car.id}', '${car.totalFare}', 'car')" not in jsp:
    jsp = jsp.replace(
        '<a href="${pageContext.request.contextPath}/car/details?id=${car.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>',
        '<a href="${pageContext.request.contextPath}/car/details?id=${car.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>\n                                                <button class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal(\'${car.id}\', \'${car.totalFare}\', \'car\')">Cancel Booking</button>'
    )

# Add Cancel button for cruises
if "openCancelModal('${cr.id}', '${cr.totalFare}', 'cruise')" not in jsp:
    jsp = jsp.replace(
        '<a href="${pageContext.request.contextPath}/cruise/details?id=${cr.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>',
        '<a href="${pageContext.request.contextPath}/cruise/details?id=${cr.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>\n                                                <button class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal(\'${cr.id}\', \'${cr.totalFare}\', \'cruise\')">Cancel Booking</button>'
    )

# Add Cancel button for helicopters
if "openCancelModal('${h.id}', '${h.totalFare}', 'helicopter')" not in jsp:
    jsp = jsp.replace(
        '<a href="${pageContext.request.contextPath}/helicopter/details?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>',
        '<a href="${pageContext.request.contextPath}/helicopter/details?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>\n                                                <button class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal(\'${h.id}\', \'${h.totalFare}\', \'helicopter\')">Cancel Booking</button>'
    )

# Update openCancelModal function in profile.jsp
jsp = jsp.replace(
    '''        if (type === 'hotel') {
            actionInput.value = 'cancelHotelBooking';
        } else {
            actionInput.value = 'cancelBooking';
        }''',
    '''        if (type === 'hotel') {
            actionInput.value = 'cancelHotelBooking';
        } else if (type === 'car') {
            actionInput.value = 'cancelCarBooking';
        } else if (type === 'cruise') {
            actionInput.value = 'cancelCruiseBooking';
        } else if (type === 'helicopter') {
            actionInput.value = 'cancelHelicopterBooking';
        } else {
            actionInput.value = 'cancelBooking';
        }'''
)

with open(jsp_path, 'w', encoding='utf-8') as f:
    f.write(jsp)

# Also fix the issue where `car.totalFare` is missing because CarBooking.java lacks `getTotalFare()`
car_booking = 'src/main/java/com/voyastra/model/CarBooking.java'
with open(car_booking, 'r', encoding='utf-8') as f:
    cb_content = f.read()

if "getTotalFare" not in cb_content:
    cb_content = cb_content.replace('public double getamount() { return amount; }', 'public double getamount() { return amount; }\n    public double getTotalFare() { return amount; }')
    with open(car_booking, 'w', encoding='utf-8') as f:
        f.write(cb_content)

print("Updated ProfileServlet, DAOs, JSP, and Models for cancellations.")
