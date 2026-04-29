<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Plans Section -->
<section id="managePlans" class="admin-section active">
    <div class="flex justify-between items-center mb-6">
        <h2>Manage Plans</h2>
        <button class="btn btn-primary" onclick="openPlanModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add New Plan
        </button>
    </div>
    
    <div class="admin-toolbar">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchPlans" placeholder="Search plans by title or location..." onkeyup="loadPlans()">
        </div>
        <div class="flex gap-3">
            <select class="filter-select" id="filterPriceRange" onchange="loadPlans()">
                <option value="">All Prices</option>
                <option value="under1000">Under $1,000</option>
                <option value="1000to2000">$1,000 - $2,000</option>
                <option value="over2000">Over $2,000</option>
            </select>
            <select class="filter-select" id="sortPlans" onchange="loadPlans()">
                <option value="newest">Newest First</option>
                <option value="price_asc">Price: Low to High</option>
                <option value="price_desc">Price: High to Low</option>
            </select>
        </div>
    </div>
    
    <div class="admin-table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width:40px;"><input type="checkbox" class="checkbox-custom" onclick="toggleAllBulk('plans', this)"></th>
                    <th>Plan Name</th>
                    <th>Location</th>
                    <th>Days</th>
                    <th>Price</th>
                    <th class="text-right">Actions</th>
                </tr>
            </thead>
            <tbody id="plansTableBody">
                <!-- Rendered by JS -->
            </tbody>
        </table>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/plans.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadPlans === 'function') loadPlans();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
