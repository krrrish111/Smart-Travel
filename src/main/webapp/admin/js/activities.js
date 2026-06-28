/* =========================================================
   ACTIVITIES MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let allActivities = [];

async function loadActivities() {
    try {
        const response = await fetch(CONTEXT_PATH + '/admin/api/activities?action=list');
        if (!response.ok) throw new Error('Failed to load activities');
        allActivities = await response.json();
        renderActivitiesTable();
    } catch (err) {
        console.error('Activities fetch error:', err);
    }
}

function renderActivitiesTable() {
    const query = (document.getElementById('searchActivities')?.value || '').toLowerCase();
    const tbody = document.getElementById('activitiesTableBody');
    if (!tbody) return;

    let filtered = [...allActivities];
    if (query) {
        filtered = filtered.filter(a => 
            (a.title && a.title.toLowerCase().includes(query)) || 
            (a.location && a.location.toLowerCase().includes(query)) ||
            (a.id && a.id.toString().includes(query))
        );
    }

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No activities found.</td></tr>';
        return;
    }

    tbody.innerHTML = filtered.map(a => `
        <tr>
            <td style="font-weight:600;">${a.title || 'Unknown Activity'}</td>
            <td style="color:var(--text-muted); font-size:0.8rem;">#${a.id}</td>
            <td><span class="result-badge" style="background:var(--color-primary);">${a.location || 'Unknown Location'}</span></td>
            <td class="font-bold text-primary">₹${a.price || 0}</td>
            <td>⭐ ${a.rating || 0} <span style="font-size:0.7rem; color:var(--text-muted)">(${a.reviewCount || 0})</span></td>
            <td style="text-align: right;">
                <button type="button" class="action-btn btn-edit" onclick="editActivity(${a.id})">Edit</button>
                <button type="button" class="action-btn btn-delete" onclick="deleteActivity(${a.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

let allDestinations = [];

async function fetchDestinationsForDropdown() {
    try {
        const response = await fetch(CONTEXT_PATH + '/destinations?action=listNames');
        allDestinations = await response.json();
        const select = document.getElementById('activityDestId');
        if (!allDestinations || allDestinations.length === 0) {
            select.innerHTML = '<option value="">No destinations available</option>';
            return;
        }
        let html = '<option value="">Select Destination</option>';
        allDestinations.forEach(d => {
            html += `<option value="${d.id}">${d.name}</option>`;
        });
        select.innerHTML = html;
    } catch (e) {
        console.error('Destinations fetch error:', e);
        document.getElementById('activityDestId').innerHTML = '<option value="">No destinations available</option>';
    }
}

async function openActivityModal(mode='add', id=null) {
    const form = document.getElementById('activityForm');
    const title = document.getElementById('activityModalTitle');
    const extra = document.getElementById('activityExtraInfo');
    
    form.reset();
    document.getElementById('activityId').value = '';
    document.getElementById('activityAction').value = 'add';
    document.getElementById('activityImagePreview').style.display = 'none';
    extra.style.display = 'none';

    await fetchDestinationsForDropdown();

    if (mode === 'edit' && id !== null) {
        title.innerText = 'Edit Activity';
        const act = allActivities.find(a => a.id === id);
        if (act) {
            document.getElementById('activityId').value = act.id;
            document.getElementById('activityAction').value = 'update';
            document.getElementById('activityName').value = act.title || '';
            
            const matchedDest = allDestinations.find(d => d.name === act.location);
            if (matchedDest) {
                document.getElementById('activityDestId').value = matchedDest.id;
            } else {
                document.getElementById('activityDestId').value = '';
            }
            
            document.getElementById('activityPrice').value = act.price || 0;
            document.getElementById('activityImage').value = act.heroImage || '';
            if (document.getElementById('activityDescription')) {
                document.getElementById('activityDescription').value = act.description || '';
            }
            document.getElementById('activityRating').value = act.rating || 4.5;
            document.getElementById('activityReviewsCount').value = act.reviewCount || 0;
            if (typeof previewImg === 'function') previewImg('activityImage', 'activityImagePreview');
            extra.style.display = 'grid';
        }
    } else {
        title.innerText = 'Add New Activity';
    }

    document.getElementById('activityModal').classList.add('active');
}

function closeActivityModal() {
    document.getElementById('activityModal').classList.remove('active');
}

// Ensure editActivity maps to openActivityModal
window.editActivity = function(id) {
    openActivityModal('edit', id);
};

if (document.getElementById('activityForm')) {
    document.getElementById('activityForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        const body = new URLSearchParams(formData);

        try {
            const response = await fetch(CONTEXT_PATH + '/admin/api/activities', {
                method: 'POST',
                body: body
            });
            const res = await response.json();
            
            if (res.status === 'success') {
                if (typeof showToast === 'function') showToast('Activity saved successfully.', 'success');
                closeActivityModal();
                loadActivities();
            } else {
                if (typeof showToast === 'function') showToast(res.message || 'Error saving activity.', 'error');
            }
        } catch (err) {
            console.error('Save error:', err);
            if (typeof showToast === 'function') showToast('Error saving activity.', 'error');
        }
    });
}

function deleteActivity(id) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Delete this activity permanently?', async () => {
            const body = new URLSearchParams();
            body.append('action', 'delete');
            body.append('id', id);

            try {
                const response = await fetch(`${CONTEXT_PATH}/admin/api/activities`, {
                    method: 'POST',
                    body: body
                });
                const res = await response.json();
                
                if (res.status === 'success') {
                    if (typeof showToast === 'function') showToast('Activity deleted.', 'warning');
                    loadActivities();
                } else {
                    if (typeof showToast === 'function') showToast(res.message || 'Failed to delete activity.', 'error');
                }
            } catch (err) {
                if (typeof showToast === 'function') showToast('Failed to delete activity.', 'error');
            }
        });
    }
}
