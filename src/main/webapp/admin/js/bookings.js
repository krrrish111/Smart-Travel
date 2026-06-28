/* =========================================================
   BOOKINGS MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let activeBookings = [];
let activeBookingType = 'all';

function changeBookingType(type, btnElem) {
    activeBookingType = type;
    document.querySelectorAll('.admin-tabs button').forEach(b => b.classList.remove('active-tab'));
    if(btnElem) btnElem.classList.add('active-tab');
    fetchBookingsFromDB();
}

async function fetchBookingsFromDB() {
    try {
        const query = (document.getElementById('searchBookings')?.value || '').trim();
        let currentType = activeBookingType;
        if (query) currentType = 'all'; // Search across all categories
        
        let url = CONTEXT_PATH + '/AdminBookingServlet?type=' + encodeURIComponent(currentType);
        if (query) url += '&q=' + encodeURIComponent(query);
        
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch bookings');
        activeBookings = await response.json();
        renderBookingsTable(currentType);
    } catch (error) {
        console.error('Bookings load error:', error);
    }
}

function loadBookings() {
    fetchBookingsFromDB();
}

function renderBookingsTable(currentType = activeBookingType) {
    const tbody = document.getElementById('bookingsTableBody');
    if (!tbody) return;

    if (!activeBookings || activeBookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No bookings found.</td></tr>';
        return;
    }

    tbody.innerHTML = activeBookings.map(b => {
        let bType = b.type || currentType;
        if (bType === 'all') bType = 'packages'; // Fallback if missing
        let details = b.planTitle || b.details || 'Custom Booking';
        if (bType === 'flight') details = 'Flight: ' + (b.details || details);
        else if (bType === 'hotel') details = 'Hotel: ' + (b.details || details);
        
        return `
        <tr id="bookingRow_${b.id}">
            <td style="font-weight:600;">${b.bookingCode || b.id || 'N/A'}</td>
            <td>${b.userName || 'Unknown'}</td>
            <td style="color:var(--text-muted);">${details} <span style="font-size:0.7rem; background:#eee; padding:2px 4px; border-radius:4px; margin-left:4px;">${bType.toUpperCase()}</span></td>
            <td class="font-bold text-primary">₹${(b.totalPrice || 0).toLocaleString()}</td>
            <td><span style="padding:4px 8px; border-radius:12px; font-size:0.75rem; background: ${b.status==='CONFIRMED'?'rgba(16,185,129,0.1)':(b.status==='CANCELLED'?'rgba(239,68,68,0.1)':'rgba(251,191,36,0.1)')}; color: ${b.status==='CONFIRMED'?'#10b981':(b.status==='CANCELLED'?'#ef4444':'#fbbf24')};">${b.status}</span></td>
            <td style="text-align: right;">
                <select class="filter-select" style="padding:4px; font-size:0.8rem; margin-right:8px; width:auto;" onchange="updateBookingStatus('${b.id}', this.value, '${bType}')">
                    <option value="" disabled selected>Change Status</option>
                    <option value="PENDING">PENDING</option>
                    <option value="CONFIRMED">CONFIRMED</option>
                    <option value="CANCELLED">CANCELLED</option>
                </select>
                <button type="button" class="action-btn btn-delete" onclick="deleteBooking('${b.id}', '${bType}')">Delete</button>
            </td>
        </tr>
    `}).join('');
}

async function updateBookingStatus(id, status, bType) {
    if(!status) return;
    try {
        const body = new URLSearchParams();
        body.append('action', 'updateStatus');
        body.append('bookingId', id);
        body.append('status', status);
        body.append('type', bType || activeBookingType);

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

function deleteBooking(id, bType) {
    if (!confirm('Permanently delete this booking?')) return;
    const body = new URLSearchParams();
    body.append('action', 'delete');
    body.append('bookingId', id);
    body.append('type', bType || activeBookingType);

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
