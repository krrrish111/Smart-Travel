<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Content Section -->
<section id="manageContent" class="admin-section active">
    <div class="flex justify-between items-center" style="margin-bottom: 24px;">
        <h2>Content Management <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Homepage Layout)</span></h2>
    </div>
    <div class="grid grid-cols-3 gap-4" id="contentGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 24px; margin-top: 24px;">
        <!-- Rendered by JS -->
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/content.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadContent === 'function') loadContent();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
