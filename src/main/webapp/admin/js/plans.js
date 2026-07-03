/* =========================================================
   PLANS MANAGEMENT LOGIC (Backend Integration)
========================================================= */
let globalPlans = [];
let globalDestsForPlans = [];

async function loadPlans() {
    try {
        const response = await fetch('/plans');
        if (!response.ok) throw new Error('Failed to fetch plans');
        
        const text = await response.text();
        if (text.startsWith("<!DOCTYPE") || text.includes("<html")) {
            console.error("Received HTML instead of JSON. Are you logged in as admin?");
            return;
        }
        
        let plans = JSON.parse(text);
        globalPlans = plans;
        
        if (document.getElementById('statPlans')) document.getElementById('statPlans').innerText = plans.length;
        
        const query = document.getElementById('searchPlans') ? document.getElementById('searchPlans').value.toLowerCase() : '';
        const priceRange = document.getElementById('filterPriceRange') ? document.getElementById('filterPriceRange').value : '';
        const sort = document.getElementById('sortPlans') ? document.getElementById('sortPlans').value : 'newest';
        
        if (query) {
            plans = plans.filter(p => 
                (p.title && p.title.toLowerCase().includes(query)) || 
                (p.destination_name && p.destination_name.toLowerCase().includes(query)) || 
                (p.category && p.category.toLowerCase().includes(query))
            );
        }

        if (priceRange) {
            plans = plans.filter(p => {
                const numPrice = p.price || 0;
                if (priceRange === 'under1000') return numPrice < 1000;
                if (priceRange === '1000to2000') return numPrice >= 1000 && numPrice <= 2000;
                if (priceRange === 'over2000') return numPrice > 2000;
                return true;
            });
        }
        
        if (sort === 'price_asc') {
            plans.sort((a,b) => a.price - b.price);
        } else if (sort === 'price_desc') {
            plans.sort((a,b) => b.price - a.price);
        } else {
            plans.sort((a,b) => b.id - a.id);
        }
        
        const tbody = document.getElementById('plansTableBody');
        if (!tbody) return;

        if (plans.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No plans found matching criteria.</td></tr>';
            return;
        }

        tbody.innerHTML = plans.map(p => `
            <tr>
                <td><input type="checkbox" class="checkbox-custom" data-bulk-context="plans" value="${p.id}" onchange="toggleBulkItem(${p.id}, 'plans', this)"></td>
                <td>
                    <div style="display:flex; align-items:center; gap:12px;">
                        <img src="${p.image ? (p.image.startsWith('http') ? p.image : '/' + p.image) : 'https://placehold.co/100x100?text=No+Img'}" style="width:40px; height:40px; border-radius:6px; object-fit:cover;">
                        <div>
                            <div style="font-weight:600;">${p.title}</div>
                            <div style="font-size:0.75rem; color:var(--text-muted);">${p.category}</div>
                        </div>
                    </div>
                </td>
                <td>${p.destination_name || 'N/A'}</td>
                <td>${p.days}D / ${p.nights}N</td>
                <td class="font-bold text-primary">₹${(p.price || 0).toLocaleString()}</td>
                <td style="text-align: right;">
                    <button type="button" class="action-btn btn-edit" onclick="openPlanModal('edit', ${p.id})">Edit</button>
                    <button type="button" class="action-btn btn-delete" onclick="deletePlan(${p.id})">Delete</button>
                </td>
            </tr>
        `).join('');
    } catch (e) {
        console.error("Error loading plans:", e);
        if (typeof showToast === 'function') showToast('Failed to load plans', 'error');
    }
}

async function loadDestinationsForPlans() {
    try {
        const response = await fetch('/destinations');
        if (response.ok) {
            const text = await response.text();
            if (!text.startsWith("<!DOCTYPE")) {
                globalDestsForPlans = JSON.parse(text);
                const select = document.getElementById('planDestination');
                if (select) {
                    select.innerHTML = '<option value="">Select a Destination</option>' + 
                        globalDestsForPlans.map(d => `<option value="${d.id}">${d.name}</option>`).join('');
                }
            }
        }
    } catch (e) {
        console.error("Failed to load destinations for plan modal", e);
    }
}

