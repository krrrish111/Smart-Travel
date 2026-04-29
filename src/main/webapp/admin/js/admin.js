/* =========================================================
   CORE ADMIN UI & COMMON UTILITIES
========================================================= */

/* =========================================================
   AUTH & GUARD SCRIPT
========================================================= */
document.addEventListener('DOMContentLoaded', () => {
    // Primary check: use Java server-side session (most reliable)
    if (window.javaSession && window.javaSession.userId && window.javaSession.userId.length > 0) {
        if (window.javaSession.role === 'admin') {
            const denied = document.getElementById('adminAccessDenied');
            const layout = document.getElementById('adminDashboardLayout');
            if (denied) denied.style.display = 'none';
            if (layout) layout.style.display = 'flex';
        } else {
            const denied = document.getElementById('adminAccessDenied');
            if (denied) denied.style.display = 'flex';
        }
        return;
    }
    // Fallback: if no Java session found, redirect to login
    window.location.href = CONTEXT_PATH + '/login?redirect=' + encodeURIComponent(CONTEXT_PATH + '/admin');
});

/* =========================================================
   UI CORE: CONFIRMATION & BULK ACTIONS
========================================================= */
window.pendingConfirmCallback = null;
function advancedConfirm(message, callback) {
    const msgElem = document.getElementById('confirmMessage');
    const modal = document.getElementById('confirmModal');
    if (msgElem) msgElem.innerText = message;
    window.pendingConfirmCallback = callback;
    if (modal) modal.classList.add('active');
}
function closeConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.classList.remove('active');
    window.pendingConfirmCallback = null;
}

const confirmActionBtn = document.getElementById('confirmActionBtn');
if (confirmActionBtn) {
    confirmActionBtn.addEventListener('click', () => {
        if(window.pendingConfirmCallback) window.pendingConfirmCallback();
        closeConfirmModal();
    });
}

let bulkSelectedIds = [];
let currentBulkContext = ''; // 'plans', 'dests', 'reviews', 'content'

function toggleBulkItem(id, context, checkboxElem) {
    if (currentBulkContext !== context) {
        bulkSelectedIds = []; 
        document.querySelectorAll('.checkbox-custom').forEach(cb => cb.checked = false);
        checkboxElem.checked = true;
        currentBulkContext = context;
    }
    
    if (checkboxElem.checked) {
        if(!bulkSelectedIds.includes(id)) bulkSelectedIds.push(id);
    } else {
        bulkSelectedIds = bulkSelectedIds.filter(i => i !== id);
    }
    updateBulkActionBar();
}

function toggleAllBulk(context, masterCheckbox) {
    currentBulkContext = context;
    const isChecked = masterCheckbox.checked;
    bulkSelectedIds = [];
    
    const checkboxes = document.querySelectorAll(`[data-bulk-context="${context}"]`);
    checkboxes.forEach(cb => {
        cb.checked = isChecked;
        if(isChecked) bulkSelectedIds.push(parseInt(cb.value));
    });
    updateBulkActionBar();
}

function updateBulkActionBar() {
    const bar = document.getElementById('bulkActionBar');
    const countTxt = document.getElementById('bulkCountTxt');
    if (bar && countTxt) {
        if (bulkSelectedIds.length > 0) {
            countTxt.innerText = bulkSelectedIds.length;
            bar.classList.add('visible');
        } else {
            bar.classList.remove('visible');
            currentBulkContext = '';
        }
    }
}

function executeBulkAction() {
    const actionSelect = document.getElementById('bulkActionSelect');
    if (!actionSelect) return;
    const action = actionSelect.value;
    if (!action) return;
    
    if (action === 'delete') {
        advancedConfirm(`Are you sure you want to delete ${bulkSelectedIds.length} item(s)?`, () => {
            // Context specific delete logic should be defined in the page's JS
            if (typeof window.performBulkDelete === 'function') {
                window.performBulkDelete(currentBulkContext, bulkSelectedIds);
            } else {
                showToast('Bulk delete not configured for this section.', 'error');
            }
            
            bulkSelectedIds = [];
            updateBulkActionBar();
            actionSelect.value = '';
        });
    }
}

/* =========================================================
   GLOBAL SEARCH LOGIC
========================================================= */
function setupGlobalSearch() {
    const input = document.getElementById('globalAdminSearch');
    const dropdown = document.getElementById('globalSearchResults');
    if (!input || !dropdown) return;
    
    input.addEventListener('input', function(e) {
        const query = e.target.value.toLowerCase().trim();
        if (!query) { dropdown.classList.remove('active'); return; }
        
        // This would ideally fetch from server, but using local fallback for now
        let resultsHTML = '';
        // Mock data search logic...
        
        if (resultsHTML === '') resultsHTML = '<div class="search-result-item text-muted">No matches found.</div>';
        dropdown.innerHTML = resultsHTML;
        dropdown.classList.add('active');
    });
    
    document.addEventListener('click', function(e) {
        if (!input.contains(e.target) && !dropdown.contains(e.target)) dropdown.classList.remove('active');
    });
}

function jumpToPage(pageName) {
    window.location.href = CONTEXT_PATH + '/admin/' + pageName;
}

// --- Responsive Sidebar Toggle ---
function toggleAdminSidebar() {
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('adminSidebarOverlay');
    if (!sidebar || !overlay) return;

    if (sidebar.classList.contains('open')) {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
        document.body.style.overflow = '';
    } else {
        sidebar.classList.add('open');
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

// --- Initial Setup ---
document.addEventListener('DOMContentLoaded', () => {
    setupGlobalSearch();
    
    const params = new URLSearchParams(window.location.search);
    const status = params.get('status');
    const message = params.get('message');
    if (status) {
        if (typeof showToast === 'function') showToast(message || 'Operation successful.', status === 'error' ? 'error' : 'success');
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});
