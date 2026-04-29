<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Activities Section -->
<section id="manageActivities" class="admin-section active">
    <div class="flex justify-between items-center" style="margin-bottom: 24px;">
        <h2>Manage Activities</h2>
        <button class="btn btn-primary" onclick="openActivityModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Activity
        </button>
    </div>
    
    <div class="admin-toolbar">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchActivities" placeholder="Search activities..." onkeyup="loadActivities()">
        </div>
    </div>
    
    <div class="admin-table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Activity Name</th>
                    <th>ID</th>
                    <th>Dest. ID</th>
                    <th>Price</th>
                    <th>Rating</th>
                    <th style="text-align: right;">Actions</th>
                </tr>
            </thead>
            <tbody id="activitiesTableBody">
                <!-- Loaded by JS -->
            </tbody>
        </table>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/activities.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadActivities === 'function') loadActivities();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
