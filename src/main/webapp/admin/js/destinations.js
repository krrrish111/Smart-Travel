/* =========================================================
   DESTINATIONS MANAGEMENT LOGIC (localStorage)
========================================================= */
const LS_DESTS_KEY = 'voyastra_admin_dests';
const initialDests = [
    { id: 1, name: 'Santorini', location: 'Greece', status: 'Active', image: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?q=80&w=400' },
    { id: 2, name: 'Maldives', location: 'South Asia', status: 'Active', image: 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=400' },
    { id: 3, name: 'Cappadocia', location: 'Turkey', status: 'Active', image: 'https://images.unsplash.com/photo-1641128324972-af3212f0f6bd?q=80&w=400' }
];

function getDests() {
    let raw = localStorage.getItem(LS_DESTS_KEY);
    if (!raw) {
        localStorage.setItem(LS_DESTS_KEY, JSON.stringify(initialDests));
        return initialDests;
    }
    return JSON.parse(raw);
}

function saveDests(dests) {
    localStorage.setItem(LS_DESTS_KEY, JSON.stringify(dests));
}

function loadDests() {
    let dests = getDests();
    if (document.getElementById('statDests')) document.getElementById('statDests').innerText = dests.length;
    
    const query = document.getElementById('searchDests') ? document.getElementById('searchDests').value.toLowerCase() : '';
    const sort = document.getElementById('sortDests') ? document.getElementById('sortDests').value : 'newest';
    
    if (query) {
        dests = dests.filter(d => d.name.toLowerCase().includes(query) || d.location.toLowerCase().includes(query));
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

    grid.innerHTML = dests.map(d => `
        <div class="stat-card" style="padding:0; overflow:hidden;">
            <div style="height:140px; background: url('${d.image}') center/cover no-repeat; position:relative;">
                <input type="checkbox" class="checkbox-custom" data-bulk-context="dests" value="${d.id}" onchange="toggleBulkItem(${d.id}, 'dests', this)" style="position:absolute; top:12px; left:12px;">
                <div style="position:absolute; bottom:12px; right:12px; padding:4px 10px; background:rgba(0,0,0,0.6); backdrop-filter:blur(4px); border-radius:8px; font-size:0.7rem; color:white;">ID: #${d.id}</div>
            </div>
            <div style="padding:20px;">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                    <div>
                        <h4 style="font-size:1.1rem; font-weight:600; margin-bottom:2px;">${d.name}</h4>
                        <div style="color:var(--text-muted); font-size:0.85rem; display:flex; align-items:center; gap:4px;">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                            ${d.location}
                        </div>
                    </div>
                    <span style="font-size:0.7rem; padding:4px 8px; border-radius:12px; background:rgba(16,185,129,0.1); color:#10b981;">${d.status}</span>
                </div>
                <div style="display:flex; gap:10px;">
                    <button class="btn btn-outline" style="flex:1; padding:8px; font-size:0.85rem;" onclick="openDestModal('edit', ${d.id})">Edit</button>
                    <button class="btn btn-outline" style="flex:1; padding:8px; font-size:0.85rem; border-color:rgba(239,68,68,0.2); color:#ef4444;" onclick="deleteDest(${d.id})">Delete</button>
                </div>
            </div>
        </div>
    `).join('');
}

function openDestModal(mode='add', id=null) {
    const form = document.getElementById('destForm');
    const title = document.getElementById('destModalTitle');
    form.reset();
    document.getElementById('destId').value = '';
    document.getElementById('destImagePreview').style.display = 'none';

    if (mode === 'edit' && id !== null) {
        title.innerText = 'Edit Destination';
        const d = getDests().find(x => x.id === id);
        if (d) {
            document.getElementById('destId').value = d.id;
            document.getElementById('destName').value = d.name;
            document.getElementById('destLocation').value = d.location;
            document.getElementById('destImage').value = d.image;
            if (typeof previewImg === 'function') previewImg('destImage', 'destImagePreview');
        }
    } else {
        title.innerText = 'Add New Destination';
    }
    document.getElementById('destModal').classList.add('active');
}

function closeDestModal() {
    document.getElementById('destModal').classList.remove('active');
}

function deleteDest(id) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Permanently remove this destination?', () => {
            const updated = getDests().filter(d => d.id !== id);
            saveDests(updated);
            loadDests();
            if (typeof logActivity === 'function') logActivity('Deleted destination ID: ' + id);
            if (typeof showToast === 'function') showToast('Destination deleted.', 'warning');
        });
    }
}
