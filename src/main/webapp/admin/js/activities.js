/* =========================================================
   ACTIVITIES MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let allActivities = [];

async function loadActivities() {
    try {
        const response = await fetch(CONTEXT_PATH + '/activities?format=json');
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
            a.name.toLowerCase().includes(query) || 
            a.destinationId.toString().includes(query)
        );
    }

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No activities found.</td></tr>';
        return;
    }

    tbody.innerHTML = filtered.map(a => `
        <tr>
            <td style="font-weight:600;">${a.name}</td>
            <td style="color:var(--text-muted); font-size:0.8rem;">#${a.id}</td>
            <td><span class="result-badge" style="background:var(--color-primary);">${a.destinationId}</span></td>
            <td class="font-bold text-primary">₹${a.price}</td>
            <td>⭐ ${a.rating} <span style="font-size:0.7rem; color:var(--text-muted)">(${a.reviewsCount})</span></td>
            <td style="text-align: right;">
                <button type="button" class="action-btn btn-edit" onclick="editActivity(${a.id})">Edit</button>
                <button type="button" class="action-btn btn-delete" onclick="deleteActivity(${a.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

function openActivityModal(mode='add', id=null) {
    const form = document.getElementById('activityForm');
    const title = document.getElementById('activityModalTitle');
    const extra = document.getElementById('activityExtraInfo');
    const destSelect = document.getElementById('activityDestId');
    
    form.reset();
    document.getElementById('activityId').value = '';
    document.getElementById('activityAction').value = 'add';
    document.getElementById('activityImagePreview').style.display = 'none';
    extra.style.display = 'none';

    // Populate Destinations
    const dests = typeof getDests === 'function' ? getDests() : []; 
    destSelect.innerHTML = dests.map(d => `<option value="${d.id}">${d.name} (#${d.id})</option>`).join('');

    if (mode === 'edit' && id !== null) {
        title.innerText = 'Edit Activity';
        const act = allActivities.find(a => a.id === id);
        if (act) {
            document.getElementById('activityId').value = act.id;
            document.getElementById('activityAction').value = 'update';
            document.getElementById('activityName').value = act.name;
            document.getElementById('activityDestId').value = act.destinationId;
            document.getElementById('activityPrice').value = act.price;
            document.getElementById('activityImage').value = act.imageUrl;
            document.getElementById('activityRating').value = act.rating;
            document.getElementById('activityReviewsCount').value = act.reviewsCount;
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

if (document.getElementById('activityForm')) {
    document.getElementById('activityForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        const body = new URLSearchParams(formData);

        try {
            const response = await fetch(CONTEXT_PATH + '/activities', {
                method: 'POST',
                body: body
            });
            
            showToast('Activity saved successfully.', 'success');
            closeActivityModal();
            loadActivities();
        } catch (err) {
            console.error('Save error:', err);
            showToast('Error saving activity.', 'error');
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
                await fetch(`${CONTEXT_PATH}/activities`, {
                    method: 'POST',
                    body: body
                });
                showToast('Activity deleted.', 'warning');
                loadActivities();
            } catch (err) {
                showToast('Failed to delete activity.', 'error');
            }
        });
    }
}
