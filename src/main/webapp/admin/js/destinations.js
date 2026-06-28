/* =========================================================
   DESTINATIONS MANAGEMENT LOGIC (Backend Integration)
========================================================= */
let globalDests = [];

async function loadDests() {
    try {
        const response = await fetch('/voyastra/destinations');
        if (!response.ok) throw new Error('Failed to fetch destinations');
        
        const text = await response.text();
        if (text.startsWith("<!DOCTYPE") || text.includes("<html")) {
            console.error("Received HTML instead of JSON. Are you logged in as admin?");
            return;
        }
        
        let dests = JSON.parse(text);
        globalDests = dests;
        
        if (document.getElementById('statDests')) document.getElementById('statDests').innerText = dests.length;
        
        const query = document.getElementById('searchDests') ? document.getElementById('searchDests').value.toLowerCase() : '';
        const sort = document.getElementById('sortDests') ? document.getElementById('sortDests').value : 'newest';
        
        if (query) {
            dests = dests.filter(d => 
                (d.name && d.name.toLowerCase().includes(query)) || 
                (d.location && d.location.toLowerCase().includes(query)) ||
                (d.country && d.country.toLowerCase().includes(query))
            );
        }
        
        if (sort === 'az') {
            dests.sort((a,b) => a.name.localeCompare(b.name));
        } else if (sort === 'za') {
            dests.sort((a,b) => b.name.localeCompare(a.name));
        } else {
            dests.sort((a,b) => b.id - a.id);
        }
        
        const grid = document.getElementById('destinationsGrid');
        if (!grid) return;

        if (dests.length === 0) {
            grid.innerHTML = '<div style="grid-column: 1/-1; text-align:center; padding: 50px; color:#888;">No destinations found.</div>';
            return;
        }

        grid.innerHTML = dests.map(d => {
            const displayLoc = d.country ? `${d.location}, ${d.country}` : d.location;
            let tags = [];
            if (d.has_unesco) tags.push('<span style="font-size:0.65rem; padding:2px 6px; background:#f59e0b; color:white; border-radius:4px;">UNESCO</span>');
            if (d.is_trending) tags.push('<span style="font-size:0.65rem; padding:2px 6px; background:#ef4444; color:white; border-radius:4px;">Trending</span>');
            
            return `
            <div class="stat-card" style="padding:0; overflow:hidden;">
                <div style="height:140px; background: url('${d.image.startsWith('http') ? d.image : '/voyastra/' + d.image}') center/cover no-repeat; position:relative;">
                    <input type="checkbox" class="checkbox-custom" data-bulk-context="dests" value="${d.id}" onchange="toggleBulkItem(${d.id}, 'dests', this)" style="position:absolute; top:12px; left:12px;">
                    <div style="position:absolute; bottom:12px; right:12px; padding:4px 10px; background:rgba(0,0,0,0.6); backdrop-filter:blur(4px); border-radius:8px; font-size:0.7rem; color:white;">ID: #${d.id}</div>
                    <div style="position:absolute; top:12px; right:12px; display:flex; gap:4px;">${tags.join('')}</div>
                </div>
                <div style="padding:20px;">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                        <div>
                            <h4 style="font-size:1.1rem; font-weight:600; margin-bottom:2px;">${d.name}</h4>
                            <div style="color:var(--text-muted); font-size:0.85rem; display:flex; align-items:center; gap:4px;">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                ${displayLoc}
                            </div>
                        </div>
                        <span style="font-size:0.7rem; padding:4px 8px; border-radius:12px; background:rgba(16,185,129,0.1); color:#10b981;">${d.status}</span>
                    </div>
                    <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:15px; display:flex; justify-content:space-between;">
                        <span>₹${d.price ? d.price.toLocaleString() : '0'}</span>
                        <span>${d.duration_days ? d.duration_days : '0'}D/${d.duration_nights ? d.duration_nights : '0'}N</span>
                    </div>
                    <div style="display:flex; gap:10px;">
                        <button class="btn btn-outline" style="flex:1; padding:8px; font-size:0.85rem;" onclick="openDestModal('edit', ${d.id})">Edit</button>
                        <button class="btn btn-outline" style="flex:1; padding:8px; font-size:0.85rem; border-color:rgba(239,68,68,0.2); color:#ef4444;" onclick="deleteDest(${d.id})">Delete</button>
                    </div>
                </div>
            </div>
            `;
        }).join('');
    } catch (e) {
        console.error("Error loading destinations:", e);
        if (typeof showToast === 'function') showToast('Failed to load destinations', 'error');
    }
}

