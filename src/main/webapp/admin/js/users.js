/* =========================================================
   USERS MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let activeUsers = [];

async function fetchUsersFromDB() {
    try {
        const query = (document.getElementById('searchUsers')?.value || '').trim();
        const response = await fetch(CONTEXT_PATH + '/AdminUserServlet' + (query ? '?q=' + encodeURIComponent(query) : ''));
        if (!response.ok) throw new Error('Failed to fetch users');
        activeUsers = await response.json();
        renderUsersTable();
    } catch (error) {
        console.error('Users load error:', error);
    }
}

function loadUsers() {
    fetchUsersFromDB();
}

function renderUsersTable() {
    const tbody = document.getElementById('usersTableBody');
    if (!tbody) return;

    if (!activeUsers || activeUsers.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding: 30px; color:#888;">No users found.</td></tr>';
        return;
    }

    tbody.innerHTML = activeUsers.map(u => `
        <tr id="userRow_${u.id}">
            <td style="font-weight:600;">${u.name}</td>
            <td style="color:var(--text-muted);">${u.email}</td>
            <td><span style="padding:4px 8px; border-radius:12px; font-size:0.75rem; background: ${u.role==='admin'?'rgba(251,191,36,0.1)':'rgba(59,130,246,0.1)'}; color: ${u.role==='admin'?'#fbbf24':'#3b82f6'};">${u.role}</span></td>
            <td style="text-align: right;">
                <button type="button" class="action-btn btn-edit" style="margin-right:8px;" onclick="toggleUserRole(${u.id}, '${u.role}')">Toggle Role</button>
                <button type="button" class="action-btn btn-delete" onclick="deleteUser(${u.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

async function toggleUserRole(id, currentRole) {
    const newRole = currentRole === 'admin' ? 'user' : 'admin';
    try {
        const body = new URLSearchParams();
        body.append('action', 'updateRole');
        body.append('userId', id);
        body.append('role', newRole);

        const res = await fetch(CONTEXT_PATH + '/AdminUserServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        });
        const data = await res.json();
        if (data.success) {
            typeof showToast === 'function' ? showToast('User role updated.', 'success') : alert('Role updated');
            fetchUsersFromDB();
        } else {
            typeof showToast === 'function' ? showToast('Failed to update role.', 'error') : alert('Error');
        }
    } catch(err) {
        console.error('Error toggling role:', err);
    }
}

function deleteUser(id) {
    if (!confirm('Permanently delete this user?')) return;
    const body = new URLSearchParams();
    body.append('action', 'delete');
    body.append('userId', id);

    fetch(CONTEXT_PATH + '/AdminUserServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            typeof showToast === 'function' ? showToast('User deleted.', 'success') : alert('User deleted');
            fetchUsersFromDB();
        } else {
            typeof showToast === 'function' ? showToast('Failed to delete user.', 'error') : alert('Error deleting');
        }
    })
    .catch(err => console.error('Error deleting user:', err));
}
