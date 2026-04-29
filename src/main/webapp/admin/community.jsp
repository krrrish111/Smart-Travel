<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Community Posts Section -->
<section id="manageCommunity" class="admin-section active">
    <div class="flex justify-between items-center" style="margin-bottom: 24px;">
        <div>
            <h2>Community Posts <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Moderation)</span></h2>
            <p class="text-muted" style="margin-top: 4px; font-size: 0.875rem;">Review, moderate and remove user-generated content from the community feed.</p>
        </div>
        <button class="btn btn-outline" onclick="loadCommunityPosts()" style="display:flex;align-items:center;gap:8px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg>
            Refresh
        </button>
    </div>

    <!-- Stats Bar -->
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:16px; margin-bottom:28px;">
        <div class="stat-card" style="padding:16px 20px;">
            <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Total Posts</div>
            <div id="communityStatTotal" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">—</div>
        </div>
        <div class="stat-card" style="padding:16px 20px;">
            <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Visible</div>
            <div id="communityStatVisible" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color:#10b981;">—</div>
        </div>
        <div class="stat-card" style="padding:16px 20px;">
            <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Hidden</div>
            <div id="communityStatHidden" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color:#f59e0b;">—</div>
        </div>
        <div class="stat-card" style="padding:16px 20px;">
            <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Deleted Today</div>
            <div id="communityStatDeleted" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color:#ef4444;">0</div>
        </div>
    </div>

    <!-- Toolbar -->
    <div class="admin-toolbar" style="margin-bottom:20px;">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchCommunityPosts" placeholder="Search by user, content or location..." oninput="filterCommunityPosts()">
        </div>
        <select class="filter-select" id="filterCommunityStatus" onchange="filterCommunityPosts()">
            <option value="all">All Posts</option>
            <option value="visible">Visible Only</option>
            <option value="hidden">Hidden Only</option>
        </select>
    </div>

    <!-- Loading state -->
    <div id="communityPostsLoading" style="text-align:center;padding:50px 20px;display:none;">
        <div style="width:36px;height:36px;border:3px solid var(--color-border);border-top-color:var(--color-primary);border-radius:50%;animation:spin 0.8s linear infinite;margin:0 auto 16px;"></div>
        <p style="color:var(--text-muted); font-size:0.9rem;">Loading community posts...</p>
    </div>

    <!-- Empty state -->
    <div id="communityPostsEmpty" style="text-align:center;padding:60px 20px;display:none;">
        <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" style="margin-bottom:16px;"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
        <h3 style="margin-bottom:8px; color:var(--text-muted);">No Community Posts Found</h3>
        <p style="color:var(--text-muted); font-size:0.875rem;">The community feed is empty. Posts will appear here once users start sharing.</p>
    </div>

    <!-- Posts table -->
    <div class="admin-table-container" id="communityPostsTableWrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Post Content</th>
                    <th>Image</th>
                    <th>Location</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th style="text-align:right;">Actions</th>
                </tr>
            </thead>
            <tbody id="communityPostsTableBody">
                <!-- Rendered by JS -->
            </tbody>
        </table>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/community.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof fetchCommunityPostsFromDB === 'function') fetchCommunityPostsFromDB();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
