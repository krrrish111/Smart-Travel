/* =========================================================
   CONTENT MANAGEMENT LOGIC (Servlet-backed)
   Manages site_content table rows (hero, promotion, etc.)
========================================================= */
let allContent = [];

async function loadContent() {
    try {
        const response = await fetch(CONTEXT_PATH + '/admin/content-api');
        if (!response.ok) throw new Error('HTTP ' + response.status);
        allContent = await response.json();
        renderContentGrid();
    } catch (err) {
        console.error('[Content] Fetch error:', err);
        const grid = document.getElementById('contentGrid');
        if (grid) grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:50px;color:var(--text-muted);">Failed to load content. Check console.</div>';
    }
}

function renderContentGrid() {
    const grid = document.getElementById('contentGrid');
    if (!grid) return;

    if (allContent.length === 0) {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align:center; padding: 50px; color:#888;">No content blocks found. Database may need initialization.</div>';
        return;
    }

    grid.innerHTML = allContent.map(c => `
        <div class="stat-card" style="padding:20px; border-top: 4px solid var(--color-primary);" data-id="${c.id}">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:15px;">
                <span style="font-size:0.7rem; font-weight:700; text-transform:uppercase; color:var(--color-primary); letter-spacing:0.08em;">${c.sectionType || '—'}</span>
                <input type="checkbox" ${c.active ? 'checked' : ''} title="Toggle visibility" onchange="toggleContent(${c.id}, this.checked)" style="width:16px;height:16px;cursor:pointer;accent-color:var(--color-primary);">
            </div>
            <h4 style="margin-bottom:6px; font-weight:600; font-size:0.95rem;">${c.title || '(No title)'}</h4>
            <p style="font-size:0.8rem; color:var(--text-muted); margin-bottom:6px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="${c.subtitle || ''}">${c.subtitle || '(No subtitle)'}</p>
            ${c.imageUrl ? `<img src="${c.imageUrl}" alt="Preview" style="width:100%;height:80px;object-fit:cover;border-radius:6px;margin-bottom:10px;" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">` : ''}
            ${c.promoCode ? `<div style="font-size:0.75rem; margin-bottom:8px;"><strong>Code:</strong> <code style="background:rgba(212,165,116,0.15);padding:2px 6px;border-radius:4px;letter-spacing:1px;">${c.promoCode}</code></div>` : ''}
            <div style="display:flex; gap:10px; margin-top:12px;">
                <span style="padding:2px 8px; border-radius:10px; font-size:0.7rem; background:${c.active ? 'rgba(16,185,129,0.12)' : 'rgba(239,68,68,0.1)'}; color:${c.active ? '#10b981' : '#ef4444'}; font-weight:600;">
                    ${c.active ? '● Active' : '○ Inactive'}
                </span>
                <button class="btn btn-outline" style="flex:1; padding:6px; font-size:0.8rem;" onclick="editContent(${c.id})">✎ Edit</button>
            </div>
        </div>
    `).join('');
}

async function toggleContent(id, active) {
    const item = allContent.find(c => c.id === id);
    if (!item) return;

    const body = new URLSearchParams();
    body.append('action', 'update');
    body.append('id', item.id);
    body.append('title', item.title || '');
    body.append('subtitle', item.subtitle || '');
    body.append('body_text', item.bodyText || '');
    body.append('image_url', item.imageUrl || '');
    body.append('button_text', item.buttonText || '');
    body.append('button_link', item.buttonLink || '');
    body.append('promo_code', item.promoCode || '');
    body.append('is_active', active);

    try {
        const response = await fetch(CONTEXT_PATH + '/admin/content-api', { method: 'POST', body });
        const res = await response.json();
        if (res.status === 'success') {
            if (typeof showToast === 'function') showToast('Content visibility updated.', 'success');
            loadContent();
        } else {
            if (typeof showToast === 'function') showToast(res.message || 'Failed to update.', 'error');
        }
    } catch (err) {
        console.error('[Content] Toggle error:', err);
        if (typeof showToast === 'function') showToast('Network error.', 'error');
    }
}

function editContent(id) {
    const item = allContent.find(c => c.id === id);
    if (!item) {
        console.error('[Content] editContent: item not found for id', id);
        return;
    }

    // Safe helper
    const set = (elId, val) => { const el = document.getElementById(elId); if (el) el.value = val || ''; };
    const setChk = (elId, val) => { const el = document.getElementById(elId); if (el) el.checked = !!val; };
    const setTxt = (elId, val) => { const el = document.getElementById(elId); if (el) el.textContent = val || ''; };

    set('contentId', item.id);
    set('contentSectionType', item.sectionType);
    set('contentTitle', item.title);
    set('contentSubtitle', item.subtitle);
    set('contentBodyText', item.bodyText);
    set('contentImageUrl', item.imageUrl);
    set('contentButtonText', item.buttonText);
    set('contentButtonLink', item.buttonLink);
    set('contentPromoCode', item.promoCode);
    setChk('contentIsActive', item.active);
    setTxt('contentModalTitle', 'Edit: ' + (item.sectionType || 'Content'));

    // Show image preview if URL exists
    const preview = document.getElementById('contentImagePreview');
    if (preview) {
        if (item.imageUrl) { preview.src = item.imageUrl; preview.style.display = 'block'; }
        else { preview.src = ''; preview.style.display = 'none'; }
    }

    // Show/hide promo code field based on section type
    const promoGroup = document.getElementById('contentPromoGroup');
    if (promoGroup) {
        promoGroup.style.display = (item.sectionType === 'promotion') ? 'block' : 'none';
    }

    const modal = document.getElementById('contentModal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    } else {
        console.error('[Content] contentModal element not found in DOM!');
    }
}

function closeContentModal() {
    const modal = document.getElementById('contentModal');
    if (modal) modal.classList.remove('active');
    document.body.style.overflow = '';
}

// Form submit handler
document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('contentForm');
    if (!form) return;

    form.addEventListener('submit', async function(e) {
        e.preventDefault();

        const saveBtn = document.getElementById('saveContentBtn');
        const saveBtnText = document.getElementById('saveContentBtnText');
        if (saveBtn) saveBtn.disabled = true;
        if (saveBtnText) saveBtnText.textContent = 'Saving...';

        const body = new URLSearchParams();
        body.append('action', 'update');
        body.append('id', document.getElementById('contentId')?.value || '');
        body.append('title', document.getElementById('contentTitle')?.value || '');
        body.append('subtitle', document.getElementById('contentSubtitle')?.value || '');
        body.append('body_text', document.getElementById('contentBodyText')?.value || '');
        body.append('image_url', document.getElementById('contentImageUrl')?.value || '');
        body.append('button_text', document.getElementById('contentButtonText')?.value || '');
        body.append('button_link', document.getElementById('contentButtonLink')?.value || '');
        body.append('promo_code', document.getElementById('contentPromoCode')?.value || '');
        body.append('is_active', document.getElementById('contentIsActive')?.checked ?? true);

        try {
            const response = await fetch(CONTEXT_PATH + '/admin/content-api', { method: 'POST', body });
            const res = await response.json();

            if (res.status === 'success') {
                if (typeof showToast === 'function') showToast(res.message || 'Content updated successfully!', 'success');
                closeContentModal();
                loadContent();
            } else {
                if (typeof showToast === 'function') showToast(res.message || 'Error saving content.', 'error');
                console.error('[Content] Save error response:', res);
            }
        } catch (err) {
            console.error('[Content] Save network error:', err);
            if (typeof showToast === 'function') showToast('Network error. Please try again.', 'error');
        } finally {
            if (saveBtn) saveBtn.disabled = false;
            if (saveBtnText) saveBtnText.textContent = 'Save Content';
        }
    });
});

// Global aliases for JSP inline calls
window.loadContent = loadContent;
window.editContent = editContent;
window.closeContentModal = closeContentModal;
window.toggleContent = toggleContent;
