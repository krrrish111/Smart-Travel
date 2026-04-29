/* =========================================================
   PLANS MANAGEMENT LOGIC (localStorage)
========================================================= */
const LS_PLANS_KEY = 'voyastra_admin_plans';
const initialPlans = [
    { id: 1, title: 'Bali Beach Escapade', location: 'Indonesia', duration: '5 Days', price: '$899', desc: 'Beach, Spa, Sunset' },
    { id: 2, title: 'Swiss Alps Adventure', location: 'Switzerland', duration: '7 Days', price: '$2,450', desc: 'Skiing, Mountains' },
    { id: 3, title: 'Kyoto Cultural Immersion', location: 'Japan', duration: '10 Days', price: '$1,800', desc: 'Temples, Cherry Blossoms' }
];

function getPlans() {
    let raw = localStorage.getItem(LS_PLANS_KEY);
    if (!raw) {
        localStorage.setItem(LS_PLANS_KEY, JSON.stringify(initialPlans));
        return initialPlans;
    }
    return JSON.parse(raw);
}

function savePlans(plans) {
    localStorage.setItem(LS_PLANS_KEY, JSON.stringify(plans));
}

function loadPlans() {
    let plans = getPlans();
    if (document.getElementById('statPlans')) document.getElementById('statPlans').innerText = plans.length;
    
    const query = document.getElementById('searchPlans') ? document.getElementById('searchPlans').value.toLowerCase() : '';
    const priceRange = document.getElementById('filterPriceRange') ? document.getElementById('filterPriceRange').value : '';
    const sort = document.getElementById('sortPlans') ? document.getElementById('sortPlans').value : 'newest';
    
    if (query) {
        plans = plans.filter(p => p.title.toLowerCase().includes(query) || p.location.toLowerCase().includes(query) || p.price.toString().toLowerCase().includes(query));
    }

    if (priceRange) {
        plans = plans.filter(p => {
            const numPrice = parseFloat(p.price.replace(/[^0-9.]/g,''));
            if (priceRange === 'under1000') return numPrice < 1000;
            if (priceRange === '1000to2000') return numPrice >= 1000 && numPrice <= 2000;
            if (priceRange === 'over2000') return numPrice > 2000;
            return true;
        });
    }
    
    if (sort === 'price_asc') {
        plans.sort((a,b) => parseFloat(a.price.replace(/[^0-9.]/g,'')) - parseFloat(b.price.replace(/[^0-9.]/g,'')));
    } else if (sort === 'price_desc') {
        plans.sort((a,b) => parseFloat(b.price.replace(/[^0-9.]/g,'')) - parseFloat(a.price.replace(/[^0-9.]/g,'')));
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
            <td style="font-weight:600;">${p.title}</td>
            <td>${p.location}</td>
            <td>${p.duration}</td>
            <td class="font-bold text-primary">${p.price}</td>
            <td style="text-align: right;">
                <button type="button" class="action-btn btn-edit" onclick="openPlanModal('edit', ${p.id})">Edit</button>
                <button type="button" class="action-btn btn-delete" onclick="deletePlan(${p.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

function openPlanModal(mode='add', id=null) {
    const form = document.getElementById('planForm');
    const title = document.getElementById('planModalTitle');
    form.reset();
    document.getElementById('planId').value = '';

    if (mode === 'edit' && id !== null) {
        title.innerText = 'Edit Plan Details';
        const p = getPlans().find(x => x.id === id);
        if (p) {
            document.getElementById('planId').value = p.id;
            document.getElementById('planTitle').value = p.title;
            document.getElementById('planLocation').value = p.location;
            document.getElementById('planDuration').value = p.duration;
            document.getElementById('planPrice').value = p.price;
            document.getElementById('planDesc').value = p.desc;
        }
    } else {
        title.innerText = 'Add New Travel Plan';
    }
    document.getElementById('planModal').classList.add('active');
}

function closePlanModal() {
    document.getElementById('planModal').classList.remove('active');
}

function deletePlan(id) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Are you sure you want to delete this plan permanently?', () => {
            const updated = getPlans().filter(p => p.id !== id);
            savePlans(updated);
            loadPlans();
            if (typeof logActivity === 'function') logActivity('Deleted plan ID: ' + id);
            if (typeof showToast === 'function') showToast('Plan removed successfully.', 'warning');
        });
    }
}
