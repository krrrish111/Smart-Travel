    </main>
</div>

<jsp:include page="/admin/components/modals.jsp" />

<!-- Bulk Action Bar -->
<div class="bulk-action-bar" id="bulkActionBar">
    <div class="bulk-count"><span id="bulkCountTxt">0</span> Selected</div>
    <select class="filter-select" id="bulkActionSelect" style="border: 1px solid var(--color-border);">
        <option value="">Choose action...</option>
        <option value="delete">Delete Selected</option>
    </select>
    <button class="btn btn-primary" onclick="executeBulkAction()">Execute</button>
</div>

<!-- GLOBAL SCRIPTS -->
<script>
    // Ensure we don't overwrite if defined above
    if (typeof CONTEXT_PATH === 'undefined') {
        window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    }
</script>

<!-- MODULAR JS INCLUDES -->
<script src="${pageContext.request.contextPath}/admin/js/admin.js"></script>
</body>
</html>
