<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Destinations Section -->
<section id="manageDestinations" class="admin-section active">
    <div class="flex justify-between items-center mb-6">
        <h2>Manage Destinations</h2>
        <button class="btn btn-primary" onclick="openDestModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Destination
        </button>
    </div>
    
    <div class="admin-toolbar">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchDests" placeholder="Search destinations..." onkeyup="loadDests()">
        </div>
        <select class="filter-select" id="sortDests" onchange="loadDests()">
            <option value="newest">Newest First</option>
            <option value="az">A-Z Name</option>
            <option value="za">Z-A Name</option>
        </select>
    </div>
    
    <div class="mb-4 flex items-center gap-2">
        <input type="checkbox" class="checkbox-custom" onclick="toggleAllBulk('dests', this)"> <span class="text-sm text-muted">Select All Destinations</span>
    </div>
    
    <div class="grid grid-cards gap-6" id="destinationsGrid">
        <!-- Rendered by JS -->
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/destinations.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadDests === 'function') loadDests();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
