<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Reviews Section -->
<section id="manageReviews" class="admin-section active">
    <div class="flex justify-between items-center" style="margin-bottom: 24px;">
        <h2>Manage Reviews <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Moderation Queue)</span></h2>
    </div>
    
    <div class="admin-toolbar" style="margin-bottom: 24px;">
        <div class="search-wrapper">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="search" id="searchReviews" placeholder="Search reviews by user or location..." onkeyup="loadReviewsRenderer()">
        </div>
        <select class="filter-select" id="sortReviews" onchange="loadReviewsRenderer()">
            <option value="newest">Newest First</option>
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
