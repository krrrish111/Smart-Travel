import os

# Update bookings.jsp
jsp_path = 'src/main/webapp/admin/bookings.jsp'
with open(jsp_path, 'r', encoding='utf-8') as f:
    jsp_content = f.read()

tabs_html = """
    <div class="admin-tabs" style="display: flex; gap: 10px; margin-bottom: 20px; overflow-x: auto; padding-bottom: 10px;">
        <button class="btn btn-outline active-tab" onclick="changeBookingType('packages', this)" style="white-space: nowrap;">Packages</button>
        <button class="btn btn-outline" onclick="changeBookingType('train', this)" style="white-space: nowrap;">Trains</button>
        <button class="btn btn-outline" onclick="changeBookingType('bus', this)" style="white-space: nowrap;">Buses</button>
        <button class="btn btn-outline" onclick="changeBookingType('cab', this)" style="white-space: nowrap;">Cabs</button>
        <button class="btn btn-outline" onclick="changeBookingType('car', this)" style="white-space: nowrap;">Cars</button>
        <button class="btn btn-outline" onclick="changeBookingType('cruise', this)" style="white-space: nowrap;">Cruises</button>
        <button class="btn btn-outline" onclick="changeBookingType('helicopter', this)" style="white-space: nowrap;">Helicopters</button>
    </div>
"""

if "changeBookingType" not in jsp_content:
    jsp_content = jsp_content.replace('<div class="admin-toolbar">', tabs_html + '\n    <div class="admin-toolbar">')
    
    style_addition = """
<style>
    .active-tab {
        background-color: var(--primary);
        color: white;
        border-color: var(--primary);
    }
</style>
"""
    jsp_content = jsp_content.replace('<!-- Manage Bookings Section -->', style_addition + '\n<!-- Manage Bookings Section -->')
    with open(jsp_path, 'w', encoding='utf-8') as f:
        f.write(jsp_content)

# Update bookings.js
js_path = 'src/main/webapp/admin/js/bookings.js'
with open(js_path, 'r', encoding='utf-8') as f:
    js_content = f.read()

if "let activeBookingType" not in js_content:
    js_new = """/* =========================================================
   BOOKINGS MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let activeBookings = [];
let activeBookingType = 'packages';

function changeBookingType(type, btnElem) {
    activeBookingType = type;
    document.querySelectorAll('.admin-tabs button').forEach(b => b.classList.remove('active-tab'));
    if(btnElem) btnElem.classList.add('active-tab');
    fetchBookingsFromDB();
}

async function fetchBookingsFromDB() {
    try {
        const query = (document.getElementById('searchBookings')?.value || '').trim();
        let url = CONTEXT_PATH + '/AdminBookingServlet?type=' + encodeURIComponent(activeBookingType);
        if (query) url += '&q=' + encodeURIComponent(query);
        
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch bookings');
        activeBookings = await response.json();
        renderBookingsTable();
    } catch (error) {
        console.error('Bookings load error:', error);
    }
}

function loadBookings() {
    fetchBookingsFromDB();
}

function renderBookingsTable() {
    const tbody = document.getElementById('bookingsTableBody');
    if (!tbody) return;

    if (!activeBookings || activeBookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No bookings found.</td></tr>';
        return;
    }

    tbody.innerHTML = activeBookings.map(b => `
        <tr id="bookingRow_${b.id}">
            <td style="font-weight:600;">${b.bookingCode || b.id || 'N/A'}</td>
            <td>${b.userName || 'Unknown'}</td>
            <td style="color:var(--text-muted);">${b.planTitle || 'Custom Plan'}</td>
            <td>$${b.totalPrice.toFixed(2)}</td>
            <td><span style="padding:4px 8px; border-radius:12px; font-size:0.75rem; background: ${b.status==='CONFIRMED'?'rgba(16,185,129,0.1)':(b.status==='CANCELLED'?'rgba(239,68,68,0.1)':'rgba(251,191,36,0.1)')}; color: ${b.status==='CONFIRMED'?'#10b981':(b.status==='CANCELLED'?'#ef4444':'#fbbf24')};">${b.status}</span></td>
            <td style="text-align: right;">
                <select class="filter-select" style="padding:4px; font-size:0.8rem; margin-right:8px; width:auto;" onchange="updateBookingStatus('${b.id}', this.value)">
                    <option value="" disabled selected>Change Status</option>
                    <option value="PENDING">PENDING</option>
                    <option value="CONFIRMED">CONFIRMED</option>
                    <option value="CANCELLED">CANCELLED</option>
                </select>
                <button type="button" class="action-btn btn-delete" onclick="deleteBooking('${b.id}')">Delete</button>
            </td>
        </tr>
    `).join('');
}

async function updateBookingStatus(id, status) {
    if(!status) return;
    try {
        const body = new URLSearchParams();
        body.append('action', 'updateStatus');
        body.append('bookingId', id);
        body.append('status', status);
        body.append('type', activeBookingType);

        const res = await fetch(CONTEXT_PATH + '/AdminBookingServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        });
        const data = await res.json();
        if (data.success) {
            typeof showToast === 'function' ? showToast('Booking status updated.', 'success') : false;
            fetchBookingsFromDB();
        } else {
            typeof showToast === 'function' ? showToast('Failed to update status.', 'error') : false;
        }
    } catch(err) {
        console.error('Error updating booking status:', err);
    }
}

function deleteBooking(id) {
    if (!confirm('Permanently delete this booking?')) return;
    const body = new URLSearchParams();
    body.append('action', 'delete');
    body.append('bookingId', id);
    body.append('type', activeBookingType);

    fetch(CONTEXT_PATH + '/AdminBookingServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            typeof showToast === 'function' ? showToast('Booking deleted.', 'success') : false;
            fetchBookingsFromDB();
        } else {
            typeof showToast === 'function' ? showToast('Failed to delete booking.', 'error') : false;
        }
    })
    .catch(err => console.error('Error deleting booking:', err));
}
"""
    with open(js_path, 'w', encoding='utf-8') as f:
        f.write(js_new)

print("Frontend files updated successfully.")
