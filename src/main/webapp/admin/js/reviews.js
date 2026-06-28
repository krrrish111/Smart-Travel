/* =========================================================
   REVIEWS MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let activeReviews = [];

async function fetchReviewsFromDB() {
    try {
        const body = new URLSearchParams();
        body.append('action', 'list');
        
        const response = await fetch(CONTEXT_PATH + '/AdminReviewServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        });
        if (!response.ok) throw new Error('Failed to fetch reviews');
        activeReviews = await response.json();
        renderReviewsGrid();
    } catch (error) {
        console.error('Reviews load error:', error);
    }
}

function loadReviewsRenderer() {
    fetchReviewsFromDB();
}

function updateStats(reviews) {
    if (!document.getElementById('statApproved')) return;
    
    let approved = 0, pending = 0, rejected = 0, totalRating = 0, ratedCount = 0;
    
    reviews.forEach(r => {
        if (r.status === 'Approved') approved++;
        else if (r.status === 'Pending') pending++;
        else if (r.status === 'Rejected') rejected++;
        
        if (r.rating > 0) {
            totalRating += r.rating;
            ratedCount++;
        }
    });
    
    document.getElementById('statApproved').innerText = approved;
    document.getElementById('statPending').innerText = pending;
    document.getElementById('statRejected').innerText = rejected;
    
    let avg = ratedCount > 0 ? (totalRating / ratedCount).toFixed(1) : "0.0";
    document.getElementById('statAvgRating').innerText = avg;
    
    let latest = "-";
    if (reviews.length > 0) {
        let sorted = [...reviews].sort((a,b) => b.id - a.id); // Approximation for latest
        latest = sorted[0].userName || "Unknown";
    }
    document.getElementById('statLatest').innerText = latest;
}

function renderReviewsGrid() {
    updateStats(activeReviews);
    
    let reviews = [...activeReviews];
    const query = document.getElementById('searchReviews') ? document.getElementById('searchReviews').value.toLowerCase() : '';
    const sort = document.getElementById('sortReviews') ? document.getElementById('sortReviews').value : 'newest';
    const filterStatus = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : 'all';
    
    if (query) {
        reviews = reviews.filter(r => 
            (r.userName && r.userName.toLowerCase().includes(query)) || 
            (r.location && r.location.toLowerCase().includes(query)) || 
            (r.comment && r.comment.toLowerCase().includes(query))
        );
    }
    
    if (filterStatus !== 'all') {
        reviews = reviews.filter(r => r.status === filterStatus);
    }
    
    if (sort === 'rating_high') {
        reviews.sort((a,b) => b.rating - a.rating);
    } else if (sort === 'rating_low') {
        reviews.sort((a,b) => a.rating - b.rating);
    } else if (sort === 'oldest') {
        reviews.sort((a,b) => a.id - b.id);
    } else {
        reviews.sort((a,b) => b.id - a.id);
    }
    
    const grid = document.getElementById('reviewsGrid');
    if (!grid) return;

    if (reviews.length === 0) {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align:center; padding: 50px; color:#888;">No reviews have been submitted yet.</div>';
        return;
    }

    grid.innerHTML = reviews.map(r => {
        let borderCol = "#10b981"; // approved
        if (r.status === 'Pending') borderCol = "#fbbf24";
        if (r.status === 'Rejected') borderCol = "#ef4444";
        
        return `
        <div class="stat-card" style="padding:24px; border-left: 4px solid ${borderCol};">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:16px;">
                <div style="display:flex; gap:12px; align-items:center;">
                    <div style="width:40px; height:40px; border-radius:50%; background:var(--color-primary); color:white; display:flex; align-items:center; justify-content:center; font-weight:600;">
                        ${r.userName ? r.userName[0].toUpperCase() : 'U'}
                    </div>
                    <div>
                        <div style="font-weight:600;">${r.userName || 'Unknown'}</div>
                        <div style="font-size:0.75rem; color:var(--text-muted);">${r.type || 'Review'} • ${r.location || 'Unknown Location'} • ${r.createdAt ? r.createdAt.substring(0, 10) : ''}</div>
                    </div>
                </div>
                <div style="display:flex; gap:2px; color:#fbbf24;">
                    ${'★'.repeat(r.rating || 0)}${'☆'.repeat(5 - (r.rating || 0))}
                </div>
            </div>
            <p style="font-size:0.9rem; line-height:1.6; color:var(--text-muted); margin-bottom:10px; font-style:italic;">"${r.comment || ''}"</p>
            <div style="margin-bottom: 20px;">
                <span style="font-size: 0.75rem; padding: 2px 8px; border-radius: 12px; background: ${borderCol}20; color: ${borderCol}; border: 1px solid ${borderCol}; font-weight: 500;">
                    ${r.status || 'Approved'}
                </span>
            </div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div style="display:flex; align-items:center; gap:8px;">
                    <input type="checkbox" class="checkbox-custom" data-bulk-context="reviews" value="${r.id}" data-type="${r.type}" onchange="toggleBulkItem(${r.id}, 'reviews', this)">
                </div>
                <div style="display:flex; gap:10px; flex-wrap:wrap; justify-content:flex-end;">
                    ${r.status !== 'Approved' ? `<button class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem; border-color:rgba(16,185,129,0.2); color:#10b981;" onclick="updateReviewStatusModule(${r.id}, '${r.type}', 'Approved')">Approve</button>` : ''}
                    ${r.status !== 'Rejected' ? `<button class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem; border-color:rgba(239,68,68,0.2); color:#ef4444;" onclick="updateReviewStatusModule(${r.id}, '${r.type}', 'Rejected')">Reject</button>` : ''}
                    ${r.status === 'Rejected' ? `<button class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem; border-color:rgba(251,191,36,0.2); color:#fbbf24;" onclick="updateReviewStatusModule(${r.id}, '${r.type}', 'Pending')">Restore</button>` : ''}
                    <button class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem; border-color:rgba(239,68,68,0.2); color:#ef4444;" onclick="deleteReviewModule(${r.id}, '${r.type}')">Delete</button>
                </div>
            </div>
        </div>
        `;
    }).join('');
}

function updateReviewStatusModule(id, type, status) {
    const body = new URLSearchParams();
    body.append('action', 'status');
    body.append('id', id);
    body.append('type', type);
    body.append('status', status);

    fetch(CONTEXT_PATH + '/AdminReviewServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (data.status === 'success') {
            if (typeof showToast === 'function') showToast('Status updated to ' + status, 'success');
            fetchReviewsFromDB();
        } else {
            if (typeof showToast === 'function') showToast(data.message || 'Failed to update status.', 'error');
        }
    })
    .catch(err => console.error('Error updating status:', err));
}

function deleteReviewModule(id, type) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Delete this review permanently?', () => {
            const body = new URLSearchParams();
            body.append('action', 'delete');
            body.append('id', id);
            body.append('type', type);

            fetch(CONTEXT_PATH + '/AdminReviewServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    if (typeof showToast === 'function') showToast('Review deleted.', 'warning');
                    fetchReviewsFromDB();
                } else {
                    if (typeof showToast === 'function') showToast(data.message || 'Failed to delete review.', 'error');
                }
            })
            .catch(err => console.error('Error deleting review:', err));
        });
    }
}

// Global alias if needed
window.loadReviews = loadReviewsRenderer;
