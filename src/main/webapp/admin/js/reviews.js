/* =========================================================
   REVIEWS MANAGEMENT LOGIC (localStorage)
========================================================= */
const LS_REVIEWS_KEY = 'voyastra_admin_reviews';
const initialReviews = [
    { id: 1, user: 'Rahul Sharma', text: 'The Bali trip was absolutely magical! Great planning.', location: 'Bali, Indonesia', rating: 5, approved: true, date: '2024-03-15' },
    { id: 2, user: 'Sarah Jenkins', text: 'Swiss Alps were beautiful, but the itinerary was a bit tight.', location: 'Switzerland', rating: 4, approved: false, date: '2024-03-20' }
];

function getReviews() {
    let raw = localStorage.getItem(LS_REVIEWS_KEY);
    if (!raw) {
        localStorage.setItem(LS_REVIEWS_KEY, JSON.stringify(initialReviews));
        return initialReviews;
    }
    return JSON.parse(raw);
}

function saveReviews(reviews) {
    localStorage.setItem(LS_REVIEWS_KEY, JSON.stringify(reviews));
}

function loadReviewsRenderer() {
    let reviews = getReviews();
    const query = document.getElementById('searchReviews') ? document.getElementById('searchReviews').value.toLowerCase() : '';
    const sort = document.getElementById('sortReviews') ? document.getElementById('sortReviews').value : 'newest';
    
    if (query) {
        reviews = reviews.filter(r => r.user.toLowerCase().includes(query) || r.location.toLowerCase().includes(query) || r.text.toLowerCase().includes(query));
    }
    
    if (sort === 'rating_high') {
        reviews.sort((a,b) => b.rating - a.rating);
    } else if (sort === 'rating_low') {
        reviews.sort((a,b) => a.rating - b.rating);
    } else {
        reviews.sort((a,b) => b.id - a.id);
    }
    
    const grid = document.getElementById('reviewsGrid');
    if (!grid) return;

    if (reviews.length === 0) {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align:center; padding: 50px; color:#888;">No reviews found.</div>';
        return;
    }

    grid.innerHTML = reviews.map(r => `
        <div class="stat-card" style="padding:24px; border-left: 4px solid ${r.approved ? '#10b981' : '#fbbf24'};">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:16px;">
                <div style="display:flex; gap:12px; align-items:center;">
                    <div style="width:40px; height:40px; border-radius:50%; background:var(--color-primary); color:white; display:flex; align-items:center; justify-content:center; font-weight:600;">${r.user[0]}</div>
                    <div>
                        <div style="font-weight:600;">${r.user}</div>
                        <div style="font-size:0.75rem; color:var(--text-muted);">${r.location} • ${r.date}</div>
                    </div>
                </div>
                <div style="display:flex; gap:2px; color:#fbbf24;">
                    ${'★'.repeat(r.rating)}${'☆'.repeat(5-r.rating)}
                </div>
            </div>
            <p style="font-size:0.9rem; line-height:1.6; color:var(--text-muted); margin-bottom:20px; font-style:italic;">"${r.text}"</p>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div style="display:flex; align-items:center; gap:8px;">
                    <input type="checkbox" class="checkbox-custom" data-bulk-context="reviews" value="${r.id}" onchange="toggleBulkItem(${r.id}, 'reviews', this)">
                    <span style="font-size:0.75rem; color:var(--text-muted);">Select for bulk</span>
                </div>
                <div style="display:flex; gap:10px;">
                    ${!r.approved ? `<button class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem; background:rgba(16,185,129,0.1); color:#10b981; border-color:transparent;" onclick="approveReview(${r.id})">Approve</button>` : ''}
                    <button class="btn btn-outline" style="padding:6px 12px; font-size:0.8rem; border-color:rgba(239,68,68,0.2); color:#ef4444;" onclick="deleteReviewModule(${r.id})">Delete</button>
                </div>
            </div>
        </div>
    `).join('');
}

function approveReview(id) {
    const reviews = getReviews();
    const idx = reviews.findIndex(r => r.id === id);
    if (idx !== -1) {
        reviews[idx].approved = true;
        saveReviews(reviews);
        loadReviewsRenderer();
        if (typeof showToast === 'function') showToast('Review approved successfully.', 'success');
        if (typeof logActivity === 'function') logActivity('Approved review from: ' + reviews[idx].user);
    }
}

function deleteReviewModule(id) {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Delete this review permanently?', () => {
            const updated = getReviews().filter(r => r.id !== id);
            saveReviews(updated);
            loadReviewsRenderer();
            if (typeof showToast === 'function') showToast('Review deleted.', 'warning');
        });
    }
}

// Global alias if needed
window.loadReviews = loadReviewsRenderer;