function openDestModal(mode='add', id=null) {
    const form = document.getElementById('destForm');
    const title = document.getElementById('destModalTitle');
    if(form) form.reset();
    
    const elId = document.getElementById('destId');
    if(elId) elId.value = '';
    
    const elAction = document.getElementById('destAction');
    if(elAction) elAction.value = (mode === 'edit' ? 'update' : 'create');
    
    const elPreview = document.getElementById('destImagePreview');
    if(elPreview) elPreview.style.display = 'none';
    
    const elGallery = document.getElementById('destGalleryPreview');
    if(elGallery) elGallery.innerHTML = '';

    if (mode === 'edit' && id !== null) {
        if(title) title.innerText = 'Edit Destination';
        const d = globalDests.find(x => x.id === id);
        if (d) {
            if(elId) elId.value = d.id;
            const setVal = (eid, val) => { const e = document.getElementById(eid); if(e) e.value = val; };
            const setCheck = (eid, val) => { const e = document.getElementById(eid); if(e) e.checked = val; };

            setVal('destName', d.name || '');
            setVal('destLocation', d.location || '');
            setVal('destCountry', d.country || '');
            setVal('destCategory', d.category || 'Popular');
            setVal('destPrice', d.price || '');
            setVal('destDurationDays', d.duration_days || '');
            setVal('destDurationNights', d.duration_nights || '');
            setVal('destBestSeason', d.best_season || '');
            setVal('destLat', d.latitude !== null ? d.latitude : '');
            setVal('destLng', d.longitude !== null ? d.longitude : '');
            setVal('destDesc', d.desc || '');
            setVal('destHighlights', d.highlights || '');
            
            setCheck('destHasUnesco', d.has_unesco);
            setCheck('destIsTrending', d.is_trending);
            setCheck('destIsPopular', d.is_popular);
            setCheck('destIsFeatured', d.is_featured);

            setVal('destImage', d.image || '');
            if (typeof previewImg === 'function' && d.image) previewImg('destImage', 'destImagePreview');
            
            if (d.gallery && d.gallery.length > 0 && elGallery) {
                const galHtml = d.gallery.map(g => `<img src="${g.startsWith('http') ? g : CONTEXT_PATH + '/' + g}" style="width:60px; height:60px; object-fit:cover; border-radius:4px;">`).join('');
                elGallery.innerHTML = galHtml;
            }
        }
    } else {
        if(title) title.innerText = 'Add New Destination';
    }
    
    const modal = document.getElementById('destModal');
    if(modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
        const modalBody = modal.querySelector('.admin-modal-body');
        if (modalBody) modalBody.scrollTop = 0;
    } else {
        console.error("Missing modal element: destModal");
    }
}

function closeDestModal() {
    const modal = document.getElementById('destModal');
    if(modal) {
        modal.classList.remove('active');
        document.body.style.overflow = 'auto';
    }
}

async function deleteDest(id) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Permanently remove this destination?', async () => {
            try {
                const formData = new URLSearchParams();
                formData.append('action', 'delete');
                formData.append('id', id);

                const response = await fetch(CONTEXT_PATH + '/destinations', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                });
                const res = await response.json();
                
                if (res.status === 'success') {
                    if (typeof showToast === 'function') showToast(res.message, 'success');
                    if (typeof logActivity === 'function') logActivity('Deleted destination ID: ' + id);
                    loadDests();
                } else {
                    if (typeof showToast === 'function') showToast(res.message, 'error');
                }
            } catch (e) {
                console.error("Delete error:", e);
                if (typeof showToast === 'function') showToast('Error deleting destination', 'error');
            }
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const destForm = document.getElementById('destForm');
    if (destForm) {
        destForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const formData = new FormData(destForm);
            try {
                const response = await fetch(destForm.getAttribute('action'), {
                    method: 'POST',
                    body: formData
                });
                
                if (!response.ok) {
                    const error = await response.text();
                    console.error("Server error:", error);
                    throw new Error(error || 'Server returned an error');
                }
                
                const res = await response.json();
                if (res.status === 'success') {
                    if (typeof showToast === 'function') showToast(res.message, 'success');
                    closeDestModal();
                    loadDests();
                } else {
                    if (typeof showToast === 'function') showToast(res.message || 'Error occurred', 'error');
                }
            } catch (err) {
                console.error('Save error:', err);
                if (typeof showToast === 'function') showToast(err.message || 'Server error', 'error');
            }
        });
    }
});
