/* =========================================================
   COMMUNITY POSTS MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let allCommunityPosts = [];

async function fetchCommunityPostsFromDB() {
    const loading = document.getElementById('communityPostsLoading');
    const empty = document.getElementById('communityPostsEmpty');
    const tableWrap = document.getElementById('communityPostsTableWrap');
    
    if (loading) loading.style.display = 'block';
    if (empty) empty.style.display = 'none';
    if (tableWrap) tableWrap.style.display = 'none';

    try {
        const response = await fetch(CONTEXT_PATH + '/AdminCommunityServlet?action=list');
        if (!response.ok) throw new Error('Failed to fetch posts');
        allCommunityPosts = await response.json();
        
        updateCommunityStats();
        renderCommunityPostsTable();
    } catch (err) {
        console.error('Community posts error:', err);
        if (typeof showToast === 'function') showToast('Failed to load community posts.', 'error');
    } finally {
        if (loading) loading.style.display = 'none';
    }
}

function updateCommunityStats() {
    if (!document.getElementById('communityStatTotal')) return;
    
    const total = allCommunityPosts.length;
    const visible = allCommunityPosts.filter(p => !p.hidden).length;
    const hidden = total - visible;
    
    document.getElementById('communityStatTotal').innerText = total;
    document.getElementById('communityStatVisible').innerText = visible;
    document.getElementById('communityStatHidden').innerText = hidden;
}

function renderCommunityPostsTable() {
    const tbody = document.getElementById('communityPostsTableBody');
    const empty = document.getElementById('communityPostsEmpty');
    const tableWrap = document.getElementById('communityPostsTableWrap');
    if (!tbody) return;

    const query = document.getElementById('searchCommunityPosts')?.value.toLowerCase() || '';
    const status = document.getElementById('filterCommunityStatus')?.value || 'all';

    let filtered = [...allCommunityPosts];
    
    if (query) {
        filtered = filtered.filter(p => 
            p.userName.toLowerCase().includes(query) || 
            p.content.toLowerCase().includes(query) || 
            (p.location && p.location.toLowerCase().includes(query))
        );
    }
    
    if (status === 'visible') filtered = filtered.filter(p => !p.hidden);
    if (status === 'hidden') filtered = filtered.filter(p => p.hidden);

    if (filtered.length === 0) {
        if (tableWrap) tableWrap.style.display = 'none';
        if (empty) empty.style.display = 'block';
        return;
    }

    if (empty) empty.style.display = 'none';
    if (tableWrap) tableWrap.style.display = 'block';

    tbody.innerHTML = filtered.map(p => `
        <tr>
            <td style="font-weight:600;">${p.userName}</td>
            <td style="max-width:300px; font-size:0.85rem; color:var(--text-muted); line-height:1.4;">${p.content}</td>
            <td>
                ${p.imageUrl ? `<img src="${p.imageUrl}" style="width:40px; height:40px; border-radius:4px; object-fit:cover;" onerror="this.src='../assets/placeholder.jpg'">` : '<span style="color:#888;font-size:0.7rem;">No Image</span>'}
            </td>
            <td style="font-size:0.8rem;">${p.location || '—'}</td>
            <td style="font-size:0.75rem; color:var(--text-muted);">${p.createdAt}</td>
            <td>
                <span style="padding:4px 8px; border-radius:12px; font-size:0.7rem; background:${p.hidden ? 'rgba(245,158,11,0.1)' : 'rgba(16,185,129,0.1)'}; color:${p.hidden ? '#f59e0b' : '#10b981'};">
                    ${p.hidden ? 'Hidden' : 'Visible'}
                </span>
            </td>
            <td style="text-align:right;">
                <div style="display:flex; justify-content:flex-end; gap:8px;">
                    <button class="action-btn" onclick="togglePostVisibility(${p.id}, ${p.hidden})" title="${p.hidden ? 'Show Post' : 'Hide Post'}">
                        ${p.hidden ? 'Show' : 'Hide'}
                    </button>
                    <button class="action-btn btn-delete" onclick="deleteCommunityPost(${p.id})">Delete</button>
                </div>
            </td>
        </tr>
    `).join('');
}

async function togglePostVisibility(id, currentlyHidden) {
    try {
        const body = new URLSearchParams();
        body.append('action', 'toggleVisibility');
        body.append('postId', id);
        body.append('hidden', !currentlyHidden);

        const res = await fetch(CONTEXT_PATH + '/AdminCommunityServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        });
        const data = await res.json();
        if (data.success) {
            if (typeof showToast === 'function') showToast(currentlyHidden ? 'Post is now visible.' : 'Post hidden from feed.', 'success');
            fetchCommunityPostsFromDB();
        }
    } catch (err) {
        console.error('Error toggling visibility:', err);
    }
}

async function deleteCommunityPost(id) {
    if (!confirm('Permanently delete this post? This cannot be undone.')) return;
    try {
        const body = new URLSearchParams();
        body.append('action', 'delete');
        body.append('postId', id);

        const res = await fetch(CONTEXT_PATH + '/AdminCommunityServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        });
        const data = await res.json();
        if (data.success) {
            if (typeof showToast === 'function') showToast('Post deleted permanently.', 'warning');
            const delCount = document.getElementById('communityStatDeleted');
            if (delCount) delCount.innerText = parseInt(delCount.innerText) + 1;
            fetchCommunityPostsFromDB();
        }
    } catch (err) {
        console.error('Error deleting post:', err);
    }
}

// Global aliases
window.loadCommunityPosts = fetchCommunityPostsFromDB;
window.filterCommunityPosts = renderCommunityPostsTable;
