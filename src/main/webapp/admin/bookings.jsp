<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Bookings Section -->
<section id="manageBookings" class="admin-section active">
    <div class="flex justify-between items-center mb-6">
        <h2>Manage Bookings</h2>
        <button class="btn btn-outline" onclick="loadBookings()">Refresh</button>
    </div>
    
    <div class="admin-toolbar">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchBookings" placeholder="Search by user, plan or ID..." onkeyup="filterBookings()">
        </div>
    </div>
    
    <div class="admin-table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Plan</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th class="text-right">Actions</th>
                </tr>
            </thead>
            <tbody id="bookingsTableBody">
                <!-- Loaded by JS -->
            </tbody>
        </table>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/bookings.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadBookings === 'function') loadBookings();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
