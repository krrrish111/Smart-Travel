<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Reviews Section -->
<section id="manageReviews" class="admin-section active">
    <div class="flex justify-between items-center" style="margin-bottom: 24px;">
        <h2>Manage Reviews <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Moderation Queue)</span></h2>
    </div>
    
    <!-- Dashboard Overview -->
    <div class="grid grid-cols-5 gap-4" style="margin-bottom: 24px; display: grid; grid-template-columns: repeat(5, 1fr); gap: 16px;">
        <div class="stat-card" style="padding:16px; background:var(--card-bg); border-radius:8px; text-align:center;">
            <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:8px;">Approved Reviews</div>
            <div id="statApproved" style="font-size:1.5rem; font-weight:700; color:#10b981;">0</div>
        </div>
        <div class="stat-card" style="padding:16px; background:var(--card-bg); border-radius:8px; text-align:center;">
            <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:8px;">Pending Reviews</div>
            <div id="statPending" style="font-size:1.5rem; font-weight:700; color:#fbbf24;">0</div>
        </div>
        <div class="stat-card" style="padding:16px; background:var(--card-bg); border-radius:8px; text-align:center;">
            <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:8px;">Rejected Reviews</div>
            <div id="statRejected" style="font-size:1.5rem; font-weight:700; color:#ef4444;">0</div>
        </div>
        <div class="stat-card" style="padding:16px; background:var(--card-bg); border-radius:8px; text-align:center;">
            <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:8px;">Average Rating</div>
            <div id="statAvgRating" style="font-size:1.5rem; font-weight:700; color:var(--text-main);">0.0</div>
        </div>
        <div class="stat-card" style="padding:16px; background:var(--card-bg); border-radius:8px; text-align:center;">
            <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:8px;">Latest Review</div>
            <div id="statLatest" style="font-size:1rem; font-weight:600; color:var(--text-main); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">-</div>
        </div>
    </div>

    <div class="admin-toolbar" style="margin-bottom: 24px; display:flex; gap:16px; flex-wrap:wrap;">
        <div class="search-wrapper" style="flex:1;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchReviews" placeholder="Search reviews by user, destination, or text..." onkeyup="loadReviewsRenderer()">
        </div>
        <select class="filter-select" id="statusFilter" onchange="loadReviewsRenderer()">
            <option value="all">All Statuses</option>
            <option value="Approved">Approved</option>
            <option value="Pending">Pending</option>
            <option value="Rejected">Rejected</option>
        </select>
        <select class="filter-select" id="sortReviews" onchange="loadReviewsRenderer()">
            <option value="newest">Newest First</option>
            <option value="oldest">Oldest First</option>
            <option value="rating_high">Highest Rating</option>
            <option value="rating_low">Lowest Rating</option>
        </select>
    </div>
    
    <div class="grid grid-cols-2 gap-4" id="reviewsGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 24px;">
        <!-- Rendered by JS -->
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/reviews.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadReviewsRenderer === 'function') loadReviewsRenderer();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
