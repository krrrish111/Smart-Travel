<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Users Section -->
<section id="manageUsers" class="admin-section active">
    <div class="flex justify-between items-center mb-6">
        <h2>Manage Users</h2>
        <div class="flex gap-3">
            <button class="btn btn-outline" onclick="loadUsers()">Refresh</button>
            <button class="btn btn-primary" onclick="openUserModal()">Add User</button>
        </div>
    </div>
    
    <div class="admin-toolbar">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchUsers" placeholder="Search by name, email or role..." onkeyup="filterUsers()">
        </div>
    </div>
    
    <div class="admin-table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th class="text-right">Actions</th>
                </tr>
            </thead>
            <tbody id="usersTableBody">
                <!-- Loaded by JS -->
            </tbody>
        </table>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/users.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadUsers === 'function') loadUsers();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