function openPlanModal(mode='add', id=null) {
    if (globalDestsForPlans.length === 0) loadDestinationsForPlans();

    const form = document.getElementById('planForm');
    const title = document.getElementById('planModalTitle');
    if(form) form.reset();
    
    const elId = document.getElementById('planId');
    if(elId) elId.value = '';
    
    const elAction = document.getElementById('planAction');
    if(elAction) elAction.value = mode;
    
    const elPreview = document.getElementById('planImagePreview');
    if(elPreview) elPreview.style.display = 'none';

    if (mode === 'edit' && id !== null) {
        if(title) title.innerText = 'Edit Plan Details';
        const p = globalPlans.find(x => x.id === id);
        if (p) {
            if(elId) elId.value = p.id;
            const elTitle = document.getElementById('planTitle');
            if(elTitle) elTitle.value = p.title || '';
            const elDest = document.getElementById('planDestination');
            if(elDest) elDest.value = p.destination_id || '';
            const elCat = document.getElementById('planCategory');
            if(elCat) elCat.value = p.category || 'Luxury';
            const elPrice = document.getElementById('planPrice');
            if(elPrice) elPrice.value = p.price || '';
            const elDays = document.getElementById('planDays');
            if(elDays) elDays.value = p.days || '';
            const elNights = document.getElementById('planNights');
            if(elNights) elNights.value = p.nights || '';
            const elDesc = document.getElementById('planDesc');
            if(elDesc) elDesc.value = p.description || '';
            const elImg = document.getElementById('planImage');
            if(elImg) elImg.value = p.image || '';
            if (typeof previewImg === 'function' && p.image) previewImg('planImage', 'planImagePreview');
        }
    } else {
        if(title) title.innerText = 'Add New Travel Plan';
    }
    
    const modal = document.getElementById('planModal');
    if(modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    } else {
        console.error("Missing modal element: planModal");
    }
}

function closePlanModal() {
    const modal = document.getElementById('planModal');
    if(modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

async function deletePlan(id) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Permanently delete this plan?', async () => {
            try {
                const formData = new URLSearchParams();
                formData.append('action', 'delete');
                formData.append('id', id);

                const response = await fetch(CONTEXT_PATH + '/plans', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                });
                const res = await response.json();
                
                if (res.status === 'success') {
                    if (typeof showToast === 'function') showToast(res.message, 'success');
                    if (typeof logActivity === 'function') logActivity('Deleted plan ID: ' + id);
                    loadPlans();
                } else {
                    if (typeof showToast === 'function') showToast(res.message, 'error');
                }
            } catch (e) {
                console.error("Delete error:", e);
                if (typeof showToast === 'function') showToast('Error deleting plan', 'error');
            }
        });
    }
}

// Intercept form submission
document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('planForm');
    if (form) {
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = document.getElementById('savePlanBtn');
            const originalText = btn ? btn.innerText : 'Save';
            if(btn) { btn.innerText = 'Saving...'; btn.disabled = true; }

            try {
                const formData = new FormData(form);
                const response = await fetch(CONTEXT_PATH + '/plans', {
                    method: 'POST',
                    body: formData
                });
                const res = await response.json();

                if (res.status === 'success') {
                    if (typeof showToast === 'function') showToast(res.message, 'success');
                    closePlanModal();
                    loadPlans();
                } else {
                    if (typeof showToast === 'function') showToast(res.message, 'error');
                }
            } catch (err) {
                console.error(err);
                if (typeof showToast === 'function') showToast('An error occurred while saving.', 'error');
            } finally {
                if(btn) { btn.innerText = originalText; btn.disabled = false; }
            }
        });
    }
    
    // Load data on start
    if (document.getElementById('plansTableBody')) {
        loadPlans();
        loadDestinationsForPlans();
    }
});
