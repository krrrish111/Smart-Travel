/* =========================================================
   BOOKINGS MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let activeBookings = [];

async function fetchBookingsFromDB() {
    try {
        const query = (document.getElementById('searchBookings')?.value || '').trim();
        const response = await fetch(CONTEXT_PATH + '/AdminBookingServlet' + (query ? '?q=' + encodeURIComponent(query) : ''));
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
            <td style="font-weight:600;">${b.bookingCode || 'N/A'}</td>
            <td>${b.userName || 'Unknown'}</td>
            <td style="color:var(--text-muted);">${b.planTitle || 'Custom Plan'}</td>
            <td>$${b.totalPrice.toFixed(2)}</td>
            <td><span style="padding:4px 8px; border-radius:12px; font-size:0.75rem; background: ${b.status==='CONFIRMED'?'rgba(16,185,129,0.1)':(b.status==='CANCELLED'?'rgba(239,68,68,0.1)':'rgba(251,191,36,0.1)')}; color: ${b.status==='CONFIRMED'?'#10b981':(b.status==='CANCELLED'?'#ef4444':'#fbbf24')};">${b.status}</span></td>
            <td style="text-align: right;">
                <select class="filter-select" style="padding:4px; font-size:0.8rem; margin-right:8px; width:auto;" onchange="updateBookingStatus(${b.id}, this.value)">
                    <option value="" disabled selected>Change Status</option>
                    <option value="PENDING">PENDING</option>
                    <option value="CONFIRMED">CONFIRMED</option>
                    <option value="CANCELLED">CANCELLED</option>
                </select>
                <button type="button" class="action-btn btn-delete" onclick="deleteBooking(${b.id})">Delete</button>
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
